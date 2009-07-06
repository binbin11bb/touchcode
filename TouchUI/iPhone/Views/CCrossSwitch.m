//
//  CCrossSwitch.m
//  TouchCode
//
//  Created by Jonathan Wight on 04/25/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CCrossSwitch.h"

#import <QuartzCore/QuartzCore.h>

#import "Geometry.h"

@interface CCrossSwitch()
@property(readwrite,nonatomic, retain) CALayer *imageLayer;
@end

@implementation CCrossSwitch

@dynamic on;
@synthesize imageLayer;

- (id)initWithCoder:(NSCoder *)inCoder
{
if ((self = [super initWithCoder:inCoder]) != nil)
	{
	self.userInteractionEnabled = YES;
	
	self.imageLayer = [[[CALayer alloc] initWithFrame:self.bounds] autorelease];
	self.imageLayer.contents = (id)[UIImage imageNamed:@"CrossSwitchButton.png"].CGImage;
	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}
	
	[self.layer addSublayer:self.imageLayer];
	}
return(self);
}

- (void)dealloc
{
self.imageLayer = NULL;
//
[super dealloc];
}

- (BOOL)isOn
{
return(on);
}

- (void)setOn:(BOOL)inOn
{
[self setOn:inOn animated:YES];
}

- (void)setOn:(BOOL)inOn animated:(BOOL)inAnimated; // does not send action
{
if (on != inOn)
	{
	on = inOn;

	if (on == YES)
		{
		CATransform3D theTransform = CATransform3DIdentity;
		theTransform = CATransform3DRotate(theTransform, DegreesToRadians(45), 0.0, 0.0, 1.0);
		self.imageLayer.transform = theTransform;
		}
	else
		{
		self.imageLayer.transform = CATransform3DIdentity;
		}
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)touchesBegan:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
self.on = !self.on;
}

- (void)touchesMoved:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
}

- (void)touchesEnded:(NSSet *)inTouches withEvent:(UIEvent *)inEvent
{
}

@end
