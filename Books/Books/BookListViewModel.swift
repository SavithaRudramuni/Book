//
//  BookListViewModel.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation

class Observable<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

class BookListViewModel {
    var list:[Book] = [Book]()
    let apiManger =  BookAPIManager()
    var currentDisplayList:[Book] = [Book]()
    
    let searchFilters = ["title", "author", "publisher"]
    
    var currentSelectedIndex:Observable<Int> = Observable(0)
    
    var currentDate =  Date()
    
    let dateFormatter =  DateFormatter()
    
    func getDateForRequest(date:Date)->String{
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //yyyy-mm-dd&
        return dateFormatter.string(from: date)
    }
    
    func fetchBooks(closure:@escaping (_ error:APIError?)->Void){
        
        let date =  self.getDateForRequest(date: currentDate)
        
        apiManger.fetchBooks(date: date) { [weak self](list:[Book]?, error:APIError?) in
            self?.list =  list ?? []
            self?.currentDisplayList =  list ?? []
            closure(error)
        }
    }
    
    func searchBooks(keyword:String) {
        
        if currentSelectedIndex.value == 0 {
            self.searchBooks(title: keyword)
        } else if currentSelectedIndex.value == 1 {
            self.searchBooks(author: keyword)
        } else if currentSelectedIndex.value == 2 {
            self.searchBooks(publisher: keyword)
        }
    }
    
    func searchBooks(author:String) {
        
        self.currentDisplayList =  self.list.filter({ (book:Book) -> Bool in
            return book.author?.lowercased().contains(author.lowercased()) == true
        })
        
    }
    
    func searchBooks(publisher:String) {
        
        self.currentDisplayList =  self.list.filter({ (book:Book) -> Bool in
            return book.publisher?.lowercased().contains(publisher.lowercased()) == true
        })
    }
    
    func searchBooks(title:String) {
       
        self.currentDisplayList =  self.list.filter({ (book:Book) -> Bool in
            return book.title?.lowercased().contains(title.lowercased()) == true
        })
    }
    
    func resetSeach() {
        self.currentDisplayList =  self.list
    }
}
