//
//  Ticket.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 05.02.14.
//  Copyright (c) 2014 Bitstem Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSString * barcode;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSNumber * ticketId;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSDate * last_fetch;
@property (nonatomic, retain) NSString * pkpass;
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) Event *event;

@end
