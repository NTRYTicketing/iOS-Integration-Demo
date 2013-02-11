//
//  BITTicketCodeViewController.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "BITBarcodeView.h"

@interface BITTicketCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCodeLabel;
@property (weak, nonatomic) IBOutlet BITBarcodeView *barcodeView;

@property (strong, nonatomic) Ticket* ticket;
@end
