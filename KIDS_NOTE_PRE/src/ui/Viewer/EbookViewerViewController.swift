//
//  EbookViewerViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/31.
//

import UIKit
import WebKit
import SnapKit
import Then

class EbookViewerViewController: BaseViewController {
    
    private let ISBN: String
    
//    class func create() -> WKWebView {
//        let config = WKWebViewConfiguration()
//        config.processPool = WebViewProcessPool.shared
//        config.allowsInlineMediaPlayback = true
//        config.defaultWebpagePreferences.allowsContentJavaScript = true
//        config.websiteDataStore = .default()
//
//        let webView = WKWebView(frame: .zero, configuration: config)
//        webView.backgroundColor = .white
//        webView.allowsLinkPreview = false
//        webView.allowsBackForwardNavigationGestures = false
//        webView.scrollView.minimumZoomScale = 1.0
//        webView.scrollView.maximumZoomScale = 1.0
//        return webView
//    }

    private let webView: WKWebView = WKWebView()
    
    override func snapKitView() -> [UIView] {
        [webView]
    }
    
    override func snapKitMakeConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    init(identifier ISBN: String) {
        self.ISBN = "ISBN:\(ISBN)"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self

        webView.configuration.userContentController.add(self, name: "ebookViewerLoad")

        if let htmlFile = Bundle.main.path(forResource: "ebook_viewer", ofType: "html") {
            let url = URL(fileURLWithPath: htmlFile)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
}

extension EbookViewerViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "ebookViewerLoad" {
            
        }
    }
}

extension EbookViewerViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        return .allow
    }
}

class WebViewProcessPool: WKProcessPool {
   private static var singleton: WebViewProcessPool!
   public static var shared: WebViewProcessPool = {
       guard let processPool = singleton else {
           singleton = WebViewProcessPool()
           return singleton!
       }
       return processPool
   }()
}
