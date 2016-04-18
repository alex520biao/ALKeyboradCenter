//
//  ALViewController.m
//  ALKeyboradCenter
//
//  Created by alex520biao on 04/18/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

#import "ALViewController.h"
#import "ViewController.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor blackColor];
    btn.frame = CGRectMake(100,100,150,50);
    [btn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark custom
-(IBAction)nextAction:(id)sender{
    ViewController *viewController=[[ViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
