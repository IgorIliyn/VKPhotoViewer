//
//  VKAlbumListViewController.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKAlbumListViewController.h"
#import "VKPhotoListViewController.h"

@interface VKAlbumListViewController ()

@property (strong, nonatomic) NSMutableArray *albumList;

@end

@implementation VKAlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Albums";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self vkGetAlbums];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vkGetAlbums{
    VKRequest *vkRequest = [[VKRequest alloc]initWith:self.albumList andRequestMethod:VK_PHOTOS_GETALBUMS andParams:@{@"owner_id":[[UserInfo sharedInstance] vkOwnerId],
                                                                                                                      @"access_token":[[UserInfo sharedInstance] vkAccessToken],
                                                                                                                      @"need_covers":@"1",
                                                                                                                      @"v":@"5.27"}];
    [vkRequest setComplationBlock:^(NSMutableArray *array) {
        if (array) {
            self.albumList = array;
            [self.tableView reloadData];
        }else{
            //handle empty array
        }
    }];
    [vkRequest loadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.albumList) {
        return 0;
    }else{
        return self.albumList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumCell"];
    }
    // Configure the cell...
    cell.textLabel.text = ((VKAlbum*)[self.albumList objectAtIndex:indexPath.row]).title;
    
    return cell;
}

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"photoList" sender:self];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     VKAlbum *album = [self.albumList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
     [[segue destinationViewController] setAlbum:album];
 }


@end
