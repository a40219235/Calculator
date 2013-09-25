//
//  GraphicView.h
//  Calculator
//
//  Created by Shane Fu on 9/23/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphicView;
@protocol GraphicViewDataSource<NSObject>

-(CGFloat)getYValueAtX:(CGFloat)x sender:(GraphicView *)sender;
@optional
-(void)didFinishDrawing;
@end

@interface GraphicView : UIView

@property (nonatomic) CGFloat graphScale;
@property (nonatomic) CGPoint originPosion;

@property (nonatomic, weak) id <GraphicViewDataSource> dataSource;

-(void)pinch:(UIPinchGestureRecognizer *)gesture;
-(void)pan:(UIPanGestureRecognizer *)gesture;

@end
