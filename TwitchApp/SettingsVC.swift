//
//  SettingsVC.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import UIKit
import WebKit

protocol SettingsDelegate: class {
    
    func reloadHandler()
    func resetPositionHandler()
    
    func chatTransparencyChanged()
    func chatWidthChanged()
    func videoDarkerChanged()
    func blockTapChanged()
    func showBonusesChanged()
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonReload: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    
    @IBOutlet weak var textFieldStreamer: UITextField!
    @IBOutlet weak var sliderChatTransparency: UISlider!
    @IBOutlet weak var sliderChatWidth: UISlider!
    @IBOutlet weak var sliderVideoDarker: UISlider!
    @IBOutlet weak var switchBlockTap: UISwitch!
    @IBOutlet weak var switchShowBonuses: UISwitch!
    @IBOutlet weak var switchLockOrientation: UISwitch!
    @IBOutlet weak var buttonResetPosition: UIButton!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var buttonLogin: UIButton!
    
    var settingsModel: SettingsModel?
    weak var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonClose.addTarget(self, action: #selector(closeHandler), for: .touchUpInside)
        buttonReload.addTarget(self, action: #selector(reloadHandler), for: .touchUpInside)
        buttonSave.addTarget(self, action: #selector(saveHandler), for: .touchUpInside)
        
        textFieldStreamer.autocorrectionType = .no
        textFieldStreamer.clearButtonMode = .whileEditing
        textFieldStreamer.delegate = self
        
        sliderChatTransparency.minimumValue = 0
        sliderChatTransparency.maximumValue = 1
        sliderChatTransparency.addTarget(self, action: #selector(chatTransparencyChanged(_:)), for: .valueChanged)
        
        sliderChatWidth.minimumValue = 100
        sliderChatWidth.maximumValue = 1000
        sliderChatWidth.addTarget(self, action: #selector(chatWidthChanged(_:)), for: .valueChanged)
        
        sliderVideoDarker.minimumValue = 0
        sliderVideoDarker.maximumValue = 100
        sliderVideoDarker.addTarget(self, action: #selector(videoDarkerChanged(_:)), for: .valueChanged)
        
        switchBlockTap.addTarget(self, action: #selector(blockTapChanged(_:)), for: .valueChanged)
        
        switchShowBonuses.addTarget(self, action: #selector(showBonusesChanged(_:)), for: .valueChanged)
        switchLockOrientation.addTarget(self, action: #selector(lockOrientationChanged(_:)), for: .valueChanged)
        
        buttonResetPosition.addTarget(self, action: #selector(resetPositionHandler), for: .touchUpInside)
        
        buttonLogin.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        
        updateUI()
        
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { [weak self] in
            print($0)
            
            self?.settingsModel?.isLogged = $0.contains(where: { $0.name == "auth-token" })
            self?.updateLoginButton()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        settingsModel?.store()
    }
    
    func updateUI() {
        switchLockOrientation.isOn = AppUtility.shared.orientationLock != .all
        
        guard let model = settingsModel else {
            closeHandler()
            return
        }
        
        textFieldStreamer.text = model.channelName
        sliderChatTransparency.value = model.chatTransparency
        sliderChatWidth.value = model.chatWidth
        
        sliderVideoDarker.value = model.videoDarker
        switchBlockTap.isOn = model.blockTap
        
        switchShowBonuses.isOn = model.showBonuses
        
        buttonResetPosition.layer.cornerRadius = 10
        
        buttonLogin.layer.cornerRadius = 10
        updateLoginButton()
    }
    
    func updateLoginButton() {
        buttonLogin.setTitle(settingsModel?.isLogged ?? false ? "Выйти из учетной записи" : "Войти в учетную запись", for: .normal)
    }
    
    @objc func closeHandler() {
        dismiss(animated: true)
    }
    
    @objc func reloadHandler() {
        delegate?.reloadHandler()
        closeHandler()
    }
    
    @objc func saveHandler() {
        settingsModel?.channelName = textFieldStreamer.text?.notEmptyValue
        
        delegate?.reloadHandler()
        closeHandler()
    }
    
    @objc func chatTransparencyChanged(_ sender: UISlider) {
        settingsModel?.chatTransparency = sender.value
        
        delegate?.chatTransparencyChanged()
    }
    
    @objc func chatWidthChanged(_ sender: UISlider) {
        settingsModel?.chatWidth = sender.value
        
        delegate?.chatWidthChanged()
    }
    
    @objc func videoDarkerChanged(_ sender: UISlider) {
        settingsModel?.videoDarker = sender.value
        
        delegate?.videoDarkerChanged()
    }
    
    @objc func blockTapChanged(_ sender: UISwitch) {
        settingsModel?.blockTap = sender.isOn
        
        delegate?.blockTapChanged()
    }
    
    @objc func showBonusesChanged(_ sender: UISwitch) {
        settingsModel?.showBonuses = sender.isOn
        
        delegate?.showBonusesChanged()
    }
    
    @objc func lockOrientationChanged(_ sender: UISwitch) {
        if sender.isOn {
            AppUtility.lockCurrentOrientation()
        } else {
            AppUtility.lockOrientation(.all, andRotateTo: UIInterfaceOrientation(rawValue: UIDevice.current.orientation.rawValue))
        }
    }
    
    @objc func resetPositionHandler() {
        delegate?.resetPositionHandler()
        closeHandler()
    }
    
    @objc func loginHandler() {
        if settingsModel?.isLogged ?? false {
            logout()
        } else {
            login()
        }
    }
    
    func login() {
        let vc = WebViewVC()
        let nvc = UINavigationController(rootViewController: vc)
        
        if #available(iOS 13.0, *) {
            nvc.modalPresentationStyle = .automatic
        } else {
            nvc.modalPresentationStyle = .fullScreen
        }
        vc.urlString = "https://www.twitch.tv/login"
        vc.returnUrl = "https://www.twitch.tv/"
        
        vc.successCallback = { [weak self] in
            guard let `self` = self else { return }
            self.settingsModel?.isLogged = true
            self.reloadHandler()
        }
        
        present(nvc, animated: true)
    }
    
//    func afterLogin(completionHandler: (() -> Void)?) {
//        let dataStore = WKWebsiteDataStore.default()
//        dataStore.httpCookieStore.getAllCookies {
//
//            if let cookie = $0.first(where: { $0.isSessionOnly }) {
//                dataStore.httpCookieStore.delete(cookie, completionHandler: completionHandler)
//            } else {
//                completionHandler?()
//            }
//        }
//    }
    
    func logout() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { [weak self] records in
            records.forEach { record in
                
                if record.displayName.contains("twitch.tv") {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record]) {
                        print("Removed: \(record.displayName)")
                    }
                }
            }
            
            self?.settingsModel?.isLogged = false
            self?.reloadHandler()
        }
    }
}

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
