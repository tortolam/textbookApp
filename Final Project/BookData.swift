//
//  BookData.swift
//  Final Project
//
//  Created by Mia Tortolani on 11/29/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import Foundation
import MapKit


class BookData: NSObject {

    var bookName: String
    var ISBN: String
    var price: Double
    var condition: String
    var postingUserID: String
    var bookDocumentID: String
    
    var dictionary: [String: Any] {
        return ["bookName": bookName,
                "ISBN": ISBN,
                "price": price,
                "condition": condition,
                "postingUserID": postingUserID]
    }
    
    init(bookName: String, ISBN: String, price: Double, condition: String, postingUserID: String, bookDocumentID: String) {
        self.bookName = bookName
        self.ISBN = ISBN
        self.price = price
        self.condition = condition
        self.postingUserID = postingUserID
        self.bookDocumentID = bookDocumentID

    }
    
    convenience override init() {
        self.init(bookName: "", ISBN: "", price: 0.0, condition: "", postingUserID: "", bookDocumentID: "")
    }
    
    convenience  init(dictionary: [String: Any]) {
        let bookName = dictionary["bookName"] as! String? ?? ""
        let condition = dictionary["condition"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let ISBN = dictionary["ISBN"] as! String? ?? ""
        let price = dictionary["price"] as! Double? ?? 0
        self.init(bookName: bookName, ISBN: ISBN, price: price, condition: condition, postingUserID: postingUserID, bookDocumentID: "")
    }
}
