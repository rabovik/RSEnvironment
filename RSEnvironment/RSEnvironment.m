//
//  RSEnvironment.m
//
//  Created by Yan Rabovik on 24.09.13.
//  Copyright (c) 2013 Yan Rabovik. All rights reserved.
//

#import "RSEnvironment.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#if !__has_feature(objc_arc)
#error This code needs ARC. Use compiler option -fobjc-arc
#endif

#pragma mark - Interface extensions -

@interface RSEVersion ()

+(instancetype)versionWithNumericRepresentation:(NSUInteger)numericRepresentation;

@property (nonatomic) NSUInteger numericRepresentation;

@end

#pragma mark - RSEnvironment -
RSEKit *RSEnvironment;

@implementation RSEKit{
    RSESystem *_system;
    RSEUI *_ui;
    RSEScreen *_screen;
    RSEApp *_app;
    RSEHardware *_hardware;
    
    RSEDeploymentTarget *_deploymentTarget;
    RSEBaseSDK *_baseSDK;
}

+(void)load{
    @autoreleasepool {
        RSEnvironment = [self sharedInstance];
    }
}

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RSEnvironment = [[self alloc] init];
    });
    return RSEnvironment;
}

// Using lazy initializations to avoid possible problems caused by
// initializing in the +load method.
// I.e. -[NSDictionary objectForKeyedSubscript:] crash on iOS 5.
-(RSESystem *)system{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _system = [RSESystem new];
    });
    return _system;
}

-(RSEUI *)UI{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ui = [RSEUI new];
    });
    return _ui;
}

-(RSEScreen *)screen{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screen = [RSEScreen new];
    });
    return _screen;
}

-(RSEApp *)app{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _app = [RSEApp new];
    });
    return _app;
}

-(RSEHardware *)hardware{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hardware = [RSEHardware new];
    });
    return _hardware;
}

-(RSEDeploymentTarget *)deploymentTarget{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deploymentTarget = [RSEDeploymentTarget new];
    });
    return _deploymentTarget;
}

-(RSEBaseSDK *)baseSDK{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _baseSDK = [RSEBaseSDK new];
    });
    return _baseSDK;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"\
            \nRSEnvironment:\
            \n  app:\
            \n    name: %@\
            \n    version: %@\
            \n    bundle ID: %@\
            \n  system:\
            \n    version: %@\
            \n  UI:\
            \n    isIdiomIPad: %d\
            \n    isIdiomIPhone: %d\
            \n    isFlatMode: %d\
            \n  screen:\
            \n    scale: %f\
            \n    isRetina: %d\
            \n    size: %.0fx%.0f points\
            \n    resolution: %.0fx%.0f pixels\
            \n    is 4-inch screen: %d\
            \n  hardware:\
            \n    model name: %@\
            \n    model ID: %@\
            \n  deploymentTarget:\
            \n    version: %@\
            \n  baseSDK:\
            \n    version: %@\
            ",
            self.app.name,
            self.app.version.string,
            self.app.bundleID,
            self.system.version.string,
            self.UI.isIdiomIPad,
            self.UI.isIdiomIPhone,
            self.UI.isFlatMode,
            self.screen.scale,
            self.screen.isRetina,
            self.screen.size.width,self.screen.size.height,
            self.screen.resolution.width,self.screen.resolution.height,
            self.screen.is4InchSize,
            self.hardware.modelName,
            self.hardware.modelID,
            self.deploymentTarget.version.string,
            self.baseSDK.version.string
            ];
}

@end

#pragma mark - .system
@implementation RSESystem

-(instancetype)init{
    self = [super init];
    if (nil == self) return nil;
    
	_version = [RSEVersion
                versionWithString:[UIDevice currentDevice].systemVersion];
    
	return self;
}

@end

#pragma mark └ .version
@implementation RSEVersion

