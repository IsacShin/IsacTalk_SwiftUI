# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IsacTalk' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
    #UI 관련
    pod 'SnapKit'
    pod 'Hex'
    pod 'Kingfisher'
    pod 'YPImagePicker'

    #AdMob관련
    pod 'Google-Mobile-Ads-SDK'

  # Pods for IsacTalk

  target 'IsacTalkTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IsacTalkUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
        end
    end
end
