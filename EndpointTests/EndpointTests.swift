// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
