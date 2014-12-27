//
//  UserInfo.m
//  VKAlbumViewer
//
//  Created by Igor Iliyn on 12/23/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "UserInfo.h"
#import "NSString+CutParameter.h"

@implementation UserInfo

@synthesize vkAccessToken            = vkAccessToken;
@synthesize vkAccessTokenDateGetting = vkAccessTokenDateGetting;
@synthesize vkOwnerId                = vkOwnerId;

+ (id)sharedInstance {
    
    static UserInfo *sharedUserInfo = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedUserInfo = [[self alloc] init];
    });
    return sharedUserInfo;
    
}

- (BOOL)isValidToken{
    
    NSString *currentDate = [NSString getGMTFormateDate:[NSDate date]];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formater setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *fromDate = [formater dateFromString:self.vkAccessTokenDateGetting];
    NSDate *toDate = [formater dateFromString:currentDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    NSLog(@"Token time: %i %i:%i:%i", components.day, components.hour, components.minute, components.second);
   
    BOOL isValid = NO;
    
    if (components.day > 0) {
        isValid = NO;
    }else{
        if (components.hour > 22) {
            if (components.minute > 58) {
                isValid = NO;
            }else{
                isValid = YES;
            }
        }else{
            isValid = YES;
        }
    }
    return isValid;
}

- (id)init {
    if (self = [super init]) {
        self.vkAccessToken            = [[NSUserDefaults standardUserDefaults] objectForKey:VKAccessTokenKey];
        self.vkAccessTokenDateGetting = [[NSUserDefaults standardUserDefaults] objectForKey:VKAccessTokenDateKey];
        self.vkOwnerId                = [[NSUserDefaults standardUserDefaults] objectForKey:VKOwnerIdKey];
    }
    return self;
}

@end
