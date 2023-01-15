#
#  Be sure to run `pod spec lint APIManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "APIManager.podspec"
  spec.version      = "1.0.0"
  spec.summary      = "APIManager is a wrapper that is used to make network calls using URLSession and is capable of decoding a Model when passed to it as an argument."
  spec.description  = <<-DESC
    APIManager is a library that helps you make network calls using URLSession. No need to write your own url session, just a pod install and you are good to use the super cool feature this pod. Want more? it even decodes your models and saves your parsing time.
                   DESC
  spec.homepage     = "https://github.com/ptejas26/APIManager"
  spec.license      = "MIT (example)"
  
  spec.author       = { "ptejas26" => "ptejas.patelia@gmail.com" }
  spec.social_media_url   = "https://twitter.com/tejaspatelia"
  spec.platform     = :ios, "15.5"
  spec.source       = { :git => "https://github.com/ptejas26/APIManager.git", :tag => "1.0.0" }
  spec.source_files  = "APIManager/**/*"
end
