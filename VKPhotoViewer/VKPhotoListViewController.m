//
//  VKPhotoListViewController.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKPhotoListViewController.h"
#import "VKRequest.h"
#import "VKAlbumViewCell.h"
#import "VKPhoto.h"
#import "IconDownloader.h"
#import "VKFullscreenPhotoViewController.h"

@interface VKPhotoListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@property (strong, nonatomic) NSMutableArray *photoList;

@end

@implementation VKPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.album.title;
    [self.tableView registerClass:[VKAlbumViewCell class] forCellReuseIdentifier:@"photoCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"photoCellLoading"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self vkGetPhotos];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vkGetPhotos{
    VKRequest *vkRequest = [[VKRequest alloc]initWith:self.photoList
                                     andRequestMethod:VK_PHOTOS_GET
                                            andParams:@{@"owner_id":[[UserInfo sharedInstance] vkOwnerId],
                                                        @"access_token":[[UserInfo sharedInstance] vkAccessToken],
                                                        @"album_id":[self.album.vk_id description],
                                                        @"v":@"5.27"}];
    [vkRequest setComplationBlock:^(NSMutableArray *array) {
        if (array) {
            self.photoList = array;
            [self.tableView reloadData];
        }else{
            //handle empty array
        }
    }];
    [vkRequest loadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!self.photoList) {
        return 1;
    }else{
        return self.photoList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VKAlbumViewCell *cell = nil;
    
    NSUInteger nodeCount = self.photoList.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:@"photoCellLoading" forIndexPath:indexPath];
        
        cell.textLabel.text = @"Loading…";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
        
        // Leave cells empty if there's no data yet
        
        // Set up the cell representing the app
        VKPhoto *appRecord = (self.photoList)[indexPath.row];
        
        cell.title.text = appRecord.text;
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.photoIcon)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.vkImageView.image = nil;
            [cell.loader startAnimating];
        }
        else
        {
            cell.vkImageView.image = appRecord.photoIcon;
        }
    }
    

    
    return cell;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"fullscreenPhoto" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    VKPhoto *photo = [self.photoList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    [[segue destinationViewController] setPhoto:photo];
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(id)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        [iconDownloader setCompletionHandler:^{
            
            VKAlbumViewCell *cell = (VKAlbumViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            
            [cell vkImageView].image = ((VKPhoto*)appRecord).photoIcon;
            [cell.loader stopAnimating];
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (self.photoList.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            VKPhoto *appRecord = (self.photoList)[indexPath.row];
            
            if (!appRecord.photoIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



@end
