//
//  NSString+CutParameter.m
//  VKAlbumViewer
//
//  Created by Igor Iliyn on 12/24/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "NSString+CutParameter.h"

@implementation NSString (CutParameter)

- (NSString*)getParameter:(NSString*)parameter fromString:(NSString*)sourceString{
    NSString *value = nil;
    
    if ([sourceString rangeOfString:parameter].location != NSNotFound) {
        
        NSRange parameterRange = [sourceString rangeOfString:parameter];
        int endIndex = 0;
        for (int i = parameterRange.location + parameterRange.length; i < sourceString.length; i++) {
            char tmp = [sourceString characterAtIndex:i];
            if (tmp == '&') {
                endIndex = i;
                break;
            }
        }
        if (endIndex == 0) {
            endIndex = sourceString.length;
        }
        NSRange valueRange = NSMakeRange(parameterRange.location + parameterRange.length,endIndex - (parameterRange.location + parameterRange.length));
        value = [sourceString substringWithRange:valueRange];
    } else {
        return value;
    }
    
    return value;
}

+ (NSString *)getGMTFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

@end
