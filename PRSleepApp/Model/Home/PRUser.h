//
//  PRUser.h
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
NS_ASSUME_NONNULL_BEGIN

@interface PRUser : NSObject

//name
@property (nonatomic,copy) NSString *username;

//
@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *avatarUrl;


+ (void)save:(AVUser *)user;
+ (id *)readLocalUser;
+ (id *)transfer:(AVUser *)user;


@end

NS_ASSUME_NONNULL_END
