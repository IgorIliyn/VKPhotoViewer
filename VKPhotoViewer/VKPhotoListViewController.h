//
//  VKPhotoListViewController.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKAlbum.h"

@interface VKPhotoListViewController : UITableViewController

@property (strong, nonatomic) VKAlbum *album;

//- (void)setAlbum:(VKAlbum *)vk_album;

@end
