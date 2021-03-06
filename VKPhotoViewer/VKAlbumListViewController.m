//
//  VKAlbumListViewController.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKAlbumListViewController.h"
#import "VKPhotoListViewController.h"
#import "VKAlbumViewCell.h"

@interface VKAlbumListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@property (strong, nonatomic) NSMutableArray *albumList;

@end

@implementation VKAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.hidesBackButton = YES;
    self.title = @"Albums";
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.tableView registerClass:[VKAlbumViewCell class] forCellReuseIdentifier:@"albumCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"albumCellLoading"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self vkGetAlbums];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
}

- (void)logout{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"vk.com"];
        
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vkGetAlbums{
    VKRequest *vkRequest = [[VKRequest alloc]initWith:self.albumList
                                     andRequestMethod:VK_PHOTOS_GETALBUMS
                                            andParams:@{@"owner_id":[[UserInfo sharedInstance] vkOwnerId],
                                                        @"access_token":[[UserInfo sharedInstance] vkAccessToken],
                                                        @"need_covers":@"1",
                                                        @"v":@"5.27"}];
    [vkRequest setComplationBlock:^(NSMutableArray *array) {
        if (array) {
            self.albumList = array;
            if (self.albumList.count == 0) {
                VKAlbum *thumb = [[VKAlbum alloc]init];
                thumb.title = @"У вас пока нет альбомов";
                thumb.albumIcon = [UIImage imageNamed:@"Vk.png"];
                [self.albumList addObject:thumb];
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlbum)];
            }
            [self.tableView reloadData];
        }else{
            //handle empty array
        }
    }];
    [vkRequest loadData];
}

- (void)addAlbum{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.albumList) {
        return 1;
    }else{
        return self.albumList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    VKAlbumViewCell *cell = nil;
    
    NSUInteger nodeCount = self.albumList.count;
    
    if (nodeCount == 0 && indexPath.row == 0)
    {
        // add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellLoading" forIndexPath:indexPath];
        
        cell.textLabel.text = @"Loading…";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
        
        // Leave cells empty if there's no data yet
    
            // Set up the cell representing the app
            VKAlbum *appRecord = (self.albumList)[indexPath.row];
            
            cell.title.text = appRecord.title;
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!appRecord.albumIcon)
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
                cell.vkImageView.image = appRecord.albumIcon;
            }
    }
    
    
    return cell;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VKAlbum *album = [self.albumList objectAtIndex:indexPath.row];
    if ([album.title isEqualToString:@"У вас пока нет альбомов"]) {
        
    }else{
        [self performSegueWithIdentifier:@"photoList" sender:self];
    }
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([[segue identifier] isEqualToString:@"photoList"]) {
         VKAlbum *album = [self.albumList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
         [[segue destinationViewController] setAlbum:album];
     }
     
     
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
            
            [cell vkImageView].image = ((VKAlbum*)appRecord).albumIcon;
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
    if (self.albumList.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            VKAlbum *appRecord = (self.albumList)[indexPath.row];
            
            if (!appRecord.albumIcon)
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
