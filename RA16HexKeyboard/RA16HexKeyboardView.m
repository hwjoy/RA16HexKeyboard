//
//  RA16HexKeyboardView.m
//  RA16HexKeyboard
//
//  Created by hongy on 27/03/2018.
//  Copyright © 2018 hongyu. All rights reserved.
//

#import "RA16HexKeyboardView.h"

@interface RA16HexKeyboardView ()

@property (nonatomic) NSTimer *deleteTimer;

@end

@implementation RA16HexKeyboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initKeyboard:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initKeyboard:frame];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    [self.deleteTimer invalidate];
    self.deleteTimer = nil;
}

- (void)initKeyboard:(CGRect)frame {
    CGFloat gapMargin = 6;
    CGFloat screenWidth = CGRectGetWidth(frame);
    if (screenWidth == 0) {
        screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    }
    CGFloat buttonWidth = (screenWidth - gapMargin) / 3 - gapMargin;
    CGFloat buttonHeight = 40;
    
    UIView *inputView = self;
    inputView.frame = CGRectMake(0, 0, CGRectGetWidth(inputView.frame), (buttonHeight + gapMargin) * 6 + gapMargin);
    inputView.backgroundColor = [UIColor colorWithRed:209.0/255 green:213.0/255 blue:218.0/255 alpha:1.0];
    
    for (int i = 0; i < 16; i++) {
        CGFloat offsetX = 0;
        CGFloat offsetY = 0;
        if (i == 0) {
            offsetX = gapMargin + (buttonWidth + gapMargin) * 1;
            offsetY = gapMargin + (buttonHeight + gapMargin) * 5;
        } else if (i < 10) {
            offsetX = gapMargin + (buttonWidth + gapMargin) * ((i + 6 - 1) % 3);
            offsetY = gapMargin + (buttonHeight + gapMargin) * ((i + 6 - 1) / 3);
        } else {
            offsetX = gapMargin + (buttonWidth + gapMargin) * ((i - 10) % 3);
            offsetY = gapMargin + (buttonHeight + gapMargin) * ((i - 10) / 3);
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetX, offsetY, buttonWidth, buttonHeight);
        [button setTitle:[NSString stringWithFormat:@"%X", (int)i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(numberButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:button];
        [self updateButtonStyle:button];
    }
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(gapMargin + (buttonWidth + gapMargin) * 2, gapMargin + (buttonHeight + gapMargin) * 5, buttonWidth, buttonHeight);
    [deleteButton setImage:[UIImage imageNamed:@"delete_white"] forState:UIControlStateNormal];
    [deleteButton setImage:[UIImage imageNamed:@"delete_black"] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(deleteButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [deleteButton addTarget:self action:@selector(deleteButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [inputView addSubview:deleteButton];
}

- (void)updateButtonStyle:(UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize:25];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:169.0/255 green:184.0/255 blue:200.0/255 alpha:1.0]] forState:UIControlStateHighlighted];
    button.layer.cornerRadius = 5.f;
    button.layer.masksToBounds = YES;
    
    CALayer *lineLayer1 = [[CALayer alloc] init];
    lineLayer1.frame = CGRectMake(CGRectGetMinX(button.frame) + 5, CGRectGetMaxY(button.frame), CGRectGetWidth(button.frame) - 10, 0.5);
    lineLayer1.backgroundColor = [UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0].CGColor;
    CALayer *lineLayer2 = [[CALayer alloc] init];
    lineLayer2.frame = CGRectMake(CGRectGetMinX(button.frame) + 5, CGRectGetMaxY(button.frame) + 0.5, CGRectGetWidth(button.frame) - 10, 0.5);
    lineLayer2.backgroundColor = [UIColor colorWithRed:132.0/255 green:136.0/255 blue:140.0/255 alpha:1.0].CGColor;
    [button.superview.layer addSublayer:lineLayer1];
    [button.superview.layer addSublayer:lineLayer2];
}

- (void)numberButtonAction:(UIButton *)button {
    [self.delegate insertText:[button titleForState:UIControlStateNormal]];
}

- (void)deleteButtonAction {
    [self.delegate deleteBackward];
}

- (void)deleteButtonTouchDown:(UIButton *)button {
    [self.delegate deleteBackward];
    
    self.deleteTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:0.5] interval:0.1 target:self selector:@selector(deleteButtonAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.deleteTimer forMode:NSRunLoopCommonModes];
}

- (void)deleteButtonTouchUp:(UIButton *)button {
    [self.deleteTimer invalidate];
    self.deleteTimer = nil;
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
