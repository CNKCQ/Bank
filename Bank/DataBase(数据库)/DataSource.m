//
//  DataSource.m
//  Bank
//
//  Created by Jack on 16/1/25.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "DataSource.h"
#import "HeadCell.h"


@implementation DataSource

- (instancetype)initWithServerData:(NSArray *)serverData cellIdentifiers:(NSArray *)cellIdentifiers{
    self = [super init];
    self.serverData = serverData;
    self.cellIdentifiers = cellIdentifiers;
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return self.serverData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        NSString *identifier = @"hello";
        
        HeadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[HeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }else{
        
        NSString *identifier = self.cellIdentifiers[0];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell configWithModel:self.serverData[indexPath.row]];
        
        
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 200;
    }else{
        return 44.0; 
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectBlock(self.serverData[indexPath.row]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat alpha = 0;
    if (offsetY > 0 && offsetY < 154) {
        if (offsetY >= 110 && (offsetY-(200 - 44))/44 <= 1) {
            alpha = 1 - ((offsetY-(200 - 44))/44);
        }else if(offsetY > 154){
            alpha = 1;
        }else{
            alpha = 0;
        }
    }else{
        alpha = 0;
    }
    self.scrollBlock(alpha);
}



@end
