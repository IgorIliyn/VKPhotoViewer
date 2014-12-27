//
//  UserInfo.h
//  VKAlbumViewer
//
//  Created by Igor Iliyn on 12/23/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString        *vkAccessToken;
@property (strong, nonatomic) NSString        *vkOwnerId;
@property (strong, nonatomic) NSString        *vkAccessTokenDateGetting;

+ (id)sharedInstance;

- (BOOL)isValidToken;

@end
