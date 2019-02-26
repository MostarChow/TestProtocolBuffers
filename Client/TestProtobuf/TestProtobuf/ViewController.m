//
//  ViewController.m
//  TestProtobuf
//
//  Created by Mostar on 2019/2/25.
//  Copyright © 2019 Mostar Chow. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self send];
}

- (void)send {
     NSURL * url = [NSURL URLWithString:@"http://192.168.10.170:8080/login?name=ios"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    
        if (!error) {
             // 请求成功
            NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData * base64 = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
          
            NSError * parseError;
            User * user = [User parseFromData:base64 error:&parseError];
            if (!parseError) {
                NSLog(@"\n用户id：%ld \n用户名称：%@ \n用户密码：%@ \n联系号码：%ld \n地址：%@",
                      (long)user.userId, user.userName, user.password, (long)user.telephone, user.address);
            }
            
            // 模拟拦截破解
            NSString * base64String = [[NSString alloc] initWithData:base64 encoding:NSASCIIStringEncoding];
            NSLog(@"非主流方式解密：%@", base64String);
    
        } else {
            // 请求失败
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

@end
