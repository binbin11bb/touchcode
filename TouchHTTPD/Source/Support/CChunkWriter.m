//
//  CChunkWriter.m
//  FileServer
//
//  Created by Jonathan Wight on 12/30/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//

#import "CChunkWriter.h"

@interface CChunkWriter ()
@property (readwrite, assign) BOOL moreChunksComing;
@property (readwrite, assign) NSInteger remainingChunkLength;
@property (readwrite, retain) NSMutableData *buffer;
@end

@implementation CChunkWriter

@synthesize outputFile;
@synthesize moreChunksComing;
@synthesize remainingChunkLength;
@synthesize buffer;
@synthesize delegate;

#if 0
+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];

NSString *theBodyString = @"27\r\nThis is the data in the first chunk... \r\n1C\r\nand this is the second one.\r\r\n0\r\n";
NSData *theBody = [theBodyString dataUsingEncoding:NSASCIIStringEncoding];

CChunkWriter *theWriter = [[[CChunkWriter alloc] init] autorelease];

theWriter.outputFile = [NSFileHandle fileHandleWithStandardOutput];

[theWriter writeData:theBody];

[thePool release];
}
#endif

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.moreChunksComing = YES;
	self.remainingChunkLength = 0;
	}
return(self);
}

- (void)dealloc
{
self.outputFile = NULL;
self.buffer = NULL;
//
[super dealloc];
}

- (void)writeData:(NSData *)inData;
{
NSInteger theChunkLength = self.remainingChunkLength;
if (theChunkLength == -1)
	{
	// JIWTODO error!
	LOG_(@"CHUNKING ERROR #0");
	}

const char *START = inData.bytes, *END = START + inData.length, *P = START;

while (START < END)
	{
	if (self.remainingChunkLength == 0)
		{
		for (; P != END && *P != '\r'; ++P)
			{
			if (ishexnumber(*P) == NO)
				{
				// JIWTODO error!
				LOG_(@"CHUNKING ERROR #1");
				}		
			}
		theChunkLength = strtol(START, NULL, 16);
		}

	if (*P++ != '\r')
		{
		// JIWTODO error!
		LOG_(@"CHUNKING ERROR #2");
		}		
		
	if (*P++ != '\n')
		{
		// JIWTODO error!
		LOG_(@"CHUNKING ERROR #2.5");
		}		

	if (theChunkLength == 0)
		{
		// We are done!
		self.remainingChunkLength = -1;
		[self.delegate chunkWriterDidReachEOF:self];
		LOG_(@"CHUNK WRITER ENDED");
		return;
		}

	NSInteger theAvailableLength = MIN(END - P, theChunkLength);
	if (theAvailableLength > 0)
		{
		NSData *theChunk = [[NSData alloc] initWithBytesNoCopy:(void *)P length:theAvailableLength freeWhenDone:NO];
		[self.outputFile writeData:theChunk];
		[theChunk release];
		}
	self.remainingChunkLength = theChunkLength - theAvailableLength;
	
	P += theAvailableLength;
	
	if (*P++ != '\r')
		{
		// JIWTODO error!
		LOG_(@"CHUNKING ERROR #10");
		}		
		
	if (*P++ != '\n')
		{
		// JIWTODO error!
		LOG_(@"CHUNKING ERROR #10.5");
		}		
		
	START = P;

	}
	
}

@end