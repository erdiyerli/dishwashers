//
//  TestURLSession.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import Base

import Foundation

struct URLResponseStub {
    private(set) var statusCode: Int = 0
    private(set) var headers: [String: String]? = nil
    private(set) var payloadFileName: String? = nil
    private(set) var payloadString: String? = nil

    public init(statusCode: Int, headers: [String: String]?, payloadFileName: String?) {
        self.statusCode = statusCode
        self.headers = headers
        self.payloadFileName = payloadFileName
    }

    public init(jsonString: String) {
        self.payloadString = jsonString
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {

    let responseStub: URLResponseStub
    let handler: (Data?, URLResponse?, Error?) -> Void

    private let stubURLResponse: URLResponse

    override var response: URLResponse? {
        return stubURLResponse
    }

    init(url: URL, response responseStub: URLResponseStub, handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.responseStub = responseStub
        self.handler = handler

        self.stubURLResponse = HTTPURLResponse(url: url,
                                               statusCode: responseStub.statusCode,
                                               httpVersion: "1.1",
                                               headerFields: responseStub.headers)!
    }

    override func resume() {
        var data: Data?

        if let json = self.responseStub.payloadString {
           data = json.data(using: .utf8)
        } else if let payloadFileName = self.responseStub.payloadFileName {
            let parts = payloadFileName.split(separator: ".")

            guard let url = Bundle(for: StubURLSessionDataTask.self).url(forResource: String(parts[0]),
                                                                         withExtension: String(parts[1])) else {
                                                                            let message = "Invalid path for test payload file '\(payloadFileName)'"
                                                                            fatalError(message)
            }

            data = try? Data(contentsOf: url)
        }

        handler(data ?? "".data(using: .utf8), self.stubURLResponse, nil)
    }
}

final class TestURLSession: URLSession {

    private var stubResponse: URLResponseStub

    init(stubResponse: URLResponseStub) {
        self.stubResponse = stubResponse
    }

    override func getAllTasks(completionHandler: @escaping ([URLSessionTask]) -> Void) {
        completionHandler([])
    }

    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let url = request.url!
        let task = StubURLSessionDataTask(url: url, response: stubResponse, handler: completionHandler)
        return task
    }
}

