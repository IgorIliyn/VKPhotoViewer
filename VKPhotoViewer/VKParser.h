//
//  VKParser.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKAlbum.h"
#import "VKPhoto.h"

@interface VKParser : NSObject

{
    vk_request_method vkMethod;
}

@property vk_request_method vkMethod;

- (id)initWithRequestMethod:(vk_request_method)method andData:(NSMutableData*)data;
- (NSMutableArray*)parse;

@end
