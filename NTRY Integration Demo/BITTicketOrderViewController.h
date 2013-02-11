//
//  BITTicketOrderViewController.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/8/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface BITTicketOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) Event* event;
@end
