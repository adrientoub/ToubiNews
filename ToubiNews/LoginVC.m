//
//  LoginVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 10/03/2016.
//  Copyright © 2016 Toub. All rights reserved.
//

#import "LoginVC.h"
#import "ApiConstants.h"

@implementation LoginVC

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.loginTextField)
  {
    [self.passwordTextField becomeFirstResponder];
    [self.loginTextField resignFirstResponder];
  }
  else if (textField == self.passwordTextField)
  {
    [self loginAction:textField];
  }
  return YES;
}

- (IBAction)loginAction:(id)sender {
  [self.loginTextField resignFirstResponder];
  [self.passwordTextField resignFirstResponder];
  [self changeController];
//  [self login:self.loginTextField.text password:self.passwordTextField.text];
}

- (void)changeController {
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UINavigationController* nav = [storyboard instantiateViewControllerWithIdentifier:@"postNC"];
  UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"postVC"];

  [nav addChildViewController:vc];
  [nav presentViewController:vc animated:NO completion:^{}];
  /*[self performSegueWithIdentifier:@"postSegue"
                            sender:self];*/
}

- (void)login:(NSString*)username password:(NSString*)password {
  NSString* strURL = [NSString stringWithFormat:@"%@%@", kAPI_BASE_URL, kAPI_LOGIN];
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
  [request setHTTPMethod:@"POST"];
  NSString* postQuery = [NSString stringWithFormat:@"username=%@&password=%@&service=ios&device_name=%@&registration_id=%@", username, password, [[UIDevice currentDevice] name], @"test"];
  NSLog(@"Posting to %@", postQuery);
  NSData* postData = [postQuery dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

  [request setValue:kAPI_KEY forHTTPHeaderField:@"key"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                           NSURLResponse *response, NSError *error)
   {
     if (!error && [response isKindOfClass:[NSHTTPURLResponse class]] &&
         ((NSHTTPURLResponse *)response).statusCode == 200)
     {
       NSError* jsonError = NULL;
       NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData: data
                                                                 options: NSJSONReadingMutableContainers error: &jsonError];

       NSLog(@"%@", arrayJson);
       self.sessionKey = [arrayJson valueForKey:@"session_key"];
       NSLog(@"%@", self.sessionKey);
       [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
         [self changeController];
       }];
     }
     else
     {
       NSLog(@"ERROR: %@; %ld", data, (long)((NSHTTPURLResponse *)response).statusCode);
     }
   }] resume];
}

@end
