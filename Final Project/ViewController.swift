//
//  ViewController.swift
//  Final Project
//
//  Created by Mia Tortolani on 11/29/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController {

    // MARK: - OUTLETS + VARIABLES
    @IBOutlet weak var tableView: UITableView!
    
    var books = [BookData]()
    var authUI: FUIAuth!
    var db: Firestore!
    
    //MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        print("******PRINTED")
        
        db = Firestore.firestore()
        print("!!!!!!!!!PRINTED")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! BookDetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.bookData = books[selectedRow]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
            let source = segue.source as! SellBookViewController
            saveData(bookData: source.bookData!)
        }
    
    
    // MARK: - FUNCTIONS
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            print(authUI)
            print(authUI.authViewController())
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }

    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
            do {
                try authUI!.signOut()
                print("^^^ Succesfully signed out!")
                signIn()
            } catch {
                print("Couldn't sign out.")
            }
    }
    
    func signOut() {
        do {
            try authUI!.signOut()
            print("^^^ Succesfully signed out!")
            //signIn()
        } catch {
            print("Couldn't sign out.")
        }
    }
    
    func checkForUpdates() {
        db.collection("books").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error adding the snapshot listener")
                return
            }
            self.loadData()
        }
    }
    
    func loadData() {
        print("******db.collection")
        db.collection("books").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("Error: Reading documents \(error!.localizedDescription)")
                return
            }
            self.books = []
            for document in querySnapshot!.documents {
                let bookData = BookData(dictionary: document.data())
                bookData.bookDocumentID = document.documentID
                self.books.append(bookData)
            }
            self.tableView.reloadData()
        }
        print("******load data")

    }
    
    func saveData(bookData: BookData) {
        if let postingUserID = (authUI.auth?.currentUser?.email) {
            bookData.postingUserID = postingUserID
        } else {
            bookData.postingUserID = "Unknown User"
        }
        
        let dataToSave: [String: Any] = bookData.dictionary
        
        if bookData.bookDocumentID != "" {
            let ref = db.collection("books").document(bookData.bookDocumentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                } else {
                    print("Document updated w/ reference ID \(ref)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("books").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                } else {
                    print("Document updated w/ reference ID \(ref!.documentID)")
                }
            }
        }
    }
    
    
}

// MARK: -
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].bookName
        cell.detailTextLabel?.text = "$\(books[indexPath.row].price)"
        return cell
    }
    
}

// MARK: -
extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        print("!!!!!FUIAuthDelegate")
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        print("lejr;oahenr.ance")
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            print("*** Successfully logged in with user = \(user.email!)")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        print("@@@@@@@@@@@")
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        print("**********")
        let marginInset: CGFloat = 16
        let imageY = self.view.center.y - 225
        
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInset, y: imageY, width: self.view.frame.width - (marginInset*2), height: 225)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "appLogo")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        
        return loginViewController
    }
}
