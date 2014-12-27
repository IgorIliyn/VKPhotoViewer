//
//  Global.h
//  VKPhotoViewer
//
//  Created by Igor Iliyn on 12/25/14.
//  Copyright (c) 2014 aura. All rights reserved.
//

#ifndef VKPhotoViewer_Global_h
#define VKPhotoViewer_Global_h

static NSString *vk_authorize_url = @"https://oauth.vk.com/authorize";
static NSString *vk_scope         = @"photo";//edit if need more permissions
static NSString *vk_redirect_uri  = @"https://oauth.vk.com/blank.html";
static NSString *vk_revoke        = @"1";
static NSString *vk_client_id     = @"4681242";
static NSString *vk_response_type = @"token";
static NSString *vk_display       = @"mobile";

static NSString *VKAccessTokenKey     = @"VKAccessToken";
static NSString *VKOwnerIdKey         = @"VKOwnerId";
static NSString *VKAccessTokenDateKey = @"VKAccessTokenDate";

static NSString *vk_api_url = @"https://api.vk.com/method/";

typedef enum{
    VK_PHOTOS_GETALBUMS = 0,
    VK_PHOTOS_GET       = 1
}vk_request_method;

#endif
