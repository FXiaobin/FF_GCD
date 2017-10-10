//
//  FourViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController (){
    
    dispatch_group_t _group;
    dispatch_semaphore_t _semaphore;
}

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    ///dispatch_group + 信号量
    ///http://blog.csdn.net/zafir_zzf/article/details/52585931
    ///http://www.jianshu.com/p/943dcb9ad632
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake( (375/4.0) * i + 5, 130, (375/4.0-10), (375/3.0-20))];
        imageV.backgroundColor = [UIColor orangeColor];
        imageV.tag = 1000 + i;
        [self.view addSubview:imageV];
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 200, 40)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(testCash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _group =  dispatch_group_create();
    _semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    dispatch_group_async(_group, queue, ^{
        [self downLoadTaskA];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self downLoadTaskB];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self downLoadTaskC];
    });
    
    dispatch_group_async(_group, queue, ^{
        [self downLoadTaskD];
    });
   
    ///注意这个队列是全局队列 不是主队列
    dispatch_group_notify(_group, queue, ^{
        // 等前面的异步操作都执行完毕后，回到全局线程...
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"--- 结束 ---");
    });
    
}

- (void)testCash:(UIButton *)sender{
    NSLog(@"---- 没有阻塞线程 --- ");
}

- (UIImageView *)imgeVWithIndex:(NSInteger)index{
    UIView *v = [self.view viewWithTag:1000 + index];
    return (UIImageView *)v;
}

- (void)downLoadTaskA{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:0];
 
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- A ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
             dispatch_semaphore_signal(_semaphore);
        });
    });
}

- (void)downLoadTaskB{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:1];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- B ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            
             dispatch_semaphore_signal(_semaphore);
        });
    });
    
}

- (void)downLoadTaskC{
    
    NSString *url = @"http://img06.tooopen.com/images/20170818/tooopen_sy_221040993375.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:2];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- C ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            
            dispatch_semaphore_signal(_semaphore);
        });
    });
}

- (void)downLoadTaskD{
    
    NSString *url = @"http://img06.tooopen.com/images/20170824/tooopen_sy_222228119642.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:3];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- D ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            
            dispatch_semaphore_signal(_semaphore);
        });
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
