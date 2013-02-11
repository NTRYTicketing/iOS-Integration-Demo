//
//  BITEventsTableViewController.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/8/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BITEventsTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
- (IBAction)doRefresh:(UIRefreshControl*)sender;

@end
