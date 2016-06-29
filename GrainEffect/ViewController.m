//
//  ViewController.m
//  GrainEffect
//
//  Created by zhouen on 16/6/22.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "ViewController.h"
#import "DropViewController.h"
#import "GiftEffectViewController.h"
#import "DazViewController.h"
#import "SprayViewController.h"
#import "SnowViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titles;
@end

static NSString *reuseIdentifier = @"reuserCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果集合";
    [self _initTabelView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) _initTabelView{
    _titles = @[@"粒子掉落",@"直播礼物冒泡效果",@"烟花效果",@"喷射效果",@"雪花飘落"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView setExclusiveTouch:YES];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            [self.navigationController pushViewController:[[DropViewController alloc] init] animated:YES];
            break;
        }
        case 1:{
            [self.navigationController pushViewController:[[GiftEffectViewController alloc] init] animated:YES];
            break;
        }
        case 2:{
            [self.navigationController pushViewController:[[DazViewController alloc] init] animated:YES];
            break;
        }
        case 3:{
            [self.navigationController pushViewController:[[SprayViewController alloc] init] animated:YES];
            break;
        }
        case 4:{
            [self.navigationController pushViewController:[[SnowViewController alloc] init] animated:YES];
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
