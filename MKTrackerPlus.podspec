#
# Be sure to run `pod lib lint MKTrackerPlus.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKTrackerPlus'
  s.version          = '1.0.1'
  s.summary          = 'MokoTracker+ APP重新做了组件化处理'

  s.homepage         = 'https://github.com/MOKO-iOS-Base-Library/MKTrackerPlus_Module'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aadyx2007@163.com' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/MOKO-iOS-Base-Library/MKTrackerPlus_Module.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  
  s.resource_bundles = {
    'MKTrackerPlus' => ['MKTrackerPlus/Assets/*.png']
  }
  
  s.subspec 'ApplicationModule' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/ApplicationModule/**'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/CTMediator/**'
  end
  
  s.subspec 'Database' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/Database/**'
  end
  
  s.subspec 'SDK-TP' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/SDK-TP/**'
  end
  
  s.subspec 'DeviceTypeManager' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/DeviceTypeManager/**'
    ss.dependency 'MKTrackerPlus/SDK-TP'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKTrackerPlus/Classes/Target/**'
    ss.dependency 'MKTrackerPlus/Functions'
  end
  
  s.subspec 'Functions' do |ss|
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/ScanPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/ScanPage/Model'
        ssss.dependency 'MKTrackerPlus/Functions/ScanPage/View'
        
        ssss.dependency 'MKTrackerPlus/Functions/TabBarPage'
        ssss.dependency 'MKTrackerPlus/Functions/UpdatePage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/ScanPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKTrackerPlus/Functions/ScanPage/Model'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKTrackerPlus/Functions/AdvertiserPage'
        ssss.dependency 'MKTrackerPlus/Functions/DeviceInfoPage'
        ssss.dependency 'MKTrackerPlus/Functions/SettingPage'
        ssss.dependency 'MKTrackerPlus/Functions/TrackerConfigPage'
      end
    end
    
    ss.subspec 'AdvertiserPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/AdvertiserPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/AdvertiserPage/Model'
        ssss.dependency 'MKTrackerPlus/Functions/AdvertiserPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/AdvertiserPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/AdvertiserPage/View/**'
      end
    end
    
    ss.subspec 'TrackerConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TrackerConfigPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/TrackerConfigPage/Model'
        ssss.dependency 'MKTrackerPlus/Functions/TrackerConfigPage/View'
        
        ssss.dependency 'MKTrackerPlus/Functions/TrackerDataPage'
        ssss.dependency 'MKTrackerPlus/Functions/FilterOptionsPage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TrackerConfigPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TrackerConfigPage/View/**'
      end
    end
    
    ss.subspec 'FilterOptionsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/FilterOptionsPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/FilterOptionsPage/Model'
        ssss.dependency 'MKTrackerPlus/Functions/FilterOptionsPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/FilterOptionsPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/FilterOptionsPage/View/**'
      end
    end
    
    ss.subspec 'TrackerDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TrackerDataPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/TrackerDataPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/TrackerDataPage/View/**'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/SettingPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/SettingPage/Model'
        ssss.dependency 'MKTrackerPlus/Functions/SettingPage/View'
        
        ssss.dependency 'MKTrackerPlus/Functions/UpdatePage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/SettingPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/SettingPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/DeviceInfoPage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/DeviceInfoPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/UpdatePage/Controller/**'
        ssss.dependency 'MKTrackerPlus/Functions/UpdatePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKTrackerPlus/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.dependency 'MKTrackerPlus/SDK-TP'
    ss.dependency 'MKTrackerPlus/Database'
    ss.dependency 'MKTrackerPlus/DeviceTypeManager'
    ss.dependency 'MKTrackerPlus/CTMediator'
    
  end
  
  s.dependency 'MKBaseBleModule'
  s.dependency 'MKBaseModuleLibrary'
  s.dependency 'MKCustomUIModule'
  s.dependency 'HHTransition'
  s.dependency 'FMDB'
  s.dependency 'MLInputDodger'
  s.dependency 'iOSDFULibrary','4.6.1'
  s.dependency 'CTMediator'
  
end
