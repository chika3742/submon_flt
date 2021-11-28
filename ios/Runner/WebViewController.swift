//
//  WebViewController.swift
//  Runner
//
//  Created by 近松和矢 on 2021/03/14.
//
import UIKit
import WebKit

class WebViewController: UIViewController {
    var url: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (url != nil) {
            navItem.title = title
            let req = URLRequest(url: URL(string: url!)!)
            webView.load(req)
        }
    }
    
    @IBAction func onTapDoneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navItem: UINavigationItem!
}
