//
//  NewsTVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import "NewsTVC.h"
#import "NewsDetailVC.h"
#import "News.h"
#import "ApiConstants.h"

@interface NewsTVC ()

@end

@implementation NewsTVC

- (void)viewDidLoad {
  [super viewDidLoad];
    
  self.newsArray = [[NSMutableArray alloc] init];
  self.searchArray = [[NSMutableArray alloc] init];

  [self getNews];

  self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height - self.tableView.contentOffset.y);

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayError
{}

- (void)getNews
{
  if (self.updating)
    return;
  self.updating = YES;
  NSString* strURL;
  if ([self.newsArray count] == 0)
    strURL = [NSString stringWithFormat:@"%@/%@/%@?limit=25", kAPI_BASE_URL, kNG_HOST, self.newsgroup];
  else
  {
    NSString* date = [[self.newsArray objectAtIndex:[self.newsArray count] - 1] creation_date];
    strURL = [NSString stringWithFormat:@"%@/%@/%@?limit=25&start_date=%@%%2B0000", kAPI_BASE_URL, kNG_HOST, self.newsgroup, date];
  }

  [self loadJSON:strURL isSearch:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  if (tableView == self.tableView)
  {
    unsigned long count = [self.newsArray count];
    if (count == 0)
      return 0;
    else if (count == self.topicNb)
      return count;
    else
      return count + 1;
  }
  else
    return [self.searchArray count];
}

-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
  if (scrollView.contentOffset.y < -64 && scrollView.contentOffset.y < self.lastContentOffset)
  {
    [self.searchBar becomeFirstResponder];
  }
  self.lastContentOffset = scrollView.contentOffset.y;
}

-(UIColor*)backgroundColorForSelectedCellAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  int red = 245;
  int green = 138;
  int blue = 67;
  return [UIColor colorWithRed: red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

-(UIColor*)backgroundColorForCellAtIndexPath:(nonnull NSIndexPath *)indexPath withTableView:(UITableView*)tableView
{
  CGFloat upRed = 2.;
  CGFloat downRed = 31.;
  CGFloat upGreen = 94.;
  CGFloat downGreen = 122.;
  CGFloat upBlue = 146.;
  CGFloat downBlue = 172.;
  NSInteger row = indexPath.row;

  CGFloat red = (row % 2 == 0 ? upRed : downRed) / 255.;
  CGFloat green = (row % 2 == 0 ? upGreen : downGreen) / 255.;
  CGFloat blue = (row % 2 == 0 ? upBlue : downBlue) / 255.;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"
                                                          forIndexPath:indexPath];
  cell.userInteractionEnabled = YES;

  if (tableView != self.tableView)
  {
    News* news = [self.searchArray objectAtIndex:indexPath.row];
    [cell.textLabel setText: [news subject]];
    [cell.detailTextLabel setText: [news author]];
  }
  else
  {
    if (indexPath.row >= [self.newsArray count] - 10 && [self.newsArray count] != self.topicNb)
    {
      [self getNews];
    }

    if (indexPath.row >= [self.newsArray count])
    {
      [self getNews];
      [cell.textLabel setText: @""];
      [cell.detailTextLabel setText:@""];
      cell.userInteractionEnabled = NO;
    }
    else
    {
      News* news = [self.newsArray objectAtIndex:indexPath.row];
      [cell.textLabel setText: [news subject]];
      [cell.detailTextLabel setText: [news author]];
    }
  }

  UIColor* color = [self backgroundColorForCellAtIndexPath: indexPath withTableView:tableView];
  cell.contentView.backgroundColor = color;
  cell.textLabel.backgroundColor = color;
  cell.detailTextLabel.backgroundColor = color;

  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  UIView* selectionColor = [[UIView alloc] init];
  selectionColor.backgroundColor = [self backgroundColorForSelectedCellAtIndexPath:indexPath];
  cell.selectedBackgroundView = selectionColor;

  cell.textLabel.textColor = [UIColor whiteColor];
  cell.detailTextLabel.textColor = [UIColor whiteColor];

  return cell;
}

