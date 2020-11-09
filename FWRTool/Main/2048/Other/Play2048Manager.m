//
//  Play2048Manager.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/28.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "Play2048Manager.h"
#import "BlockModel.h"
#import "BlockView.h"

@interface Play2048Manager ()

@property (nonatomic, strong) NSMutableArray *arrayBoard;
@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger historyScore;

@end

@implementation Play2048Manager

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray <BlockView *>*)createBaseData
{
    if (self.arrayBoard) {
        for (NSMutableArray *rawArray in self.arrayBoard) {
            for (id obj in rawArray) {
                if ([obj isKindOfClass:[BlockView class]]) {
                    BlockView *blockView = (BlockView *)obj;
                    [blockView removeFromSuperview];
                }
            }
        }
    }
    
    self.num = 0;
    self.score = 0;
    self.historyScore = 0;
    
    self.arrayBoard = [[NSMutableArray alloc] initWithCapacity:4];
    for (NSInteger x = 0; x < 4; x++) {
        NSMutableArray *rawArr = [[NSMutableArray alloc] init];
        for (NSInteger y = 0; y < 4; y++) {
            [rawArr addObject:@0];
        }
        [self.arrayBoard addObject:rawArr];
    }
    
    NSString* filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        self.historyScore = [dict[@"historyScore"] unsignedIntegerValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshHistoryScore:)]) {
            [self.delegate refreshHistoryScore:self.historyScore];
        }
        if (dict[@"score"] && dict[@"array"]) {
            self.score = [dict[@"score"] unsignedIntegerValue];
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshScore:)]) {
                [self.delegate refreshScore:self.score];
            }
            NSArray* arr = dict[@"array"];
            NSMutableArray <BlockView *>*blockArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in arr) {
                BlockView *blockView = [self createBlock:dict];
                [blockArr addObject:blockView];
            }
            return blockArr;
        }

    }
    
    BlockView *blockView1 = [self createBlock];
    BlockView *blockView2 = [self createBlock];
    
    return @[blockView1,blockView2];
}

- (BlockView *)createBlock
{
    BlockView *blockView = [[BlockView alloc] init];
    
    int i = arc4random()%(16-self.num);
    int scoreRate = arc4random()%10;
    
    NSInteger score = 0;
    if (scoreRate < 1) {
        score = 4;
    } else {
        score = 2;
    }
    
    self.num++;
    int j = 0;
    for (NSInteger x = 0; x < 4; x++) {
        for (NSInteger y = 0; y < 4; y++) {
            if ([self.arrayBoard[x][y] isKindOfClass:[NSNumber class]]) {
                if (i == j) {
                    blockView.block.x = x;
                    blockView.block.y = y;
                    blockView.block.score = score;
                    
                    self.arrayBoard[x][y] = blockView;
                    return blockView;
                }
                j++;
            }
        }
    }
    
    
    return blockView;
}
- (BlockView *)createBlock:(NSDictionary *)dict
{
    BlockView *blockView = [[BlockView alloc] init];
    [blockView.block setBlockWithDict:dict];
    
    self.num++;
    self.arrayBoard[blockView.block.x][blockView.block.y] = blockView;
    
    return blockView;
}

- (void)saveCurrentData
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (NSInteger x = 0; x < 4; x++) {
        for (NSInteger y = 0; y < 4; y++) {
            if ([self.arrayBoard[x][y] isKindOfClass:[BlockView class]]) {
                BlockView *blockView = (BlockView *)self.arrayBoard[x][y];
                NSDictionary *data = [blockView.block getDict];
                [dataArr addObject:data];
            }
        }
    }
    
    NSDictionary *dict = @{@"score":[NSNumber numberWithUnsignedInteger:self.score],@"array":dataArr,@"historyScore":[NSNumber numberWithUnsignedInteger:self.historyScore]};
    BOOL success = [dict writeToFile:[self dataFilePath] atomically:true];
    NSLog(@"%d",success);
}
- (void)clearCurrentData
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[self dataFilePath]]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[self dataFilePath]];
        NSDictionary *clearDict = @{@"historyScore":dict[@"historyScore"]};
        [clearDict writeToFile:[self dataFilePath] atomically:true];
    }
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    return [documentDirectory stringByAppendingPathComponent:@"arrData.plist"];
}

