//
//  BITTicketCodeViewController.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "BITTicketCodeViewController.h"
#import "Event.h"
#import <PassKit/PassKit.h>

@implementation BITTicketCodeViewController

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

    
    self.eventTitleLabel.text = self.ticket.event.title;
    self.ticketCodeLabel.text = self.ticket.code;
    
    self.barcodeView.aztecData = [NSJSONSerialization JSONObjectWithData:[self.ticket.barcode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addToPassbook:(id)sender {
    if ( [PKPassLibrary isPassLibraryAvailable] ) {
        NSData *pkpassData = [[NSData alloc] initWithBase64EncodedString:self.ticket.pkpass options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        PKPass* pass = [[PKPass new] initWithData:pkpassData error:nil];
        PKPassLibrary* passLib = [PKPassLibrary new];
        
        if ( [passLib containsPass:pass] ) {
            // pass is already in there, just show it
            [[UIApplication sharedApplication] openURL:[pass passURL]];
        } else {
            PKAddPassesViewController* apvc = [[PKAddPassesViewController new] initWithPass:pass];
            [self presentViewController:apvc animated:YES completion:nil];
        }
    }
}
@end
