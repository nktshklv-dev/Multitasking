//
//  ViewController.swift
//  Multitasking
//
//  Created by Nikita  on 8/9/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var adressBar: UITextField!
    @IBOutlet var stackView: UIStackView!
    weak var activeWebView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    func setDefaultTitle(){
        title = "Multibrowser"
    }
    
    
    @objc func addWebView(){
       let webView = WKWebView()
        
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://google.com")!
        webView.load(URLRequest(url: url))
        
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func deleteWebView(){
        if let webView = activeWebView{
            if let index = stackView.arrangedSubviews.firstIndex(of: webView){
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0{
                    setDefaultTitle()
                } else{
                    var currentIndex = Int(index)
                    
                    if currentIndex == stackView.arrangedSubviews.count{
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView{
                        selectWebView(newSelectedWebView)
                    }
                }
                
                
                
            }
        }
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer){
        if let selectedWebView = recognizer.view as? WKWebView{
            selectWebView(selectedWebView)
           
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func selectWebView(_ webView: WKWebView){
        for view in stackView.arrangedSubviews{
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        title = webView.title!
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = adressBar.text{
            if let url = URL(string: address){
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }


}

