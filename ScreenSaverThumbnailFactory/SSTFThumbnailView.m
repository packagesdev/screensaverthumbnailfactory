/*
 Copyright (c) 2015, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SSTFThumbnailView.h"

@interface SSTFThumbnailView ()
{
	NSImage * _thumbnail;
}

@end

@implementation SSTFThumbnailView

- (void)setThumbnail:(NSImage *)inImage
{
	_thumbnail=inImage;
	
	[self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSRect tBounds=[self bounds];
	
	tBounds=NSInsetRect(tBounds,3,3);
	
	tBounds.origin.x-=0.5;
	tBounds.size.width+=1;
	tBounds.origin.y+=0.5;
	tBounds.size.height-=0;
	
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath * tBezierPath=[NSBezierPath bezierPathWithRoundedRect:tBounds xRadius:2.5 yRadius:2.5];
	
	NSShadow * tShadow=[NSShadow new];
	
	tShadow.shadowOffset=CGSizeMake(0,-1);
	tShadow.shadowBlurRadius=0.5;
	tShadow.shadowColor=[NSColor grayColor];
	
	[tShadow set];
	
	[[NSColor blackColor] setFill];
	
	[tBezierPath fill];
	
	[tBezierPath addClip];
	
	[_thumbnail drawInRect:tBounds fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	[NSGraphicsContext restoreGraphicsState];
	
	[[NSColor blackColor] setStroke];
	
	[tBezierPath stroke];
}


@end
