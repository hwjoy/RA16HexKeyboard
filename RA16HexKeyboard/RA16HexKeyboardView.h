//
//  RA16HexKeyboardView.h
//  RA16HexKeyboard
//
//  Created by hongy on 27/03/2018.
//  Copyright © 2018 hongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RAKeyboardDelegate <NSObject>

@required

- (void)insertText:(NSString *_Nonnull)text;
- (void)deleteBackward;

@end

@interface RA16HexKeyboardView : UIView

@property (nonatomic, weak, nullable) id <RAKeyboardDelegate> delegate;

@end
