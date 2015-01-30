//
//  SendData.m
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/30/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "SendData.h"

@interface SendData ()

@end

@implementation SendData

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SendDatatoServer:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dbpath = [documentsDirectory stringByAppendingPathComponent:@"CheckIN.sqlite"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Bangkok"]];
    
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    
    NSString *filename = [NSString stringWithFormat:@"CheckIN_%@.csv",stringFromDate];
    
    NSString *CSVpath = [documentsDirectory stringByAppendingPathComponent:filename];
        
    FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
    
    [database open];
    
    FMResultSet *results = [database executeQuery:@"SELECT * FROM list"];
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:CSVpath];
    
    while([results next]) {
        NSString *date = [results stringForColumn:@"DATE"];
        NSString *std_id = [results stringForColumn:@"StdID"];
        
        [csvWriter writeField:date];
        [csvWriter writeField:std_id];
        [csvWriter finishLine];
    }
    [csvWriter closeStream];
    
    NSString *emailTitle = [NSString stringWithFormat:@"Student Check IN file [CSV] date : %@",stringFromDate];
    NSString *messageBody = @"Let's download";
    NSArray *toRecipents = [NSArray arrayWithObject:@"bestwhatup@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSData *fileData = [NSData dataWithContentsOfFile:CSVpath];
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:@"text/csv" fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (IBAction)deleteData:(id)sender {
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alv;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            alv = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alv show];
            break;
        case MFMailComposeResultSaved:
            alv = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alv show];
            break;
        case MFMailComposeResultSent:
            alv = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alv show];
            break;
        case MFMailComposeResultFailed:
            alv = [[UIAlertView alloc] initWithTitle:@"" message:@"Mail sent failure" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alv show];
//            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
