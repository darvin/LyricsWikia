//
//  LyricsWikiaTests.m
//  LyricsWikiaTests
//
//  Created by Sergey Klimov on 8/12/13.
//  Copyright (c) 2013 Sergey Klimov. All rights reserved.
//

#import "LyricsWikiaTests.h"
#import "LyricsWikia.h"
#import <SenTestingKitAsync/SenTestingKitAsync.h>



@implementation LyricsWikiaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testShortLyricsAsync
{
    STFailAfter(2.0, @"Short lyrics fetching took too long time");
    LyricsWikia *l = [[LyricsWikia alloc] init];
    [l getLyricsForSongNamed:@"Uprising" artist:@"MUSE" full:NO completion:^(NSError *error, NSString *result) {
        
        STAssertNil(error, @"error should be nil");
        STAssertNotNil(result, @"short lyrics should not be nil");
        NSArray *separatedLines = [result componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
        STAssertEqualsWithAccuracy((int)[separatedLines count], 5, 3, @"lyrics should be short");
        STSuccess();

    }];
    NSLog(@"Test Finished!");

}



- (void)testLongLyricsAsync
{
    STFailAfter(4.0, @"Long lyrics fetching took too long time");
    LyricsWikia *l = [[LyricsWikia alloc] init];
    [l getLyricsForSongNamed:@"Uprising" artist:@"MUSE" full:YES completion:^(NSError *error, NSString *result) {
        
        STAssertNil(error, @"error should be nil");
        STAssertNotNil(result, @"long lyrics should not be nil");
        NSArray *separatedLines = [result componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
        STAssertEqualsWithAccuracy((int)[separatedLines count], 40, 6, @"lyrics should be long");
        STSuccess();
        
    }];
    NSLog(@"Test Finished!");
    
}

@end
