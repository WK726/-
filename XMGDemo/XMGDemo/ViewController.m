//
//  ViewController.m
//  XMGDemo
//
//  Created by 姣姣 on 2019/5/12.
//  Copyright © 2019年 CaiFaXian.com. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
@interface ViewController ()
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //文本计算
    [@"haha" boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    [@"hahatesst" drawInRect:CGRectMake(0, 0, 100, 100) withAttributes:nil];
}
- (void)image{
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:imageview];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       //获取CGImage
        CGImageRef cgImage = [UIImage imageNamed:@"haha"].CGImage;
        
        //alphaInfo
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) &kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast || alphaInfo == kCGImageAlphaPremultipliedFirst || alphaInfo == kCGImageAlphaLast || alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        
        //bitmapInfo
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        
        //size
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        
        //context上下文
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        
        //绘制
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
        
        //获取图片
        cgImage = CGBitmapContextCreateImage(context);
        UIImage *newImage = [UIImage imageWithCGImage:cgImage];
        
        CGContextRelease(context);
        CGImageRelease(cgImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
