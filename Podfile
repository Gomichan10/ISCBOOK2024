# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'ISCBOOK2024' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ISCBOOK2024
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseStorage'
pod 'FirebaseUI/Storage'
pod 'Alamofire', '~> 5.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end

plugin 'cocoapods-keys', {
  :project => "ISCBOOK2024",
  :keys => [
    "GoogleBooksAPIKey"
  ]
}