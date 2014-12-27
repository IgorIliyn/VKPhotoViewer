//
//  NSString+CutParameter.h
//  VKAlbumViewer
//
//  Created by Igor Iliyn on 12/24/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CutParameter)

- (NSString*)getParameter:(NSString*)parameter fromString:(NSString*)sourceString;
+ (NSString *)getGMTFormateDate:(NSDate *)localDate;

@end
