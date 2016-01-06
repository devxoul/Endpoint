//
//  EndpointTests.swift
//  EndpointTests
//
//  Created by 전수열 on 1/7/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import XCTest

import Alamofire
import Endpoint

enum GitHub: Rule, Endpoint {

    static var baseURLString = "https://api.github.com"

    case User = "GET /user/{username}"

    case Repo = "GET /repos/{owner}/{repo}"
    case RepoIssues  = "GET  /repos/{owner}/{repo}/issues"
    case CreateIssue = "POST /repos/{owner}/{repo}/issues"

}

class EndpointTests: XCTestCase {

    func testBuildURL() {
        {
            let values = ["owner": "devxoul", "repo": "Then"]
            let (method, URL, otherValues) = GitHub.Repo.buildURL(values)
            XCTAssertEqual(method, Alamofire.Method.GET)
            XCTAssertEqual(URL.absoluteString, "https://api.github.com/repos/devxoul/Then")
            XCTAssertTrue(otherValues?.isEmpty == true)
        }();
        {
            let values = ["owner": "devxoul", "repo": "Then"]
            let (method, URL, otherValues) = GitHub.RepoIssues.buildURL(values)
            XCTAssertEqual(method, Alamofire.Method.GET)
            XCTAssertEqual(URL.absoluteString, "https://api.github.com/repos/devxoul/Then/issues")
            XCTAssertTrue(otherValues?.isEmpty == true)
        }();
        {
            let values = ["owner": "devxoul", "repo": "Then", "title": "Hello, World!"]
            let (method, URL, otherValues) = GitHub.CreateIssue.buildURL(values)
            XCTAssertEqual(method, Alamofire.Method.POST)
            XCTAssertEqual(URL.absoluteString, "https://api.github.com/repos/devxoul/Then/issues")
            XCTAssertEqual(otherValues?.count, 1)
            XCTAssertEqual(otherValues!["title"] as? String, "Hello, World!")
        }();
    }

    func testRequest() {
        {
            let values = ["owner": "devxoul", "repo": "Then", "title": "Hello, World!"]
            let request = GitHub.CreateIssue.request(values)
            XCTAssertEqual(request.request?.HTTPMethod, "POST")
            XCTAssertEqual(request.request?.URL?.absoluteString, "https://api.github.com/repos/devxoul/Then/issues")
        }();
    }

}
