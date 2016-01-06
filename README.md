Endpoint
========

![Swift](https://img.shields.io/badge/Swift-2.1-orange.svg)
[![Build Status](https://travis-ci.org/devxoul/Endpoint.svg)](https://travis-ci.org/devxoul/Endpoint)
[![CocoaPods](http://img.shields.io/cocoapods/v/Endpoint.svg)](https://cocoapods.org/pods/Endpoint)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

🚀 Elegant API Abstraction for Swift.


At a Glance
-----------

##### API Declarations

Create an Enum with raw type `Rule` and conform protocol `Endpoint`. Each cases is the API endpoint which contains HTTP method and URL path.

```swift
enum GitHub: Rule, Endpoint {
    static var baseURLString = "https://api.github.com"

    case Repo        = "GET  /repos/{owner}/{repo}"
    case RepoIssues  = "GET  /repos/{owner}/{repo}/issues"
    case CreateIssue = "POST /repos/{owner}/{repo}/issues"
}
```

##### Using APIs

Endpoint is built on [Alamofire](https://github.com/Alamofire/Alamofire). Calling `request()` on endpoint cases returns `Alamofire.Request` instance.

```swift
GitHub.Repo.request(["owner": "devxoul", "repo": "Then"]).responseJSON { response in
    // This is an Alamofire's response block!
}
```

This example is sending an HTTP request to `https://api.github.com/repos/devxoul/Then` using `GET`.


Installation
------------

- **Using [CocoaPods](https://cocoapods.org)**:

    ```ruby
    pod 'Endpoint', '~> 0.1'
    ```

- **Using [Carthage](https://github.com/Carthage/Carthage)**:

    ```
    github "devxoul/Endpoint" ~> 0.1
    ```

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

    ```swift
    import PackageDescription

    let package = Package(
        name: "MyAwesomeApp",
        dependencies: [
            .Package(url: "https://github.com/devxoul/Endpoint", "0.1.0"),
        ]
    )
    ```


License
-------

**Endpoint** is under MIT license. See the [LICENSE](LICENSE) file for more info.
