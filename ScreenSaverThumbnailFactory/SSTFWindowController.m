/*
 Copyright (c) 2015, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SSTFWindowController.h"

#import <ScreenSaver/ScreenSaver.h>

#import "SSTFThumbnailView.h"
#import "SSTFThumbnail2xView.h"


@interface SSTFWindowController () <NSTableViewDataSource,NSTableViewDelegate>
{
	IBOutlet NSTableView * _screensaversTableView;
	
	IBOutlet NSView * _screenSaverContentView;
	
	IBOutlet SSTFThumbnail2xView * _thumbnail2xView;
	IBOutlet SSTFThumbnailView * _thumbnailView;
	
	
	
	NSArray * _screensaverBundlesArray;
	
	ScreenSaverView * _screensaverView;
	
	NSTimer * _animationTimer;
	
	BOOL _paused;
}

- (void)showScreenSaverForBundle:(NSBundle *)inBundle;

- (void)animateScreenSaver:(NSTimer *)inTimer;

- (IBAction)pause:(id)sender;
- (IBAction)restart:(id)sender;

- (IBAction)export:(id)sender;

@end

@implementation SSTFWindowController

/* This is not super clean but because of OpenGL, it's needed */

+ (NSImage*) screenCacheImageForView:(NSView*)aView
{
	NSRect originRect = [aView convertRect:[aView bounds] toView:[[aView window] contentView]];
	
	NSRect rect = originRect;
	rect.origin.y = 0;
	rect.origin.x += [aView window].frame.origin.x;
	rect.origin.y += [[aView window] screen].frame.size.height - [aView window].frame.origin.y - [aView window].frame.size.height;
	rect.origin.y += [aView window].frame.size.height - originRect.origin.y - originRect.size.height;
	
	CGImageRef cgimg = CGWindowListCreateImage(rect,
											   kCGWindowListOptionIncludingWindow,
											   (CGWindowID)[[aView window] windowNumber],
											   kCGWindowImageDefault);
	return [[NSImage alloc] initWithCGImage:cgimg size:[aView bounds].size];
}

- (NSString *) windowNibName
{
	return @"SSTFWindowController";
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	// A COMPLETER
}

#pragma mark - Tableview data source

// A COMPLETER

#pragma mark - Tableview delegate

// A COMPLETER

#pragma mark -

- (void)animateScreenSaver:(NSTimer *)inTimer
{
	if (_paused==NO)
	{
		[_screensaverView animateOneFrame];
	
		NSImage * cacheImage = [SSTFWindowController screenCacheImageForView:_screenSaverContentView];
	
		[_thumbnail2xView setThumbnail:cacheImage];
		[_thumbnailView setThumbnail:cacheImage];
	}
}

- (void)showScreenSaverForBundle:(NSBundle *)inBundle
{
	_paused=YES;
	
	[_animationTimer invalidate];
	_animationTimer=nil;
	
	[_screensaverView removeFromSuperview];
	_screensaverView=nil;
	
	if (inBundle!=nil)
	{
		Class tScreenSaverClass=[inBundle principalClass];
		
		NSRect tFrame=[_screenSaverContentView bounds];
		
		_screensaverView=[[tScreenSaverClass alloc] initWithFrame:tFrame isPreview:NO];
		
		[_screensaverView setFrame:tFrame];
		
		[_screenSaverContentView addSubview:_screensaverView];
		
		[_screensaverView startAnimation];
		
		_paused=NO;
		
		_animationTimer=[NSTimer scheduledTimerWithTimeInterval:[_screensaverView animationTimeInterval]
														 target:self
													   selector:@selector(animateScreenSaver:)
													   userInfo:nil
														repeats:YES];
	}
}

#pragma mark -

- (IBAction)pause:(id)sender
{
	_paused=!_paused;
}

- (IBAction)restart:(id)sender
{
	// A COMPLETER
}

- (IBAction)export:(id)sender
{
	NSSavePanel * tSavePanel=[NSSavePanel savePanel];
	
	tSavePanel.nameFieldStringValue=@"untitled";
	
	[tSavePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger bResult){
	
		if (bResult==NSFileHandlingPanelOKButton)
		{
			[[NSFileManager defaultManager] createDirectoryAtURL:tSavePanel.URL
									 withIntermediateDirectories:NO
													  attributes:nil
														   error:NULL];
			
			NSURL * tThumbnail1xURL=[[tSavePanel.URL URLByAppendingPathComponent:@"thumbnail" isDirectory:NO] URLByAppendingPathExtension:@"png"];
			
			NSBitmapImageRep * tThumbnailImageRep=[_thumbnailView bitmapImageRepForCachingDisplayInRect:[_thumbnailView bounds]];
			
			[_thumbnailView cacheDisplayInRect:[_thumbnailView bounds] toBitmapImageRep:tThumbnailImageRep];
			
			[[tThumbnailImageRep representationUsingType:NSPNGFileType properties:nil] writeToURL:tThumbnail1xURL atomically:YES];
			
			NSURL * tThumbnail2xURL=[[tSavePanel.URL URLByAppendingPathComponent:@"thumbnail@2x" isDirectory:NO] URLByAppendingPathExtension:@"png"];
			
			NSBitmapImageRep * tThumbnail2xImageRep=[_thumbnail2xView bitmapImageRepForCachingDisplayInRect:[_thumbnail2xView bounds]];
			
			[_thumbnail2xView cacheDisplayInRect:[_thumbnail2xView bounds] toBitmapImageRep:tThumbnail2xImageRep];
			
			[[tThumbnail2xImageRep representationUsingType:NSPNGFileType properties:nil] writeToURL:tThumbnail2xURL atomically:YES];
		}
	}];
}

@end
