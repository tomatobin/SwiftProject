//
//  LCTextField.h
//  LCTextField
//
//  Owned by han_dong on 16/09/30.
//  Created by amysDavidHan on 16/2/21.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LCTextFieldMsgBlock)(NSString *checkingMsg);

typedef void(^LCTextFieldTextChangedBlock)(NSString *text);

NS_CLASS_AVAILABLE_IOS(7_0) @interface LCTextField : UITextField <UITextFieldDelegate> {
	
}
	/*!
	 *  @author han_dong, 16-02-23 14:02:52
	 *
	 *  @brief 限制输入
	 */
	//@property (nonatomic, assign) BOOL          isMenuItemsEnable; //默认YES. 是否支持长按弹出编辑菜单
	@property (nonatomic, assign) BOOL          isRuled; //默认NO. 输入是否受限
	@property (nonatomic, assign) BOOL          disableEmoji; //输入内容禁止emoji表情, 默认为NO
	@property (nonatomic, assign) BOOL          disableSpace; //输入内容禁止全角半角空格符\竖直水平制表符\回车换行换页符等所有空白符, 默认为NO
	@property (nonatomic, assign) BOOL          disableSpecialChar; //输入内容禁止特殊符号, 默认为NO
	@property (nonatomic, assign) BOOL          disableUnderRegEx;
	@property (nonatomic, assign) NSUInteger    chineseStrLength; //默认一个中文算2字节，如有特别需求，可在外部自定义。影响可输入的字节长度。
	
	/// 是否显示菜单
	@property (nonatomic, assign) BOOL          isMenuHidden;
	
	/*!
	 *  @author han_dong, 16-02-23 14:02:31
	 *
	 *  @brief 校验输入
	 */
	@property (nonatomic, assign) BOOL          isChecking; //默认为NO. 输入时是否校验
	@property (nonatomic, assign) BOOL          checkOnTextChanged; //输入框内容发生变化时, 动态校验, 默认为NO
	@property (nonatomic, assign) BOOL          checkOnResign; //输入完成后(更改FirstResponder), 后置校验, 默认为NO
	
	/// 文字变化的block，上层需要注意循环引用！！！
	@property (nonatomic, copy) LCTextFieldTextChangedBlock textChanged;
	
- (void)lc_setInputRuleWithRegEx:(NSString *)stringRegEx andInputLength:(unsigned int)inputLength; //自定义正则表达式字符串. 限制内容及长度. 调用该方法后, 默认将isRuledByRegEx状态置为YES
	
- (void)lc_addRegExToCheckTextField:(NSString *)strRegEx withMsgBlock:(LCTextFieldMsgBlock)msgBlock; //自定义正则表达式, 调用时默认将isChecking状态置为YES
	
- (void)lc_addConfirmValidationToCheckTextField:(LCTextField *)targetTextField withMsgBlock:(LCTextFieldMsgBlock)msgBlock; //用于校验输入确认密码, 调用时默认将isChecking状态置为YES
	
- (void)lc_setBlankMsgBlock:(LCTextFieldMsgBlock)block; //设置空内容提醒
	
- (BOOL)lc_checkIt; //检验方法, 开放外部调用.
	
@end
