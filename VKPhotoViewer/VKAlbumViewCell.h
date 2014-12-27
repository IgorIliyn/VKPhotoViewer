//
//  VKAlbumViewCell.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKAlbumViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *vkImageView;
@property (strong, nonatomic) UIActivityIndicatorView *loader;
@property (strong, nonatomic) UILabel *title;

@end
