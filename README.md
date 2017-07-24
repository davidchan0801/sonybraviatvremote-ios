# sonybraviatvremote-ios
It is a Sony Bravia TV remote app for iOS. It provides a sample code for us to customize your own remote app for Sony TV.

The sample project is designed for Hong Kong TV remote. Therefore, please customize your own remote for your needs.

1. Please set your Sony Bravia TV to use a pre-shared key
   a. Navigate to: [Settings] → [Network] → [Home Network Setup] → [IP Control]
   b. Set [Authentication] to [Normal and Pre-Shared Key]
   c. There should be a new menu entry [Pre-Shared Key]. Set it to 0000.
2. Please edit the following variable in SonyTVIRRCLib.m
   a. static NSString *IPString = @"192.168.1.110"; // TV IP Address
   b. static NSString *AUTHString = @"0000"; // Pre-Shared Ke
3. Compile and run. Let's try.
