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
    let favoriteService = FavoriteService.instance
    var keyboardHeight: CGFloat = 0.0
    let googleAddress = "https://www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.urlTextField.delegate = self
        
        self.setUpWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.firstLoad()
    }
    
    @objc func onKeyboardHide(notification: NSNotification) {
        self.keyboardHeight = 0.0
    }
    
    @objc func onKeyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
        }
        
    }
    
    func refreshBookmark() {
        let favorites = favoriteService.getFavorites()
        
        let exists = favorites.filter { (favorite) -> Bool in
            favorite.url == self.urlTextField.text
        }
        
        if !exists.isEmpty {
            self.bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            
            self.bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    func setUpWebView() {
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let term = self.urlTextField.text {
            if term.isValidURL() {
                goToSite(term)
            } else {
                searchOnGoogle(term)
            }
            
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url?.absoluteString
        
        urlTextField.text = url
        history.append(url!)
        refreshBookmark()
        
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
            self.urlTextField.text = history.last!
            self.webView.load(request)
            return
        }
        
        self.urlTextField.text = self.googleAddress
        
        let request: URLRequest = URLRequest(url: URL(string: self.googleAddress)!)
        self.webView.load(request)
    }
    
    func goToSite(_ url: String) {
        self.loading.startAnimating()
        var address: String;
        
        if !url.contains("http://") && !url.contains("https://") {
            address = "http://\(url)"
        } else {
            address = url
        }
        
        let request: URLRequest = URLRequest(url: URL(string: address)!)
        self.webView.load(request)
    }
    
    func searchOnGoogle(_ search: String) {
        let encodedSearch = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let address = "\(self.googleAddress)/search?q=\(encodedSearch)"
        
        let request: URLRequest = URLRequest(url: URL(string: address)!)
        self.webView.load(request)
    }
    
    @IBAction func markAsFavorite(_ sender: Any) {
        if let url = self.urlTextField.text {
            if url.isValidURL() {
                
                let favorites = favoriteService.getFavorites()
                
                let exists = favorites.filter { (favorite) -> Bool in
                    favorite.url == url
                }
                
                if exists.isEmpty {
                    self.favoriteService.addToFavorite(url: url)
                    self.showToast(message: "Adicionado aos favoritos", offSetY: self.keyboardHeight)
                } else {
                    self.favoriteService.removeFavorite(forValue: url)
                    self.showToast(message: "Removido dos favoritos", offSetY: self.keyboardHeight)
                }
                
                refreshBookmark()
            }
        }
    }
    
    @IBAction func goToFavorites(_ sender: Any) {
        let favoritesViewController = storyboard?.instantiateViewController(identifier: "Favorites") as! FavoritesViewController
        
        self.present(favoritesViewController, animated: true, completion: nil)
    }
    
    @IBAction func backOnHistory(_ sender: Any) {
        self.webView.goBack()
    }
    
    @IBAction func advanceOnHistory(_ sender: Any) {
        self.webView.goForward()
    }
    
    @IBAction func shareUrl(_ sender: UIButton) {
        if let url = self.urlTextField.text{
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
