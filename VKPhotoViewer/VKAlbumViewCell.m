//
//  VKAlbumViewCell.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/27/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKAlbumViewCell.h"

@implementation VKAlbumViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:reuseIdentifier]) {
        self.title = [[UILabel alloc]init];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.vkImageView = [[UIImageView alloc]init];
        self.loader = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loader.hidesWhenStopped = YES;
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.vkImageView];
        [self.contentView addSubview:self.loader];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    //contentRect.size.width = 320.f;
    self.contentView.frame = contentRect;
    self.backgroundView = [[UIView alloc]initWithFrame:contentRect];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame = CGRectMake(boundsX, 0, 50, 50);
    self.vkImageView.frame = frame;
    
    frame = CGRectMake(boundsX + 7 ,7, 37, 37);
    self.loader.frame = frame;
    
    frame = CGRectMake(boundsX + 55, 15, contentRect.size.width - (boundsX + 50), 20);
    self.title.frame = frame;
    
   
}


@end
