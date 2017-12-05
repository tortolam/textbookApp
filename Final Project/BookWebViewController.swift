//
//  BookWebViewController.swift
//  Final Project
//
//  Created by Mia Tortolani on 12/5/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit

class BookWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var book: BookData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://isbn.nu/" + book.ISBN)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }

}
