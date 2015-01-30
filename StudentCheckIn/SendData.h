//
//  SendData.h
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/30/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "CHCSVParser.h"
#import <MessageUI/MessageUI.h>

@interface SendData : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
- (IBAction)SendDatatoServer:(id)sender;
- (IBAction)deleteData:(id)sender;

@end
