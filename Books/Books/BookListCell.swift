//
//  BookListCell.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation
import UIKit


class BookListCell: UITableViewCell {
    
    @IBOutlet weak var bookTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var publisherLabel:UILabel!
    
    var book:Book? {
        didSet {
            
            if let book = book {
                
                bookTitleLabel.text =  book.title
                if let author = book.author {
                authorLabel.text = "By:\(author)"
                }
                if let publisher =  book.publisher {
                publisherLabel.text = "Published by:\(publisher)"
                }
            }
        }
    }
}
