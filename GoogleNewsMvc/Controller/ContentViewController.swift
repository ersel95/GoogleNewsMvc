//
//  ContentViewController.swift
//  GoogleNewsMvc
//
//  Created by Mr. T. on 1.03.2020.
//  Copyright © 2020 Mr. T. All rights reserved.
//

import UIKit
import WebKit


class ContentViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        webView.navigationDelegate = self
        if let reachability = Reachability(), !reachability.isReachable{ //connection not available
            present(AlertController.presentAlert(title: "Connection Error", message: "check your connection and try again.", cancelMsg: "Cancel"), animated: true)
        } else { //connection Available
            let link = URL(string: selectedUrl)!
            let request = URLRequest(url: link)
            webView.load(request)
        }
    }
}

extension ContentViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}
