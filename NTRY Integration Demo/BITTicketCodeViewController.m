//
//  BITTicketCodeViewController.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "BITTicketCodeViewController.h"
#import "Event.h"

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
    self.ticketCodeLabel.text = self.ticket.formatedCode;
    
    self.barcodeView.aztecData = [NSJSONSerialization JSONObjectWithData:[self.ticket.aztecData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
