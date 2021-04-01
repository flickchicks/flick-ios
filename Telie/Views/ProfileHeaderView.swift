import UIKit

protocol ProfileDelegate: class {
    func createFriendRequest()
    func showCreateListModal()
    func pushNotificationsView()
    func pushSettingsView()
    func pushFriendsView()
    func showLists()
    func showLikedLists()
//    func pushFindFriendsView()
}

class ProfileHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private View Vars
    private let createListButton = UIButton()
    private let containerView = UIView()
    private let friendButton = UIButton()
    private let likedListsButton = UIButton()
    private let listsButton = UIButton()
    private let roundTopView = RoundTopView(hasShadow: true)

    // MARK: - Private Data Vars
    private let buttonSize = CGSize(width: 44, height: 44)
    weak var delegate: ProfileDelegate?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .offWhite
        
        containerView.addSubview(roundTopView)
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)

        createListButton.setImage(UIImage(named: "newList"), for: .normal)
        createListButton.layer.cornerRadius = buttonSize.width / 2
        createListButton.addTarget(self, action: #selector(showCreateListModal), for: .touchUpInside)

        friendButton.layer.cornerRadius = buttonSize.width / 2
        friendButton.addTarget(self, action: #selector(friendButtonTapped), for: .touchUpInside)

        listsButton.setTitleColor(.darkBlue, for: .normal)
        listsButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        listsButton.titleEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        listsButton.backgroundColor = .lightPurple
        listsButton.layer.cornerRadius = 14
        listsButton.addTarget(self, action: #selector(listsButtonTapped), for: .touchUpInside)
        contentView.addSubview(listsButton)

        likedListsButton.setTitleColor(.mediumGray, for: .normal)
        likedListsButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        likedListsButton.titleEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        likedListsButton.backgroundColor = .white
        likedListsButton.layer.cornerRadius = 14
        likedListsButton.layer.borderWidth = 1
        likedListsButton.layer.borderColor = UIColor.lightGray2.cgColor
        likedListsButton.addTarget(self, action: #selector(likedListsButtonTapped), for: .touchUpInside)
        contentView.addSubview(likedListsButton)

        setupConstraints()
    }

    func setupConstraints() {
        roundTopView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(buttonSize.height / 2)
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview()
        }

        likedListsButton.snp.makeConstraints { make in
            make.top.equalTo(roundTopView).offset(30)
            make.leading.equalTo(listsButton.snp.trailing).offset(12)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }

        listsButton.snp.makeConstraints { make in
            make.top.equalTo(roundTopView).offset(30)
            make.leading.equalTo(roundTopView).offset(34)
            make.height.equalTo(28)
            make.width.equalTo(60)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(user: UserProfile?, isCurrentUser: Bool) {
        if isCurrentUser {
            contentView.addSubview(createListButton)
            createListButton.snp.makeConstraints { make in
                make.centerY.equalTo(roundTopView.snp.top)
                make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
                make.size.equalTo(buttonSize)
            }
        } else {
            switch user?.friendStatus {
            case .friends:
                friendButton.isUserInteractionEnabled = false
                friendButton.setImage(UIImage(named: "friendsIcon"), for: .normal)
            case .outgoingRequest:
                friendButton.isUserInteractionEnabled = false
                friendButton.setImage(UIImage(named: "addFriendButtonDisabled"), for: .normal)
            default:
                friendButton.isUserInteractionEnabled = true
                friendButton.setImage(UIImage(named: "addFriendButton"), for: .normal)
            }
            contentView.addSubview(friendButton)
            friendButton.snp.makeConstraints { make in
                make.centerY.equalTo(roundTopView.snp.top)
                make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
                make.size.equalTo(buttonSize)
            }
        }
        if let user = user {
            let firstName = user.name.split(separator: " ")[0]
            likedListsButton.setTitle("Liked lists", for: .normal)
            likedListsButton.sizeToFit()
            listsButton.setTitle(isCurrentUser ? "My lists" : "\(firstName)'s lists", for: .normal)
            listsButton.sizeToFit()
            listsButton.snp.updateConstraints { update in
                update.width.equalTo(listsButton.frame.width + 24)
            }
            likedListsButton.snp.updateConstraints { update in
                update.width.equalTo(likedListsButton.frame.width + 24)
            }
        }
    }

    @objc func showCreateListModal() {
        delegate?.showCreateListModal()
    }

    @objc func friendButtonTapped() {
        delegate?.createFriendRequest()
    }

    @objc private func listsButtonTapped() {
        listsButton.setTitleColor(.darkBlue, for: .normal)
        listsButton.backgroundColor = .lightPurple
        listsButton.layer.borderWidth = 0

        likedListsButton.setTitleColor(.mediumGray, for: .normal)
        likedListsButton.backgroundColor = .white
        likedListsButton.layer.borderWidth = 1
        likedListsButton.layer.borderColor = UIColor.lightGray2.cgColor
    }

    @objc private func likedListsButtonTapped() {
        likedListsButton.setTitleColor(.darkBlue, for: .normal)
        likedListsButton.backgroundColor = .lightPurple
        likedListsButton.layer.borderWidth = 0

        listsButton.setTitleColor(.mediumGray, for: .normal)
        listsButton.backgroundColor = .white
        listsButton.layer.borderWidth = 1
        listsButton.layer.borderColor = UIColor.lightGray2.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
