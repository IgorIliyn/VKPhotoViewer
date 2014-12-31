//
//  ViewController.m
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/24/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#import "ViewController.h"
#import "UserInfo.h"
#import "NSString+CutParameter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    CGRect frame = [[UIScreen mainScreen]bounds];
    self.vkWebView.frame = frame;
    [self authorizeIfNeed];
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *url = [NSString stringWithFormat:@"%@?scope=%@&revoke=%@&response_type=%@&redirect_uri=%@&client_id=%@&display=%@",vk_authorize_url,
                     vk_scope,
                     vk_revoke,
                     vk_response_type,
                     vk_redirect_uri,
                     vk_client_id,
                     vk_display];
    
    [self.vkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)authorizeIfNeed{
    if ([[UserInfo sharedInstance] vkAccessToken] && [[UserInfo sharedInstance] isValidToken]) {
        [self performSegueWithIdentifier:@"albumList" sender:self];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@?scope=%@&revoke=%@&response_type=%@&redirect_uri=%@&client_id=%@&display=%@",vk_authorize_url,
                         vk_scope,
                         vk_revoke,
                         vk_response_type,
                         vk_redirect_uri,
                         vk_client_id,
                         vk_display];
        
        [self.vkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.vkWebView.hidden = YES;
    [self.loader startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"%@",webView.request.URL.absoluteString);
    NSString *checkUrl = webView.request.URL.absoluteString;
    NSArray *values = [checkUrl componentsSeparatedByString:@"#"];
    if (values && [[values objectAtIndex:0] isEqualToString:vk_redirect_uri]) {
        self.vkWebView.hidden = YES;
        
        NSString *ownerId   = [checkUrl getParameter:@"user_id=" fromString:checkUrl];
        NSString *token     = [checkUrl getParameter:@"access_token=" fromString:checkUrl];
        NSString *tokenDate = [NSString getGMTFormateDate:[NSDate date]];
        
        [[NSUserDefaults standardUserDefaults] setObject:ownerId forKey:VKOwnerIdKey];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:VKAccessTokenKey];
        [[NSUserDefaults standardUserDefaults] setObject:tokenDate forKey:VKAccessTokenDateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[UserInfo sharedInstance] setVkOwnerId:ownerId];
        [[UserInfo sharedInstance] setVkAccessToken:token];
        [[UserInfo sharedInstance] setVkAccessTokenDateGetting:tokenDate];
        
        [self performSegueWithIdentifier:@"albumList" sender:self];
        
    }else{
        self.vkWebView.hidden = NO;
    }
    [self.loader stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self.loader stopAnimating];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    sleep(1);
}


@end
