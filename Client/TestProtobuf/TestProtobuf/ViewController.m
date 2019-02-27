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
    switch (sender.tag) {
        case 100: {
             [self sendPost];
            break;
        }
        case 101: {
            [self sendGet];
            break;
        }
    }
}

- (void)sendPost {
    // 请求接口和参数
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:8080/login"];
    Input * input = [Input message];
    input.account = @"administrotor";
    input.password = @"P@ssw0rd";
  
    NSString * base64String = [[input data] base64EncodedStringWithOptions:0];
    NSData * base64 = [base64String dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = base64;
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 请求成功
            [self handleData:data];
            // 模拟拦截破解
            // 请求数据
            NSString * requestDataString = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
            NSData * requestBase64 = [[NSData alloc] initWithBase64EncodedString:requestDataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString * requestBase64String = [[NSString alloc] initWithData:requestBase64 encoding:NSUTF8StringEncoding];
            NSLog(@"请求解密：%@", requestBase64String);
            // 返回数据
            NSString * responseDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData * responseBase64 = [[NSData alloc] initWithBase64EncodedString:responseDataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString * responseBase64String = [[NSString alloc] initWithData:responseBase64 encoding:NSUTF8StringEncoding];
            NSLog(@"数据解密：%@", responseBase64String);
        } else {
            // 请求失败
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

- (void)sendGet {
    NSURL * url = [NSURL URLWithString:@"http://127.0.0.1:8080/login?name=ios"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
             // 请求成功
            [self handleData:data];
        } else {
            // 请求失败
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [dataTask resume];
}


- (void)handleData:(NSData *)data {
    NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData * base64 = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSError * parseError;
    Output * user = [Output parseFromData:base64 error:&parseError];
    if (!parseError) {
        NSLog(@"\n用户id：%ld \n用户名称：%@ \n用户密码：%@ \n联系号码：%ld \n地址：%@ \n老爸：%@ \n老母：%@, \n数组:%@",
              (long)user.userId, user.userName, user.password, (long)user.telephone, user.address, user.family.father, user.family.mother, user.arrayArray);
    } else {
        NSLog(@"%@", parseError.localizedDescription);
    }
}

@end
