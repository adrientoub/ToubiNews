//
//  LoginVC.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 10/03/2016.
//  Copyright © 2016 Toub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) NSString* sessionKey;

@end
