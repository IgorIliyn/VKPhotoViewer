//
//  VKFullscreenPhotoViewController.m
//  VKPhotoViewer
//
//  Created by Igor on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKFullscreenPhotoViewController.h"

@interface VKFullscreenPhotoViewController ()

@property (strong, nonatomic) NSMutableData *photoData;

@end

@implementation VKFullscreenPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fullscreenImage.image = self.photo.photoIcon;
    [self loadImage:self.photo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadImage:(VKPhoto*)photo{
    NSString *maxPhotoUrl;
    if (self.photo.photo_2560) {
        maxPhotoUrl = self.photo.photo_2560;
    } else if (self.photo.photo_1280) {
        maxPhotoUrl = self.photo.photo_1280;
    } else if (self.photo.photo_807) {
        maxPhotoUrl = self.photo.photo_807;
    } else if (self.photo.photo_604) {
        maxPhotoUrl = self.photo.photo_604;
    } else if (self.photo.photo_130) {
        maxPhotoUrl = self.photo.photo_130;
    } else {
        maxPhotoUrl = self.photo.photo_75;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:maxPhotoUrl]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.photoData = [NSMutableData data];
    [self.loader startAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.photoData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.fullscreenImage.image = [UIImage imageWithData:self.photoData];
    [self.loader stopAnimating];
}

@end
