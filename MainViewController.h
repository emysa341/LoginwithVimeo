//
//  VimeoViewController.h
//  FacebookSignIn
//
//  Created by Muhammad Asim Malik on 9/2/13.
//  Copyright (c) 2013 Innventee. All rights reserved.
//  www.codegerms.com

#import <UIKit/UIKit.h>
#import "OAConsumer.h"

#import "OAToken.h"

#import "OAMutableURLRequest.h"

#import "OADataFetcher.h"


@interface MainViewController : UIViewController <UIWebViewDelegate>
{
    
    IBOutlet UIWebView *WebView;
    OAConsumer* consumer;
    
    OAToken* requestToken;
    
    OAToken* accessToken;
}

-(void)connectTumblr;
@property(nonatomic,strong) IBOutlet UIWebView *WebView;

@end

