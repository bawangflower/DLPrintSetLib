#
# Be sure to run `pod lib lint DLPrintSetLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DLPrintSetLib'
  s.version          = '0.1.0'
  s.summary          = 'DLPrintSetLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    多种方式的打印设置
                       DESC

  s.homepage         = 'https://github.com/bawangflower/DLPrintSetLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bawangflower' => 'flower258@dingtalk.com' }
  s.source           = { :git => 'https://github.com/bawangflower/DLPrintSetLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DLPrintSetLib/Classes/**/*'

   s.resource_bundles = {
     'DLPrintSetLib' => ['DLPrintSetLib/Assets/*.png']
   }

    s.public_header_files = 'DLPrintSetLib/Classes/*.h'
    s.dependency 'Colours'
    s.dependency 'Masonry'
    s.dependency 'DLFoundationLib'
    s.dependency 'DLNetwork'
    s.dependency 'MJExtension'

end
