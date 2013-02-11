//
//  Event.h
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * doors;
@property (nonatomic, retain) NSDate * endsAt;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSNumber * hasDoorsOpenTime;
@property (nonatomic, retain) NSNumber * hasEndTime;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * locationExtra;
@property (nonatomic, retain) NSString * normalImagePath;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * presentedBy;
@property (nonatomic, retain) NSString * shortUrl;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tickets;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addTicketsObject:(Ticket *)value;
- (void)removeTicketsObject:(Ticket *)value;
- (void)addTickets:(NSSet *)values;
- (void)removeTickets:(NSSet *)values;

@end
