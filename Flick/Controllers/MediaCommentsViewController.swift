//
//  MediaCommentsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaCommentsViewController: UIViewController {

    private var commentsTableView: UITableView!
    private let commentView = UIView()
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()
    
    private var comments: [Comment]!

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

        commentView.backgroundColor = .movieWhite

        commentSeparatorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 2)
        commentSeparatorView.backgroundColor = .lightGray2
        commentView.addSubview(commentSeparatorView)
        commentView.layer.zPosition = 1
        view.addSubview(commentView)

        commentTextField.backgroundColor = .lightGray2
        commentTextField.layer.cornerRadius = 15
        commentTextField.placeholder = "Share your thoughts"
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        commentView.addSubview(commentTextField)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        commentView.addSubview(sendCommentButton)

        commentsTableView = UITableView(frame: .zero)
        commentsTableView.backgroundColor = .none
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.isScrollEnabled = true
        commentsTableView.alwaysBounceVertical = true
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentsTableCell")
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

        let thoughtsLabel = UILabel()
        thoughtsLabel.text = "Thoughts"
        thoughtsLabel.font = .boldSystemFont(ofSize: 24)
        thoughtsLabel.textColor = .black
        navigationController?.navigationBar.addSubview(thoughtsLabel)

        thoughtsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.top.bottom.trailing.equalToSuperview()
        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupConstraints() {
        commentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(71 + view.safeAreaInsets.bottom)
        }

        commentTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(16)
        }

        sendCommentButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(commentTextField.snp.trailing).offset(14)
            make.centerY.equalTo(commentTextField)
        }

        commentsTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentView.snp.top)
        }
    }

}

extension MediaCommentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
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
}

