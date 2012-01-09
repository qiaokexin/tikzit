//
//  NodeStyle.m
//  TikZiT
//  
//  Copyright 2010 Aleks Kissinger. All rights reserved.
//  
//  
//  This file is part of TikZiT.
//  
//  TikZiT is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  TikZiT is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with TikZiT.  If not, see <http://www.gnu.org/licenses/>.
//  

#import "NodeStyle.h"
#import "ShapeNames.h"

@implementation NodeStyle


- (id)init {
	self = [super initWithNotificationName:@"NodeStylePropertyChanged"];
	if (self != nil) {
		strokeThickness = 1;
		scale = 1.0f;
		strokeColorRGB = [[ColorRGB alloc] initWithRed:0 green:0 blue:0];
		fillColorRGB = [[ColorRGB alloc] initWithRed:255 green:255 blue:255];
		
		name = @"new";
		category = nil;
		shapeName = SHAPE_CIRCLE;
	}
	return self;
}

- (id)initWithName:(NSString*)nm {
	self = [self init];
	if (self != nil) {
		[self setName:nm];
	}
	return self;
}

+ (NodeStyle*)defaultNodeStyleWithName:(NSString*)nm {
	return [[[NodeStyle alloc] initWithName:nm] autorelease];
}

- (NSString*)name {
	return name;
}

- (void)setName:(NSString *)s {
	if (name != s) {
		NSString *oldValue = name;
		name = [s copy];
		[self postPropertyChanged:@"name" oldValue:oldValue];
		[oldValue release];
	}
}

- (NSString*)shapeName {
	return shapeName;
}

- (void)setShapeName:(NSString *)s {
	if (shapeName != s) {
		NSString *oldValue = shapeName;
		shapeName = [s copy];
		[self postPropertyChanged:@"shapeName" oldValue:oldValue];
		[oldValue release];
	}
}

- (NSString*)category {
	return category;
}

- (void)setCategory:(NSString *)s {
	if (category != s) {
		NSString *oldValue = category;
		category = [s copy];
		[self postPropertyChanged:@"category" oldValue:oldValue];
		[oldValue release];
	}
}

- (int)strokeThickness { return strokeThickness; }
- (void)setStrokeThickness:(int)i {
	int oldValue = strokeThickness;
	strokeThickness = i;
	[self postPropertyChanged:@"strokeThickness" oldValue:[NSNumber numberWithInt:oldValue]];
}

- (float)scale { return scale; }
- (void)setScale:(float)s {
	float oldValue = scale;
	scale = s;
	[self postPropertyChanged:@"scale" oldValue:[NSNumber numberWithFloat:oldValue]];
}

- (ColorRGB*)strokeColorRGB {
	return strokeColorRGB;
}

- (void)setStrokeColorRGB:(ColorRGB*)c {
	if (strokeColorRGB != c) {
		ColorRGB *oldValue = strokeColorRGB;
		strokeColorRGB = [c copy];
		[self postPropertyChanged:@"strokeColorRGB" oldValue:oldValue];
		[oldValue release];
	}
}

- (ColorRGB*)fillColorRGB {
	return fillColorRGB;
}

- (void)setFillColorRGB:(ColorRGB*)c {
	if (fillColorRGB != c) {
		ColorRGB *oldValue = fillColorRGB;
		fillColorRGB = [c copy];
		[self postPropertyChanged:@"fillColorRGB" oldValue:oldValue];
		[oldValue release];
	}
}

- (NSString*)tikz {
	NSString *fillName, *strokeName;
	
	NSMutableString *buf = [NSMutableString string];
	
	fillName = [fillColorRGB name];
	strokeName = [strokeColorRGB name];
	
	// If the colors are unknown, fall back on hexnames. These should be defined as colors
	// in the Preambles class.
	if (fillName == nil) fillName = [fillColorRGB hexName];
	if (strokeName == nil) strokeName = [strokeColorRGB hexName];
	
	[buf appendFormat:@"\\tikzstyle{%@}=[%@,fill=%@,draw=%@%@]\n",
		name,
		shapeName,
		fillName,
		strokeName,
		(strokeThickness != 1) ?
			[NSString stringWithFormat:@",line width=%@ pt",
			 [NSNumber numberWithFloat:(float)strokeThickness * 0.4f]] : @""];
	
	return buf;
}

- (BOOL)strokeColorIsKnown {
	return ([strokeColorRGB name] != nil);
}

- (BOOL)fillColorIsKnown {
	return ([fillColorRGB name] != nil);
}

- (void)dealloc {
	[self setName:nil];
	[super dealloc];
}

@end

// vi:ft=objc:ts=4:noet:sts=4:sw=4