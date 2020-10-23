//
//  PersonManager.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "PersonManager.h"

@interface PersonManager ()

@property (nonatomic, strong) NSMutableArray *arrayBoard;

@end

@implementation PersonManager

- (instancetype)init
{
    if (self = [super init]) {
       
    }
    return self;
}

- (void)createBaseData
{
    //        {   {1,1,1,1},
    //            {1,1,1,1},
    //            {0,1,1,0},
    //            {1,1,1,1},
    //            {1,1,1,1}}
    PointModel *empty1;
    PointModel *empty2;
    switch (self.type) {
        case 0:
            empty1 = [PointModel makePointWithX:4 y:1];
            empty2 = [PointModel makePointWithX:4 y:2];
            break;
        case 1:
            empty1 = [PointModel makePointWithX:4 y:0];
            empty2 = [PointModel makePointWithX:4 y:3];
            break;
        case 2:
            empty1 = [PointModel makePointWithX:4 y:0];
            empty2 = [PointModel makePointWithX:4 y:1];
            break;
        case 3:
            empty1 = [PointModel makePointWithX:4 y:0];
            empty2 = [PointModel makePointWithX:4 y:3];
            break;
        case 4:
            empty1 = [PointModel makePointWithX:4 y:1];
            empty2 = [PointModel makePointWithX:4 y:2];
            break;
        case 5:
            empty1 = [PointModel makePointWithX:4 y:0];
            empty2 = [PointModel makePointWithX:4 y:3];
            break;
        case 6:
            empty1 = [PointModel makePointWithX:4 y:1];
            empty2 = [PointModel makePointWithX:4 y:2];
            break;
        case 7:
            empty1 = [PointModel makePointWithX:4 y:1];
            empty2 = [PointModel makePointWithX:4 y:2];
            break;
        case 8:
            empty1 = [PointModel makePointWithX:0 y:0];
            empty2 = [PointModel makePointWithX:0 y:3];
            break;
            
        default:
            empty1 = [PointModel makePointWithX:4 y:1];
            empty2 = [PointModel makePointWithX:4 y:2];
            break;
    }
    
    self.arrayBoard = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSInteger x = 0; x < 5; x++) {
        NSMutableArray *rawArr = [[NSMutableArray alloc] init];
        for (NSInteger y = 0; y < 4; y++) {
            if ((x==empty1.x&&y==empty1.y) || (x==empty2.x&&y==empty2.y)) {
                [rawArr addObject:@0];
            } else {
                [rawArr addObject:@1];
            }
        }
        [self.arrayBoard addObject:rawArr];
    }
    
//    @[
//    @[@1,@1,@1,@1],
//    @[@1,@1,@1,@1],
//    @[@0,@1,@1,@0],
//    @[@1,@1,@1,@1],
//    @[@1,@1,@1,@1]
//   ]

}

- (void)setType:(NSInteger)type
{
    _type = type;
    
    [self createBaseData];
}

- (BOOL)couldMoveWithPersonView:(PersonView *)personView direct:(UISwipeGestureRecognizerDirection)direct
{
    NSArray *pointArr = personView.pointArr;
    
    if (direct == UISwipeGestureRecognizerDirectionUp) {
        NSInteger minX = 4;
        for (PointModel *point in pointArr) {
            if (point.x < minX) {
                minX = point.x;
            }
        }
        if (minX == 0) {
            return false;
        }
        for (PointModel *point in pointArr) {
            if (point.x == minX) {
                if ([self.arrayBoard[point.x-1][point.y] boolValue]) {
                    return false;
                }
            }
        }
    } else if (direct == UISwipeGestureRecognizerDirectionDown) {
        NSInteger maxX = 0;
        for (PointModel *point in pointArr) {
            if (point.x > maxX) {
                maxX = point.x;
            }
        }
        if (maxX == 4) {
            return false;
        }
        for (PointModel *point in pointArr) {
            if (point.x == maxX) {
                if ([self.arrayBoard[point.x+1][point.y] boolValue]) {
                    return false;
                }
            }
        }
    } else if (direct == UISwipeGestureRecognizerDirectionLeft) {
        NSInteger minY = 3;
        for (PointModel *point in pointArr) {
            if (point.y < minY) {
                minY = point.y;
            }
        }
        if (minY == 0) {
            return false;
        }
        for (PointModel *point in pointArr) {
            if (point.y == minY) {
                if ([self.arrayBoard[point.x][point.y-1] boolValue]) {
                    return false;
                }
            }
        }
    } else if (direct == UISwipeGestureRecognizerDirectionRight) {
        NSInteger maxY = 0;
        for (PointModel *point in pointArr) {
            if (point.y > maxY) {
                maxY = point.y;
            }
        }
        if (maxY == 3) {
            return false;
        }
        for (PointModel *point in pointArr) {
            if (point.y == maxY) {
                if ([self.arrayBoard[point.x][point.y+1] boolValue]) {
                    return false;
                }
            }
        }
    }
    
    NSMutableArray *freshPoint = [[NSMutableArray alloc] init];
    for (PointModel *point in pointArr) {
        NSMutableArray *rawArr = self.arrayBoard[point.x];
        rawArr[point.y] = @0;
        if (direct == UISwipeGestureRecognizerDirectionUp) {
            point.x -= 1;
        } else if (direct == UISwipeGestureRecognizerDirectionDown) {
            point.x += 1;
        } else if (direct == UISwipeGestureRecognizerDirectionLeft) {
            point.y -= 1;
        } else if (direct == UISwipeGestureRecognizerDirectionRight) {
            point.y += 1;
        }
        [freshPoint addObject:point];
    }
    for (PointModel *point in freshPoint) {
        NSMutableArray *rawArr = self.arrayBoard[point.x];
        rawArr[point.y] = @1;
    }
    
    return true;
}

@end
