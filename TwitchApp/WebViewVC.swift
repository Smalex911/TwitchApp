//
//  WebViewVC.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    var webView: WKWebView!
    
    var url: URL?
    var returnUrl: String?
    
    var successCallback: (() -> Void)?
    
    lazy var closeBarButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(close))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = closeBarButton
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.tintColor = UIColor.secondaryLabel
        } else {
            navigationController?.navigationBar.tintColor = .black
        }
        
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        
        add(webView, to: view)
        
        reloadUrl()
    }
    
    func setUrlString(_ str: String?) {
        guard let str = str else { return }
        url = URL(string: str)
    }
    
    func add(_ view: UIView, to parent: UIView) {
        parent.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = view.leftAnchor.constraint(equalTo: parent.leftAnchor)
        let rightConstraint = view.rightAnchor.constraint(equalTo: parent.rightAnchor)
        let topConstraint = view.topAnchor.constraint(equalTo: parent.layoutMarginsGuide.topAnchor)
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        
        parent.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    func reloadUrl() {
        guard let url = url else {
            dismiss(animated: true)
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}

extension WebViewVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("URL RESULT \(navigationAction.request.url?.absoluteString ?? "")")
        
        let path = "\(navigationAction.request.url?.host ?? "")\(navigationAction.request.url?.path ?? "")"
        
        if returnUrl?.contains(path) ?? false {
            
            dismiss(animated: true) { [weak self] in
                self?.successCallback?()
            }
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
