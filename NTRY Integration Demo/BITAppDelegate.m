//
//  BITAppDelegate.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/8/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "BITAppDelegate.h"
#import "Ticket.h"

@interface BITAppDelegate ()
@property (strong, nonatomic) RKManagedObjectStore* managedObjectStore;
@end

@implementation BITAppDelegate

- (void) defineMapping {
    
     RKLogConfigureByName("RestKit", RKLogLevelTrace);
     RKLogConfigureByName("RestKit/CoreData", RKLogLevelTrace);
     RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
     RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
     RKLogConfigureByName("RestKit/Search", RKLogLevelTrace);
    
    NSURL *baseURL = [NSURL URLWithString:API_PROTOCOL API_HOST];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSS"];
    [RKObjectMapping addDefaultDateFormatter:dateFormatter];
    [RKObjectMapping setPreferredDateFormatter:dateFormatter];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel: managedObjectModel];
    objectManager.managedObjectStore = self.managedObjectStore;
    
    
    [self.managedObjectStore createPersistentStoreCoordinator];

    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"ntry_integration_demo_1.1d.sqlite"];
    NSError *error;
    [self.managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    
    // Create the managed object contexts
    [self.managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    self.managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    
    //define the json mapping for events
    RKEntityMapping * eventMapping = [RKEntityMapping mappingForEntityForName:@"Event" inManagedObjectStore: self.managedObjectStore];
    eventMapping.identificationAttributes = @[ @"eventId" ];
  
    [eventMapping addAttributeMappingsFromDictionary: @{
     @"id" : @"eventId",
     @"description" : @"eventDescription",
     @"address" : @"address",
     @"country" : @"country",
     @"date" : @"date",
     @"ends_at" : @"endsAt",
     @"has_doors_open_time" : @"hasDoorsOpenTime",
     @"has_end_time" : @"hasEndTime",
     @"lat" : @"lat",
     @"lng" : @"lng",
     @"link" : @"link",
     @"location" : @"location",
     @"location_extra" : @"locationExtra",
     @"normal_image_path" : @"normalImagePath",
     @"postcode" : @"postcode",
     @"presented_by" : @"presentedBy",
     @"short_url" : @"shortUrl",
     @"subtitle" : @"subtitle",
     @"title" : @"title",
    }];
    

    RKResponseDescriptor *eventResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping method:RKRequestMethodAny pathPattern: @"/api/events/" keyPath: @"event" statusCodes:nil];
    [objectManager addResponseDescriptor:eventResponseDescriptor];

    
    RKEntityMapping * ticketMapping = [RKEntityMapping mappingForEntityForName:@"Ticket" inManagedObjectStore: self.managedObjectStore];
    ticketMapping.identificationAttributes = @[ @"ticketId" ];
    
    [ticketMapping addAttributeMappingsFromDictionary: @{
                                                        @"id" : @"ticketId",
                                                        @"event_id" : @"event_id",
                                                        @"code" : @"code",
                                                        @"timestamp" : @"timestamp",
                                                        @"last_fetch" : @"last_fetch",
                                                        @"persons" : @"persons",
                                                        @"name" : @"name",
                                                        @"barcode" : @"barcode",
                                                        @"pkpass" : @"pkpass"
                                                        }];
    
 
    
    [ticketMapping addConnectionForRelationship:@"event" connectedBy:@{ @"event_id": @"eventId" }];
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[Ticket class] pathPattern:@"/api/tickets/:ticketId" method:RKRequestMethodGET]];
    
    RKResponseDescriptor *ticketResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ticketMapping method:RKRequestMethodAny pathPattern: @"/api/tickets/:ticketId" keyPath: @"ticket_instance" statusCodes:nil];
    [objectManager addResponseDescriptor:ticketResponseDescriptor];

    RKResponseDescriptor *ticketIndexResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:ticketMapping method:RKRequestMethodAny pathPattern: @"/api/tickets/" keyPath: @"ticket_instance" statusCodes:nil];
    [objectManager addResponseDescriptor:ticketIndexResponseDescriptor];

    
    [RKObjectManager setSharedManager:objectManager];
    
}

- (void)checkForTickets
{
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    if ( token ) {
        NSLog(@"Have device token, will check for new tickets");
        
        NSDictionary* params = @{
                                @"device_id": [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                @"token": token
                                };
        
        RKObjectManager* objectManager = [RKObjectManager sharedManager];
        
        [objectManager getObjectsAtPath:@"/api/tickets/"
                             parameters: params
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    NSLog(@"Ticket index GET successful");
                                    
                                    for ( Ticket* ticket in mappingResult.array) {
                                        if ( ![ticket.timestamp isEqualToDate:ticket.last_fetch] ) {
                                            // our lokal instance is either new or out of date, need to load details
                                            [objectManager getObject:ticket
                                                                path:nil
                                                          parameters:params
                                                             success:nil
                                                             failure:nil];
                                        }
                                    }
                                }
                                failure:nil];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self defineMapping];
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(checkForTickets)
                                   userInfo:nil
                                    repeats:YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
