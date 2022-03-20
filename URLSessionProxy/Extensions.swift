//
//  Extensions.swift
//  URLSessionProxy
//
//  Created by Karthik Shiva on 20/03/22.
//

import Foundation

extension URLSession {
    static func injectProxy() {
        #if !Release
        URLProtocol.registerClass(URLSessionProxy.self)
        URLSession.shared.configuration.protocolClasses = [URLSessionProxy.self]
        #endif
    }
}

extension URLResponse {
    static func statusCode(_ code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: .init(string: "google.com")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
