//
//  ReachabilityManager.h
//  Hotels24
//
//  Created by Igor Iliyn on 12/19/14.
//  Copyright (c) 2014 Igor. All rights reserved.
//

#import "Reachability.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
