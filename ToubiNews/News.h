//
//  News.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, assign) int iId;
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* creation_date;
@property (nonatomic, strong) NSString* newsgroup;
@property (nonatomic, strong) NSString* content;

@end
