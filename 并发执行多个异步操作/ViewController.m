//
//  ViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property  (nonatomic,strong) UITableView *tableView;

@property  (nonatomic,strong) NSArray *dataArr;

@end

@implementation ViewController

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"多线程";
    self.dataArr = @[@"多个同步任务并发异步执行",@"多个异步并发任务顺序执行",@"多个异步任务异步执行后再执行最后一个任务",@"多个网络请求后再执行最后一个任务",@"多个网络请求顺序执行"];
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            
        case 0: {
            FirstViewController *vc = [[FirstViewController alloc] init];
            vc.navigationItem.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case 1: {
            SecondViewController *vc = [[SecondViewController alloc] init];
            vc.navigationItem.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case 2: {
            ThirdViewController *vc = [[ThirdViewController alloc] init];
            vc.navigationItem.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case 3: {
            FourViewController *vc = [[FourViewController alloc] init];
            vc.navigationItem.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
        case 4: {
            FiveViewController *vc = [[FiveViewController alloc] init];
            vc.navigationItem.title = self.dataArr[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }  break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