+(instancetype)versionWithString:(NSString *)version{
    NSParameterAssert(version);
    
    NSArray *components = [version componentsSeparatedByString:@"."];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSUInteger(^parse)(NSString *) = ^NSUInteger(NSString *string) {
        NSNumber *number = [formatter numberFromString:string];
        if (number == nil) @throw NSInvalidArgumentException;
        return [number unsignedIntegerValue];
    };
    
    NSUInteger major = 0, minor = 0, micro = 0;
    
    switch (components.count){
        case 3:
            micro = parse([components objectAtIndex:2]);
            // continue
        case 2:
            minor = parse([components objectAtIndex:1]);
            // continue
        case 1:
            major = parse([components objectAtIndex:0]);
            break;
        default:
            @throw NSInvalidArgumentException;
    }

    return [[self alloc] initWithMajor:major minor:minor micro:micro];
}

+(instancetype)versionWithNumericRepresentation:(NSUInteger)numericRepresentation{
    NSUInteger major = numericRepresentation / 10000;
    NSUInteger minor = (numericRepresentation % 10000) / 100;
    NSUInteger micro = numericRepresentation % 100;
    
    return [[self alloc] initWithMajor:major minor:minor micro:micro];
}

-(instancetype)initWithMajor:(NSUInteger)major
                       minor:(NSUInteger)minor
                       micro:(NSUInteger)micro
{
    self = [super init];
    if (nil == self) return nil;
    
    _major = major;
    _minor = minor;
    _micro = micro;
    
    _numericRepresentation = _major * 10000 + _minor * 100 + _micro;
    
    _string = [NSString stringWithFormat:@"%u.%u.%u",major,minor,micro];
    
	return self;
}

-(BOOL)isEqualTo:(NSString *)version{
    return self.numericRepresentation ==
        [RSEVersion versionWithString:version].numericRepresentation;
}

-(BOOL)isGreaterThan:(NSString *)version{
    return self.numericRepresentation >
        [RSEVersion versionWithString:version].numericRepresentation;
}

-(BOOL)isGreaterThanOrEqualTo:(NSString *)version{
    return self.numericRepresentation >=
        [RSEVersion versionWithString:version].numericRepresentation;
}

-(BOOL)isLessThan:(NSString *)version{
    return self.numericRepresentation <
        [RSEVersion versionWithString:version].numericRepresentation;
}

-(BOOL)isLessThanOrEqualTo:(NSString *)version{
    return self.numericRepresentation <=
        [RSEVersion versionWithString:version].numericRepresentation;
}

@end

#pragma mark - .UI
@implementation RSEUI

-(BOOL)isIdiomIPad{
    return UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom;
}

-(BOOL)isIdiomIPhone{
    return UIUserInterfaceIdiomPhone == [UIDevice currentDevice].userInterfaceIdiom;
}

// Based on UIKitLegacyDetector by Peter Steinberger
// https://gist.github.com/steipete/6526860
-(BOOL)isFlatMode{
    static BOOL isUIKitFlatMode = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (RSEnvironment.system.version.major >= 7){
            NSAssert([NSThread isMainThread],nil);
            
            // If your app is running in legacy mode, tintColor will be nil - else it must be set to some color.
            if ([UIApplication sharedApplication].keyWindow) {
                isUIKitFlatMode = [UIApplication.sharedApplication.keyWindow
                                   performSelector:@selector(tintColor)] != nil;
            }else {
                // Possible that we're called early on (e.g. when used in a Storyboard). Adapt and use a temporary window.
                isUIKitFlatMode = [[UIWindow new]
                                   performSelector:@selector(tintColor)] != nil;
            }
        }
    });
    return isUIKitFlatMode;
}

@end

#pragma mark - .screen
@implementation RSEScreen

-(BOOL)isRetina{
    return self.scale > 1.0f;
}

-(BOOL)isRetinaHD{
  return self.scale > 2.0f;
}


-(CGFloat)scale{
    return [UIScreen mainScreen].scale;
}

-(CGSize)size{
    return [UIScreen mainScreen].bounds.size;
}

-(CGSize)resolution{
    CGSize size = self.size;
    CGFloat scale = self.scale;
    return CGSizeMake(size.width * scale, size.height * scale);
}

-(BOOL)is4InchSize{
    return RSEnvironment.UI.isIdiomIPhone && self.size.height == 568.0f;
}

- (BOOL)is4_7InchSize {
  return RSEnvironment.UI.isIdiomIPhone && self.size.height ==  667.0f;
}

- (BOOL)is5_5InchSize {
  return RSEnvironment.UI.isIdiomIPhone && self.size.height ==  736.0f;
}

@end