- (void)swipWithSwipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeG
{
    if (self.arrayBoard) {
        
        BOOL add = false;
        if (swipeG.direction == UISwipeGestureRecognizerDirectionUp) {
            
            for (NSInteger y = 0; y < 4; y++) {
                BlockView *blockView = nil;
                for (NSInteger x = 0; x < 4; x++) {
                    if ([self.arrayBoard[x][y] isKindOfClass:[BlockView class]]) {
                        BlockView *blockView2 = (BlockView *)self.arrayBoard[x][y];
                        if (blockView2) {
                            if (blockView) {
                                if ((blockView.block.score == blockView2.block.score) && !blockView.isMerged) {
                                    [blockView2 moveX:blockView.block.x isMergedTo:blockView];
                                    self.arrayBoard[x][y] = @0;
                                    self.score += blockView.block.score;
                                    
                                    blockView2 = nil;
                                    self.num--;
                                    add = true;
                                } else {
                                    if (blockView2.block.x != blockView.block.x+1) {
                                        [blockView2 moveX:blockView.block.x+1 isMergedTo:nil];
                                        self.arrayBoard[x][y] = @0;
                                        self.arrayBoard[blockView.block.x+1][y] = blockView2;
                                        add = true;
                                    }
                                }
                            } else {
                                if (blockView2.block.x != 0) {
                                    [blockView2 moveX:0 isMergedTo:nil];
                                    self.arrayBoard[x][y] = @0;
                                    self.arrayBoard[0][y] = blockView2;
                                    add = true;
                                }
                            }
                            if (blockView) {
                                blockView.isMerged = false;
                            }
                            if (blockView2) {
                                blockView = blockView2;
                            }
                        } else {
                            continue;
                        }
                    }
                }
                if (blockView) {
                    blockView.isMerged = false;
                }
            }
            
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionDown) {
            
            for (NSInteger y = 0; y < 4; y++) {
                BlockView *blockView = nil;
                for (NSInteger x = 3; x >= 0; x--) {
                    if ([self.arrayBoard[x][y] isKindOfClass:[BlockView class]]) {
                        BlockView *blockView2 = (BlockView *)self.arrayBoard[x][y];
                        if (blockView2) {
                            if (blockView) {
                                if ((blockView.block.score == blockView2.block.score) && !blockView.isMerged) {
                                    [blockView2 moveX:blockView.block.x isMergedTo:blockView];
                                    self.arrayBoard[x][y] = @0;
                                    self.score += blockView.block.score;
                                    
                                    blockView2 = nil;
                                    self.num--;
                                    add = true;
                                } else {
                                    if (blockView2.block.x != blockView.block.x-1) {
                                        [blockView2 moveX:blockView.block.x-1 isMergedTo:nil];
                                        self.arrayBoard[x][y] = @0;
                                        self.arrayBoard[blockView.block.x-1][y] = blockView2;
                                        add = true;
                                    }
                                }
                            } else {
                                if (blockView2.block.x != 3) {
                                    [blockView2 moveX:3 isMergedTo:nil];
                                    self.arrayBoard[x][y] = @0;
                                    self.arrayBoard[3][y] = blockView2;
                                    add = true;
                                }
                            }
                            if (blockView) {
                                blockView.isMerged = false;
                            }
                            if (blockView2) {
                                blockView = blockView2;
                            }
                        } else {
                            continue;
                        }
                    }
                }
                if (blockView) {
                    blockView.isMerged = false;
                }
            }
            
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionLeft) {
            
            for (NSInteger x = 0; x < 4; x++) {
                BlockView *blockView = nil;
                for (NSInteger y = 0; y < 4; y++) {
                    if ([self.arrayBoard[x][y] isKindOfClass:[BlockView class]]) {
                        BlockView *blockView2 = (BlockView *)self.arrayBoard[x][y];
                        if (blockView2) {
                            if (blockView) {
                                if ((blockView.block.score == blockView2.block.score) && !blockView.isMerged) {
                                    [blockView2 moveY:blockView.block.y isMergedTo:blockView];
                                    self.arrayBoard[x][y] = @0;
                                    self.score += blockView.block.score;
                                    
                                    blockView2 = nil;
                                    self.num--;
                                    add = true;
                                } else {
                                    if (blockView2.block.y != blockView.block.y+1) {
                                        [blockView2 moveY:blockView.block.y+1 isMergedTo:nil];
                                        self.arrayBoard[x][y] = @0;
                                        self.arrayBoard[x][blockView.block.y+1] = blockView2;
                                        add = true;
                                    }
                                }
                            } else {
                                if (blockView2.block.y != 0) {
                                    [blockView2 moveY:0 isMergedTo:nil];
                                    self.arrayBoard[x][y] = @0;
                                    self.arrayBoard[x][0] = blockView2;
                                    add = true;
                                }
                            }
                            if (blockView) {
                                blockView.isMerged = false;
                            }
                            if (blockView2) {
                                blockView = blockView2;
                            }
                        } else {
                            continue;
                        }
                    }
                }
                if (blockView) {
                    blockView.isMerged = false;
                }
            }
            
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionRight) {
            
            for (NSInteger x = 0; x < 4; x++) {
                BlockView *blockView = nil;
                for (NSInteger y = 3; y >= 0; y--) {
                    if ([self.arrayBoard[x][y] isKindOfClass:[BlockView class]]) {
                        BlockView *blockView2 = (BlockView *)self.arrayBoard[x][y];
                        if (blockView2) {
                            if (blockView) {
                                if ((blockView.block.score == blockView2.block.score) && !blockView.isMerged) {
                                    [blockView2 moveY:blockView.block.y isMergedTo:blockView];
                                    self.arrayBoard[x][y] = @0;
                                    self.score += blockView.block.score;
                                    
                                    blockView2 = nil;
                                    self.num--;
                                    add = true;
                                } else {
                                    if (blockView2.block.y != blockView.block.y-1) {
                                        [blockView2 moveY:blockView.block.y-1 isMergedTo:nil];
                                        self.arrayBoard[x][y] = @0;
                                        self.arrayBoard[x][blockView.block.y-1] = blockView2;
                                        add = true;
                                    }
                                }
                            } else {
                                if (blockView2.block.y != 3) {
                                    [blockView2 moveY:3 isMergedTo:nil];
                                    self.arrayBoard[x][y] = @0;
                                    self.arrayBoard[x][3] = blockView2;
                                    add = true;
                                }
                            }
                            if (blockView) {
                                blockView.isMerged = false;
                            }
                            if (blockView2) {
                                blockView = blockView2;
                            }
                        } else {
                            continue;
                        }
                    }
                }
                if (blockView) {
                    blockView.isMerged = false;
                }
            }
            
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshScore:)]) {
            [self.delegate refreshScore:self.score];
        }
        if (self.score > self.historyScore) {
            self.historyScore = self.score;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshHistoryScore:)]) {
            [self.delegate refreshHistoryScore:self.historyScore];
        }
        
        if (add) {
            [NSTimer scheduledTimerWithTimeInterval:0.2f repeats:false block:^(NSTimer * _Nonnull timer) {
                BlockView *blockView = [self createBlock];
                if (self.delegate && [self.delegate respondsToSelector:@selector(addBlockView:)]) {
                    [self.delegate addBlockView:blockView];
                }
                [self saveCurrentData];
            }];
        }
        
    }
}

@end
