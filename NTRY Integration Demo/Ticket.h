//
//  Ticket.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSString * aztecData;
@property (nonatomic, retain) NSString * imageUri;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSString * ticketCode;
@property (nonatomic, retain) NSString * formatedCode;
@property (nonatomic, retain) Event *event;

@end
