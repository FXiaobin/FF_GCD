//
//  FiveViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "FiveViewController.h"

@interface FiveViewController (){
    
    dispatch_semaphore_t _semaphore;
}

@end

@implementation FiveViewController

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
    
    _semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    [self downLoadTaskA];  //请求A
    
    //任务2
    [self downLoadTaskB]; //请求B
    
    //任务3
    [self downLoadTaskC]; //请求C
   
    //任务4
    [self downLoadTaskD]; //请求D
    
    
}

- (UIImageView *)imgeVWithIndex:(NSInteger)index{
    UIView *v = [self.view viewWithTag:1000 + index];
    return (UIImageView *)v;
}

- (void)downLoadTaskA{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:0];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- A ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
           
        });
        
        dispatch_semaphore_signal(_semaphore);
    });
    
}
- (void)downLoadTaskB{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:1];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- B ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
           
        });
        dispatch_semaphore_signal(_semaphore);
    });
    
}
- (void)downLoadTaskC{
    
    NSString *url = @"http://img06.tooopen.com/images/20170818/tooopen_sy_221040993375.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:2];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- C ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
          
        });
        
        dispatch_semaphore_signal(_semaphore);
    });
    
}

- (void)downLoadTaskD{
    
    NSString *url = @"http://img06.tooopen.com/images/20170824/tooopen_sy_222228119642.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:3];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- D ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            
        });
        
        dispatch_semaphore_signal(_semaphore);
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
