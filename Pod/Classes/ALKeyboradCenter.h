//
//  ALKeyboradCenter.h
//  alex
//
//  Created by alex520biao on 13-7-18.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    //键盘展示
    ALKeyboradNotificationType_willShow,
    //键盘改变
    ALKeyboradNotificationType_willChange,
    //键盘隐藏
    ALKeyboradNotificationType_willHide,
} ALKeyboradNotificationType;

/*!
 *  @brief  键盘变化事件(键盘事件UIKeyboardWillChangeFrameNotification的NSNotification封装,包括willShow/willHide事件)
 */
@interface ALKeyboradNotification : NSObject

/*!
 *  @brief 键盘事件类型(显示/隐藏)
 */
@property (nonatomic, assign) ALKeyboradNotificationType keyboradNotificationType;

/*!
 *  @brief 键盘frame的fromView即为UIApplication的keyWindow
 */
@property (nonatomic, weak,readonly) UIView* fromView;

/*!
 *  @brief  键盘事件前键盘在keywindow上的frame
 *  @note   CGRect keyboardFrameEnd_View = [self.view convertRect:keyboradObj.keyboardFrameEnd fromView:keyboradObj.fromView];

 */
@property (nonatomic, assign) CGRect keyboardFrameBegin;

/*!
 *  @brief  键盘事件后键盘在keywindow上的frame
 */
@property (nonatomic, assign) CGRect keyboardFrameEnd;

/*!
 *  @brief  键盘动画时长
 */
@property (nonatomic, assign) NSTimeInterval keyboardAnimationDuration;

/*!
 *  @brief  键盘动画类型
 */
@property (nonatomic, assign) UIViewAnimationCurve keyboradAnimationCurve;

/*!
 *  @brief 原始NSNotification对象
 */
@property (nonatomic, strong) NSNotification* notification;


/*!
 *  @brief 封装键盘事件的NSNotification
 *
 *  @param notification 系统UIKeyboardWillShowNotification和UIKeyboardWillHideNotification事件notification
 *
 *  @return
 */
-(ALKeyboradNotification*)initWithNotification:(NSNotification*)notification;

@end

//定义Blocks类型
typedef void (^ALKeyboardWillShowBlcok)(ALKeyboradNotification *keyboradObj);
typedef void (^ALKeyboardWillHideBlock)(ALKeyboradNotification *keyboradObj);

/*!
 *  @brief 键盘事件监听者对象
 */
@interface ALKeyboradBlocks : NSObject
/*!
 *  @brief 监听者
 */
@property (nonatomic, weak) id observer;
/*!
 *  @brief 键盘展示事件block
 */
@property (nonatomic, copy) ALKeyboardWillShowBlcok keyboardWillShowBlcok;
/*!
 *  @brief 键盘隐藏事件block
 */
@property (nonatomic, copy) ALKeyboardWillHideBlock keyboardWillHideBlock;
@end

@interface ALKeyboradCenter : NSObject
+(ALKeyboradCenter *)defaultCenter;

/*!
 *  @brief 添加键盘事件监听者
 *
 *  @param observer      observer为weak弱引用
 *  @param willShowBlcok KeyboardWillShowBlcok会被copy
 *  @param willHideBlock keyboardWillHideBlock会被copy
 */
-(void)addObserver:(id)observer
          willShow:(ALKeyboardWillShowBlcok)willShowBlcok
          willHide:(ALKeyboardWillHideBlock)willHideBlock;

/*!
 *  @brief 移除observer对象的键盘监听
 *
 *  @param observer
 */
-(void)removeKeyBoradObserver:(id)observer;
@end



