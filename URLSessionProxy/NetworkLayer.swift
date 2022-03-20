//
//  NetworkLayer.swift
//  conffetiEffect
//
//  Created by Karthik Shiva on 12/03/22.
//

import Foundation

class NetworkLayer {
    func loadUserFeed(onCompletion: @escaping (UserFeed)->()) {
        URLSession.shared.dataTask(with: URL(string: "https://www.mock.com/userfeed")!) { data, response, error in
            try? onCompletion(
                JSONDecoder().decode(UserFeed.self, from: data!)
            )
        }.resume()
    }
    
    func searchPosts(searchTerm: String, onCompletion: @escaping (SearchResultsContainer)->()) {
        var components = URLComponents(string: "https://www.mock.com/searchPosts")!
        components.queryItems = [.init(name: "searchTerm", value: "\(searchTerm)")]
        
        URLSession.shared.dataTask(with: .init(url: components.url!)) { data, response, error in
            try? onCompletion(
                JSONDecoder().decode(SearchResultsContainer.self, from: data!)
            )
        }.resume()
    }
    
    func logout(onCompletion: @escaping (Bool)->()) {
        URLSession.shared.dataTask(with: URL(string: "https://www.mock.com/logout")!) { data, response, error in
            onCompletion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }
}
