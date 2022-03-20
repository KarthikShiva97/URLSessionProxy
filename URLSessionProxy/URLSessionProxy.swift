//
//  MockNetworkProxy.swift
//  conffetiEffect
//
//  Created by Karthik Shiva on 12/03/22.
//

import Foundation

class URLSessionProxy: URLProtocol {
    static var contactedURLs = [URL]()
    static var shouldHandleRequest: ((URLRequest) -> Bool) = { _ in false }
    static var handleRequest: ((URLRequest) -> RequestHandler)?
    
    static func clear() {
        contactedURLs.removeAll()
        shouldHandleRequest = { _ in true }
        handleRequest = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        if let url = request.url {
            contactedURLs.append(url)
        }
        return shouldHandleRequest(request)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.handleRequest?(request) else {
            return
        }
        
        switch requestHandler.result {
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
            
        case .success(let data):
            client?.urlProtocol(
                self,
                didReceive: requestHandler.response,
                cacheStoragePolicy: requestHandler.cacheStoragePolicy
            )
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension URLSessionProxy {
    struct RequestHandler {
        var cacheStoragePolicy: URLCache.StoragePolicy = .notAllowed
        var result: Result<Data, Error> = .success(.init())
        var response: HTTPURLResponse = .init()
        static let `default`: Self = .init()
    }
}
