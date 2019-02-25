//
//  ViewController.m
//  TestProtobuf
//
//  Created by Mostar on 2019/2/25.
//  Copyright © 2019 Mostar Chow. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
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
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
     [manager.requestSerializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary * params = @{@"name" : @"ios"};
    [manager GET:@"http://127.0.0.1:8080/login" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * dataString = responseObject[@"Output"];
        NSData * data = [[NSData alloc]initWithBase64EncodedString:dataString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        User * user = [User parseFromData:data error:nil];
        NSLog(@"%ld + %@", user.userId, user.userName);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end
