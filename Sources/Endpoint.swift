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

import Alamofire
import Foundation

/// `String` itself.
public typealias Rule = String

/// `Alamofire.Manager` for `Endpoint` enum names.
private var managers = [String: Manager]()


// MARK: - Endpoint

public protocol Endpoint: RawRepresentable {
    static var baseURLString: String { get }
    var rule: Rule { get }
}


public extension Endpoint {

    // MARK: Rule

    public var rule: Rule {
        return self.rawValue as! Rule
    }


    // MARK: Manager

    public static var manager: Alamofire.Manager {
        let name = String(self)
        if let manager = managers[name] {
            return manager
        }

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders

        let manager = Alamofire.Manager(configuration: configuration)
        managers[name] = manager
        return manager
    }


    // MARK: Building URLs

    /// Parses and returns HTTP Method and URL from `Rule`.
    ///
    /// - Parameters:
    ///     - values: A dictionary which contains URL placeholder values.
    ///
    /// - Returns: `Alamofire.Method`, `NSURL`, and the parameter dictionary except URL placeholder values.
    public func buildURL(values: [String: AnyObject]? = nil) -> (method: Alamofire.Method,
                                                                 URL: NSURL,
                                                                 otherValues: [String: AnyObject]?) {
        let method: Alamofire.Method
        var path: String

        // e.g. "GET /me" -> ["GET", "/me"]
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        let components = self.rule.componentsSeparatedByCharactersInSet(whitespace).filter { !$0.isEmpty }
        if components.count > 1 {
            method = Alamofire.Method(rawValue: components[0]) ?? .GET
            path = components[1]
        } else {
            method = .GET
            path = components[0]
        }

        var placeholders = [String]()

        // replace `<key>` with `value`
        for (key, value) in values ?? [:] {
            let pattern = "<" + key + ">" // 3x faster than "<\(key)>"
            let replacement = value as? String ?? String(value)
            if path.containsString(pattern) {
                path = path.stringByReplacingOccurrencesOfString(pattern, withString: replacement)
                placeholders.append(key)
            }
        }

        var otherValues = values
        for key in placeholders {
            otherValues?.removeValueForKey(key) // remove URL placeholder values
        }

        let URL = NSURL(string: self.dynamicType.baseURLString + path)!
        return (method, URL, otherValues)
    }


    // MARK: Request

    /// Send an HTTP request with Endpoint information.
    ///
    /// - parameters:
    ///     - parameters: The values for URL placeholders and HTTP request parameters.
    ///     - unless: The URL or URL path. If exists, send an HTTP request using this instead of Endpoint URL.
    ///
    /// - Returns: The `Alamofire.Request` instance.
    public func request(parameters: [String: AnyObject]? = nil,
                        encoding: Alamofire.ParameterEncoding = .URL,
                        unless: URLStringConvertible? = nil) -> Alamofire.Request {
        let (method, URL, otherValues) = self.buildURL(parameters)

        // if `unless` is the URL string
        if let URLString = unless?.URLString, URL = NSURL(string: URLString) where !URL.scheme.isEmpty {
            return Alamofire.request(method, URL)
        }
        // if `unless` is the URL path
        if let path = unless?.URLString {
            return Alamofire.request(method, self.dynamicType.baseURLString + path)
        }

        return Alamofire.request(method, URL, parameters: otherValues, encoding: encoding)
    }

}
