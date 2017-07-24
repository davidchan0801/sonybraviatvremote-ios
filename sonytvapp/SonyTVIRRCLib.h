//
//  SonyTVIRRCLib.h
//  sonytvapp
//
//  Created by ChanDavid on 23/7/2017.
//  Copyright © 2017 ChanDavid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonyTVIRRCLib : NSObject {
    NSArray *cmdArray;
    
    NSArray *cmdQ;
}

+ (SonyTVIRRCLib *)getInstance;
+ (NSString *)getSonyTVCommandFilePath;
- (void)initialize;


- (void)sendCommand:(NSString *)cmdValue;
- (void)sendCommandMacro:(NSArray *)cmdMacro;
@end
