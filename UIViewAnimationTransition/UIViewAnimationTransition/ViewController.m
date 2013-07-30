//
//  ViewController.m
//  UIViewAnimationTransition
//
//  Created by Dolice on 2013/07/30.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

static const NSInteger kTagViewForTransitionTest = 1;

#pragma mark ----- Private Methods Definition -----

@interface ViewController ()

- (UIView*)nextView;
- (void)animationDidStop;

@end

#pragma mark ----- Start Implementation For Methods -----

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self nextView]];
}

#pragma mark ----- Responder -----

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if ( ![UIView areAnimationsEnabled] ) {
        [self.nextResponder touchesEnded:touches withEvent:event];
        return;
    }
    static UIViewAnimationTransition transition = UIViewAnimationTransitionFlipFromLeft;
    
    UIView* nextView = [self nextView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [[self.view viewWithTag:kTagViewForTransitionTest] removeFromSuperview];
    [self.view addSubview:nextView];
    [UIView commitAnimations];
    [UIView setAnimationsEnabled:NO];
    
    if ( UIViewAnimationTransitionCurlDown < ++transition ) {
        transition = UIViewAnimationTransitionFlipFromLeft;
    }
}

#pragma mark ----- Private Methods -----

- (UIView*)nextView {
    static BOOL isFront = YES;
    UIImage* image;
    if ( isFront ) {
        image = [UIImage imageNamed:@"Hesychasm_640_1136.jpg"]; //< 表用の画像
    } else {
        image = [UIImage imageNamed:@"Echidna_640_1136.jpg"]; //< 裏用の画像
    }
    isFront = ( YES != isFront );
    UIView* view = [[UIImageView alloc] initWithImage:image];
    view.tag = kTagViewForTransitionTest;
    view.frame = self.view.bounds;
    view.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.contentMode = UIViewContentModeScaleAspectFill;
    return view;
}

- (void)animationDidStop {
    [UIView setAnimationsEnabled:YES];
}

@end
