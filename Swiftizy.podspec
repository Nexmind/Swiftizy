#
# Be sure to run `pod lib lint Swiftizy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Swiftizy"
  s.version          = "1.3.2"
  s.summary          = "Swiftizy help you in your development with CoreData, Rest, Json,..."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Swiftizy help you in your development with a lot of tool like helper for CoreData, consume REST service, JSON, and other little tools
                       DESC

  s.homepage         = "https://github.com/Nexmind/Swiftizy"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Julien Henrard" => "j.henrard@nexmind.com" }
  s.source           = { :git => "https://github.com/Nexmind/Swiftizy.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.platform = :ios, '8.0'

  s.source_files = 'Swiftizy/Classes/**/*'
#s.resource_bundles = {
#   'Swiftizy' => ['Swiftizy/Assets/*.png']
# }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
