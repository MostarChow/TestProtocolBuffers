//
//  ViewController.m
//  TestProtobuf
//
//  Created by Mostar on 2019/2/25.
//  Copyright © 2019 Mostar Chow. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textField.delegate = self;
}

- (IBAction)buttonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 10: {
            self.textView.text = nil;
            break;
        }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)sendPost {
    // 请求接口和参数
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/login", self.textField.text]];
    Input * input = [Input message];
    input.account = @"administrotor";
    input.password = @"P@ssw0rd";
    
    NSString * base64String = [[input data] base64EncodedStringWithOptions:0];
    NSData * base64 = [base64String dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [input data];
    request.timeoutInterval = 10;
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
        } else {
            // 请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = error.localizedDescription;
            });
        }
    }];
    [dataTask resume];
}

- (void)sendGet {
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/login?name=ios", self.textField.text]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 请求成功
            NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData * base64 = [[NSData alloc] initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self handleData:base64];
            
            // 模拟拦截破解
            // 返回数据
            NSString * responseDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData * responseBase64 = [[NSData alloc] initWithBase64EncodedString:responseDataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSString * responseBase64String = [[NSString alloc] initWithData:responseBase64 encoding:NSUTF8StringEncoding];
            NSLog(@"数据解密：%@", responseBase64String);
        } else {
            // 请求失败
            self.textView.text = error.localizedDescription;
        }
    }];
    [dataTask resume];
}


- (void)handleData:(NSData *)data {
    Output * user = [Output parseFromData:data error:nil];
    NSString * string = [NSString stringWithFormat:@"\n用户id：%ld \n用户名称：%@ \n用户密码：%@ \n联系号码：%ld \n地址：%@ \n老爸：%@ \n老母：%@, \n数组:%@",
                         (long)user.userId, user.userName, user.password, (long)user.telephone, user.address, user.family.father, user.family.mother, user.arrayArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.text = string;
    });
}

@end
