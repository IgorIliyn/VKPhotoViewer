//
//  VKRequest.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "VKRequest.h"

@interface VKRequest()

@property (strong, nonatomic) NSMutableArray *tmpResponceArray;
@property (strong, nonatomic) NSDictionary   *tmpParams;
@property vk_request_method   vkRequestMethod;

@end

@implementation VKRequest

@synthesize connection = connection;
@synthesize serverData = serverData;

#pragma mark Initialize

- (id)initWith:(NSMutableArray*)responceArray andRequestMethod:(vk_request_method)requestMethod andParams:(NSDictionary *)params{
    self = [super init];
    if (self) {
        self.tmpResponceArray = responceArray;
        self.vkRequestMethod  = requestMethod;
        self.tmpParams        = params;
    }
    return self;
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (self.connection) {
        self.connection = nil;
    }
    if (self.complationBlock) {
        self.complationBlock(nil);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    VKParser *parser = [[VKParser alloc]initWithRequestMethod:self.vkRequestMethod andData:self.serverData];
    self.tmpResponceArray = [parser parse];
    self.complationBlock(self.tmpResponceArray);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    serverData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [serverData appendData:data];
}

#pragma mark Load data json from server

- (void)loadData{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self getURLForMethod:self.vkRequestMethod]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (NSURL*)getURLForMethod:(vk_request_method)method{
    NSURL *url = nil;
    switch (method) {
        case VK_PHOTOS_GET:
            // todo
            break;
        case VK_PHOTOS_GETALBUMS:{
            NSString *strUrl = [NSString stringWithFormat:@"%@photos.getAlbums%@",vk_api_url,[self getParamString:self.tmpParams]];
            url = [NSURL URLWithString:strUrl];
        }
            break;
        default:
            break;
    }
    return url;
}

- (NSString*)getParamString:(NSDictionary*)params{
    NSMutableString *paramsString = [[NSMutableString alloc]initWithString:@"?"];
    for (NSString *key in [params allKeys]) {
        [paramsString appendString:key];
        [paramsString appendString:@"="];
        [paramsString appendString:[params objectForKey:key]];
        [paramsString appendString:@"&"];
    }
    [paramsString deleteCharactersInRange:NSMakeRange(paramsString.length - 1, 1)];//remove last '&'
    return (NSString*)paramsString;
}

@end
