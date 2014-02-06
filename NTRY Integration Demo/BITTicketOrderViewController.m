//
//  BITTicketOrderViewController.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/8/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "NSString+URLEncode.h"

#import "BITTicketOrderViewController.h"
#import "Ticket.h"

@interface BITTicketOrderViewController () <UIWebViewDelegate>
@end

@implementation BITTicketOrderViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSString* iframeLocation = [NSString stringWithFormat:@"http://ntry2.dev/if-test/simple.html"];
    NSString* iframeLocation = [NSString stringWithFormat:@"%@%@/%@.iframe?l=en&device_id=%@", API_PROTOCOL, API_HOST, self.event.shortUrl, [[[UIDevice currentDevice] identifierForVendor] UUIDString] ];

    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:iframeLocation]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack:(id)sender {
    [self.webView goBack];
}

#pragma mark - UIWebView delegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSCachedURLResponse *cur = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)cur.response;
    NSDictionary* headers = [response allHeaderFields];
    NSLog(@"loaded %@, back: %d, %@", [webView debugDescription], webView.canGoBack, headers);
    
    NSString* token = [headers objectForKey:@"NTRY-Device-Token"];
    if ( token ) {
        NSLog( @"Got device token %@", token );
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

        
    // hijack UINavController's back button?
    if ( webView.canGoBack ) {
        UIBarButtonItem *backButton =[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        self.navigationItem.leftBarButtonItem = backButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}
@end
