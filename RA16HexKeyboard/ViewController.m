//
//  ViewController.m
//  RA16HexKeyboard
//
//  Created by hongy on 27/03/2018.
//  Copyright © 2018 hongyu. All rights reserved.
//

#import "ViewController.h"
#import "RA16HexKeyboardView.h"

@interface ViewController () <RAKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic) CGRect contentViewFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.contentViewFrame = self.view.frame;
    [self addObserveTapGesture];
    [self initKeyboard];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.contentViewFrame, self.view.frame)) {
        self.contentViewFrame = self.view.frame;
        
        [self hideKeyboard];
        [self initKeyboard];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.inputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initKeyboard {
//    self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    NSLog(@"initKeyboard: %@", NSStringFromCGRect(self.view.frame));
    RA16HexKeyboardView *inputView = [[RA16HexKeyboardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    inputView.delegate = self;
    self.inputTextField.inputView = inputView;
}

#pragma mark - RAKeyboardDelegate

- (void)insertText:(NSString *)text {
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:text];
}

- (void)deleteBackward {
    NSString *text = self.inputTextField.text;
    if (text.length == 0) {
        return;
    }
    self.inputTextField.text = [text substringToIndex:text.length - 1];
}

#pragma mark - hide keyboard

- (void)addObserveTapGesture {
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
