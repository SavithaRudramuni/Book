//
//  BookAPIManager.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation

struct BookResponse:Decodable {
    
    var results:Result?

    
    struct Result:Decodable {
        var lists:[List]?
        private enum CodingKeys: String, CodingKey {
            case lists
        }
        
        init(from decoder: Decoder) throws {
            
            let container  = try decoder.container(keyedBy: CodingKeys.self)
            self.lists =  try container.decodeIfPresent([List].self, forKey: .lists)
        }
    }
    
    struct List:Decodable {
        var books:[Book]?
        private enum CodingKeys: String, CodingKey {
            case books
        }
        
        init(from decoder: Decoder) throws {
            
            let container  = try decoder.container(keyedBy: CodingKeys.self)
            self.books =  try container.decodeIfPresent([Book].self, forKey: .books)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case results
        case lists
    }
    
    init(from decoder: Decoder) throws {
        
        let container  = try decoder.container(keyedBy: CodingKeys.self)
        self.results =  try container.decodeIfPresent(Result.self, forKey: .results)
    }
}

class BookAPIManager:APIManager {
    
    let urlPath =  "https://api.nytimes.com/svc/books/v2/lists/overview.json?published_date=%@&api-key=%@"
    let apiKey = "76363c9e70bc401bac1e6ad88b13bd1d"
    
    func fetchBooks(date:String,closure:@escaping ([Book]?,APIError?)->Void) {
        
        let path =  String(format: urlPath,date ,apiKey)
        print("URL:\(path)")
        self.getDataOfApi(request: path) { (data:Data?, error:APIError?) in
            
            var result:BookResponse?
            
            if let data = data {
                do {
                    result =  try JSONDecoder().decode(BookResponse.self, from: data)
                } catch {
                    print("error:\(error)")
                }
            }
            
            var books:[Book]?
            
            if let lists =  result?.results?.lists {
                books =  [Book]()
                for list in lists {
                    
                    if let aBooks =  list.books {
                        books?.append(contentsOf: aBooks)
                    }
                }
            }
            
            closure(books,error)
  
        }
    }
    
}
