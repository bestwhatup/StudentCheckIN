//
//  SecondViewController.m
//  StudentCheckIn
//
//  Created by Chawatvish Worrapoj on 1/29/2558 BE.
//  Copyright (c) 2558 Chawatvish Worrapoj. All rights reserved.
//

#import "SecondViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    NSMutableArray *date_array;
    NSMutableArray *std_id_array;
}

@synthesize TableView;

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    date_array = [[NSMutableArray alloc] init];
    std_id_array = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *dbpath = [documentsDirectory stringByAppendingPathComponent:@"CheckIN.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbpath];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"SELECT * FROM List"];

    while ([rs next]) {
        NSString *date = [rs stringForColumn:@"Date"];
        NSString *std_id = [rs stringForColumn:@"StdID"];
        
        [date_array addObject:date];
        [std_id_array addObject:std_id];
    }
    [TableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([date_array count] != 0) {
        return [date_array count];
    } else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [TableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([date_array count] != 0) {
        cell.textLabel.text = [std_id_array objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [date_array objectAtIndex:indexPath.row];
        tableView.tableFooterView = [[UIView alloc] init];
        return cell;
    } else {
        cell.textLabel.text = @"No Record";
        cell.detailTextLabel.text = @"";
        tableView.tableFooterView = [[UIView alloc] init];
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
