//
//  Model.swift
//  URLSessionProxy
//
//  Created by Karthik Shiva on 20/03/22.
//

import Foundation

typealias Post = String
struct UserFeed: Codable {
    let posts: [Post]
}

struct SearchResultsContainer: Codable {
    let searchResults: [Post]
}
