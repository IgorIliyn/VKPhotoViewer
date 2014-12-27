//
//  VKRequest.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "VKParser.h"

@interface VKRequest : NSObject
<
    NSURLConnectionDataDelegate
>
{
    NSURLConnection *connection;
    NSMutableData   *serverData;
}

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData   *serverData;

@property (strong, nonatomic) void (^complationBlock)(NSMutableArray*);

- (id)initWith:(NSMutableArray*)responceArray andRequestMethod:(vk_request_method)requestMethod andParams:(NSDictionary*)params;
- (void)loadData;

@end
