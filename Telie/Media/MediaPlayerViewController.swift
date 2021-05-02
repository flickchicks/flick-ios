//
//  MediaPlayerViewController.swift
//  Telie
//
//  Created by Lucy Xu on 5/1/21.
//  Copyright © 2021 Telie. All rights reserved.
//
import UIKit
import WebKit

class MediaPlayerViewController: UIViewController, WKUIDelegate {

    private var webView: WKWebView!
    private let urlString: String
    private let webPlayerView = UIView()

    init(urlString: String) {
        print(urlString)
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .offWhite
        title = "Trailer"

        view.addSubview(webPlayerView)

        webPlayerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true

        DispatchQueue.main.async {
            self.webView = WKWebView(frame: self.webPlayerView.bounds, configuration: webConfiguration)
            self.webPlayerView.addSubview(self.webView)

            guard let videoURL = URL(string: self.urlString) else { return }
            let request = URLRequest(url: videoURL)
            self.webView.load(request)
        }

    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
}
