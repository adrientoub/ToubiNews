//
//  Newsgroup.h
//  ToubiNews
//
//  Created by Adrien on 08/06/15.
//  Copyright (c) 2015 Toub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Newsgroup : NSObject

@property (nonatomic, assign) int iId;
@property (nonatomic, strong) NSString* group_name;
@property (nonatomic, assign) int topic_nb;

@end
