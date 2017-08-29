Pod::Spec.new do |s|
  s.name             = 'Moya-ErrorObjectMapper'
  s.version          = '0.1.0'
  s.summary          = 'ObjectMapper bindings when Moya encounters a status code error.'
  s.description      = <<-DESC
When Moya throws a status code MoyaError indicating that the API server returned an invalid status code, use Moya-ErrorObjectMapper to get error message from JSON body of error response.
                       DESC

  s.homepage         = 'https://github.com/levibostian/Moya-ErrorObjectMapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Levi Bostian' => 'levi.bostian@gmail.com' }
  s.source           = { :git => 'https://github.com/Levi Bostian/Moya-ErrorObjectMapper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/levibostian'
  s.ios.deployment_target = '8.0'
  s.default_subspec = "Core"
  s.framework = "Foundation"
    
  s.subspec "Core" do |ss|
    ss.source_files  = "Moya-ErrorObjectMapper/Classes/Core/**/*.swift"
    ss.dependency "Moya-ObjectMapper", '~> 2.3.2'
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Moya-ErrorObjectMapper/Classes/RxSwift/**/*.swift"
    ss.dependency "Moya-ObjectMapper/RxSwift", '~> 2.3.2'
    ss.dependency "Moya-ErrorObjectMapper/Core"
  end

end
