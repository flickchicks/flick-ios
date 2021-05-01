//
//  MediaCommentsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/30/20.
//  Copyright © 2020 flick. All rights reserved.
//
import UIKit

class MediaCommentsViewController: UIViewController {

    // MARK: - Private View Vars
    private let commentsTableView = UITableView(frame: .zero)
    private let commentAreaView = CommentAreaView(type: .comment)
    private let loadingIndicatorView = LoadingIndicatorView()
    private let sendCommentButton = UIButton()

    // MARK: - Private Data Vars
    private var comments: [Comment]!
    private var mediaId: Int!

    init(comments: [Comment], mediaId: Int) {
        self.comments = comments
        self.mediaId = mediaId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Thoughts"
        view.backgroundColor = .movieWhite

        commentAreaView.delegate = self
        view.addSubview(commentAreaView)

        commentsTableView.backgroundColor = .clear
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.isScrollEnabled = true
        commentsTableView.alwaysBounceVertical = true
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier)
        commentsTableView.separatorStyle = .none
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.sizeToFit()
        commentsTableView.keyboardDismissMode = .onDrag
        commentsTableView.showsVerticalScrollIndicator = false
        view.addSubview(commentsTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            commentAreaView.snp.updateConstraints { update in
                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardHeight)
            }
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                let indexPath = IndexPath(item: self.comments.count - 1, section: 0)
                self.commentsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            })
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        commentAreaView.snp.updateConstraints { update in
            update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setupConstraints() {
        commentAreaView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(commentAreaView.snp.top)
        }
    }

    func showLoadingIndicatorView() {
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }

}

extension MediaCommentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.reuseIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.configure(for: comment, index: indexPath.row, hideSpoiler: true, delegate: self)
        return cell
    }

}

extension MediaCommentsViewController: CommentDelegate {
    func showProfile(userId: Int) {
        navigationController?.pushViewController(ProfileViewController(isHome: false, userId: userId), animated: true)
    }

    func likeComment(index: Int) {
        let commentId = comments[index].id
        NetworkManager.likeComment(commentId: commentId) { [weak self] comment in
            guard let self = self else { return }
            self.comments[index] = comment
            self.commentsTableView.reloadData()
        }
    }

    func addComment(commentText: String, isSpoiler: Bool) {
        self.commentAreaView.commentTextView.text = ""
        self.commentAreaView.commentTextView.endEditing(true)
        showLoadingIndicatorView()
        NetworkManager.postComment(mediaId: mediaId, comment: commentText, isSpoiler: isSpoiler) { [weak self] media in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.comments = media.comments
                self.loadingIndicatorView.removeFromSuperview()
                self.commentsTableView.reloadData()

            }
        }
    }

    func showSpoilerModal(commentText: String) {
        let commentSpoilerModalView = CommentSpoilerModalView(comment: commentText)
        commentSpoilerModalView.modalDelegate = self
        commentSpoilerModalView.commentDelegate = self
        showModalPopup(view: commentSpoilerModalView)
    }

    func seeAllComments() {
        // Not used in this view controller
        return
    }
}

extension MediaCommentsViewController: ModalDelegate {
    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }
}
