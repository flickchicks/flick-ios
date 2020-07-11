//
//  PrivacySwitch.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import CoreMotion

protocol PrivacySwitchDelegate: class {
    func privacyChanged(isPrivate: Bool)
}

class PrivacySwitch: UIButton {

    // MARK: - Private View Vars
    private let lockBackgroundView = UIView()
    private let lockImageView = UIImageView()
    private let unlockBackgroundView = UIView()
    private let unlockImageView = UIImageView()

    // MARK: - Private Data Vars
    private let activeBackgroundSize = CGSize(width: 20, height: 20)
    private let activeLockSize = CGSize(width: 10, height: 13)
    private let inactiveBackgroundSize = CGSize(width: 16, height: 16)
    private let inactiveLockSize = CGSize(width: 8, height: 11)

    weak var delegate: PrivacySwitchDelegate?

    var isPrivate: Bool = false {
        didSet {
            self.update()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false

        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false

        setupViews()
        addSubview(lockBackgroundView)
        lockBackgroundView.addSubview(lockImageView)
        addSubview(unlockBackgroundView)
        unlockBackgroundView.addSubview(unlockImageView)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        lockBackgroundView.backgroundColor = isPrivate ? .darkBlueGray2 : .lightGray2
        lockBackgroundView.layer.cornerRadius = isPrivate ? activeBackgroundSize.width / 2 : inactiveBackgroundSize.width / 2

        lockImageView.image = UIImage(named: isPrivate ? "lockActive" : "lockInactive")
        lockImageView.tintColor = isPrivate ? .offWhite : .lightGray

        unlockBackgroundView.backgroundColor = isPrivate ? .lightGray2 : .darkBlueGray2
        unlockBackgroundView.layer.cornerRadius = isPrivate ? inactiveBackgroundSize.width / 2 : activeBackgroundSize.width / 2

        unlockImageView.image = UIImage(named: isPrivate ? "unlockInactive" : "unlockActive")
        unlockImageView.tintColor = isPrivate ? .lightGray : .offWhite
    }

    private func setupConstraints() {
        let horizontalOffset = 14

        lockBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.leading).offset(horizontalOffset)
            make.size.equalTo(isPrivate ? activeBackgroundSize : inactiveBackgroundSize)
        }

        lockImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(isPrivate ? activeLockSize : inactiveLockSize)
        }

        unlockBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.trailing).offset(-horizontalOffset)
            make.size.equalTo(isPrivate ? inactiveBackgroundSize : activeBackgroundSize)
        }

        unlockImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(isPrivate ? inactiveLockSize : activeLockSize)
        }
    }

    private func remakeConstraints() {
        let horizontalOffset = 14

        lockBackgroundView.snp.remakeConstraints { remake in
            remake.centerY.equalToSuperview()
            remake.centerX.equalTo(self.snp.leading).offset(horizontalOffset)
            remake.size.equalTo(isPrivate ? activeBackgroundSize : inactiveBackgroundSize)
        }

        lockImageView.snp.remakeConstraints { remake in
            remake.centerX.centerY.equalToSuperview()
            remake.size.equalTo(isPrivate ? activeLockSize : inactiveLockSize)
        }

        unlockBackgroundView.snp.remakeConstraints { remake in
            remake.centerY.equalToSuperview()
            remake.centerX.equalTo(self.snp.trailing).offset(-horizontalOffset)
            remake.size.equalTo(isPrivate ? inactiveBackgroundSize : activeBackgroundSize)
        }

        unlockImageView.snp.remakeConstraints { remake in
            remake.centerX.centerY.equalToSuperview()
            remake.size.equalTo(isPrivate ? inactiveLockSize : activeLockSize)
        }
    }

    private func update() {
        UIView.animate(withDuration: 0.5) {
            self.setupViews()
            self.remakeConstraints()
        }
    }

    func toggle() {
        self.isPrivate ? self.setPrivate(false) : self.setPrivate(true)
    }

    func setPrivate(_ isPrivate: Bool) {
        self.isPrivate = isPrivate
        delegate?.privacyChanged(isPrivate: isPrivate)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.sendHapticFeedback()
        self.toggle()
    }

    // It will give a physical feedback to the user when they tap to toggle.
    private func sendHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

}
