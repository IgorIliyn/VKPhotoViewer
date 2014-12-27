//
//  VKFullscreenPhotoViewController.h
//  VKPhotoViewer
//
//  Created by Igor on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKPhoto.h"

@interface VKFullscreenPhotoViewController : UIViewController

@property (strong, nonatomic) VKPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *fullscreenImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end
