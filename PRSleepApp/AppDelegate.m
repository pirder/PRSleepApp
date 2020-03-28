//
//  AppDelegate.m
//  PRSleepApp
//
//  Created by priders on 2020/2/18.
//  Copyright © 2020 priders. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MoreViewController.h"
#import "MineViewController.h"
//#import "PRLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#import "Public.h"

#define APP_ID @"erPdYyNlHrnLg71uCqcY8GxD-gzGzoHsz"
#define APP_KEY @"qaxblrv3HKG2uiKdDR9MpYDF"


@interface AppDelegate ()

@end

@implementation AppDelegate


-(void) initRootVC
{
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.hidden = NO;
    self.window.backgroundColor = [UIColor blackColor];
    self.window.hidden = NO;
    //1
    HomeViewController *VC1 = [[HomeViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:VC1];
   
    MoreViewController *VC2 = [[MoreViewController alloc]init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:VC2];
    
    MineViewController *VC3 = [[MineViewController alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:VC3];
   
    VC1.title = @"我的家";
    VC2.title = @"更多";
    VC3.title = @"我的";
    
    //2
    NSArray *viewCtrs = @[nav1,nav2,nav3];
    //3
    self.rootTabbarCtr = [[UITabBarController alloc]init];
//    [self.rootTabbarCtr setViewControllers:viewCtrs animated:YES];
    [self.rootTabbarCtr setViewControllers:viewCtrs];
//    self.window.rootViewController = self.rootTabbarCtr;
//    [self.window setRootViewController:self.rootTabbarCtr];
    self.window.rootViewController = self.rootTabbarCtr;
    
    UITabBar *tabBar = self.rootTabbarCtr.tabBar;
    UITabBarItem  *item1 = [tabBar.items objectAtIndex:0];
    UITabBarItem  *item2 = [tabBar.items objectAtIndex:1];
    UITabBarItem  *item3 = [tabBar.items objectAtIndex:2];
//
   
    //半透明属性
    //    tabBar.backgroundImage = [[UIImage alloc] init];
    //    tabBar.backgroundColor = nil;
//    tabBar.translucent = YES;
  //tabBar透明
    tabBar.backgroundImage = [UIImage imageNamed:@"tranlcent"];
    tabBar.shadowImage = [[UIImage alloc]init];
    //设置图片
    item1.selectedImage = [[UIImage imageNamed:@"iconClockSlected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"iconClockNormal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"iconMoreSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"iconMoreNormal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"iconMineSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"iconMineNormal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置uitabbaritewm字体
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(54, 185,175),UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
//    self.window.rootViewController = [[PRLoginViewController alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    
}
- (UIImage *)imageWithColorDIY{
    return [[UIImage alloc]init];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY serverURLString:@"https://erpdyynl.lc-cn-n1-shared.com"];
//
//    [AVOSCloud setAllLogsEnabled:YES];
    
    
    [self initRootVC];
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PRSleepApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
