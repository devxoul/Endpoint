Pod::Spec.new do |s|
  s.name             = "Endpoint"
  s.version          = "0.1.0"
  s.summary          = "Elegant API Abstraction for Swift."
  s.homepage         = "https://github.com/devxoul/Endpoint"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Suyeol Jeon" => "devxoul@gmail.com" }
  s.source           = { :git => "https://github.com/devxoul/Endpoint.git",
                         :tag => s.version.to_s }
  s.source_files     = "Sources/*.swift"
  s.requires_arc     = true

  s.dependency 'Alamofire', '~> 3.1'

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
end
