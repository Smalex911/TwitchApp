//
//  ViewController.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 07.11.2020.
//

import UIKit
import WebKit

extension WKWebView {
    
    override open var safeAreaInsets: UIEdgeInsets {
        .zero
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonSettings: UIButton!
    
    @IBOutlet weak var viewVideoContainer: WebViewContainer!
    @IBOutlet weak var viewChatContainer: WebViewContainer!
    
    @IBOutlet weak var widthChat: NSLayoutConstraint!
    
    var settingsModel = SettingsModel.restore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSettings.addTarget(self, action: #selector(settingsHandler), for: .touchUpInside)
        
        viewVideoContainer.initiateWebView(with: [.disableScrolling, .disableSelecting])
        viewVideoContainer.addGestureRecognizers(in: view)
        viewVideoContainer.webView?.navigationDelegate = self
        
        viewChatContainer.contentInsets = UIEdgeInsets(top: -50, left: -8, bottom: settingsModel.showBonuses ? 0 : -94, right: 0)
        viewChatContainer.initiateWebView(with: [.disableScrolling, .betterttv, .bonusesMining])
//        viewChatContainer.addGestureRecognizers(in: view)
        
//        webViewChat.navigationDelegate = self
        
//        if #available(iOS 11.0, *) {
//            viewChatContainer.webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
//                print(cookies)
//            }
//        }
        
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { [weak self] in
            self?.settingsModel.isLogged = $0.contains(where: { $0.name == "auth-token" })
        }
        
//        let dataStore = WKWebsiteDataStore.default()
//        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
//            records.forEach { (record) in
//
//                if record.displayName.contains("twitch.tv") {
//                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record]) {
//                        print("Removed: \(record.displayName)")
//                    }
//                }
//            }
//        }
        
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
//            $0.contains(where: { $0.displayName.contains("twitch.tv") })
//            records.forEach { (record) in
//
//                if record.displayName.contains("twitch.tv") {
//                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record]) {
//                        print("Removed: \(record.displayName)")
//                    }
//                }
//            }
//        }
        
        updateChatTransparencyUI()
        updateChatWidthUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadVideo()
        reloadChat()
    }
    
    func reloadVideo() {
        guard let name = settingsModel.channelName else { return }
        viewVideoContainer.reload("https://player.twitch.tv/?channel=\(name)&parent=twitch.tv")
    }
    
    func reloadChat() {
        guard let name = settingsModel.channelName else { return }
        viewChatContainer.reload("https://www.twitch.tv/popout/\(name)/chat")
    }
    
    func updateChatTransparencyUI() {
        viewChatContainer.alpha = CGFloat(settingsModel.chatTransparency)
    }
    
    func updateChatWidthUI() {
        widthChat.constant = CGFloat(settingsModel.chatWidth)
    }
    
    @objc func settingsHandler() {
        guard let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC else { return }
        
        popupVC.modalPresentationStyle = .popover
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.preferredContentSize = .init(width: 300, height: 350)
        popupVC.popoverPresentationController?.sourceView = buttonSettings
        
        popupVC.settingsModel = settingsModel
        popupVC.delegate = self
        
        present(popupVC, animated: true)
    }
}

extension ViewController: SettingsDelegate {
    
    func reloadHandler() {
//        viewChatContainer.webView?.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
//            print(cookies)
//        }
        
        reloadVideo()
        reloadChat()
    }
    
    func resetPositionHandler() {
        viewVideoContainer.transform = .identity
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func chatTransparencyChanged() {
        updateChatTransparencyUI()
    }
    
    func chatWidthChanged() {
        updateChatWidthUI()
    }
    
    func showBonusesChanged() {
        viewChatContainer.contentInsets.bottom = settingsModel.showBonuses ? 0 : -94
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let javascriptStyle = "var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}'; var head = document.head || document.getElementsByTagName('head')[0]; var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); head.appendChild(style);"
//        webView.evaluateJavaScript(javascriptStyle, completionHandler: nil)
        
//        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML") { innerHTML, error in
//            print(innerHTML!)
//        }
    }
}
