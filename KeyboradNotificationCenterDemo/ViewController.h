//
//  ViewController.h
//  KeyboradNotificationCenterDemo
//
//  Created by alex on 13-7-23.
//  Copyright (c) 2013年 alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet UIButton *closeBtn;

-(IBAction)closeAction:(id)sender;
@end
