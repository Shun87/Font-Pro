//
//  MoreViewController.m
//  Text2Group
//
//  Created by chenshun on 13-4-12.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SettingViewController.h"
#import "TTSocial.h"
#import "UIColor+HexColor.h"
#import "MoreApp.h"


@interface SettingViewController ()
{
    TTSocial *socila;
}
@end

@implementation SettingViewController
@synthesize appArray;

- (void)dealloc
{
    [appArray release];
    [socila release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"setting"];
        socila = [[TTSocial alloc] init];
        socila.viewController = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    self.tableView.backgroundView = nil;
    self.tableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
    
    self.appArray = [MoreApp moreApps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }
    else if (section == 2)
    {
        return [appArray count];
    }
    else if (section == 1)
    {
        return 1;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"Feedback", nil);
    }
    else if (section == 2)
    {
        return NSLocalizedString(@"More Apps", nil);
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"About", nil);
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        CGRect rect = cell.frame;
        rect.origin.x = cell.contentView.frame.size.width - 40;
        rect.size.width = 40;
        UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 100;
        [cell.contentView addSubview:label];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor colorFromHex:0x074765];
        
        label.textAlignment = UITextAlignmentCenter;
        
        if ([indexPath section] == 1)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 29, 29)];
            imageView.tag = 101;
            [cell.contentView addSubview:imageView];
        }
    
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = nil;
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:101];
    imageView.image = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    if (section == 0)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"Invite By Email", nil);
            cell.imageView.image = [UIImage imageNamed:@"email"];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"Invite By SMS", nil);
            cell.imageView.image = [UIImage imageNamed:@"sms"];
        }
        else if (row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"Send feekback", nil);
            cell.imageView.image = [UIImage imageNamed:@"feedback"];
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"Rate us", nil);
            cell.imageView.image = [UIImage imageNamed:@"like"];
        }
    }
    else if (section == 2)
    {
        AppDesc *app = [appArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = app.name;
        cell.imageView.image = app.icon;

    }
    else if (section == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"Version", nil);
        label.text = @"1.1";
    }

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (section == 0)
    {
        if (row == 0)
        {
            [socila sendEmail:NSLocalizedString(@"FontDesigner", nil) body:NSLocalizedString(@"invite", nil) recipient:nil];
        }
        else if (row == 1)
        {
            [socila showSMSPicker:NSLocalizedString(@"invite", nil) phones:nil];
        }
        else if (row == 2)
        {
            [socila sendFeedback:NSLocalizedString(@"FontDesigner", nil) body:nil];
        }
    }
}
@end
