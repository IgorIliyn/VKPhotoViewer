//
//  VKPhoto.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKPhoto : NSObject

@property (strong, nonatomic) NSNumber *vk_id;
@property (strong, nonatomic) NSNumber *album_id;
@property (strong, nonatomic) NSNumber *owner_id;
@property (strong, nonatomic) NSString *photo_75;
@property (strong, nonatomic) NSString *photo_130;
@property (strong, nonatomic) NSString *photo_604;
@property (strong, nonatomic) NSString *photo_807;
@property (strong, nonatomic) NSString *photo_1280;
@property (strong, nonatomic) NSString *photo_2560;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *date;

@property (strong, nonatomic) UIImage *photoIcon;

@end
