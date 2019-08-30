#
# Be sure to run `pod lib lint EventsCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EventsCalendar'
  s.version          = '0.1.0'
  s.swift_version    = '4.2'
  s.summary          = 'A light weight customizable iOS CalendarView with events population written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Events Calendar is a user-friendly iOS Swift library that helps you achieve a cool Calendar UI with events mapping. Its supports both sync and async events loading. It is very light and optimized that it allows to achieve ~60 fps rendering easily. Achieves smooth scrolling and takes less memory. The attributes of calendar UI are completely customizable.
                       DESC

  s.homepage         = 'https://github.com/akaashdev/EventsCalendar'
  s.screenshots      = 'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_1.png',
                        'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_2.png',
                        'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_3.png',
                        'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_4.png',
                        'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_5.png',
                        'https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_6.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Akaash Dev' => 'heatblast.akaash@gmail.como' }
  s.source           = { :git => 'https://github.com/akaashdev/EventsCalendar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'EventsCalendar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'EventsCalendar' => ['EventsCalendar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
