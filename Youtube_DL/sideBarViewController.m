//
//  sideBarViewController.m
//  Youtube_DL
//
//  Created by Majd Alfhaily on 10/1/13.
//  Copyright (c) 2013 Majd Alfhaily. All rights reserved.
//

#import "sideBarViewController.h"

#import <MessageUI/MessageUI.h>

@interface sideBarViewController ()

@end

@implementation sideBarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Pages";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *cellBtns = [NSArray arrayWithObjects:@"Home", @"Search", @"Downloads", @"More", nil];
    cell.textLabel.text = cellBtns[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController toggleLeftView];
    if (indexPath.row == 1)
    {
        searchViewController *iPhoneSearch = [[searchViewController alloc] init];
        UINavigationController *newmainController = [[UINavigationController alloc] initWithRootViewController:iPhoneSearch];
        [self presentModalViewController:newmainController animated:YES];
    }
    if (indexPath.row == 2)
    {
        iPhoneDownloadsViewController *downloadSection = [[iPhoneDownloadsViewController alloc] init];
        UINavigationController *dlController = [[UINavigationController alloc] initWithRootViewController:downloadSection];
        [self presentModalViewController:dlController animated:YES];
    }
    if (indexPath.row == 3)
    {
        [[[UIAlertView alloc] initWithTitle:@"More?" message:@"There should be something available here in the future! :)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
