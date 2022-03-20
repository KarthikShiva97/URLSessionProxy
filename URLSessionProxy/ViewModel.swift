//
//  ViewModel.swift
//  conffetiEffect
//
//  Created by Karthik Shiva on 12/03/22.
//

import Foundation

protocol ViewModelDelegate {
    func reloadPosts()
    func reloadSearchResults()
    func handleLogoutResult(didLogoutSuccessfully: Bool)
}

extension ViewModelDelegate {
    func reloadPosts() {}
    func reloadSearchResults() {}
    func handleLogoutResult(didLogoutSuccessfully: Bool) {}
}

class ViewModel {
    let networkLayer: NetworkLayer
    var posts = [Post]()
    var searchResults = [Post]()
    var delegate: ViewModelDelegate?
    
    init(networkLayer: NetworkLayer = .init()) {
        self.networkLayer = networkLayer
    }
    
    func viewDidLoad() {
        networkLayer.loadUserFeed { userFeed in
            self.posts = userFeed.posts
            self.delegate?.reloadPosts()
        }
    }
    
    func searchPosts(searchTerm: String) {
        networkLayer.searchPosts(searchTerm: searchTerm) { container in
            self.searchResults = container.searchResults
            self.delegate?.reloadSearchResults()
        }
    }
    
    func logout() {
        networkLayer.logout {
            self.delegate?.handleLogoutResult(didLogoutSuccessfully: $0)
        }
    }
}
