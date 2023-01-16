Pod::Spec.new do |spec|
  spec.name         = "APIManager"
  spec.version      = "1.0.0"
  spec.summary      = "APIManager is a wrapper that is used to make network calls using URLSession and is capable of decoding a Model when passed to it as an argument."
  spec.description  = "APIManager is a library that helps you make network calls using URLSession. No need to write your own url session, just a pod install and you are good to use the super cool feature this pod. Want more? it even decodes your models and saves your parsing time."
  spec.homepage     = "https://github.com/ptejas26/APIManager"
  spec.license      = "MIT"
  swift_versions    = "5.5"
  
  spec.author       = { "ptejas26" => "ptejas.patelia@gmail.com" }
  spec.social_media_url   = "https://twitter.com/tejaspatelia"
  spec.platform     = :ios, "15.5"
  spec.source       = { :git => "https://github.com/ptejas26/APIManager.git", :tag => "1.0.0" }
  spec.source_files  = "APIManager/*.{h,m,swift}"
end
