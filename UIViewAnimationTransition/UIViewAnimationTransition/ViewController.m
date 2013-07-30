//
//  ViewController.m
//  UIViewAnimationTransition
//
//  Created by Dolice on 2013/07/30.
//  Copyright (c) 2013年 Dolice. All rights reserved.
//

#import "ViewController.h"

#pragma mark start implementation for methods

@implementation ViewController

typedef enum transitions : NSUInteger {
    viewForTransition = 1
} transitions;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //次のビューをセット
    [self.view addSubview:[self nextView]];
}

#pragma mark responder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //アニメーション実行中であれば処理しない
    if (![UIView areAnimationsEnabled]) {
        [self.nextResponder touchesEnded:touches withEvent:event];
        return;
    }
    static UIViewAnimationTransition transition = ANIMATION_FLIP_FROM_LEFT;
    
    //次のビューをセット
    UIView *nextView = [self nextView];
    
    //アニメーション定義
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    
    //ビューの入れ替え
    [[self.view viewWithTag:viewForTransition] removeFromSuperview];
    [self.view addSubview:nextView];
    
    //アニメーション実行
    [UIView commitAnimations];
    
    //アニメーションを無効にする
    [UIView setAnimationsEnabled:NO];
    
    //次に実行されるアニメーションの種類変更
    if (ANIMATION_CURL_DOWN < ++transition) {
        transition = ANIMATION_FLIP_FROM_LEFT;
    }
}

#pragma mark private methods

- (UIView *)nextView
{
    //表か裏の画像を指定
    static BOOL isFront = YES;
    UIImage *image = [UIImage imageNamed:isFront ? FRONT_IMAGE : BACK_IMAGE];
    isFront = !isFront;
    
    //ビューに画像をセット
    UIView *view = [[UIImageView alloc] initWithImage:image];
    view.tag = viewForTransition;
    view.frame = self.view.bounds;
    view.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.contentMode = UIViewContentModeScaleAspectFill;
    return view;
}

- (void)animationDidStop:(id)selector
{
    //アニメーションを有効にする
    [UIView setAnimationsEnabled:YES];
}

@end
