//
//  KeyboradCenter.h
//  CloudAlbum
//
//  Created by alex on 13-7-18.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

//键盘监听返回的userInfo数据对象
@interface NSKeyboradNotification : NSObject
@property (nonatomic, assign) CGRect keyboardFrameBegin;//键盘弹出前在keyWindow上的frame
@property (nonatomic, assign) CGRect keyboardFrameEnd;//键盘弹出后前在keyWindow上的frame
@property (nonatomic, assign) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic, assign) UIViewAnimationCurve keyboradAnimationCurve;

-(NSKeyboradNotification*)initWithKeyboardDict:(NSDictionary*)keyboardDict;
@end

//定义Blocks类型
typedef void (^KeyboardWillShowBlcok)(NSKeyboradNotification *keyboradObj);
typedef void (^keyboardWillHideBlock)(NSKeyboradNotification *keyboradObj);

//键盘监听对象
@interface KeyboradBlocks : NSObject
@property (nonatomic, assign) id observer;
@property (nonatomic, copy) KeyboardWillShowBlcok keyboardWillShowBlcok;
@property (nonatomic, copy) keyboardWillHideBlock keyboardWillHideBlock;
@end

@interface KeyboradNotificationCenter : NSObject
+(KeyboradNotificationCenter *)defaultCenter;

//添加键盘监听: observer为assign，KeyboardWillShowBlcok和keyboardWillHideBlock均为copy
-(void)addObserver:(id)observer willShow:(KeyboardWillShowBlcok)willShowBlcok willHide:(keyboardWillHideBlock)willHideBlock;

//取消observer对象的键盘监听
-(void)removeKeyBoradObserver:(id)observer;
@end



