//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "ImageDownloader.h"
#import "ZHFileCache.h"


// 1: Declare a private interface, so you can change the attributes of instance variables to read-write.
@interface ImageDownloader () {
    double totalTime;
    
    bool downloadResoult;

}
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) NSDictionary *dict;


@end


@implementation ImageDownloader
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark - Life Cycle

static int down_count = 5;

- (id)initWithPhotoRecord:(NSDictionary *)record  delegate:(id<DownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.dict = record;
        
        downloadResoult = false;
    }
    return self;
}



- (void)finsh:(NSData *)data content:(NSDictionary *)content
{
    
    ZHFileCache *zfc = [[ZHFileCache alloc] init];
    
    [zfc saveFile:data fileName:[content objectForKey:@"name"] ];
}



- (BOOL)downLoad:(NSString *)pathUrlString
{
    

    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: pathUrlString]];
    
    if (self.isCancelled) {

        data = nil;
        return NO;
    }

    if (data) {
        
        [self finsh:data content:self.dict];
        return YES;
        
    }
    else {
        data = nil;
        return NO;
    }

    data = nil;
    
    return NO;
}

#pragma mark -
#pragma mark - Downloading image

- (void)dowloadRecursion:(int)count
{
    
    
    NSString *pathUrlString = [NSString string];
    
    
    if (self.dict) {
        pathUrlString = [self.dict objectForKey:@"url"];
    }
    
    pathUrlString = [pathUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@", pathUrlString);
    bool downloadResult= [self downLoad:pathUrlString];
    
    if ( downloadResult ) {
        
        downloadResoult = true;
        return;
    }
    else {
        downloadResoult = false;

        count--;
        if (count != 0) {
            [self dowloadRecursion:count];
        }
        return;
    }
}

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main {
    
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        if (self.isCancelled)
            return;

        
        [self dowloadRecursion:down_count];
        
        
        if ( ! downloadResoult) {
            
            DLog(@"下载失败文件name:%@, 尝试下载%d次, url:%@", [self.dict objectForKey:@"name"], down_count,[self.dict objectForKey:@"url"]);
        }
        
        
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end


