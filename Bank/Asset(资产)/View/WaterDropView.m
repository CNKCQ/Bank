//
//  WaterDropView.m
//  Bank
//
//  Created by Jack on 16/1/2.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "WaterDropView.h"


#define COLLISION_BOUNDARY_ID_FLOOR @"floor"




@interface WaterDropView ()<UICollisionBehaviorDelegate>

@property (nonatomic, strong)UIDynamicAnimator *animator;
@property (nonatomic, strong)UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong)UICollisionBehavior *collisionBehavior;



@property (strong, nonatomic) CAShapeLayer *topWaterLayer;
@property (strong, nonatomic) UIView *topWaterDrop;
@property (strong, nonatomic) UIView *topWaterDropAssistance;
@property (strong, nonatomic)UIDynamicItemBehavior *topWaterDropBehavior;
@property (strong, nonatomic)CADisplayLink *topWaterDropFallDisplayLink;
@property (strong, nonatomic)CADisplayLink *topWaterDropBackDisplayLink;



@property (strong, nonatomic) CAShapeLayer *bottomWaterLater;
@property (strong, nonatomic) UIView *bottomWaterDropAssistance;
@property (strong, nonatomic)UIDynamicItemBehavior *bottomWaterDropAssistanceBehavior;
@property (strong, nonatomic)CADisplayLink *bottomWaterDropJumpDisplayLink;
@property (strong, nonatomic)CADisplayLink *bottomWaterDropBackDisplayLink;

@end

@implementation WaterDropView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setupDynamic];
    [self setupTopWater];
    [self setupBottomWater];
    return self;
}
- (void)setupDynamic{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    self.gravityBehavior = [[UIGravityBehavior alloc] init];
    [self.animator addBehavior:self.gravityBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] init];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    self.collisionBehavior.collisionDelegate = self;
    [self.collisionBehavior addBoundaryWithIdentifier:COLLISION_BOUNDARY_ID_FLOOR fromPoint:CGPointMake(0,self.frame.size.height) toPoint:CGPointMake(self.frame.size.width, self.height)];
    [self.animator addBehavior:self.collisionBehavior];

}
- (void)setupTopWater{
    
}
- (void)setupBottomWater{
    
}


- (void)play{
    
}
@end
