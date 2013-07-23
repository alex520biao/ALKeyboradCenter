//
//  ViewController.m
//  KeyboradNotificationCenterDemo
//
//  Created by alex on 13-7-23.
//  Copyright (c) 2013年 alex. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textField=_textField;
@synthesize closeBtn=_closeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //当前爱你controller监听键盘事件
        __block ViewController *selfBlock=self;
        //__block用于修饰self，保证不会循环引用
        [[KeyboradNotificationCenter defaultCenter] addObserver:self
                                                       willShow:^(NSKeyboradNotification *keyboradObj) {
                                                           CGRect keyboardFrameEnd_View = [selfBlock.view convertRect:keyboradObj.keyboardFrameEnd fromView:nil];
                                                           
                                                           NSLog(@"NSKeyboradNotification");
                                                           
                                                           /* Move the toolbar to above the keyboard */
                                                           [UIView beginAnimations:nil context:NULL];
                                                           [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
                                                           [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
                                                           [UIView setAnimationBeginsFromCurrentState:YES];
                                                           CGRect frame = selfBlock.textField.frame;
                                                           frame.origin.y= keyboardFrameEnd_View.origin.y-selfBlock.textField.frame.size.height;//键盘高度
                                                           selfBlock.textField.frame = frame;
                                                           [UIView commitAnimations];
                                                       }
                                                       willHide:^(NSKeyboradNotification *keyboradObj) {
                                                            CGRect keyboardFrameEnd_View = [selfBlock.view convertRect:keyboradObj.keyboardFrameEnd fromView:nil];
                                                           
                                                           /* Move the toolbar to above the keyboard */
                                                           [UIView beginAnimations:nil context:NULL];
                                                           [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
                                                           [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
                                                           [UIView setAnimationBeginsFromCurrentState:YES];
                                                           CGRect frame = selfBlock.textField.frame;
                                                           frame.origin.y= keyboardFrameEnd_View.origin.y-selfBlock.textField.frame.size.height;//键盘高度
                                                           selfBlock.textField.frame = frame;
                                                           [UIView commitAnimations];
                                                       }
         ];

    }
    return self;
}

-(void)dealloc{
    [[KeyboradNotificationCenter defaultCenter] removeKeyBoradObserver:self];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark custom
-(IBAction)closeAction:(id)sender{
    [self.textField resignFirstResponder];
}
@end
