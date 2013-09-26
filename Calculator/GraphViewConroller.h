//
//  GraphViewConroller.h
//  Calculator
//
//  Created by Shane Fu on 9/23/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicView.h"
#import "SplitViewBarButtonItemPresenter.h"

@class GraphViewConroller;

@protocol GraphicViewControllerDataSource
-(NSString *)functionDisplay:(GraphViewConroller *)sender;

@end

@interface GraphViewConroller : UIViewController<SplitViewBarButtonItemPresenter, GraphicViewDataSource>
@property (strong, nonatomic) IBOutlet GraphicView *graphicView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property(nonatomic, weak) id<GraphicViewControllerDataSource> delegate;
@end
