//
//  KeyboradCenter.m
//  CloudAlbum
//
//  Created by alex on 13-7-18.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import "KeyboradNotificationCenter.h"

@implementation NSKeyboradNotification
@synthesize keyboardFrameBegin=_keyboardFrameBegin;
@synthesize keyboardFrameEnd=_keyboardFrameEnd;
@synthesize keyboardAnimationDuration=_keyboardAnimationDuration;
@synthesize keyboradAnimationCurve=_keyboradAnimationCurve;

-(NSKeyboradNotification*)initWithKeyboardDict:(NSDictionary*)keyboardDict{
    self=[super init];
    if (self) {
        //keyboardFrameBegin、keyboardFrameEnd为键盘弹出前后在当前UIWindow上的frame
        self.keyboardFrameBegin=[[keyboardDict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        self.keyboardFrameEnd=[[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.keyboardAnimationDuration=[[keyboardDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        self.keyboradAnimationCurve=[[keyboardDict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    return self;
}
@end

@implementation KeyboradBlocks

@synthesize observer=_observer;
@synthesize keyboardWillShowBlcok=_keyboardWillShowBlcok;
@synthesize keyboardWillHideBlock=_keyboardWillHideBlock;

-(void)dealloc{
    _observer=nil;
    
    [_keyboardWillShowBlcok release];
    _keyboardWillShowBlcok=nil;
    
    [_keyboardWillHideBlock release];
    _keyboardWillHideBlock=nil;
    
    [super dealloc];
}

@end


@interface KeyboradNotificationCenter ()
@property (nonatomic, retain) NSMutableSet *keyboradBlcksSet;

@end

@implementation KeyboradNotificationCenter
@synthesize keyboradBlcksSet=_keyboradBlcksSet;

static KeyboradNotificationCenter *keyboradCenter = nil;
+(KeyboradNotificationCenter *)defaultCenter{
    if (keyboradCenter==nil){
        keyboradCenter=[[KeyboradNotificationCenter alloc] init];
    }
    return keyboradCenter;
}

- (id)init
{
    self = [super init];
    if (self) {        
        self.keyboradBlcksSet=[NSMutableSet set];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的
        #ifdef __IPHONE_5_0
                if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
                }
        #endif
    }
    return self;
}

-(void)dealloc{
    [_keyboradBlcksSet release];
    _keyboradBlcksSet=nil;
    
    //清理与键盘相关的监听事件等同于[supser removeObserver:];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    #ifdef __IPHONE_5_0
        if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        }
    #endif    
    [super dealloc];
}

-(void)addObserver:(id)observer willShow:(KeyboardWillShowBlcok)willShowBlcok willHide:(keyboardWillHideBlock)willHideBlock{
    KeyboradBlocks *blocks=[[KeyboradBlocks alloc] init];
    blocks.observer=observer;
    blocks.keyboardWillShowBlcok=willShowBlcok;
    blocks.keyboardWillHideBlock=willHideBlock;
    [self.keyboradBlcksSet addObject:blocks];
    [blocks release];
}

-(void)removeKeyBoradObserver:(id)observer{
    KeyboradBlocks *currentBlock=nil;
    for (KeyboradBlocks *blicks in self.keyboradBlcksSet) {
        if (blicks.observer==observer) {
            currentBlock=blicks;
        }
    }
    if (currentBlock) {
        [self.keyboradBlcksSet removeObject:currentBlock];
    }
}

#pragma mark keyboardNSNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    //将UIkeyborad消息中的userInfo信息封装为UIKeyboardObj
    /*回调方法:键盘弹出时的回调方法*/    
    for (KeyboradBlocks *blicks in self.keyboradBlcksSet) {
        if (blicks.keyboardWillShowBlcok) {
            NSKeyboradNotification *keyboradeObj=[[[NSKeyboradNotification alloc] initWithKeyboardDict:[notification userInfo]] autorelease];
            blicks.keyboardWillShowBlcok(keyboradeObj);
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /*回调方法:键盘隐藏时的回调方法*/    
    for (KeyboradBlocks *blicks in self.keyboradBlcksSet) {
        if (blicks.keyboardWillHideBlock) {
            NSKeyboradNotification *keyboradeObj=[[[NSKeyboradNotification alloc] initWithKeyboardDict:[notification userInfo]] autorelease];
            blicks.keyboardWillHideBlock(keyboradeObj);
        }
    }
}


@end
