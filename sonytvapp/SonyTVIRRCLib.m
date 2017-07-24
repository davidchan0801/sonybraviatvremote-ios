//
//  SonyTVIRRCLib.m
//  sonytvapp
//
//  Created by ChanDavid on 23/7/2017.
//  Copyright © 2017 ChanDavid. All rights reserved.
//

#import "SonyTVIRRCLib.h"

@interface SonyTVIRRCLib (Private)

- (NSMutableURLRequest *)_createSonyTVIRRCRequestWithCommand:(NSString *)cmd;
- (NSDictionary *)_searchCommand:(NSString *)cmdKey;
- (NSString *)_getCommandValue:(NSDictionary *)cmdDict;
- (void)_getAndSaveAllCommands;
- (void)_sendCommandMacro:(NSArray *)cmdMacro;
- (void)_cycle;

@end

@implementation SonyTVIRRCLib

static NSString *IPString = @"192.168.1.110";
static NSString *AUTHString = @"0000";

static SonyTVIRRCLib *_instance = nil;
+ (SonyTVIRRCLib *)getInstance {
    if (_instance == nil)
        _instance = [SonyTVIRRCLib new];
    return _instance;
}

+ (NSString *)getSonyTVCommandFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"SonyTVCommand.plist"];
    return filePath;
}

- (id)init {
    if (self = [super init]) {

    }
    
    return self;
}

- (void)initialize {
    cmdArray = [NSArray arrayWithContentsOfFile:[SonyTVIRRCLib getSonyTVCommandFilePath]];
    if (cmdArray == nil) {
        [self _getAndSaveAllCommands];
    }
    cmdQ = [NSArray array];
    [NSThread detachNewThreadSelector:@selector(_cycle) toTarget:self withObject:nil];
}

- (void)_cycle {
    do {
        if ([cmdQ count] > 0) {
            [self performSelectorOnMainThread:@selector(_sendCommandMacro:) withObject:cmdQ waitUntilDone:YES];
        }
        [NSThread sleepForTimeInterval:0.5];
    }while(true);
}

- (void)sendCommand:(NSString *)cmd {
    NSMutableURLRequest *httpRequest = [self _createSonyTVIRRCRequestWithCommand:cmd];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:httpRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [postDataTask resume];
}

- (void)_sendCommandMacro:(NSArray *)cmdMacro {
    if ([cmdMacro count] > 0) {
        NSString *cmd = [cmdMacro objectAtIndex:0];
        NSLog(@"%@", cmd);
        NSMutableURLRequest *httpRequest = [self _createSonyTVIRRCRequestWithCommand:cmd];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:httpRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSMutableArray *newMacro = [NSMutableArray arrayWithArray:cmdMacro];
            [newMacro removeObjectAtIndex:0];
            cmdQ = newMacro;
        }];
        [postDataTask resume];
    }
}

- (void)sendCommandMacro:(NSArray *)cmdMacro {
    NSMutableArray *newCmdQ = [NSMutableArray arrayWithArray:cmdQ];
    [newCmdQ addObjectsFromArray:cmdMacro];
    cmdQ = newCmdQ;
}

#pragma mark - Private Methods
- (NSMutableURLRequest *)_createSonyTVIRRCRequestWithCommand:(NSString *)cmd {
    NSString *cmdValue = [self _getCommandValue:[self _searchCommand:cmd]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/sony/IRCC", IPString]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"Content-type"];
    [request setValue:AUTHString forHTTPHeaderField:@"X-Auth-PSK"];
    [request setValue:@"\"urn:schemas-sony-com:service:IRCC:1#X_SendIRCC\"" forHTTPHeaderField:@"SOAPACTION"];
    
    NSString *sendString = @"<?xml version=\"1.0\"?>";
    sendString = [sendString stringByAppendingString:@"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"];
    sendString = [sendString stringByAppendingString:@"<s:Body>"];
    sendString = [sendString stringByAppendingString:@"<u:X_SendIRCC xmlns:u=\"urn:schemas-sony-com:service:IRCC:1\">"];
    sendString = [sendString stringByAppendingString:@"<IRCCCode>"];
    sendString = [sendString stringByAppendingString:cmdValue];
    sendString = [sendString stringByAppendingString:@"</IRCCCode>"];
    sendString = [sendString stringByAppendingString:@"</u:X_SendIRCC>"];
    sendString = [sendString stringByAppendingString:@"</s:Body>"];
    sendString = [sendString stringByAppendingString:@"</s:Envelope>"];
    
    [request setValue:[NSString stringWithFormat:@"%d", (int)[sendString length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[sendString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (NSDictionary *)_searchCommand:(NSString *)cmdKey {
    for (NSDictionary *dict in cmdArray) {
        if ([[dict objectForKey:@"name"] isEqualToString:cmdKey])
            return dict;
    }
    return nil;
}

- (NSString *)_getCommandValue:(NSDictionary *)cmdDict {
    return [cmdDict objectForKey:@"value"];
}

- (void)_getAndSaveAllCommands {
    NSString *jsonRequest = @"{\"id\":20,\"method\":\"getRemoteControllerInfo\",\"version\":\"1.0\",\"params\":[]}";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/sony/system", IPString]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [request setValue:[NSString stringWithFormat:@"%d", (int)[jsonRequest length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil && data.length > 0) {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            cmdArray = [[dict objectForKey:@"result"] objectAtIndex:1]; // Hardcode, to get the cmd list
            [cmdArray writeToFile:[SonyTVIRRCLib getSonyTVCommandFilePath] atomically:YES];
        }
        
    }];
    [postDataTask resume];
}

@end