-(void)searchDisplayControllerWillBeginSearch:(nonnull UISearchDisplayController *)controller
{
  UITableView* searchResultTableView = self.searchDisplayController.searchResultsTableView;
  [searchResultTableView registerNib: [UINib nibWithNibName: @"Cell"
                                                     bundle: [NSBundle mainBundle]]
              forCellReuseIdentifier: @"resultCell"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view

  NewsDetailVC* detail = [segue destinationViewController];
  NSIndexPath* index;
  if (self.searchDisplayController.active == YES)
  {
    index = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
    [detail setNews:[self.searchArray objectAtIndex: index.row]];
  }
  else
  {
    index = [self.tableView indexPathForCell:sender];
    [detail setNews:[self.newsArray objectAtIndex: index.row]];
  }
}

- (void)getNews:(NSString*)term withScope:(NSString*)scope
{
  NSString* strURL;
  if ([scope isEqual: @"Title"])
    strURL = [NSString stringWithFormat:@"%@/%@/%@/search?term=%@&title", kAPI_BASE_URL, kNG_HOST, self.newsgroup, term];
  else if ([scope isEqual: @"Author"])
    strURL = [NSString stringWithFormat:@"%@/%@/%@/search?term=%@&author", kAPI_BASE_URL, kNG_HOST, self.newsgroup, term];
  else
    strURL = [NSString stringWithFormat:@"%@/%@/%@/search?term=%@&content", kAPI_BASE_URL, kNG_HOST, self.newsgroup, term];

  [self loadJSON:strURL isSearch:YES];
}

-(void)loadJSON:(NSString*)strURL isSearch:(BOOL)search
{
  NSLog(@"%@", strURL);

  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                            NSURLResponse *response, NSError *error)
    {
      NSError* jsonError;
      if (!error && [response isKindOfClass:[NSHTTPURLResponse class]] &&
          ((NSHTTPURLResponse *)response).statusCode == 200)
      {
        NSArray *arrayJson = [NSJSONSerialization JSONObjectWithData: data
                                                             options: NSJSONReadingMutableContainers error: &jsonError];

        if (!jsonError)
        {
          [self fetchDatas:arrayJson isSearch:search];
        }
        else
        {
          NSLog(@"json convertion error");
        }
      }
      else
      {
        [self displayError];
      }
    }] resume];
}

- (void)fetchDatas:(NSArray*)jsonArray isSearch:(BOOL)search
{
  NSLog(@"JSON: %@", jsonArray);
  [self parseNews:jsonArray isSearch:search];
  dispatch_async(dispatch_get_main_queue(), ^{
    if (search)
      [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
  });
  self.updating = false;
}

- (void)parseNews:(NSArray*)jsonArray isSearch:(BOOL)search
{
  if (search)
    [self.searchArray removeAllObjects];
  for (NSDictionary* newsDico in jsonArray)
  {
    News* newsTmp = [[News alloc] init];
    newsTmp.iId = [[newsDico objectForKey:@"id"] intValue];
    newsTmp.uid = [newsDico objectForKey:@"uid"];
    newsTmp.subject = [newsDico objectForKey:@"subject"];
    newsTmp.author = [newsDico objectForKey:@"author"];
    newsTmp.creation_date = [newsDico objectForKey:@"creation_date"];

    if (search)
      [self.searchArray addObject:newsTmp];
    else
      [self.newsArray addObject:newsTmp];
  }
}


-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (tableView != self.tableView)
    [self performSegueWithIdentifier:@"newsDetailSegue"
                              sender:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void)search:(nonnull UISearchBar*)searchBar
{
  NSString *text = [searchBar text];
  NSString *scope = [[searchBar scopeButtonTitles] objectAtIndex:[searchBar selectedScopeButtonIndex]];
  NSLog(@"Searching %@ in %@", text, scope);
  [self getNews:text withScope:scope];
}

-(void)searchBar:(nonnull UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText
{
  if ([searchText length] > 3)
  {
    [self search: searchBar];
  }
}

-(void)searchBar:(nonnull UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
  if ([[searchBar text] length] > 3)
    [self search: searchBar];
}

-(void)searchBarSearchButtonClicked:(nonnull UISearchBar *)searchBar
{
  [self search: searchBar];
}

@end
