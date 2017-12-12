//
//  AppDelegate.m
//  spikeZoom
//
//  Created by Anny Pino on 12/8/17.
//  Copyright © 2017 Anny Pino. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#define kZoomSDKAppKey     @"uDmTHHYGJ1tU5gaXMlBhtaNAGMNW00okxRUR"
#define kZoomSDKAppSecret   @"kPaRLMUDFbCQPGhAVqqw50D5SYjSJpW9nifV"
#define kZoomSDKDomain      @"zoom.us"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    NSLog(@"MobileRTC Version: %@", [[MobileRTC sharedRTC] mobileRTCVersion]);
    
    //1. Set MobileRTC Domain
    [[MobileRTC sharedRTC] setMobileRTCDomain:kZoomSDKDomain];
    //    //2. Set MobileRTC Resource Bundle path
    //    //Note: This step is optional, If MobileRTCResources.bundle is included in other bundle/framework, use this method to set the path of MobileRTCResources.bundle, or just ignore this step
    //    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //    [[MobileRTC sharedRTC] setMobileRTCResPath:bundlePath];
    //3. Set Root Navigation Controller
    //Note: This step is optional, If app’s rootViewController is not a UINavigationController, just ignore this step.
    //[[MobileRTC sharedRTC] setMobileRTCRootController:navVC];
    
    [self sdkAuth];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     [[MobileRTC sharedRTC] appWillResignActive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   [[MobileRTC sharedRTC] appDidEnterBackgroud];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  [[MobileRTC sharedRTC] appDidBecomeActive];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   [[MobileRTC sharedRTC] appWillTerminate];
}


#pragma mark - Auth Delegate

- (void)sdkAuth
{
    MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];
    if (authService)
    {
        authService.delegate = self;
        
        authService.clientKey = kZoomSDKAppKey;
        authService.clientSecret = kZoomSDKAppSecret;
        
        [authService sdkAuth];
    }
}

- (void)onMobileRTCLoginReturn:(NSInteger)returnValue {
    NSLog(@"onMobileRTCLoginReturn result=%zd", returnValue);
    
    MobileRTCPremeetingService *service = [[MobileRTC sharedRTC] getPreMeetingService];
    if (service)
    {
        service.delegate = self;
    }
}

- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue {
    NSLog(@"onMobileRTCAuthReturn %d", returnValue);
    
    if (returnValue != MobileRTCAuthError_Success)
    {
          NSLog(@"ERROR onMobileRTCAuthReturn %d", returnValue);
    }
}


@end
