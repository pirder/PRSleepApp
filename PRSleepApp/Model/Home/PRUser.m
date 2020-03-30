//
//  PRUser.m
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRUser.h"

@implementation PRUser

+ (void)save:(AVUser *)user{
    
    PRUser *curUser = [[PRUser alloc]init];
    
    if (user != nil) {
        curUser.username = user.username;
       
        curUser.avatarUrl = ((AVFile *)[user objectForKey:@"imageHead"]).url;
        
        curUser.userId = user.objectId;
        
    }
  
}

+ (void)readLocalUser{
    
}

+ (id)transfer:(AVUser *)user{
    PRUser *curUser = [[PRUser alloc]init];
    
    if (user != nil) {
        curUser.username = user.username;
        
        curUser.avatarUrl = ((AVFile *)[user objectForKey:@"imageHead"]).url;
        
        curUser.userId = user.objectId;
        
    }
      return curUser;
}
@end
