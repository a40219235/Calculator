//
//  GraphViewConroller.m
//  Calculator
//
//  Created by Shane Fu on 9/23/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "GraphViewConroller.h"
#import "GraphicView.h"

@interface GraphViewConroller ()



@end

@implementation GraphViewConroller
@synthesize graphicView = _graphicView;

#pragma mark - setter and getter
-(void)setGraphicView:(GraphicView *)graphicView
{
	_graphicView = graphicView;
	UIGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphicView action:@selector(pinch:)];
	UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphicView	action:@selector(pan:)];
	[self.graphicView addGestureRecognizer:pinch];
	[self.graphicView addGestureRecognizer:pan];
}
#pragma mark - gesture handler
//panning gesture should handle here because view dose not know about the origin


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
}

//bounds only correct after it appears
-(void)viewDidAppear:(BOOL)animated
{
	self.graphicView.originPosion = CGPointMake(self.graphicView.bounds.origin.x + self.graphicView.bounds.size.width/2, self.graphicView.bounds.origin.y + self.graphicView.bounds.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
