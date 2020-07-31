//
//  AppDelegate.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/30.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;

- (void)saveContext;

@property (nonatomic,strong)UIWindow *window;


@end

