//
//  ThirdViewController.m
//  并发执行多个异步操作
//
//  Created by fanxiaobin on 2017/10/10.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController (){
    
    dispatch_group_t _group;

}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
     简单的说，就是dispatch_group_enter会对group的内部计数加一，dispatch_group_leave会对group的内部计数减一，就类似以前的retain和release方法。说白了也是维护了一个计数器。
     
     以前我的做法就是自己维护计数器。在发送网络请求前，记下发送总数，数据返回后，在同一个thread中（或者在一个DISPATCH_QUEUE_SERIAL类型的dispatch_queue中），对计数器进行+1操作，当计数器和网络请求数相等时，调用最后的处理。
     
     相比自己的处理的计数器，dispatch_group_enter 处理方法可能显得更正规一些，代码更规范了，但执行效果是一样的。。。
     */

    ///dispatch_group + 信号量
    ///http://www.jianshu.com/p/07eb268c93f2
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

    //dispatch_group_enter(_group);
    [self downLoadTaskA];
    
    //dispatch_group_enter(_group);
    [self downLoadTaskB];
    
    //dispatch_group_enter(_group);
    [self downLoadTaskC];
    
    //dispatch_group_enter(_group);
    [self downLoadTaskD];
  
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
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
    
    dispatch_group_enter(_group);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- A ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            dispatch_group_leave(_group);
        });
    });
}

- (void)downLoadTaskB{
    
    NSString *url = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1188238263,844192284&fm=27&gp=0.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:1];
   dispatch_group_enter(_group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- B ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];

            dispatch_group_leave(_group);
        });
    });
    
}

- (void)downLoadTaskC{
    
    NSString *url = @"http://img06.tooopen.com/images/20170818/tooopen_sy_221040993375.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:2];
    dispatch_group_enter(_group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- C ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            dispatch_group_leave(_group);
        });
    });
}

- (void)downLoadTaskD{
    
    NSString *url = @"http://img06.tooopen.com/images/20170824/tooopen_sy_222228119642.jpg";
    UIImageView *iamgeView = [self imgeVWithIndex:3];
    dispatch_group_enter(_group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSLog(@"--- D ---");
        dispatch_async(dispatch_get_main_queue(), ^{
            iamgeView.image = [UIImage imageWithData:data];
            dispatch_group_leave(_group);
        });
    });
}


/*
- (void)getNetworkingData{
    NSString *appIdKey = @"8781e4ef1c73ff20a180d3d7a42a8c04";
    NSString* urlString_1 = @"http://api.openweathermap.org/data/2.5/weather";
    NSString* urlString_2 = @"http://api.openweathermap.org/data/2.5/forecast/daily";
    NSDictionary* dictionary =@{@"lat":@"40.04991291",
                                @"lon":@"116.25626162",
                                @"APPID" : appIdKey};
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);  ///信号量为0
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_1
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"成功请求数据1:%@",[responseObject class]);
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);  ///信号量为0
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"失败请求数据");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore); ///信号量为0
             }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);  ///信号量为-1
    });
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_2
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"成功请求数据2:%@",[responseObject class]);
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"失败请求数据");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"完成了网络请求，不管网络请求失败了还是成功了。");
    });
}

 */

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
