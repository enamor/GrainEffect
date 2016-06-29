//
//  DropViewController.m
//  GrainEffect
//
//  Created by zhouen on 16/6/22.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "DropViewController.h"
#import <CoreMotion/CoreMotion.h>

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

@interface DropViewController ()<UIAccelerometerDelegate>
@property (nonatomic , strong) UIDynamicAnimator        * animator;
@property (nonatomic , strong) UIGravityBehavior        * gravityBehavior;
@property (nonatomic , strong) UICollisionBehavior      * collisionBehavitor;
@property (nonatomic , strong) UIDynamicItemBehavior    * itemBehavitor;
@property (nonatomic, strong)  CMMotionManager * motionMManager;
@property (strong,nonatomic)   NSMutableArray *dropsArray;
@property (strong,nonatomic) UIImageView *leftShoot;
@property (strong,nonatomic) UIImageView *rightShoot;

@property (strong,nonatomic) UIView *giftView;


@property (nonatomic, strong) dispatch_source_t timer;


@property (assign,nonatomic) BOOL isDropping;

@property (assign,nonatomic) int page;
@end
@implementation DropViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _motionMManager = [[CMMotionManager alloc] init];
        [self startMotion];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _giftView =[[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_giftView];
    
    _leftShoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _leftShoot.image = [UIImage imageNamed:@"leftShoot"];
    [self.giftView addSubview:_leftShoot];
    _leftShoot.center = CGPointMake(50, 100);
    
    _rightShoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _rightShoot.image = [UIImage imageNamed:@"rightShoot"];
    [self.giftView addSubview:_rightShoot];
    _rightShoot.center = CGPointMake(SCREEN_WIDTH - 50, 100);
    

    UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 50, 30)];
    buton.backgroundColor = [UIColor grayColor];
    [buton setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:buton];
    [buton addTarget:self action:@selector(addSerialDrop) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 50, 30)];
    clearButton.backgroundColor = [UIColor grayColor];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:clearButton];
    [clearButton addTarget:self action:@selector(didClickedClear:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self didClickedClear:nil];
}
-(void)addSerialDrop{
    [self startMotion];
    UIImage *love = [UIImage imageNamed:@"love"];
    UIImage *star = [UIImage imageNamed:@"star"];
    if (self.dropsArray.count % 2 == 0) {
        [self dropWithCount:30 images:@[love]];
    }else{
        [self dropWithCount:30 images:@[star]];
    }
    
    [self serialDrop];
    
}

-(void)didClickedClear:(id)sender{
    // 停止陀螺仪
    [_motionMManager stopAccelerometerUpdates];
    _isDropping = NO;
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    for (UIDynamicBehavior *behavior in _animator.behaviors)
    {
        if (behavior == self.gravityBehavior)
        {
            for (UIImageView *v in self.gravityBehavior.items)
            {
                [self.gravityBehavior removeItem:v];
                if (v.superview)[v removeFromSuperview];
            }
            continue;
        }
        else if (behavior == self.collisionBehavitor)
        {
            for (UIImageView *v in self.collisionBehavitor.items) {
                [self.collisionBehavitor removeItem:v];
                if (v.superview)[v removeFromSuperview];
            }
            continue;
        }
        else [_animator removeBehavior:behavior];;
    }
    self.animator = nil;
    [self.dropsArray removeAllObjects];
}

//串行
-(void)serialDrop{
    if (_isDropping) return;
    _isDropping = YES;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));/**< 延迟一秒执行*/
    uint64_t interval = (uint64_t)(0.05 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.dropsArray.count == 0) return;
        NSMutableArray *currentDrops = self.dropsArray[0];
        
        if ([currentDrops count]) {
            if (currentDrops.count == 0) return;
            UIImageView * dropView = currentDrops[0];
            [currentDrops removeObjectAtIndex:0];
            [self.giftView addSubview:dropView];
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[dropView] mode:UIPushBehaviorModeInstantaneous];
            [self.animator addBehavior:pushBehavior];
            //角度范围 ［0.6 1.0］
            float random = ((int)(2 + (arc4random() % (10 - 4 + 1))))*0.1;
            
            pushBehavior.pushDirection = CGVectorMake(0.6,random);
            if (dropView.tag != 11) {
                pushBehavior.pushDirection = CGVectorMake(-0.6,random);
            }
            
            pushBehavior.magnitude = 0.3;
            [self.gravityBehavior addItem:dropView];
            [self.collisionBehavitor addItem:dropView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dropView.alpha = 0;
                [self.gravityBehavior removeItem:dropView];
                [self.collisionBehavitor removeItem:dropView];
                [pushBehavior removeItem:dropView];
                [self.animator removeBehavior:pushBehavior];
                [dropView removeFromSuperview];
            });
            
        }else{
            dispatch_source_cancel(self.timer);
            [self.dropsArray removeObject:currentDrops];
            _isDropping = NO;
            if (self.dropsArray.count) {
                [self serialDrop];
            }
        }
        
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        
    });
    //启动
    dispatch_resume(self.timer);
    
}


#pragma mark instance methods
- (void)startMotion
{
    
    if(_motionMManager.accelerometerAvailable)
    {
        if (!_motionMManager.accelerometerActive)
        {
            _motionMManager.accelerometerUpdateInterval = 1.0/3.0;
            __unsafe_unretained typeof(self) weakSelf = self;
            [_motionMManager
             startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                 
                 if (error)
                 {
                     NSLog(@"CoreMotion Error : %@",error);
                     [_motionMManager stopAccelerometerUpdates];
                 }
                 CGFloat a = accelerometerData.acceleration.x;
                 CGFloat b = accelerometerData.acceleration.y;
                 CGVector gravityDirection = CGVectorMake(a,-b);
                 weakSelf.gravityBehavior.gravityDirection = gravityDirection;
             }];
        }
        
    }
    else
    {
        NSLog(@"The accelerometer is unavailable");
    }
}

- (NSMutableArray *)dropWithCount:(int)count images:(NSArray *)images
{
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < count; i++) {
        
        UIImage *image = [images objectAtIndex:rand()%[images count]];
        UIImageView * imageView =[[UIImageView alloc ]initWithImage:image];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.center = CGPointMake(50, 100);
        imageView.tag = 11;
        if (i%2 == 0) {
            imageView.center = CGPointMake(SCREEN_WIDTH - 50, 100);
            imageView.tag = 22;
        }
        [viewArray addObject:imageView];
    }
    [self.dropsArray addObject:viewArray];
    return _dropsArray;

}

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_giftView];
        /** 重力效果*/
        self.gravityBehavior = [[UIGravityBehavior alloc] init];
        //        self.gravityBehavior.gravityDirection = CGVectorMake(0.5,1);
        /** 碰撞效果*/
        self.collisionBehavitor = [[UICollisionBehavior alloc] init];
        [self.collisionBehavitor setTranslatesReferenceBoundsIntoBoundary:YES];
        [_animator addBehavior:self.gravityBehavior];
        [_animator addBehavior:self.collisionBehavitor];
    }
    return _animator;
}

-(NSMutableArray *)dropsArray{
    if (nil == _dropsArray) {
        _dropsArray = [NSMutableArray array];
    }
    return _dropsArray;
}

-(void)dealloc{
    NSLog(@"dealloc");
}


@end
