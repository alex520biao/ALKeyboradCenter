//
//  ViewController.h
//  KeyboradNotificationCenterDemo
//
//  Created by alex on 13-7-23.
//  Copyright (c) 2013年 alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *closeBtn;

-(IBAction)closeAction:(id)sender;
@end
