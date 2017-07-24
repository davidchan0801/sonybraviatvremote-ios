//
//  HKViewController.m
//  sonytvapp
//
//  Created by ChanDavid on 23/7/2017.
//  Copyright © 2017 ChanDavid. All rights reserved.
//

#import "HKViewController.h"
#import "SonyTVIRRCLib.h"

@interface HKViewController ()

@end

@implementation HKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[SonyTVIRRCLib getInstance] initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressButton:(id)sender {
    switch (((UIButton *)sender).tag) {
        case 0:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num3", @"Num1", @"Confirm", nil]];
            break;
        case 1:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num3", @"Num2", @"Confirm", nil]];
            break;
        case 2:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num3", @"Num3", @"Confirm", nil]];
            break;
        case 10:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num7", @"Num7", @"Confirm", nil]];
            break;
        case 20:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num8", @"Num1", @"Confirm", nil]];
            break;
        case 21:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num8", @"Num2", @"Confirm", nil]];
            break;
        case 22:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num8", @"Num3", @"Confirm", nil]];
            break;
        case 23:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num8", @"Num4", @"Confirm", nil]];
            break;
        case 24:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num8", @"Num5", @"Confirm", nil]];
            break;
        case 30:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num9", @"Num6", @"Confirm", nil]];
            break;
        case 31:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Tv", @"Num9", @"Num9", @"Confirm", nil]];
            break;
        case 32:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Hdmi3", nil]];
            break;
        case 40:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Hdmi2", nil]];
            break;
        case 41:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Hdmi4", nil]];
            break;
        case 42:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"Hdmi1", nil]];
            break;
        case 50:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"VolumeUp", nil]];
            break;
        case 51:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"VolumeDown", nil]];
            break;
        case 52:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"MediaAudioTrack", @"CursorUp", @"Confirm", nil]];
            break;
        case 53:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"TvPower", nil]];
            break;
        case 54:
            [[SonyTVIRRCLib getInstance] sendCommandMacro:[NSArray arrayWithObjects:@"SubTitle", @"CursorUp", @"Confirm", nil]];
            break;
        default:
            break;
    }
    
}

@end
