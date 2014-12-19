//
//  MainViewController.m
//  LoginwithVimeo
//
//  Created by Ammad on 19/12/14.
//  Copyright (c) 2014 Ammad. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

NSString *clientID;
NSString *Secret;
NSString *callback;

@implementation MainViewController
@synthesize WebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    clientID = @"fd02fbdce7d0755fd71f09989dd1e7f7ec7a1815";
    Secret = @"6babf4c7d056a357ef92a56d49047d2737c621e2";
    callback  = @"vimeo://authorized";

    
    [self connectTumblr];
    
    
}


-(void)connectTumblr {
    
    consumer = [[OAConsumer alloc] initWithKey:clientID secret:Secret realm:nil];
    
    
    NSURL* requestTokenUrl = [NSURL URLWithString:@"https://vimeo.com/oauth/request_token"];
    
    OAMutableURLRequest* requestTokenRequest = [[OAMutableURLRequest alloc] initWithURL:requestTokenUrl
                                                
                                                                               consumer:consumer
                                                
                                                                                  token:nil
                                                
                                                                                  realm:callback
                                                
                                                                      signatureProvider:nil] ;
    
    OARequestParameter* callbackParam = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callback] ;
    
    [requestTokenRequest setHTTPMethod:@"POST"];
    
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init] ;
    
    [dataFetcher fetchDataWithRequest:requestTokenRequest
     
                             delegate:self
     
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
     
                      didFailSelector:@selector(didFailOAuth:error:)];
    
}

- (void)didReceiveRequestToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://vimeo.com/oauth/authorize"];
    
    OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                             
                                                                            consumer:nil
                                             
                                                                               token:nil
                                             
                                                                               realm:nil
                                             
                                                                   signatureProvider:nil];
    
    NSString* oauthToken = requestToken.key;
    
    OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken] ;
    
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    //  UIWebView* webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //  webView.scalesPageToFit = YES;
    
    //  [[[UIApplication sharedApplication] keyWindow] addSubview:webView];
    
    
    
    WebView.delegate = self;
    
    [WebView loadRequest:authorizeRequest];
    
}


#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] scheme] isEqualToString:@"vimeo"]) {
        
        // Extract oauth_verifier from URL query
        
        NSString* verifier = nil;
        
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        
        for (NSString* param in urlParams) {
            
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            
            NSString* key = [keyValue objectAtIndex:0];
            
            if ([key isEqualToString:@"oauth_verifier"]) {
                
                verifier = [keyValue objectAtIndex:1];
                
                break;
                
            }
            
        }
        
        if (verifier) {
            
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://vimeo.com/oauth/access_token"];
            
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl
                                                       
                                                                                      consumer:consumer
                                                       
                                                                                         token:requestToken
                                                       
                                                                                         realm:nil
                                                       
                                                                             signatureProvider:nil];
            
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            
            [accessTokenRequest setHTTPMethod:@"POST"];
            
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            
            [dataFetcher fetchDataWithRequest:accessTokenRequest
             
                                     delegate:self
             
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
             
                              didFailSelector:@selector(didFailOAuth:error:)];
            
        } else {
            
            // ERROR!
            
        }
        
        [webView removeFromSuperview];
        
        return NO;
        
    }
    
    return YES;
    
}




- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
   
    
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    
    NSString *OAuthKey = accessToken.key;    // HERE YOU WILL GET ACCESS TOKEN
    
    NSString *OAuthSecret = accessToken.secret;  //HERE  YOU WILL GET SECRET TOKEN
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Vimeo TOken"
                              message:OAuthSecret
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
