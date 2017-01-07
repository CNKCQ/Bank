//
//  AppDataManager.m
//  Bank
//
//  Created by Jack on 16/1/15.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "AppDataManager.h"
#import <CoreData/CoreData.h>


@interface AppDataManager ()

@property (nonatomic, strong)NSMutableArray *appsCollection;


@end

@implementation AppDataManager



#pragma mark - Private methods
- (NSMutableArray *)appsCollection{
    if (!_appsCollection) {
        _appsCollection = [[NSMutableArray alloc] init];
        NSArray *apps = [self readAppItemFromDisk];
        if (apps.count == 0) {
            apps = [self loadDefaultAppItems];
        }
        [_appsCollection addObjectsFromArray:apps];
    }
    return _appsCollection;
}

- (NSArray *)readAppItemFromDisk{
    
//    NSMutableArray *appItems = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AppItems"];
    NSError *error = nil;
    NSArray *appItemArr = [_managedObjectContext executeFetchRequest:request error:&error];
//    for (AppItems *app in appItemArr) {
//
//    }
//    NSArray *appar = [[NSArray alloc] initWithArray:appItems];
    return appItemArr;
}



- (NSMutableArray *)loadDefaultAppItems{
    
    NSMutableArray *appItems = [NSMutableArray array];
    NSString *paths = [[NSBundle mainBundle] pathForResource:@"Apps" ofType:@"plist"];
    NSDictionary *appDic = [NSDictionary dictionaryWithContentsOfFile:paths];
    NSArray *apparr = appDic[@"Apps"];
    
    [apparr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AppItems *appItem = [[AppItems alloc] init];
        appItem.title = obj[@"title"];
        appItem.imageName = obj[@"imageName"];
        appItem.selected = obj[@"selected"];
        
        [appItems addObject:appItem];
        
    }];
    
    return appItems;
}


/************************************core data****************************/

// Insert code here to add functionality to your managed object subclass
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jack.CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppItems" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppItems.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
