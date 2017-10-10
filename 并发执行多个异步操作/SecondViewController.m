//
//  SecondViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController (){
    dispatch_semaphore_t semaphore;
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake( (375/4.0) * i + 5, 130, (375/4.0-10), (375/3.0-20))];
        imageV.backgroundColor = [UIColor orangeColor];
        imageV.tag = 1000 + i;
        [self.view addSubview:imageV];
    }
    
    [self semaphoreTest];
    
    
}

- (UIImageView *)imgeVWithIndex:(NSInteger)index{
    return (UIImageView *)[self.view viewWithTag:1000 + index];
}

- (void)semaphoreTest{
    //定义一个信号量，初始化为1
    // http://blog.csdn.net/fhbystudy/article/details/25918451
    // http://www.jianshu.com/p/ea72d1ded383
    /*
     dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号,让信号总量-1，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，根据这样的原理，我们便可以快速的创建一个并发控制来同步任务和有限资源访问控制。
     */
    
    ///处理并发个数 如果初始为1 那么任务就会顺序执行 (可用来控制异步任务的顺序执行)
    semaphore = dispatch_semaphore_create(1);
    [self downLoadTaskA];
    [self downLoadTaskB];
    [self downLoadTaskC];
    [self downLoadTaskD];
}

- (void)downLoadTaskA{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- A ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
        });
        dispatch_semaphore_signal(semaphore);
    });
}

- (void)downLoadTaskB{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:1];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- B ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
        });
        dispatch_semaphore_signal(semaphore);
    });
    
}

- (void)downLoadTaskC{
    
    NSString *url = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1726373646,1696262491&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:2];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- C ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
        });
        dispatch_semaphore_signal(semaphore);
    });
}

- (void)downLoadTaskD{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:3];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- D ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
        });
        dispatch_semaphore_signal(semaphore);
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
