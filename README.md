# ALKeyboradCenter

ALKeyboradCenter封装NSNotificationCenter监听键盘事件,对NSNotificationCenter进行包装，专注于处理键盘事件UIKeyboardWillShowNotification、UIKeyboardWillHideNotification、UIKeyboardWillChangeFrameNotification。 

监听键盘事件可以实现输入框与键盘的联动以及其他功能。

####一.封装内容
1. 键盘事件消息封装: 封装了NSNotificationCenter有关键盘事件的三个消息，并针对不同iOS版本进行兼容处理;
2. 键盘事件回调封装: 使用KeyboardWillShowBlcok和keyboardWillHideBlock两个Block来实现键盘事件回调，使用更加方便、代码更加集中;
3. 键盘事件参数封装: 使用NSKeyboradNotification类封装了键盘的消息userInfo信息,并通过block返回,这样查看键盘事件参数更加直观、使用更加方便;

####二.方法说明  

    -(void)addObserver:(id)observer 
              willShow:(KeyboardWillShowBlcok)willShowBlcok 
              willHide:(keyboardWillHideBlock)willHideBlock;
此方法中observer不会被retain，willShowBlock和willHideBlock会被copy;  

[[KeyboradNotificationCenter defaultCenter] removeKeyBoradObserver:self];
必须在dealloc中解除键盘事件监听，否则当前congtroller将得不到释放。willShowBlock和willHideBlock中不应该直接使用self或者成员变量，否则将产生循环引用问题。

####三.使用步骤:
1. 拖动KeyboradNotificationCenter目录添加到工程中;   
2. 在工程XXXX-Prefix.pch文件中添加import； 

    	#import "KeyboradNotificationCenter.h"
    
3. 在init方法中addObserver  
因为KeyboardWillShowBlcok和keyboardWillHideBlock的内容都是会被copy的，所以Blocks内容中不能出现self或者是当前类的成员变量，否则会引起循环引用;  

	    -(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	        if (self) {
	            //__block用于修饰self，保证不会循环引用
	            __block ViewController *selfBlock=self;
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

4. dealloc中解除键盘监听  
        
        -(void)dealloc{
            [[KeyboradNotificationCenter defaultCenter] removeKeyBoradObserver:self];
            
            [super dealloc];
        }
        

## 维护者

alex520biao <alex520biao@163.com>

## License

ALKeyboradCenter is available under the MIT license. See the LICENSE file for more info.
