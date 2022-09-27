//
//  VideoExpressViewController.swift
//  VideoExpressiOS
//
//  Created by Abdulhakim Ajetunmobi on 31/08/2022.
//

import UIKit
import WebKit
import SafariServices

class VideoExpressViewController: UIViewController, WKNavigationDelegate {
    
    private let session: String
    
    private var webView: WKWebView!

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "\(AppDelegate.baseUrl)/video?session=\(session)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = false
    }
    
    init(session: String) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
