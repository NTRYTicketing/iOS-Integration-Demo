//
//  BITTicketOrderViewController.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/8/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "NSString+URLEncode.h"
#import "TFHpple.h"

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
    
    NSString* iframeLocation = [NSString stringWithFormat:@"%@%@/%@.iframe?stay_in_frame=yes", API_PROTOCOL, API_HOST, self.event.shortUrl ];

    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:iframeLocation]]];
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
    NSLog(@"loaded %@, back: %d", [webView debugDescription], webView.canGoBack);
    
    // check for embedded tickets
    NSString *ticketHtml = [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('tickets').outerHTML;"];
    
    if ( ticketHtml.length ) {
        TFHpple* tickets = [[TFHpple alloc] initWithHTMLData:[ticketHtml dataUsingEncoding:NSUTF8StringEncoding]];
        
        for ( TFHppleElement* ticket in [tickets searchWithXPathQuery:@"//div[@class='ticket']"] ) {
            
            //create a new ticket
            Ticket* newTicket = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Ticket"
                                   inManagedObjectContext:[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext];
            
            newTicket.ticketCode = [[ticket attributes] valueForKey:@"data-code"];
            newTicket.persons = [NSNumber numberWithInteger:[[[ticket attributes] valueForKey:@"data-persons"] intValue]];
            newTicket.imageUri = [[ticket attributes] valueForKey:@"data-ticket-image-url"];
            newTicket.aztecData = [[ticket attributes] valueForKey:@"data-aztec"];
            newTicket.formatedCode = [[ticket attributes] valueForKey:@"data-formatted-code"];
            
            [self.event addTicketsObject:newTicket];
            [[RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext saveToPersistentStore:nil];
        }
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
