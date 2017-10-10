//
//  FirstViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake( (375/4.0) * i + 5, 130, (375/4.0-10), (375/3.0-20))];
        imageV.backgroundColor = [UIColor orangeColor];
        imageV.tag = 1000 + i;
        [self.view addSubview:imageV];
    }
    
    
    dispatch_group_t group =  dispatch_group_create();
    
    
     dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 执行1个耗时的异步操作
         [self downLoadTaskA];
    
     });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
        [self downLoadTaskB];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
        [self downLoadTaskC];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
        [self downLoadTaskD];
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // 等前面的异步操作都执行完毕后，回到主线程...
    
        NSLog(@"--- 结束 ---");
    
    });
    
}

- (UIImageView *)imgeVWithIndex:(NSInteger)index{
    return (UIImageView *)[self.view viewWithTag:1000 + index];
}

- (void)downLoadTaskA{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:0];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"--- A ---");
    dispatch_async(dispatch_get_main_queue(), ^{
        iamgeView.image = [UIImage imageWithData:data];
    });
    
}

- (void)downLoadTaskB{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:1];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"--- B ---");
    dispatch_async(dispatch_get_main_queue(), ^{
        iamgeView.image = [UIImage imageWithData:data];
    });
    
}

- (void)downLoadTaskC{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:2];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"--- C ---");
    dispatch_async(dispatch_get_main_queue(), ^{
        iamgeView.image = [UIImage imageWithData:data];
    });
}

- (void)downLoadTaskD{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:3];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"--- D ---");
    dispatch_async(dispatch_get_main_queue(), ^{
        iamgeView.image = [UIImage imageWithData:data];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
