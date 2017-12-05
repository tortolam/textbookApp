//
//  SellBookViewController.swift
//  Final Project
//
//  Created by Mia Tortolani on 11/29/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

var books = [BookData]()

class SellBookViewController: UIViewController {

    var bookData: BookData?
    var authUI: FUIAuth!
    var db: Firestore!
    
    @IBOutlet weak var bookNameField: UITextField!
    @IBOutlet weak var ISBNField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var bookSegment: UISegmentedControl!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self as? FUIAuthDelegate
        
        db = Firestore.firestore()
        
        bookNameField.becomeFirstResponder()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func sellButtonPressed(_ sender: UIButton) {
        let newBook = getDataFromFields()
        saveData(newBook: newBook)
        clearFields()
    }
    
    func saveData(newBook: BookData) {
        if let postingUserID = (authUI.auth?.currentUser?.email) {
            newBook.postingUserID = postingUserID
        } else {
            newBook.postingUserID = "Unknown User"
        }
        
        let dataToSave: [String: Any] = newBook.dictionary
        
        if newBook.bookDocumentID != "" {
            let ref = db.collection("books").document(newBook.bookDocumentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                } else {
                    print("Document updated with reference ID \(ref.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            print("*****ref: DocumentReference? = nil")
            ref = db.collection("books").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                } else {
                    print("@^@^@^@")
                    print("Document added with reference ID \(ref!.documentID)")
                    newBook.bookDocumentID = "\(ref!.documentID)"
                    print("****new document id")
                }
            }
        }
    }
    
    func getDataFromFields() -> BookData {
        let newBook = BookData()
        newBook.bookName = bookNameField.text!
        newBook.ISBN = ISBNField.text!
        
        if let postingUserID = (authUI.auth?.currentUser?.email) {
            newBook.postingUserID = postingUserID
        } else {
            newBook.postingUserID = "Unknown User"
        }
        
        // Check for valid ISBN number
//        if let ISBN = ISBNField.text! {
//            newBook.ISBN = ISBN
//        } else {
//            showAlert(title: "Invalid ISBN", message: "Please enter your book's ISBN")
//        }
        
        // Check for valid price
        if let price = Double(priceField.text!) {
            newBook.price = price
        } else {
            showAlert(title: "Invalid Item Price", message: "Please enter a valid number for book price")
        }
        
        if bookSegment.selectedSegmentIndex == 0 {
            newBook.condition = "Used"
            print("******New")
        } else {
            newBook.condition = "New"
        }
        books.append(newBook)
        return newBook
    }
    
    func clearFields() {
        bookNameField.text = ""
        ISBNField.text = ""
        priceField.text = ""
        bookSegment.selectedSegmentIndex = 0
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
