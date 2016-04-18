# ALKeyboradCenter

ALKeyboradCenter封装NSNotificationCenter监听键盘事件,对NSNotificationCenter进行包装，专注于处理键盘事件UIKeyboardWillShowNotification、UIKeyboardWillHideNotification、UIKeyboardWillChangeFrameNotification。 

监听键盘事件可以实现输入框与键盘的联动以及其他功能。

####一.封装内容
1. 键盘事件消息封装: 封装了NSNotificationCenter有关键盘事件的三个消息，并针对不同iOS版本进行兼容处理;
2. 键盘事件回调封装: 使用KeyboardWillShowBlcok和keyboardWillHideBlock两个Block来实现键盘事件回调，使用更加方便、代码更加集中;
3. 键盘事件参数封装: 使用NSKeyboradNotification类封装了键盘的消息userInfo信息,并通过block返回,这样查看键盘事件参数更加直观、使用更加方便;

####二.方法说明  

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

此方法中observer不会被retain，willShowBlock和willHideBlock会被copy;  

[[ALKeyboradCenter defaultCenter] removeKeyBoradObserver:self];
必须在dealloc中解除键盘事件监听，否则当前congtroller将得不到释放。willShowBlock和willHideBlock中不应该直接使用self或者成员变量，否则将产生循环引用问题。

####三.使用步骤:
1. podfile中添加ALKeyboradCenter;   
2. 在工程XXXX-Prefix.pch文件中添加import； 

        #import <ALKeyboradCenter/ALKeyboradCenter.h>
    
3. 在init方法中addObserver  
因为KeyboardWillShowBlcok和keyboardWillHideBlock的内容都是会被copy的，所以Blocks内容中不能出现self或者是当前类的成员变量，否则会引起循环引用;  

		- (void)viewDidLoad
		{
		    [super viewDidLoad];
		    self.view.backgroundColor=[UIColor whiteColor];
		    // Do any additional setup after loading the view, typically from a nib.
		    
		    //controller监听键盘事件
		    __weak typeof(self) weakSelf = self;
		    [[ALKeyboradCenter defaultCenter] addObserver:self
		                                         willShow:^(ALKeyboradNotification *keyboradObj) {
		                                             //处理keyboradObj
		                                             //将UIWindow坐标系的keyboardFrameEnd转换为self.view坐标系的keyboardFrameEnd_View
												    CGRect keyboardFrameEnd_View = [weakSelf.view convertRect:keyboradObj.keyboardFrameEnd fromView:keyboradObj.fromView];
												    
												    /* Move the toolbar to above the keyboard */
												    [UIView beginAnimations:nil context:NULL];
												    [UIView setAnimationDuration:keyboradObj.keyboardAnimationDuration];
												    [UIView setAnimationCurve:keyboradObj.keyboradAnimationCurve];
												    [UIView setAnimationBeginsFromCurrentState:YES];
												    
												    CGRect frame = self.textField.frame;
												    frame.origin.y= keyboardFrameEnd_View.origin.y - self.textField.frame.size.height;//键盘高度
												    self.textField.frame = frame;
												    
												    [UIView commitAnimations];

		                                         }
		                                         willHide:^(ALKeyboradNotification *keyboradObj) {
													//同上
		                                         }
		     ];
		} 

4. dealloc中解除键盘监听  
        
        -(void)dealloc{
            [[ALKeyboradCenter defaultCenter] removeKeyBoradObserver:self];
            
        }
        

## 维护者

alex520biao <alex520biao@163.com>

## License

ALKeyboradCenter is available under the MIT license. See the LICENSE file for more info.
