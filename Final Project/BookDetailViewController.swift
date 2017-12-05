//
//  BookDetailViewController.swift
//  Final Project
//
//  Created by Mia Tortolani on 11/30/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class BookDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ISBNLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    var bookData: BookData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bookData = bookData {
            titleLabel.text = bookData.bookName
            priceLabel.text = "$\(bookData.price)"
            ISBNLabel.text = "\(bookData.ISBN)"
            conditionLabel.text = bookData.condition
        } else {
            bookData = BookData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindBook" {
            let destination = segue.destination as! BookWebViewController
            destination.book = bookData
        }
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        showAlert(title: "Contact Seller", message: "Contact \((bookData?.postingUserID)!) for information and availability.")
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
