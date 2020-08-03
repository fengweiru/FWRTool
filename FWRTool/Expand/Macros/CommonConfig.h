//
//  CommonConfig.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/30.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#ifndef CommonConfig_h
#define CommonConfig_h

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define CommonOrangeColor FColor(238, 105, 85)

// 自定义颜色
#define FColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]
// 自定义颜色 透明度
#define FColorWithAlpha(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define FFontRegular(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightRegular]
#define FFontMedium(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightMedium]
#define FFontSemibold(size) [UIFont systemFontOfSize:(size) weight:UIFontWeightSemibold]

#define Color_Background  FColor(0xf7, 0xf7, 0xf7)

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define Height_For_AppHeader  ([[UIApplication sharedApplication] statusBarFrame].size.height+44)
#define Height_For_StatusBar  [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_For_IphoneBottom   ((kScreenH==812)?34:0)
#define Height_For_Tabbar     49

/****************
 正则表达式
 ****************/

#define REGEXP_PHONE                                  @"^(1\\d{10})|(1\\d{2}\\-\\d{4}\\-\\d{4})$"
#define REGEXP_EMAIL                                  @"^\\w+([-+._]\\w+)*@\\w+([-._]\\w+)*\\.\\w+([-._]\\w+)*$"
//#define REGEXP_EMAIL                                  @"/^[a-zA-Z0-9!#$%&\'*+\\/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&\'*+\\/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$/"
#define REGEXP_PASSWORD                               @"^[a-zA-Z0-9]{6,16}$"
#define REGEXP_NICKNAME                               @"^[\u4E00-\u9FA5A-Za-z0-9]{1,12}$"
#define REGEXP_ContactLabelNAME                               @"^[\u4E00-\u9FA5A-Za-z0-9]{1,16}$"
#define REGEXP_IDCARD                                 @"^(\\d{18}$|^\\d{17}(\\d|X|x))$"
#define REGEXP_GROUPNAME                              @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$"
#define REGEXP_CLOCKLABLE                              @"[a-zA-Z0-9\u4e00-\u9fa5]{0,20}"
#define REGEXP_REMARK                                 @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$"

#endif /* CommonConfig_h */
