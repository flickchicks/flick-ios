import UIKit
import Kingfisher
import SkeletonView

class ProfileSummaryTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let bioLabel = UILabel()
    private var friendsPreviewView: UsersPreviewView!
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()
    private let settingsButton = UIButton()
    private let userInfoView = UIView()
    private let usernameLabel = UILabel()
    weak var delegate: ProfileDelegate?

    // MARK: - Private Data Vars
    private var condensedCellSpacing = -8
    private let maxFriendsPreview = 6
    private let profileImageSize = CGSize(width: 70, height: 70)
    static var reuseIdentifier = "ProfileSummaryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .offWhite
        selectionStyle = .none

        profileImageView.backgroundColor = .deepPurple
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        contentView.addSubview(profileImageView)

        nameLabel.linesCornerRadius = 10
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .darkBlue
        contentView.addSubview(nameLabel)

        usernameLabel.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.userUsername)
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .mediumGray
        usernameLabel.linesCornerRadius = 6
        userInfoView.addSubview(usernameLabel)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFriendsPreviewTap))
        friendsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .friends)
        friendsPreviewView.addGestureRecognizer(tapGestureRecognizer)
        userInfoView.addSubview(friendsPreviewView)

        contentView.addSubview(userInfoView)

        bioLabel.font = .systemFont(ofSize: 12)
        bioLabel.textColor = .darkBlueGray2
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        contentView.addSubview(bioLabel)

        settingsButton.setImage(UIImage(named: "options"), for: .normal)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        settingsButton.tintColor = .mediumGray
        settingsButton.isHidden = true
        contentView.addSubview(settingsButton)

        setupConstraints()
    }

    @objc func notificationButtonPressed() {
        delegate?.pushNotificationsView()
    }

    @objc func settingsButtonPressed() {
        delegate?.pushSettingsView()
    }
    
    @objc func handleFriendsPreviewTap() {
        delegate?.pushFriendsView()
    }

    private func calculateUserInfoViewWidth(friendsCount: Int, friendsPreviewWidth: CGFloat) -> CGFloat {
        let padding = friendsCount == 0 ? 0 : 20
        let userNameLabelWidth = usernameLabel.frame.size.width
        let userInfoViewWidth = userNameLabelWidth + CGFloat(padding) + friendsPreviewWidth
        return userInfoViewWidth
    }

    private func setupConstraints() {
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
            make.leading.equalTo(usernameLabel.snp.trailing)
            make.top.bottom.height.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(20)
        }

        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.bottom.equalTo(bioLabel.snp.top).offset(-8)
            make.leading.equalTo(usernameLabel.snp.leading)
            make.trailing.equalTo(friendsPreviewView.snp.trailing)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }

        bioLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(38)
            make.bottom.equalToSuperview().inset(8)
        }

        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(10)
        }
    }

    private func updateUserInfoViewConstraints() {
        let friendsPreviewWidth = friendsPreviewView.getUsersPreviewWidth()

        friendsPreviewView.snp.updateConstraints { update in
            update.width.equalTo(friendsPreviewWidth)
            update.leading.equalTo(usernameLabel.snp.trailing).offset(20)
        }
    }

    func configure(isHome: Bool, user: UserProfile?, friends: [UserProfile], delegate: ProfileDelegate) {

        if isHome {
            print("IS HOME")
            isSkeletonable = false
            nameLabel.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.userName)
            if let userProfilePicUrl = UserDefaults.standard.string(forKey: Constants.UserDefaults.userProfilePicUrl) {
                profileImageView.kf.setImage(with: URL(string: userProfilePicUrl))
            } else {
                profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
            }

            var cachedFriends: [UserProfile] {
                if let savedFriends = UserDefaults.standard.value(forKey: Constants.UserDefaults.userFriends) as? Data {
                   let decoder = JSONDecoder()
                   if let friendsDecoded = try? decoder.decode(Array.self, from: savedFriends) as [UserProfile] {
                      return friendsDecoded
                   }
                }
                return []
            }

            friendsPreviewView.users = cachedFriends.count > 0 ? cachedFriends : []
            updateUserInfoViewConstraints()
            bioLabel.text = UserDefaults.standard.string(forKey: Constants.UserDefaults.userBio)


        } else {
            isSkeletonable = true
            usernameLabel.text = " " // Add spaces for skeleton view
            usernameLabel.skeletonCornerRadius = 6
            usernameLabel.isSkeletonable = true

            nameLabel.text = "                   " // Add spaces for skeleton view
            nameLabel.skeletonCornerRadius = 10
            nameLabel.isSkeletonable = true

            profileImageView.isSkeletonable = true
            profileImageView.skeletonCornerRadius = 35

            friendsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .friends)

            userInfoView.isSkeletonable = true
            userInfoView.skeletonCornerRadius = 10
        }

        guard let user = user else { return }
        self.delegate = delegate
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        usernameLabel.sizeToFit()
        bioLabel.text = user.bio
        if let imageUrl = URL(string: user.profilePicUrl ?? Constants.User.defaultImage) {
            profileImageView.kf.setImage(with: imageUrl)
        }
        // Show settings buttons only if current user is at Home
        settingsButton.isHidden = !isHome

        // Update friends preview
        if !friends.isEmpty {
            friendsPreviewView.users = friends
            updateUserInfoViewConstraints()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
