//
//  WebViewContainer.swift
//  TwitchApp
//
//  Created by Aleksandr Smorodov on 08.11.2020.
//

import UIKit
import WebKit

class WebViewContainer: UIView {
    
    var webView: WKWebView?
    
    private var parent: UIView?
    
    var contentInsets: UIEdgeInsets = .zero {
        didSet {
            leftConstraint?.constant = contentInsets.left
            rightConstraint?.constant = 0 - contentInsets.right
            topConstraint?.constant = contentInsets.top
            bottomConstraint?.constant = 0 - contentInsets.bottom
        }
    }
    
    var didTapLink: ((URL) -> Void)?
    
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    func initiateWebView(with userScripts: [WKUserScript] = []) {
        let view = WKWebView(frame: bounds, configuration: configuration(userScripts))
        view.navigationDelegate = self
        view.scrollView.isScrollEnabled = false
        view.isOpaque = false
        
        backgroundColor = nil
        
        webView = view
        
        add(view, to: self)
    }
    
    func configuration(_ userScripts: [WKUserScript] = []) -> WKWebViewConfiguration {
        let cc = WKUserContentController()
        
        userScripts.forEach { cc.addUserScript($0) }

        let config = WKWebViewConfiguration()
        config.userContentController = cc
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        return config
    }
    
    func add(_ view: UIView, to parent: UIView) {
        parent.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = view.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: contentInsets.left)
        rightConstraint = view.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: 0 - contentInsets.right)
        topConstraint = view.topAnchor.constraint(equalTo: parent.topAnchor, constant: contentInsets.top)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0 - contentInsets.bottom)
        
        parent.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint].compactMap({ $0 }))
    }
    
    func addGestureRecognizers(in view: UIView) {
        parent = view
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
        pinch.delegate = self
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        pan.delegate = self
        
        addGestureRecognizer(pinch)
        addGestureRecognizer(pan)
    }
    
    @objc func pinchAction(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    @objc func panView(_ sender: UIPanGestureRecognizer) {
        guard let parent = parent else { return }
        
        let translation = sender.translation(in: parent)
        
        if let viewToDrag = sender.view {
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                                        y: viewToDrag.center.y + translation.y)
            sender.setTranslation(CGPoint(x: 0, y: 0), in: viewToDrag)
        }
    }
    
    func reload(_ stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        webView?.load(URLRequest(url: url))
    }
}

extension WebViewContainer: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension WebViewContainer: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        didTapLink?(url)
        decisionHandler(.cancel)
    }
}

extension WKUserScript {
    
    static var disableScrolling: WKUserScript {
        let source = """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';

        var head = document.getElementsByTagName('head')[0];
        head.appendChild(meta);
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    static var disableSelecting: WKUserScript {
        let source = """
        var css = '*{-webkit-touch-callout:none;-webkit-user-select:none}';
        var style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        
        var head = document.getElementsByTagName('head')[0];
        head.appendChild(style);
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    static var betterttv: WKUserScript {
        let source = """
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = 'https://cdn.betterttv.net/betterttv.js';
        
        var head = document.getElementsByTagName('head')[0];
        head.appendChild(script);
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    static var bonusesMining: WKUserScript {
        let source = """
        setInterval(function() {
          var chestColl = document.getElementsByClassName('claimable-bonus__icon');

          if (chestColl.length > 0) {
            chestColl[0].parentElement.parentElement.click()
          }

        }, 1000);
        """
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
