//
//  VKAlbum.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAlbum : NSObject

@property (strong, nonatomic) NSNumber *vk_id;
@property (strong, nonatomic) NSNumber *thumb_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *vk_description;
@property (strong, nonatomic) NSNumber *created;
@property (strong, nonatomic) NSNumber *updated;
@property (strong, nonatomic) NSNumber *size;
@property (strong, nonatomic) NSString *thumb_src;

@property (strong, nonatomic) UIImage *albumIcon;

@end
