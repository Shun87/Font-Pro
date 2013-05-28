//
//  SymbolListViewController.m
//  FontDesigner
//
//  Created by chenshun on 13-5-23.
//  Copyright (c) 2013年 ChenShun. All rights reserved.
//

#import "SymbolListViewController.h"
#import "UIColor+HexColor.h"
#import "SymbolDesc.h"
#import "NSString+Transform.h"
#import "SymbolsViewController.h"
#import "AppDelegate.h"

@interface SymbolListViewController ()

@end

@implementation SymbolListViewController

@synthesize symbolListArray, mTableView;
- (void)dealloc
{
    [symbolListArray release];
    [mTableView release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        symbolListArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorFromHex:LightGray];
    self.mTableView.backgroundView = nil;
    self.mTableView.separatorColor = [UIColor colorFromHex:SeperatorColor];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundImage:[UIImage imageNamed:@"today.png"] forState:UIControlStateNormal];
//    [button setTitle:NSLocalizedString(@"Emoj", nil) forState:UIControlStateNormal];
//    [button setFrame:CGRectMake(0, 0, 60, 30)];
//    [button addTarget:self
//               action:@selector(emojSymbols:) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    button.titleLabel.textColor = [UIColor whiteColor];
//    button.titleLabel.shadowColor = [UIColor darkGrayColor];
//    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [rightItem release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Symbols.plist" ofType:nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    for (int i=0; i<[[dic allKeys] count]; i++)
    {
        NSString *key = [[dic allKeys] objectAtIndex:i];
        NSDictionary *symbolDic = [dic objectForKey:key];
        NSString *min = [symbolDic objectForKey:@"from"];
        NSString *max = [symbolDic objectForKey:@"to"];
        SymbolDesc *symbol = [[SymbolDesc alloc] initWithName:key minHex:min maxHex:max];
        [symbolListArray addObject:symbol];
    }
    
    [symbolListArray sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
        
        SymbolDesc *objStr1 = (SymbolDesc *)obj1;
        SymbolDesc *objStr2 = (SymbolDesc *)obj2;
        return [objStr1.minUnicode compare:objStr2.minUnicode];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if FreeApp
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.adBanner.superview != nil)
    {
        [app.adBanner removeFromSuperview];
    }
    
    CGRect rect = app.adBanner.frame;
    rect.origin.y = self.view.frame.size.height -  CGSizeFromGADAdSize(kGADAdSizeBanner).height;
    app.adBanner.frame = rect;
    app.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:app.adBanner];
#endif
}

- (IBAction)emojSymbols:(id)sender
{
    SymbolsViewController *detailViewController = [[SymbolsViewController alloc] initWithNibName:@"SymbolsViewController" bundle:nil];
    detailViewController.emoj = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [symbolListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([symbolListArray count] > [indexPath row])
    {
        SymbolDesc *desc = [symbolListArray objectAtIndex:[indexPath row]];
        cell.textLabel.text = desc.symbolName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SymbolsViewController *detailViewController = [[SymbolsViewController alloc] initWithNibName:@"SymbolsViewController" bundle:nil];
    detailViewController.symbolDesc = [symbolListArray objectAtIndex:[indexPath row]];
    detailViewController.emoj = NO;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
@end
