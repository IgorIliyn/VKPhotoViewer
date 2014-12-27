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
                for (NSDictionary *item in objects[@"response"][@"items"]) {
                    VKPhoto *photo   = [[VKPhoto alloc]init];
                    photo.vk_id      = item[@"id"];
                    photo.album_id   = item[@"album_id"];
                    photo.owner_id   = item[@"owner_id"];
                    photo.photo_75   = item[@"photo_75"];
                    photo.photo_130  = item[@"photo_130"];
                    photo.photo_604  = item[@"photo_604"];
                    photo.photo_807  = item[@"photo_807"];
                    photo.photo_1280 = item[@"photo_1280"];
                    photo.photo_2560 = item[@"photo_2560"];
                    photo.width      = item[@"width"];
                    photo.height     = item[@"height"];
                    photo.text       = item[@"text"];
                    photo.date       = item[@"date"];
                    [rezult addObject:photo];
                }
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
