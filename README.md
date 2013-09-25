# RSEnvironment
Most common environment checks in one place. Pull Requests are welcome.

## Usage

#### Detect iOS version
```objective-c
if ([RSEnvironment.system.version isGreaterThanOrEqualTo:@"5.1"]){
    // iOS 5.1+ code
}
if ([RSEnvironment.system.version isLessThan:@"6.1"]){
    // ...
}
if ([RSEnvironment.system.version.major >= 7]){
    // iOS 7+ code
}
```

#### UI modes 
Detect new iOS 7 flat UI mode:
```objective-c
if (RSEnvironment.UI.isFlatMode){
    // ...
}
```
UI idioms:
```objective-c
if (RSEnvironment.UI.isIdiomIPad){
    // ...
}
```

#### Detect screen properties
```objective-c
if (RSEnvironment.screen.is4InchSize){
    // iPhone 5+ screen size
}
if (RSEnvironment.screen.isRetina){
    // ...
}
NSLog(@"Scale: %f", RSEnvironment.screen.scale);
```

#### Hardware checks
```objective-c
if (RSEnvironment.hardware.isIPadMini){
    // The device is iPad Mini
}
```
Detecting specific model:
```
if (RSEHardwareModelIPhone5s == RSEnvironment.hardware.model){
    // iPhone5s-only code
}
```

#### Compare versions

App's version:
```objective-c
NSString *appStoreVersion = @"2.19.0";
if ([RSEnvironment.app.version isLessThan:appStoreVersion]){
    NSLog(@"An update available!");
}
```
Some abstract versions:
```objective-c
NSString *version1 = @"3.0";
NSString *version2 = @"3.0.0";
if ([[RSEVersion versionWithString:version1] isGreaterThanOrEqualTo:version2]){
    // ...
}
```

#### Check deployment target and Base SDK versions
```objective-c
#if RS_DEPLOYMENT_TARGET_GREATER_THAN_OR_EQUAL(6,0,0)
    // Compile 6.0+ code.
#endif
#if RS_BASE_SDK_LESS_THAN(7,0,0)
    // Do not use features not available in SDK 6.
#endif
```

Runtime checks for deployment target and base SDK are also available if needed:
```objective-c
if ([RSEnvironment.deploymentTarget.version isLessThan:@"6.0"]){
    // ...
}
NSLog(@"%@",RSEnvironment.baseSDK.version.string); // 7.0.0
```

#### Get basic environment summary
```objective-c
NSLog(@"%@",RSEnvironment.description);
```
Sample output:
```
RSEnvironment:            
  app:            
    name: RSEnvironmentExample            
    version: 2.17.3            
    bundle ID: ru.rabovik.RSEnvironmentExample            
  system:            
    version: 5.1.1            
  UI:            
    isIdiomIPad: 1            
    isIdiomIPhone: 0            
    isFlatMode: 0            
  screen:            
    scale: 1.000000            
    isRetina: 0            
    size: 768x1024 points            
    resolution: 768x1024 pixels            
    is 4-inch screen: 0            
  hardware:            
    model name: iPad            
    model ID: iPad1,1            
  deploymentTarget:            
    version: 5.1.0            
  baseSDK:            
    version: 7.0.0
```

## CocoaPods
Add `RSEnvironment` to your _Podfile_.

## Requirements
* iOS 5.0+
* ARC

## Author
Yan Rabovik ([@rabovik][twitter] on twitter)

## License
MIT License.

## Acknowledgments

* [Peter Steinberger][steipete] for [UIKitLegacyDetector][UIKitLegacyDetector].
* [Jaybles][Jaybles] for [UIDeviceHardware][UIDeviceHardware].
* [The iPhone wiki][theiphonewiki] project.
* [Takahiko Kawasaki][TakahikoKawasaki] for [nv-ios-version].

[twitter]: https://twitter.com/rabovik
[UIKitLegacyDetector]: https://gist.github.com/steipete/6526860
[steipete]: http://github.com/steipete/
[Jaybles]: https://github.com/Jaybles
[UIDeviceHardware]: https://gist.github.com/Jaybles/1323251
[theiphonewiki]: http://theiphonewiki.com/wiki/Models
[nv-ios-version]: https://github.com/TakahikoKawasaki/nv-ios-version
[TakahikoKawasaki]: https://github.com/TakahikoKawasaki