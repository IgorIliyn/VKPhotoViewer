//
//  VKParser.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKParser.h"

@interface VKParser()

@property (strong, nonatomic) NSMutableData *ptrData;

@end

@implementation VKParser

@synthesize vkMethod = vkMethod;

- (id)initWithRequestMethod:(vk_request_method)method andData:(NSMutableData*)data{
    self = [super init];
    if (self) {
        vkMethod     = method;
        self.ptrData = data;
    }
    return self;
}

- (NSMutableArray*)parse{
    NSError *error;
    NSMutableArray *rezult = [NSMutableArray array];
    NSDictionary   *objects = [NSJSONSerialization JSONObjectWithData:self.ptrData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        rezult = nil;
    }else{
        switch (vkMethod) {
            case VK_PHOTOS_GET:
                
                break;
            case VK_PHOTOS_GETALBUMS:
                for (NSDictionary *item in objects[@"response"][@"items"]) {
                    VKAlbum *album       = [[VKAlbum alloc]init];
                    album.vk_id          = item[@"id"];
                    album.thumb_id       = item[@"thumb_id"];
                    album.title          = item[@"title"];
                    album.vk_description = item[@"description"];
                    album.created        = item[@"created"];
                    album.updated        = item[@"updated"];
                    album.size           = item[@"size"];
                    album.thumb_src      = item[@"thumb_src"];
                    [rezult addObject:album];
                }
                break;
            default:
                break;
        }
    }
    return rezult;
}

@end
