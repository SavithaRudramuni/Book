//
//  Book.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation

struct Book:Decodable {
    var title:String?
    var author:String?
    var publisher:String?
    var contributor:String?
    var info:String?
    var imageUrl:String?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case author
        case publisher
        case contributor
        case info =  "description"
        case imageUrl = "book_image"
    }
    
}
