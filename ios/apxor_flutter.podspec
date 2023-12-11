#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint apxor_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'apxor_flutter'
  s.version          = '1.0.7'
  s.summary          = 'Apxor Flutter plugin.'
  s.description      = <<-DESC
Apxor Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.apxor.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Apxor' => 'dev@apxor.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.requires_arc = true
  s.dependency 'Apxor-Core', '~> 2.10.01'
  s.dependency 'Apxor-CE', '~> 1.05.03'
  s.dependency 'Apxor-RTA', '~> 1.09.01'
  s.dependency 'Apxor-WYSIWYG', '~> 1.02.52'
  s.dependency 'Apxor-Survey', '~> 1.04.01'
end
