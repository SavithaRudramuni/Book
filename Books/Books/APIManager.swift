//
//  APIManager.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation


class APIManager {
    
    private var session:URLSession =  URLSession(configuration: URLSessionConfiguration.default)
    private var queue =   DispatchQueue(label: "book.api.queue",attributes: .concurrent)
    
    func getDataOfApi(request:String, completionBlock: @escaping (Data?, APIError?) -> Void) {
        
        self.queue.async {
            
            if let url =  URL(string: request) {
            let aRequest: URLRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
                let task: URLSessionDataTask = self.session.dataTask(with:aRequest ) { (data:Data?, response:URLResponse?, error:Error?) in
                    let currentError = error?.converToApiError()
                    completionBlock(data, currentError)
                }
                task.resume()
            } else {
                completionBlock(nil, APIError.invalidRequest)
            }

          
        }
    }
}
