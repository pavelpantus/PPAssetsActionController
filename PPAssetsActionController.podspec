Pod::Spec.new do |s|
  s.name             = 'PPAssetsActionController'
  s.version          = '0.1.0'
  s.summary          = 'Highly customizable Action Sheet Controller with Assets Preview.'
  s.description      = <<-DESC
Highly customizable, easy to use Action Sheet Controller which shows previews of assets.
By default replicates system appearence but user can customize it to match the app style.
User can control every aspect of PPAssetsActionController's style.
                       DESC

  s.homepage         = 'https://github.com/pantuspavel/PPAssetsActionController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Pavel Pantus' => 'pantusp@gmail.com' }
  s.source           = { :git => 'https://github.com/pantuspavel/PPAssetsActionController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pantusp'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PPAssetsActionController/Classes/**/*'
  s.resource = 'PPAssetsActionController/Assets/*.xcassets'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MobileCoreServices', 'Photos'
end
