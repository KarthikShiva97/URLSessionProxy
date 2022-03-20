//
//  URLSessionProxyTests.swift
//  URLSessionProxyTests
//
//  Created by Karthik Shiva on 20/03/22.
//

import XCTest
@testable import URLSessionProxy

class URLSessionProxyTests: XCTestCase {
    var viewModel: ViewModel!
    
    override func setUp() {
        viewModel = ViewModel(networkLayer: .init())
        URLSessionProxy.clear()
    }
    
    func testIfViewModelLoadsUserFeedOnViewDidLoad() throws {
        let expectation = XCTestExpectation(description: "view model calls user feed API on viewDidLoad()")
        URLSessionProxy.handleRequest = { request in
            expectation.fulfill()
            return .default
        }
        viewModel.viewDidLoad()
        wait(for: [expectation], timeout: 1)
        XCTAssert(URLSessionProxy.contactedURLs.contains(URL(string: "https://www.mock.com/userfeed")!))
    }
    
    func testIfViewModelContactsSearchApiWithCorrectParameters() {
        let expectation = XCTestExpectation(description: "view model contacts Search API with passed in search term from view model")
        var request: URLRequest!
        URLSessionProxy.handleRequest = { _request in
            request = _request
            expectation.fulfill()
            return .default
        }
        
        viewModel.searchPosts(searchTerm: "iPhone Pro")
        wait(for: [expectation], timeout: 5)
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        XCTAssert(components.path == "/searchPosts")
        XCTAssert(components.queryItems!.first == URLQueryItem(name: "searchTerm", value: "iPhone Pro"))
    }
    
    func testUserPostsParsing() {
        struct Delegate: ViewModelDelegate {
            let expectation: XCTestExpectation
            func reloadPosts() {
                expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation(description: "view model contacts user feed API and ")
        URLSessionProxy.handleRequest = { request in
            return .init(result:
                .success("""
                    {
                      "posts": [
                        "iPhone 11",
                        "iPhone SE",
                        "iPhone 13 Pro",
                        "iPhone 13 Pro Max"
                      ]
                    }
                """.data(using: .utf8)!
            ))
        }
        
        viewModel.delegate = Delegate(expectation: expectation)
        viewModel.viewDidLoad()
        
        wait(for: [expectation], timeout: 5)
        XCTAssert(URLSessionProxy.contactedURLs.contains(URL(string: "https://www.mock.com/userfeed")!))
        XCTAssert(viewModel.posts == [
            "iPhone 11",
            "iPhone SE",
            "iPhone 13 Pro",
            "iPhone 13 Pro Max"
        ])
    }
    
    func testSearchResultsParsing() {
        struct Delegate: ViewModelDelegate {
            let expectation: XCTestExpectation
            func reloadSearchResults() {
                expectation.fulfill()
            }
        }
        
        let expectation = XCTestExpectation(description: "view model contacts search feed API and ")
        URLSessionProxy.handleRequest = { request in
            return .init(result:
                .success("""
                    {
                      "searchResults": [
                        "iPhone 13 Pro",
                        "iPhone 13 Pro Max"
                      ]
                    }
                """.data(using: .utf8)!
            ))
        }
        
        viewModel.delegate = Delegate(expectation: expectation)
        viewModel.searchPosts(searchTerm: "iPhone Pro")
        
        wait(for: [expectation], timeout: 5)
        XCTAssert(viewModel.searchResults == [
            "iPhone 13 Pro",
            "iPhone 13 Pro Max"
        ])
    }
    
    func testLogoutSuccess() {
        struct Delegate: ViewModelDelegate {
            let expectation: XCTestExpectation
            let handleLogoutResult: (Bool) -> ()
            func handleLogoutResult(didLogoutSuccessfully: Bool) {
                expectation.fulfill()
                handleLogoutResult(didLogoutSuccessfully)
            }
        }
        
        let expectation = XCTestExpectation(description: "view model contacts search feed API and ")
        URLSessionProxy.handleRequest = { request in
            return .init(response: .statusCode(200))
        }
        
        viewModel.delegate = Delegate(expectation: expectation) { didLogout in
            XCTAssertTrue(didLogout)
        }
        viewModel.logout()
        wait(for: [expectation], timeout: 1)
    }
}
