//
//  RSEnvironment.h
//
//  Created by Yan Rabovik on 24.09.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSEKit;
@class RSESystem;
@class RSEVersion;
@class RSEUI;
@class RSEScreen;
@class RSEApp;
@class RSEHardware;

@class RSEDeploymentTarget;
@class RSEBaseSDK;

#pragma mark - RSEnvironment -

/// RSEnvironmentKit singleton instance
extern RSEKit *RSEnvironment;

@interface RSEKit : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, readonly) RSESystem *system;

@property (nonatomic, readonly) RSEUI *UI;

@property (nonatomic, readonly) RSEScreen *screen;

@property (nonatomic, readonly) RSEApp *app;

@property (nonatomic, readonly) RSEHardware *hardware;

/// Deployment target the app was built with.
/// @note Most of the time you should use corresponding compile time macros instead.
@property (nonatomic, readonly) RSEDeploymentTarget *deploymentTarget;

/// Base SDK the app was built with.
/// @note Most of the time you should use corresponding compile time macros instead.
@property (nonatomic, readonly) RSEBaseSDK *baseSDK;

@end

#pragma mark - .system

@interface RSESystem : NSObject

@property (nonatomic, readonly) RSEVersion *version;

@end

#pragma mark └ .version

@interface RSEVersion : NSObject

+(instancetype)versionWithString:(NSString *)version;

-(BOOL)isEqualTo:(NSString *)version;

-(BOOL)isGreaterThan:(NSString *)version;

-(BOOL)isGreaterThanOrEqualTo:(NSString *)version;

-(BOOL)isLessThan:(NSString *)version;

-(BOOL)isLessThanOrEqualTo:(NSString *)version;

/// Major version, for example 6 for @"6.1.3".
@property (nonatomic, readonly) NSUInteger major;
/// Minor version, for example 1 for @"6.1.3".
@property (nonatomic, readonly) NSUInteger minor;
/// Micro version, for example 3 for @"6.1.3".
@property (nonatomic, readonly) NSUInteger micro;

/// Version in the string format, for example @"6.1.3".
@property (nonatomic, readonly) NSString *string;

@end

#pragma mark - .UI

@interface RSEUI : NSObject

@property (nonatomic, readonly) BOOL isIdiomIPad;

@property (nonatomic, readonly) BOOL isIdiomIPhone;

/// Detects if we're running in iOS 7 flat UI mode
@property (nonatomic, readonly) BOOL isFlatMode;

@end

#pragma mark - .screen

@interface RSEScreen : NSObject

@property (nonatomic, readonly) BOOL isRetina;

/// Detects if the screen has iPhone 6 Plus density
@property (nonatomic, readonly) BOOL isRetinaHD;

@property (nonatomic, readonly) CGFloat scale;

/// Size of the screen in points;
@property (nonatomic, readonly) CGSize size;

/// Resolution of the screen in pixels;
@property (nonatomic, readonly) CGSize resolution;

/// Detects if the screen has iPhone 5/5S/5C size
@property (nonatomic, readonly) BOOL is4InchSize;

/// Detects if the screen has iPhone 6 size
@property (nonatomic, readonly) BOOL is4_7InchSize;

/// Detects if the screen has iPhone 6 Plus size
@property (nonatomic, readonly) BOOL is5_5InchSize;

@end

#pragma mark - .app
@interface RSEApp : NSObject

@property (nonatomic, readonly) RSEVersion *version;

@property (nonatomic, readonly) NSString *name;

@property (nonatomic, readonly) NSString *bundleID;

@end

#pragma mark - .hardware

