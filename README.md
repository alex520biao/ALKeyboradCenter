KeyboradNotificationCenterDemo
==============================

KeyboradNotificationCenter是对NSNotificationCenter进行包装，专注于处理键盘事件UIKeyboardWillShowNotification、UIKeyboardWillHideNotification、UIKeyboardWillChangeFrameNotification
封装内容:

*添加键盘监听: 封装了上面的三个键盘事件，特别针对不同iOS版本进行特别处理;

*键盘事件处理: 使用KeyboardWillShowBlcok和keyboardWillHideBlock两个Block来实现键盘事件回调，使用更加方便、代码更加集中;

*键盘事件参数: 使用NSKeyboradNotification类封装了键盘的消息userInfo信息,查看更加直观、使用更加方便;


使用步骤:
1.拖动KeyboradNotificationCenter目录添加到工程中;
2.在工程XXXX-Prefix.pch文件中添加import
#import "KeyboradNotificationCenter.h"
    
3.在init方法中addObserver
因为KeyboardWillShowBlcok和keyboardWillHideBlock的内容都是会被copy的，所以Blocks内容中不能出现self或者是当前类的成员变量，否则会引起循环引用;
__block ViewController *selfBlock=self;
__block关字可以让变量不被retain并且允许在在Block内容中修改变量的值;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

4.dealloc中解除键盘监听

-(void)dealloc{
    [[KeyboradNotificationCenter defaultCenter] removeKeyBoradObserver:self];
    
    [super dealloc];
}




