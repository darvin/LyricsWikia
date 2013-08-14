//
//  LyricsWikia.h
//  Tunez
//
//  Created by Sergey Klimov on 8/12/13.
//  Copyright (c) 2013 Sergey Klimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsWikia : NSObject
- (void)getLyricsForSongNamed:(NSString *)name artist:(NSString *)artist full:(BOOL)full completion:(void (^)(NSError *, NSString *))completion;
@end
