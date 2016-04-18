//
//  ViewController.m
//  ALKeyboradCenter
//
//  Created by alex520biao on 16/4/18.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ViewController.h"
#import <ALKeyboradCenter/ALKeyboradCenter.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)dealloc{
    [[ALKeyboradCenter defaultCenter] removeKeyBoradObserver:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    //controller监听键盘事件
    __weak typeof(self) weakSelf = self;
    [[ALKeyboradCenter defaultCenter] addObserver:self
                                         willShow:^(ALKeyboradNotification *keyboradObj) {
                                             //处理keyboradObj
                                             [weakSelf updatView_KeyboradNotification:keyboradObj];
                                         }
                                         willHide:^(ALKeyboradNotification *keyboradObj) {
                                             //处理keyboradObj
                                             [weakSelf updatView_KeyboradNotification:keyboradObj];
                                         }
     ];
    
    UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-30,self.view.frame.size.width, 30)];
    textField.borderStyle=UITextBorderStyleRoundedRect;//边框类型
    textField.font=[UIFont systemFontOfSize:12.0f];
    textField.text=@"";
    textField.placeholder=@"请输入";//提示语
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    self.textField=textField;
    [self.view addSubview:textField];
    
    //结束编辑
    UIButton *endBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [endBtn setTitle:@"关闭键盘" forState:UIControlStateNormal];
    endBtn.titleLabel.textColor=[UIColor redColor];
    endBtn.frame=CGRectMake(100,100,80,40);
    [endBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.textField.text=nil;
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updatView_KeyboradNotification:(ALKeyboradNotification *)keyboradObj{
    //将UIWindow坐标系的keyboardFrameEnd转换为self.view坐标系的keyboardFrameEnd_View
    CGRect keyboardFrameEnd_View = [self.view convertRect:keyboradObj.keyboardFrameEnd fromView:nil];
    
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
    [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = self.textField.frame;
    frame.origin.y= keyboardFrameEnd_View.origin.y - self.textField.frame.size.height;//键盘高度
    self.textField.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark custom
-(IBAction)closeAction:(id)sender{
    [self.textField resignFirstResponder];
}


@end
