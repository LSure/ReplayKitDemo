//
//  ViewController.m
//  ReplayKitDemo
//
//  Created by 刘硕 on 16/4/23.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>

@interface ViewController () <RPPreviewViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createImageView];
}

- (void)createImageView {
    self.imageView.animationImages = @[[UIImage imageNamed:@"img_01"], [UIImage imageNamed:@"img_02"], [UIImage imageNamed:@"img_03"], [UIImage imageNamed:@"img_04"]];
    self.imageView.animationDuration = 1;
    [self.imageView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//启动或者停止录制回放
- (IBAction)replayKitAction:(UIButton *)sender {
    //判断是否已经开始录制回放
    if (sender.isSelected) {
        //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                //处理发生的错误，如磁盘空间不足而停止等
            }
            if (previewViewController) {
                //设置预览页面到代理
                previewViewController.previewControllerDelegate = self;
                [self presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
        sender.selected = NO;
        return;
    }
    
    //如果还没有开始录制，判断系统是否支持
    if ([RPScreenRecorder sharedRecorder].available) {
        NSLog(@"OK");
        sender.selected = YES;
        //如果支持，就使用下面的方法可以启动录制回放
        [[RPScreenRecorder sharedRecorder] startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
            NSLog(@"%@", error);
            //处理发生的错误，如设用户权限原因无法开始录制等
        }];
    } else {
        NSLog(@"录制回放功能不可用");
    }
}

//回放预览界面的代理方法
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    //用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
