platform :ios, '9.0'

def common_pods
  pod 'SwiftLint'
end

target 'Kiko' do
  use_frameworks!

  common_pods
  target 'KikoTests' do
    inherit! :search_paths
  end
end

target 'KikoModels' do
  use_frameworks!

  common_pods
  pod 'RealmSwift'

  target 'KikoModelsTests' do
    inherit! :search_paths
  end
end
