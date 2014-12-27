//
//  VKAlbum.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAlbum : NSObject
{
    NSNumber *vk_id; // - идентификатор альбома;
    NSNumber *thumb_id; // — идентификатор фотографии, которая является обложкой;
    NSString *title; // — название альбома;
    NSString *vk_description; // — описание альбома; (не приходит для системных альбомов)
    NSNumber *created; // — дата создания альбома в формате unixtime; (не приходит для системных альбомов);
    NSNumber *updated; // — дата последнего обновления альбома в формате unixtime; (не приходит для системных альбомов);
    NSNumber *size; // — количество фотографий в альбоме;
    NSString *thumb_src; // — ссылка на изображение обложки альбома (если был указан параметр need_covers).
    
    UIImage *albumIcon;
}

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
