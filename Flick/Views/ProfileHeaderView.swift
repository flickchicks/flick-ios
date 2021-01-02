import UIKit

protocol ProfileDelegate: class {
    func showCreateListModal()
    func pushNotificationsView()
    func pushSettingsView()
    func pushFriendsView()
}

class ProfileHeaderView: UITableViewHeaderFooterView {

    // MARK: - Private View Vars
    private let createListButton = UIButton()
    private let containerView = UIView()
    private let friendButton = UIButton()
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

        friendButton.setImage(UIImage(named: "addFriendButton"), for: .normal)
        friendButton.layer.cornerRadius = buttonSize.width / 2

        setupConstraints()
    }

    func setupConstraints() {
        roundTopView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(buttonSize.height / 2)
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(isCurrentUser: Bool) {
        if isCurrentUser {
            contentView.addSubview(createListButton)
            createListButton.snp.makeConstraints { make in
                make.centerY.equalTo(roundTopView.snp.top)
                make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
                make.size.equalTo(buttonSize)
            }
        } else {
            contentView.addSubview(friendButton)
            friendButton.snp.makeConstraints { make in
                make.centerY.equalTo(roundTopView.snp.top)
                make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
                make.size.equalTo(buttonSize)
            }
        }
    }

    @objc func showCreateListModal() {
        delegate?.showCreateListModal()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
