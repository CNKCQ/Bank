//
//  AppItemManager.m
//  Bank
//
//  Created by Jack on 16/1/13.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "AppItemManager.h"
#import <objc/runtime.h>

NS_INLINE NSString* documentDirectoryPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        return nil;
    }
    return documentsDirectory;
}

@implementation AppItem

#pragma mark - NSCoding protocol
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.title forKey:@"title"];
//    [aCoder encodeObject:self.imageName forKey:@"imageName"];
//    [aCoder encodeBool:self.selected forKey:@"selected"];
//}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if (self) {
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
//        self.selected = [aDecoder decodeBoolForKey:@"selected"];
//    }
//    return self;
//}

- (void)encodeWithCoder:(NSCoder *)encoder{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        
        objc_property_t property = properties[i];
        
        const char *name = property_getName(property);
        
        NSString *key = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:key];
        
        [encoder encodeObject:value forKey:key];
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {

        unsigned int outCount = 0;
         objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {

            objc_property_t property = properties[i];
            
            const char *name = property_getName(property);
            
            NSString *key = [NSString stringWithUTF8String:name];
            
            id value = [decoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
            
        }
         free(properties);
    }
    return self;
}

//IMP_CODING

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setNilValueForKey:(NSString *)key{
    
}

#pragma mark - NSCopying protocol
- (id)copyWithZone:(NSZone *)zone{
    
    return self;
}


@end

static NSString * const APPITEMMANAGERFILENAME = @"appitems";
@interface AppItemManager ()

@property (nonatomic, strong)NSMutableArray *appsCollection;

@end
@implementation AppItemManager

+ (instancetype)defaultManager{
    static AppItemManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [AppItemManager new];
        
    });
    return instance;
}

#pragma  mark - public methods
- (NSArray *)appItems{
    return self.appsCollection;
}
- (void)moveAppItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    __strong AppItem *appItem = self.appsCollection[fromIndex];
    [self.appsCollection removeObject:appItem];
    [self.appsCollection insertObject:appItem atIndex:toIndex];
}
- (void)svaeToDisk{
    NSString *documentPath = documentDirectoryPath();
    NSString *filePath = [documentPath stringByAppendingPathComponent:APPITEMMANAGERFILENAME];
    [NSKeyedArchiver archiveRootObject:self.appsCollection toFile:filePath];
}
- (NSInteger)numberOfSelectedAppItems{
    NSInteger count = 0;
    for (AppItem *appItem in self.appsCollection) {
        if (appItem.selected) {
            count++;
        }
    }
    return count;
}
#pragma mark - Private methods
- (NSMutableArray *)appsCollection{
    if (!_appsCollection) {
        _appsCollection = [[NSMutableArray alloc] init];
        NSArray *apps = [self loadAppItemFromDisk];
        if (apps.count == 0) {
            apps = [self loadDefaultAppItems];
        }
        [_appsCollection addObjectsFromArray:apps];
    }
    return _appsCollection;
}

- (NSArray *)loadAppItemFromDisk{
    
    NSString *documentPath = documentDirectoryPath();
    NSString *filePath = [documentPath stringByAppendingPathComponent:APPITEMMANAGERFILENAME];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (NSMutableArray *)loadDefaultAppItems{

    NSMutableArray *appItems = [NSMutableArray array];
    NSString *paths = [[NSBundle mainBundle] pathForResource:@"Apps" ofType:@"plist"];
    NSDictionary *appDic = [NSDictionary dictionaryWithContentsOfFile:paths];
    NSArray *apparr = appDic[@"Apps"];
    
    [apparr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AppItem *appItem = [[AppItem alloc] initWithDictionary:obj];
        
        [appItems addObject:appItem];
        
    }];

    return appItems;
}



@end
