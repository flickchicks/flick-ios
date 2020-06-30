import UIKit

class ProfileSummaryTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var friendsPreviewView: UsersPreviewView!
    private let nameLabel = UILabel()
    private let notificationButton = UIButton()
    private let profileImageView = UIImageView()
    private let settingsButton = UIButton()
    private let userInfoView = UIView()
    private let usernameLabel = UILabel()

    // MARK: - Private Data Vars
    private var condensedCellSpacing = -8
    private let profileImageSize = CGSize(width: 70, height: 70)
    private let sideButtonsSize = CGSize(width: 24, height: 24)

    // TODO: Update with backend values
    private let name = "Alanna Zhou"
    private let username = "alannaz"
    private let friends = ["A", "B", "C", "D", "E", "F", "G"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite

        selectionStyle = .none

        profileImageView.backgroundColor = .deepPurple
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        contentView.addSubview(profileImageView)

        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .darkBlue
        contentView.addSubview(nameLabel)

        usernameLabel.text = "@\(username)"
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .mediumGray
        usernameLabel.sizeToFit()
        userInfoView.addSubview(usernameLabel)

        friendsPreviewView = UsersPreviewView(users: friends, usersLayoutMode: .friends)
        userInfoView.addSubview(friendsPreviewView)

        contentView.addSubview(userInfoView)

        notificationButton.setImage(UIImage(named: "notificationButton"), for: .normal)
        contentView.addSubview(notificationButton)

        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        contentView.addSubview(settingsButton)

        setupConstraints()
    }
    
    private func setupConstraints() {
        // Calculate width of friends preview based on number of friends and spacing between cells
        let numFriendsInPreview = min(friends.count, 7) + 1
        let fullFriendsWidth = numFriendsInPreview * 20
        let overlapFriendsWidth = (numFriendsInPreview-1) * condensedCellSpacing * -1
        let friendsPreviewWidth = fullFriendsWidth - overlapFriendsWidth

        let padding = 20
        let userNameLabelWidth = Int(usernameLabel.frame.size.width)
        let userInfoViewWidth = userNameLabelWidth + padding + friendsPreviewWidth

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        usernameLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.height.equalTo(15)
        }

        friendsPreviewView.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.trailing).offset(padding)
            make.top.bottom.height.equalToSuperview()
            make.width.equalTo(friendsPreviewWidth)
            make.height.equalTo(20)
        }

        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(userInfoViewWidth)
        }

        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(sideButtonsSize)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(padding)
        }

        notificationButton.snp.makeConstraints { make in
            make.size.equalTo(sideButtonsSize)
            make.top.equalTo(settingsButton)
            make.trailing.equalTo(settingsButton.snp.leading).offset(-7)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
