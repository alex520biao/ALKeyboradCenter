//
//  ALKeyboradCenter.m
//  alex
//
//  Created by alex520biao on 13-7-18.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import "ALKeyboradCenter.h"

@implementation ALKeyboradNotification
@synthesize keyboardFrameBegin=_keyboardFrameBegin;
@synthesize keyboardFrameEnd=_keyboardFrameEnd;
@synthesize keyboardAnimationDuration=_keyboardAnimationDuration;
@synthesize keyboradAnimationCurve=_keyboradAnimationCurve;

/*!
 *  @brief 封装键盘事件的NSNotification
 *
 *  @param notification 系统UIKeyboardWillShowNotification和UIKeyboardWillHideNotification事件notification
 *
 *  @return
 */
-(ALKeyboradNotification*)initWithNotification:(NSNotification*)notification{
    self=[super init];
    if (self) {
        NSDictionary* keyboardDict = [notification userInfo];
        
        ALKeyboradNotificationType type = ALKeyboradNotificationType_willShow;
        if([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification]){
            type = ALKeyboradNotificationType_willChange;
        }else if ([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification]){
            type = ALKeyboradNotificationType_willHide;
        }
        self.keyboradNotificationType = type;
        self.notification  = notification;
        
        //keyboardFrameBegin、keyboardFrameEnd为键盘弹出前后在当前UIWindow上的frame
        self.keyboardFrameBegin=[[keyboardDict objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        self.keyboardFrameEnd=[[keyboardDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.keyboardAnimationDuration=[[keyboardDict objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        self.keyboradAnimationCurve=[[keyboardDict objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    return self;
}

@end

@implementation ALKeyboradBlocks

@synthesize observer=_observer;
@synthesize keyboardWillShowBlcok=_keyboardWillShowBlcok;
@synthesize keyboardWillHideBlock=_keyboardWillHideBlock;

-(void)dealloc{
    _observer=nil;
    
    _keyboardWillShowBlcok=nil;
    _keyboardWillHideBlock=nil;
}

@end


@interface ALKeyboradCenter ()
@property (nonatomic, retain) NSMutableSet *keyboradBlcksSet;

@end

@implementation ALKeyboradCenter
@synthesize keyboradBlcksSet=_keyboradBlcksSet;

+ (ALKeyboradCenter *) defaultCenter{
    static ALKeyboradCenter * __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {        
        self.keyboradBlcksSet=[NSMutableSet set];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        // 键盘frame变化通知，ios5.0新增的
        #ifdef __IPHONE_5_0
            if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(keyboardWillChange:)
                                                             name:UIKeyboardWillChangeFrameNotification
                                                           object:nil];
            }
        #endif
    }
    return self;
}

-(void)dealloc{
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
}

#pragma mark - ManagerObserver
-(void)addObserver:(id)observer willShow:(KeyboardWillShowBlcok)willShowBlcok willHide:(keyboardWillHideBlock)willHideBlock{
    ALKeyboradBlocks *blocks=[[ALKeyboradBlocks alloc] init];
    blocks.observer=observer;
    blocks.keyboardWillShowBlcok=willShowBlcok;
    blocks.keyboardWillHideBlock=willHideBlock;
    [self.keyboradBlcksSet addObject:blocks];
}

-(void)removeKeyBoradObserver:(id)observer{
    ALKeyboradBlocks *currentBlock=nil;
    for (ALKeyboradBlocks *blicks in self.keyboradBlcksSet) {
        if (blicks.observer==observer) {
            currentBlock=blicks;
        }
    }
    if (currentBlock) {
        NSLog(@"%lu",(unsigned long)self.keyboradBlcksSet.count);
        [self.keyboradBlcksSet removeObject:currentBlock];
        NSLog(@"%lu",(unsigned long)self.keyboradBlcksSet.count);
    }
}

#pragma mark- NSNotification
- (void)keyboardWillShow:(NSNotification *)notification{
    /*回调方法:键盘弹出时的回调方法*/
    NSMutableSet *set = [NSMutableSet setWithSet:self.keyboradBlcksSet];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        ALKeyboradBlocks *blicks = (ALKeyboradBlocks*)obj;
        if (blicks.keyboardWillShowBlcok) {
            ALKeyboradNotification *keyboradeObj = [[ALKeyboradNotification alloc] initWithNotification:notification];
            blicks.keyboardWillShowBlcok(keyboradeObj);
        }
    }];
}

- (void)keyboardWillChange:(NSNotification *)notification{
    /*回调方法:键盘 改变时的回调方法*/
    NSMutableSet *set = [NSMutableSet setWithSet:self.keyboradBlcksSet];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        ALKeyboradBlocks *blicks = (ALKeyboradBlocks*)obj;
        if (blicks.keyboardWillShowBlcok) {
            ALKeyboradNotification *keyboradeObj = [[ALKeyboradNotification alloc] initWithNotification:notification];
            blicks.keyboardWillShowBlcok(keyboradeObj);
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    /*回调方法:键盘隐藏时的回调方法*/
    NSMutableSet *set = [NSMutableSet setWithSet:self.keyboradBlcksSet];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        ALKeyboradBlocks *blicks = (ALKeyboradBlocks*)obj;
        if (blicks.keyboardWillHideBlock) {
            ALKeyboradNotification *keyboradeObj = [[ALKeyboradNotification alloc] initWithNotification:notification];
            blicks.keyboardWillHideBlock(keyboradeObj);
        }
    }];
}

@end
