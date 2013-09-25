//
//  RSAppDelegate.m
//  RSEnvironmentExample
//
//  Created by Yan Rabovik on 24.09.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSAppDelegate.h"
#import "RSEnvironment.h"

@implementation RSAppDelegate

-(void)showExample{
    
    // Check iOS version
    BOOL iOS_6_1_3 = [RSEnvironment.system.version isGreaterThan:@"6.1.3"];
    NSLog(@"System version greater than 6.1.3: %d", iOS_6_1_3);
    
    BOOL iOS_6_0 = [RSEnvironment.system.version isLessThanOrEqualTo:@"6.1"];
    NSLog(@"System version less than or equal to 6.1: %d", iOS_6_0);
    
    BOOL iOS_7 = RSEnvironment.system.version.major >= 7;
    NSLog(@"System version greater than or equal to 7.0: %d", iOS_7);
    
    // Check for new iOS 7 flat UI mode
    NSLog(@"Flat UI: %d",RSEnvironment.UI.isFlatMode);
    
    // Check UI Idioms
    NSLog(@"UI is for iPad: %d", RSEnvironment.UI.isIdiomIPad);
    
    // Check if running on iPad Mini
    NSLog(@"Device is iPad Mini: %d", RSEnvironment.hardware.isIPadMini);
    
    // Retina check
    NSLog(@"Retina: %d", RSEnvironment.screen.isRetina);
    
    // Screen scale
    NSLog(@"Scale: %f", RSEnvironment.screen.scale);
    
    // iPhone 5+ size
    NSLog(@"4-inch screen: %d", RSEnvironment.screen.is4InchSize);
    
    // Compare app's version with some string, may be with the latest on the App Store
    NSString *appStoreVersion = @"2.19.0";
    if ([RSEnvironment.app.version isLessThan:appStoreVersion]) {
        NSLog(@"An update available!");
    }
    
    // Compare some abstract versions
    NSString *version1 = @"3.0";
    NSString *version2 = @"3.0.0";
    BOOL greaterOrEqual = [[RSEVersion versionWithString:version1]
                           isGreaterThanOrEqualTo:version2];
    NSLog(@"%@ >= %@: %s", version1, version2, greaterOrEqual ? "true" : "false");
    
    // Compile time checks
#if RS_BASE_SDK_GREATER_THAN_OR_EQUAL(7,0,0)
#if RS_DEPLOYMENT_TARGET_GREATER_THAN(5,0,99)
    NSLog(@"Compile time checks are correct.");
#endif
#endif
    
    // Check for Simulator targer
#if RS_SIMULATOR
    NSLog(@"Running in simulator");
#endif
    
    // Check if device is iPad:
    NSLog(@"Device is iPad: %d",RSEnvironment.hardware.isIPad);
    
    // Check for specific models:
    NSLog(@"Device is iPad 1: %d", RSEHardwareModelIPad1 == RSEnvironment.hardware.model);
    NSLog(@"Device is iPhone 5s: %d",
          RSEHardwareModelIPhone5s == RSEnvironment.hardware.model);
    
    // Print basic environment information
    NSLog(@"%@",RSEnvironment);
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self showExample];
    return YES;
}

@end
