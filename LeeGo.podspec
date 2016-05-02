#
# Be sure to run `pod lib lint LeeGo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LeeGo"
  s.version          = "0.5.1"
  s.summary          = "A Swift framework that helps you decouple & modularise your UI component into small pieces of LEGO style's bricks."

  s.description      = <<-DESC
                        LeeGo is a Swift framework that helps you decouple & modularise your UI component into small pieces of LEGO style's bricks. Try to make iOS UI development declarative, configurable and highly reusable. LeeGo may help  you with:
                        * Describe your whole UI into small pieces of Lego style’s bricks. Let you configure your view as a `brick` whenever & wherever you want.
                        * No longer need to deal with a bunch of custom UIView’s subclasses. Instead, you only need to deal with different `Brick`s which is lightweight and pure value type.
                        * Designed to be UIKit friendly and non-intrusive. There is no need to inherit from other base class at all.
                        * Capable to update remotely almost everything via your JSON payload.
                        * Built-in convenience methods to make UIStackView like layout hassle-free.
                        * Built-in **self-sizing mechanism** to calculate cell’s height automatically.
                        * Benefits from Swift’s enum, let you put the whole UI in a single enum file.
                        DESC

  s.homepage         = "https://github.com/wangshengjia/LeeGo"
  s.screenshots      = "https://raw.githubusercontent.com/wangshengjia/LeeGo/master/Medias/leego.jpg"

  s.license          = { :type => "MIT", :file => "LICENSE" }

  s.author           = { "Victor Wang" => "wangshengjia01@gmail.com" }
  s.source           = { :git => "https://github.com/wangshengjia/LeeGo.git", :tag => s.version.to_s }

  s.social_media_url = 'https://twitter.com/wangshengjia'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*'

  # s.public_header_files = 'Sources/**/*.h'

  s.frameworks = 'UIKit'

end