typedef NS_ENUM(NSUInteger, RSEHardwareModel) {
    RSEHardwareModelUnknown = 0,
    RSEHardwareModelIPodTouch3G,
    RSEHardwareModelIPodTouch4G,
    RSEHardwareModelIPodTouch5G,
    RSEHardwareModelIPhone3Gs,
    RSEHardwareModelIPhone4,
    RSEHardwareModelIPhone4s,
    RSEHardwareModelIPhone5,
    RSEHardwareModelIPhone5c,
    RSEHardwareModelIPhone5s,
    RSEHardwareModelIPhone6,
    RSEHardwareModelIPhone6Plus,
    RSEHardwareModelIPad1,
    RSEHardwareModelIPad2,
    RSEHardwareModelIPad3,
    RSEHardwareModelIPad4,
    RSEHardwareModelIPadAir1,
    RSEHardwareModelIPadAir2,
    RSEHardwareModelIPadMini1,
    RSEHardwareModelIPadMini2,
    RSEHardwareModelIPadMini3,
    RSEHardwareModelSimulator
};

@interface RSEHardware : NSObject

@property (nonatomic, readonly) BOOL isIPodTouch;

@property (nonatomic, readonly) BOOL isIPhone;

@property (nonatomic, readonly) BOOL isIPad;

@property (nonatomic, readonly) BOOL isIPadMini;

/// @note Most of the time you should use corresponding compile time macro instead.
@property (nonatomic, readonly) BOOL isSimulator;

/// Model identificator, for example `iPhone4,1`.
@property (nonatomic, readonly) NSString *modelID;

/// Model name, for example `iPhone 4S`.
@property (nonatomic, readonly) NSString *modelName;

@property (nonatomic, readonly) RSEHardwareModel model;

@end

#pragma mark - .deploymentTarget

@interface RSEDeploymentTarget : NSObject

@property (nonatomic, readonly) RSEVersion *version;

@end

#pragma mark - .baseSDK

@interface RSEBaseSDK : NSObject

@property (nonatomic, readonly) RSEVersion *version;

@end

#pragma mark - COMPILE TIME MACROS -

#pragma mark └ Simulator

#define RS_SIMULATOR TARGET_IPHONE_SIMULATOR

#pragma mark └ Deployment Target

#define RS_DEPLOYMENT_TARGET_EQUAL_TO(major,minor,micro) \
    (__IPHONE_OS_VERSION_MIN_REQUIRED == major * 10000 + minor * 100 + micro)

#define RS_DEPLOYMENT_TARGET_GREATER_THAN(major,minor,micro) \
    (__IPHONE_OS_VERSION_MIN_REQUIRED > major * 10000 + minor * 100 + micro)


#define RS_DEPLOYMENT_TARGET_GREATER_THAN_OR_EQUAL(major,minor,micro) \
    (__IPHONE_OS_VERSION_MIN_REQUIRED >= major * 10000 + minor * 100 + micro)

#define RS_DEPLOYMENT_TARGET_LESS_THAN(major,minor,micro) \
    (__IPHONE_OS_VERSION_MIN_REQUIRED <= major * 10000 + minor * 100 + micro)

#define RS_DEPLOYMENT_TARGET_LESS_THAN_OR_EQUAL(major,minor,micro) \
    (__IPHONE_OS_VERSION_MIN_REQUIRED <= major * 10000 + minor * 100 + micro)

#pragma mark └ Base SDK

#define RS_BASE_SDK_EQUAL_TO(major,minor,micro) \
    (__IPHONE_OS_VERSION_MAX_ALLOWED == major * 10000 + minor * 100 + micro)

#define RS_BASE_SDK_GREATER_THAN(major,minor,micro) \
    (__IPHONE_OS_VERSION_MAX_ALLOWED > major * 10000 + minor * 100 + micro)

#define RS_BASE_SDK_GREATER_THAN_OR_EQUAL(major,minor,micro) \
    (__IPHONE_OS_VERSION_MAX_ALLOWED >= major * 10000 + minor * 100 + micro)

#define RS_BASE_SDK_LESS_THAN(major,minor,micro) \
    (__IPHONE_OS_VERSION_MAX_ALLOWED < major * 10000 + minor * 100 + micro)

#define RS_BASE_SDK_LESS_THAN_OR_EQUAL(major,minor,micro) \
    (__IPHONE_OS_VERSION_MAX_ALLOWED <= major * 10000 + minor * 100 + micro)

#pragma mark - Implementation details
// Do not write code that depends on anything below this line.
