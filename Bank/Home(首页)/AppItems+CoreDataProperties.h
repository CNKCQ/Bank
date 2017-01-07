//
//  AppItems+CoreDataProperties.h
//  Bank
//
//  Created by Jack on 16/1/14.
//  Copyright © 2016年 Jack. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AppItems.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppItems (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *imageName;
@property (nonatomic) BOOL selected;

@end

NS_ASSUME_NONNULL_END
