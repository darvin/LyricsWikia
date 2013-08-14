//
//  LyricsWikia.m
//  Tunez
//
//  Created by Sergey Klimov on 8/12/13.
//  Copyright (c) 2013 Sergey Klimov. All rights reserved.
//

#import "LyricsWikia.h"
#import "AFNetworking.h"



@implementation LyricsWikia {
    AFHTTPClient *_client;
}

- (id)init {
    self = [super init];
    if (self) {
        _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://lyrics.wikia.com/api.php"]];
    }
    return self;
}

- (void)getShortLyricsForSongNamed:(NSString *)name artist:(NSString *)artist completion:(void (^)(NSError *, NSString *, NSURL* ))completion {
    NSURLRequest * urlRequest = [_client requestWithMethod:@"GET" path:@"" parameters:@{@"artist":artist, @"song":name, @"fmt":@"realjson"}];
    AFJSONRequestOperation* apiRequest = [[AFJSONRequestOperation alloc] initWithRequest:urlRequest];
    [apiRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        
        completion(nil, responseObject[@"lyrics"], [NSURL URLWithString:responseObject[@"url"]]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil, nil);
    }];
    [_client enqueueHTTPRequestOperation:apiRequest];
}

- (void)getFullLyricsForURL:(NSURL *)url completion:(void (^)(NSError *, NSString *))completion{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[ NSURL URLWithString:[[url absoluteString] stringByAppendingString:@"?action=edit"]]];
    AFHTTPRequestOperation* apiRequest = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [apiRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *response) {
          //search for <lyrics> and </lyrics>
        NSString* responseString = [[NSString alloc] initWithData:response
                                         encoding:NSUTF8StringEncoding];
        NSRange rangeStart = [responseString rangeOfString:@"&lt;lyrics>"];
        NSRange rangeEnd = [responseString rangeOfString:@"&lt;/lyrics>"];
        NSRange lyricsRange = NSMakeRange(rangeStart.location+rangeStart.length, rangeEnd.location - (rangeStart.location+rangeStart.length));
        NSString *lyrics = [responseString substringWithRange:lyricsRange];

        completion(nil, lyrics);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
    [_client enqueueHTTPRequestOperation:apiRequest];

}


- (void)getLyricsForSongNamed:(NSString *)name artist:(NSString *)artist full:(BOOL)full completion:(void (^)(NSError *, NSString *))completion {
        [self getShortLyricsForSongNamed:name artist:artist completion:^(NSError *error, NSString *shortLyrics, NSURL *fullURL) {
            if (!full) {
                completion(error, shortLyrics);
            } else {
                [self getFullLyricsForURL:fullURL completion:^(NSError *error, NSString *fullLyrics) {
                    completion(error, fullLyrics);
                }];
            }
        }];
    
}
@end
