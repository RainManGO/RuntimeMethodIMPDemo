//
//  ViewController.m
//  Runtime Method IMP Intro
//
//  Created by apple on 2017/7/20.
//  Copyright © 2017年 ZY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo1];
    [self demo2];
}

-(void)demo1{
    //首先我们早类里面找到该方法
    Method ori_Method = class_getInstanceMethod([self class], @selector(myMethod:));
#if 0
    //获取方法名 SEL
    SEL oriMethodName = method_getName(ori_Method);
    //根据方法名获取函数指针
    IMP myMethodImp  =  [self methodForSelector:oriMethodName];
#else
    //直接根据方法名获取函数指针  等同于IF 0
    IMP myMethodImp  =  method_getImplementation(ori_Method);
#endif
    
    //在该类中添加方法。
#if 0
    class_addMethod([self class], @selector(testMethod:), myMethodImp, method_getTypeEncoding(ori_Method));
#else
    class_addMethod([self class], @selector(testMethod:), myMethodImp, "V@:@");
#endif
    
    //在执行方法。
    [self performSelector:@selector(testMethod:) withObject:@"7777"];
}

-(void)myMethod:(NSString *)myValue{
    NSLog(@"myMethod:%@",myValue);
}

//方法交换
-(void)demo2{
    Method method1 = class_getInstanceMethod([self class], @selector(exchangeMethod1:));
    Method method2 = class_getInstanceMethod([self class], @selector(exchangeMethod2:));
    Method method3 = class_getInstanceMethod([self class], @selector(exchangeMethod3:));
    Method method4 = class_getInstanceMethod([self class], @selector(exchangeMethod4:));
    //方法替换   替换SEL 的IMP实现
    class_replaceMethod([self class], @selector(exchangeMethod1:), method_getImplementation(method3), method_getTypeEncoding(method3));
    //和class_replaceMethod 类似，替换method 的结构题IMP指针
    method_setImplementation(method4, method_getImplementation(method2));
    //方法交换
    method_exchangeImplementations(method1, method2);
    //猜一猜打印的什么
    [self performSelector:method_getName(method1) withObject:@"Runtime Method Demo1" afterDelay:0.0];
    [self exchangeMethod2:@"Runtime Method Demo2"];
    [self exchangeMethod3:@"Runtime Method Demo3"];
    [self exchangeMethod4:@"Runtime Method Demo4"];
}

-(void)exchangeMethod1:(id)str{
    NSLog(@"exchangeMethod1:%@",str);
}

-(void)exchangeMethod2:(id)num{
    NSLog(@"exchangeMethod2:%@",num);
}

-(void)exchangeMethod3:(id)f{
    NSLog(@"exchangeMethod3:%@",f);
}

-(void)exchangeMethod4:(id)w{
    NSLog(@"exchangeMethod4:%@",w);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
