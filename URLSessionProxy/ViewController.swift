//
//  ViewController.swift
//  URLSessionProxy
//
//  Created by Karthik Shiva on 20/03/22.
//

import UIKit

class ViewController: UIViewController, ViewModelDelegate {
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    func reloadPosts() {
        
    }
    
    func reloadSearchResults() {
        
    }
    
    func handleLogoutResult(didLogoutSuccessfully: Bool) {
        
    }
}

