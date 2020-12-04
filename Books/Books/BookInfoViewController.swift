//
//  BookInfoViewController.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation
import UIKit

class BookInfoViewController:UIViewController {
    
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var bookTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var infoLabel:UILabel!
    
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.numberOfLines = 0
        infoLabel.numberOfLines = 0
        
        if let book = book {
            
            bookTitleLabel?.text =  book.title
            if let author = book.author, let publisher =  book.publisher {
                authorLabel?.text = "By:\(author) Published by:\(publisher)"
            }
            if let info  = book.info {
                infoLabel?.text = info
            }
            
            DispatchQueue.main.async {
                
                if let path  = book.imageUrl , let url = URL(string: path) {
                    
                    do {
                        let data =  try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
}
