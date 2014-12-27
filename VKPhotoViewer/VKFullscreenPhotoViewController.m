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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.fullscreenImage.frame = CGRectMake(0, 52, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 52);
    }
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.fullscreenImage.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    }
}

- (void)loadImage:(VKPhoto*)photo{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.photo.photo_1280]];
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
