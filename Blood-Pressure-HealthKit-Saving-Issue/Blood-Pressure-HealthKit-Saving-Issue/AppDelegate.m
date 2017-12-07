//
//  AppDelegate.m
//  Blood-Pressure-HealthKit-Saving-Issue
//
//  Created by Serhii Horbenko on 12/7/17.
//  Copyright © 2017 Serhii. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (atomic) UIBackgroundTaskIdentifier backgroundTaskID;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.backgroundTaskID = UIBackgroundTaskInvalid;
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application Did Enter Background: %@",application);
    [self endBackgroundTask];
    // Start a background to task
    self.backgroundTaskID = [application beginBackgroundTaskWithName:@"BackgroundTask" expirationHandler:^{
        [self endBackgroundTask];
    }];
}

- (void)endBackgroundTask
{
    if (self.backgroundTaskID != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
        self.backgroundTaskID = UIBackgroundTaskInvalid;
    }
}


@end
