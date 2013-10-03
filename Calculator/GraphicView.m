//
//  GraphicView.m
//  Calculator
//
//  Created by Shane Fu on 9/23/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "GraphicView.h"
#import "AxesDrawer.h"

#define DEFAULT_GRAPH_SIZE 10

@implementation GraphicView
@synthesize graphScale = _graphScale;
@synthesize originPosion = _originPosion;
@synthesize dataSource = _dataSource;

#pragma mark - init
-(void)setup{
	[self setNeedsDisplay];
}

-(void)awakeFromNib{
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup]; 
	}
    return self;
}



#pragma mark - setter and getter
-(void)setOriginPosion:(CGPoint)originPosion
{
	if (!CGPointEqualToPoint(originPosion, _originPosion)) {
		_originPosion = originPosion;
		[self setNeedsDisplay];
	}
}

-(void)setGraphScale:(CGFloat)graphScale
{
	if (graphScale != _graphScale) {
		_graphScale = graphScale;
		[self setNeedsDisplay];
	}
}

-(CGFloat)graphScale
{
	if (!_graphScale) {
		_graphScale = DEFAULT_GRAPH_SIZE;
	}
	return _graphScale;
}

#pragma mark - gesture handler

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
		self.graphScale *= gesture.scale;
		gesture.scale = 1; //??
	}
}

-(void)pan:(UIPanGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded)  {
		self.originPosion = CGPointMake(self.originPosion.x + [gesture translationInView:self].x, self.originPosion.y + [gesture translationInView:self].y);
		if (self.originPosion.x < 0) self.originPosion = CGPointMake(0, self.originPosion.y);
		if (self.originPosion.x > self.bounds.size.width) self.originPosion = CGPointMake(self.bounds.size.width, self.originPosion.y);
		if (self.originPosion.y < 0) self.originPosion = CGPointMake(self.originPosion.x, 0);
		if (self.originPosion.y > self.bounds.size.height) self.originPosion = CGPointMake(self.originPosion.x, self.bounds.size.height);
		[gesture setTranslation:CGPointZero inView:self];
	}
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{    
	[AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.originPosion scale:self.graphScale];
	
	if (self.graphScale == 0) {
		return;
	}
	
	//copy this code and constant from axesDrawer
#define HASH_MARK_SIZE 3
#define MIN_PIXELS_PER_HASHMARK 25
	int unitsPerHashmark = MIN_PIXELS_PER_HASHMARK * 2 / self.graphScale;
	if (!unitsPerHashmark) unitsPerHashmark = 1;
	CGFloat pixelsPerHashmark = self.graphScale * unitsPerHashmark;
	CGFloat valuePerPixel = unitsPerHashmark/ pixelsPerHashmark;
	if ([self.dataSource respondsToSelector:@selector(getYValueAtX:sender:)]) {
		for (int i = 0;  i < self.bounds.size.width - self.originPosion.x; i ++) {
			
			CGFloat realXValue = valuePerPixel * i;
			CGPoint startPoint = CGPointMake(i, [self.dataSource getYValueAtX:realXValue sender:self]/valuePerPixel);
			CGPoint convertedStartPoint = CGPointMake(self.originPosion.x + startPoint.x, self.originPosion.y - startPoint.y);

			CGFloat notsure2 = valuePerPixel * (i +1);
			CGPoint endPoint = CGPointMake(i + 1, [self.dataSource getYValueAtX:notsure2 sender:self]/valuePerPixel);
			CGPoint convertedEndPoint = CGPointMake(self.originPosion.x + endPoint.x, self.originPosion.y - endPoint.y);
			[self drawLineFromPoint:convertedStartPoint toPoint:convertedEndPoint];
			
		}
		
		for (int i = 0;  i > -self.originPosion.x; i--) {
			
			CGFloat realXValue = valuePerPixel * i;
			CGPoint startPoint = CGPointMake(i, [self.dataSource getYValueAtX:realXValue sender:self]/valuePerPixel);
			CGPoint convertedStartPoint = CGPointMake(self.originPosion.x + startPoint.x, self.originPosion.y - startPoint.y);
			
			CGFloat notsure2 = valuePerPixel * (i +1);
			CGPoint endPoint = CGPointMake(i + 1, [self.dataSource getYValueAtX:notsure2 sender:self]/valuePerPixel);
			CGPoint convertedEndPoint = CGPointMake(self.originPosion.x + endPoint.x, self.originPosion.y - endPoint.y);
			[self drawLineFromPoint:convertedStartPoint toPoint:convertedEndPoint];
			
		}
		if ([self.dataSource respondsToSelector:@selector(didFinishDrawing)]) [self.dataSource didFinishDrawing];
	}
}

-(void)drawLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint{
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, startPoint.x, startPoint.y);
 	CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
	
	CGContextStrokePath(context);
	
	UIGraphicsPopContext();
}


@end
