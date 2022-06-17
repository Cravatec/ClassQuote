//
//  QuoteService.swift
//  ClassQuote
//
//  Created by Sam on 17/06/2022.
//  Copyright © 2022 OpenClassrooms. All rights reserved.
//

import Foundation

class QuoteService {
    private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureURL = URL(string: "https://source.unsplash.com/random/1000x1000")!
    
    // private var task: URLSessionDataTask?
    
    static func getQuote() {
        // Request
        var request = URLRequest(url: QuoteService.quoteUrl)
        // Request Method
        request.httpMethod = "POST"
        // Request Body
        let body = "method=getQuote&lang=en&format=json"
        // Encoding method
        request.httpBody = body.data(using: .utf8)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in guard let data = data, error == nil else {
            return
        }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                  let text = responseJSON["quoteText"],
                  let author = responseJSON["quoteAuthor"] else {
                return
            }
            getImage { data in
                print(data)
                print(text)
                print(author)
            }
        }
            task.resume()
        }
    
    
    private static func getImage(completionHandler: @escaping (Data?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: pictureURL) { (data, response, error) in guard let data = data, error == nil else {
            completionHandler(nil)
            return
        }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
}
