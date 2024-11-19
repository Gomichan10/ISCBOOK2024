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


plugin 'cocoapods-keys', {
  :project => "ISCBOOK2024",
  :keys => [
    "GoogleBooksAPIKey",
    "BooksAPIKey",
    "StudentAPIKey",
    "BookSearchAPIKey"
  ]
}
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # xcconfigファイルの修正
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end

    # abseilライブラリのC++バージョン設定
    if target.name == 'abseil'
      Pod::UI.puts "Workaround: Configuring abseil to use gnu++14 language standard for cocoapods 1.16+ compatibility".yellow
      Pod::UI.puts "            Remove workaround when upstream issue fixed https://github.com/firebase/firebase-ios-sdk/issues/13996".yellow
      target.build_configurations.each do |config|
        config.build_settings['CLANG_CXX_LANGUAGE_STANDARD'] = 'gnu++14'
      end
    end
  end
end