#pragma mark - .app
@implementation RSEApp

-(instancetype)init{
    self = [super init];
    if (nil == self) return nil;
    
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
	_version = [RSEVersion versionWithString:info[@"CFBundleShortVersionString"]];
    
	return self;
}

-(NSString *)name{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
}

-(NSString *)bundleID{
    return [NSBundle mainBundle].bundleIdentifier;
}

@end

#pragma mark - .hardware
@implementation RSEHardware

-(NSString *)modelID{
    static NSString *platform;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return platform;
}

static const NSString * const hwModelName = @"name";
static const NSString * const hwModel = @"model";
static const NSString * const hwFamily = @"family";

typedef NS_ENUM(NSUInteger, RSEHardwareFamily) {
    RSEHardwareFamilyUnknown = 0,
    RSEHardwareFamilyIPodTouch,
    RSEHardwareFamilyIPhone,
    RSEHardwareFamilyIPadStandard,
    RSEHardwareFamilyIPadMini,
    RSEHardwareFamilySimulator
};

static NSDictionary *modelsData(){
    static NSDictionary *data;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Filling only devices that can run iOS 5
        // See http://theiphonewiki.com/wiki/Models
        data =  @{
                  // iPod
                  @"iPod3,1": @{hwModel: @(RSEHardwareModelIPodTouch3G),
                                hwFamily: @(RSEHardwareFamilyIPodTouch),
                                hwModelName: @"iPod Touch 3G"},
                  @"iPod4,1": @{hwModel: @(RSEHardwareModelIPodTouch4G),
                                hwFamily: @(RSEHardwareFamilyIPodTouch),
                                hwModelName: @"iPod Touch 4G"},
                  @"iPod5,1": @{hwModel: @(RSEHardwareModelIPodTouch5G),
                                hwFamily: @(RSEHardwareFamilyIPodTouch),
                                hwModelName: @"iPod Touch 5G"},
                  // iPhone
                  @"iPhone2,1":@{hwModel: @(RSEHardwareModelIPhone3Gs),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 3GS"},
                  @"iPhone3,1":@{hwModel: @(RSEHardwareModelIPhone4),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 4 (GSM)"},
                  @"iPhone3,2":@{hwModel: @(RSEHardwareModelIPhone4),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 4 (GSM rev A)"},
                  @"iPhone3,3":@{hwModel: @(RSEHardwareModelIPhone4),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 4 (CDMA)"},
                  @"iPhone4,1":@{hwModel: @(RSEHardwareModelIPhone4s),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 4s"},
                  @"iPhone5,1":@{hwModel: @(RSEHardwareModelIPhone5),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5 (GSM)"},
                  @"iPhone5,2":@{hwModel: @(RSEHardwareModelIPhone5),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5 (GSM + CDMA)"},
                  @"iPhone5,3":@{hwModel: @(RSEHardwareModelIPhone5c),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5c (GSM)"},
                  @"iPhone5,4":@{hwModel: @(RSEHardwareModelIPhone5c),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5c (Global)"},
                  @"iPhone6,1":@{hwModel: @(RSEHardwareModelIPhone5s),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5s (GSM)"},
                  @"iPhone6,2":@{hwModel: @(RSEHardwareModelIPhone5s),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 5s (Global)"},
                  @"iPhone7,1":@{hwModel: @(RSEHardwareModelIPhone6Plus),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 6 Plus (Global)"},
                  @"iPhone7,2":@{hwModel: @(RSEHardwareModelIPhone6),
                                 hwFamily: @(RSEHardwareFamilyIPhone),
                                 hwModelName: @"iPhone 6 (Global)"},
                  // iPad
                  @"iPad1,1":@{hwModel: @(RSEHardwareModelIPad1),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad"},
                  @"iPad2,1":@{hwModel: @(RSEHardwareModelIPad2),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 2 (Wi-Fi)"},
                  @"iPad2,2":@{hwModel: @(RSEHardwareModelIPad2),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 2 (GSM)"},
                  @"iPad2,3":@{hwModel: @(RSEHardwareModelIPad2),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 2 (CDMA)"},
                  @"iPad2,4":@{hwModel: @(RSEHardwareModelIPad2),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 2 (Wi-Fi Rev A)"},
                  @"iPad3,1":@{hwModel: @(RSEHardwareModelIPad3),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 3 (Wi-Fi)"},
                  @"iPad3,2":@{hwModel: @(RSEHardwareModelIPad3),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 3 (GSM + CDMA)"},
                  @"iPad3,3":@{hwModel: @(RSEHardwareModelIPad3),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 3 (GSM)"},
                  @"iPad3,4":@{hwModel: @(RSEHardwareModelIPad4),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 4 (Wi-Fi)"},
                  @"iPad3,5":@{hwModel: @(RSEHardwareModelIPad4),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 4 (GSM)"},
                  @"iPad3,6":@{hwModel: @(RSEHardwareModelIPad4),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad 4 (GSM + CDMA)"},
                  @"iPad4,1":@{hwModel: @(RSEHardwareModelIPadAir1),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad Air (Wi-Fi)"},
                  @"iPad4,2":@{hwModel: @(RSEHardwareModelIPadAir1),
                               hwFamily: @(RSEHardwareFamilyIPadStandard),
                               hwModelName: @"iPad Air (Cellular)"},
                  // iPad Mini
                  @"iPad2,5":@{hwModel: @(RSEHardwareModelIPadMini1),
                               hwFamily: @(RSEHardwareFamilyIPadMini),
                               hwModelName: @"iPad Mini (Wi-Fi)"},
                  @"iPad2,6":@{hwModel: @(RSEHardwareModelIPadMini1),
                               hwFamily: @(RSEHardwareFamilyIPadMini),
                               hwModelName: @"iPad Mini (GSM)"},
                  @"iPad2,7":@{hwModel: @(RSEHardwareModelIPadMini1),
                               hwFamily: @(RSEHardwareFamilyIPadMini),
                               hwModelName: @"iPad Mini (GSM + CDMA)"},
                  @"iPad4,4":@{hwModel: @(RSEHardwareModelIPadMini2),
                               hwFamily: @(RSEHardwareFamilyIPadMini),
                               hwModelName: @"iPad Mini 2 (Wi-Fi)"},
                  @"iPad4,5":@{hwModel: @(RSEHardwareModelIPadMini2),
                               hwFamily: @(RSEHardwareFamilyIPadMini),
                               hwModelName: @"iPad Mini 2 (Cellular)"},
                  // Simulator
                  @"i386":@{hwModel: @(RSEHardwareModelSimulator),
                            hwFamily: @(RSEHardwareFamilySimulator),
                            hwModelName: @"Simulator"},
                  @"x86_64":@{hwModel: @(RSEHardwareModelSimulator),
                              hwFamily: @(RSEHardwareFamilySimulator),
                              hwModelName: @"Simulator"},
                  };
    });
    return data;
}

-(NSString *)modelName{
    return modelsData()[self.modelID][hwModelName];
}

-(RSEHardwareModel)model{
    return [modelsData()[self.modelID][hwModel] unsignedIntegerValue];
}

-(RSEHardwareFamily)family{
    return [modelsData()[self.modelID][hwFamily] unsignedIntegerValue];
}

-(BOOL)isIPodTouch{
    return RSEHardwareFamilyIPodTouch == self.family;
}

-(BOOL)isIPhone{
    return RSEHardwareFamilyIPhone == self.family;
}

-(BOOL)isIPad{
    return RSEHardwareFamilyIPadStandard == self.family ||
           RSEHardwareFamilyIPadMini == self.family;
}

-(BOOL)isIPadMini{
    return RSEHardwareFamilyIPadMini == self.family;
}

-(BOOL)isSimulator{
#if RS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end

#pragma mark - .deploymentTarget
@implementation RSEDeploymentTarget

-(instancetype)init{
    self = [super init];
    if (nil == self) return nil;
    
	_version = [RSEVersion
                versionWithNumericRepresentation:__IPHONE_OS_VERSION_MIN_REQUIRED];
    
	return self;
}

@end

#pragma mark - .baseSDK
@implementation RSEBaseSDK

-(instancetype)init{
    self = [super init];
    if (nil == self) return nil;
    
	_version = [RSEVersion
                versionWithNumericRepresentation:__IPHONE_OS_VERSION_MAX_ALLOWED];
    
	return self;
}

@end

