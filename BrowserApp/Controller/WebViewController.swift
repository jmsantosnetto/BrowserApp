//
//  WebViewController.swift
//  BrowserApp
//
//  Created by Jose Martins on 15/10/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var history: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.urlTextField.addTarget(self, action: #selector(onTapTextField), for: .touchDown)
        self.urlTextField.delegate = self
        
        self.setUpWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.firstLoad()
    }
    
    @objc func onTapTextField() {
        self.urlTextField.text = ""
    }
    
    func setUpWebView() {
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.goToSite()
        self.view.endEditing(true)
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url?.absoluteString
        
        urlTextField.text = url
        history.append(url!)
        
        self.loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loading.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loading.stopAnimating()
    }
    
    func firstLoad() {
        if history.count > 0 {
            let request: URLRequest = URLRequest(url: URL(string: history.last!)!)
            self.webView.load(request)
            return
        }
        
        let request: URLRequest = URLRequest(url: URL(string: "https://www.google.com/")!)
        self.webView.load(request)
    }
    
    func goToSite() {
        self.loading.startAnimating()
        
        if var address = self.urlTextField.text {
            if !address.contains("http://") && !address.contains("https://") {
                address = "http://\(address)"
            }
            
            let request: URLRequest = URLRequest(url: URL(string: address)!)
            self.webView.load(request)
        }
    }
    
    @IBAction func markAsFavorite(_ sender: Any) {
        
    }
    
    @IBAction func goToFavorites(_ sender: Any) {
        
    }
    
    @IBAction func backOnHistory(_ sender: Any) {
        self.webView.goBack()
    }
    
    @IBAction func advanceOnHistory(_ sender: Any) {
        self.webView.goForward()
    }
    @IBAction func shareUrl(_ sender: Any) {
        if let url = self.urlTextField.text {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
