//
//  MediaCommentsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class CommentTextField: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)))
    }
}

class MediaCommentsViewController: UIViewController {

    // MARK: - Private View Vars
    private let commentSeparatorView = UIView()
    private var commentsTableView: UITableView!
    private let commentTextField = UITextField()
    private let commentAreaView = CommentAreaView()
    private let sendCommentButton = UIButton()
    private let thoughtsTitleLabel = UILabel()

    // MARK: - Private Data Vars
    private var comments: [Comment]!
    private let commentsCellReuseIdentifier = "CommentsTableCellReuseIdentifier"

    init(comments: [Comment]) {
        super.init(nibName: nil, bundle: nil)
        self.comments = comments
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movieWhite

        setupNavigationBar()

        commentAreaView.delegate = self
        view.addSubview(commentAreaView)

        commentsTableView = UITableView(frame: .zero)
        commentsTableView.backgroundColor = .none
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.isScrollEnabled = true
        commentsTableView.alwaysBounceVertical = true
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentsCellReuseIdentifier)
        commentsTableView.separatorStyle = .none
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.sizeToFit()
        view.addSubview(commentsTableView)

        setupConstraints()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        thoughtsTitleLabel.text = "Thoughts"
        thoughtsTitleLabel.font = .boldSystemFont(ofSize: 18)
        thoughtsTitleLabel.textColor = .black
        navigationController?.navigationBar.addSubview(thoughtsTitleLabel)

        thoughtsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(59)
            make.top.bottom.trailing.equalToSuperview()
        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {

        let bottomSafeAreaInsets = view.safeAreaInsets.bottom

        commentAreaView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(71 + bottomSafeAreaInsets)
        }

        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentAreaView.snp.top)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        thoughtsTitleLabel.removeFromSuperview()
    }

}

extension MediaCommentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentsCellReuseIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.configure(for: comment, index: indexPath.row, delegate: self)
        return cell
    }

}

extension MediaCommentsViewController: CommentDelegate {
    func likeComment(index: Int) {
        comments[index].liked.toggle()
        commentsTableView.reloadData()
    }

    func addComment(commentText: String) {
        let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
        comments.insert(comment, at: 0)
        commentsTableView.reloadData()
    }
}

