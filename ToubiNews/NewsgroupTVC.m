//
//  NewsgroupTVC.m
//  ToubiNews
//
//  Created by Adrien on 08/06/15.
//  Copyright (c) 2015 Toub. All rights reserved.
//

#import "NewsgroupTVC.h"
#import "Newsgroup.h"
#import "NewsTVC.h"
#import "News.h"
#import "NewsDetailVC.h"
#import "ApiConstants.h"

@interface NewsgroupTVC ()

@end

@implementation NewsgroupTVC

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.newsgroups = [[NSMutableArray alloc] init];
  self.searchArray = [[NSMutableArray alloc] init];

  self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height - self.tableView.contentOffset.y);

  [self getNewsgroups];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayError
{}

- (void)getNews:(NSString*)term withScope:(NSString*)scope
{
  NSString* strURL;
  if ([scope isEqual: @"Title"])
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&title", kAPI_BASE_URL, kAPI_SEARCH, term];
  else if ([scope isEqual: @"Author"])
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&author", kAPI_BASE_URL, kAPI_SEARCH, term];
  else
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&content", kAPI_BASE_URL, kAPI_SEARCH, term];

  [self loadJSON:strURL isSearch:YES];
}

- (void)getNewsgroups
{
  NSString* strURL = [NSString stringWithFormat:@"%@/%@", kAPI_BASE_URL, kNG_HOST];

  [self loadJSON:strURL isSearch:NO];
}

-(void)loadJSON:(NSString*)strURL isSearch:(BOOL)search
{
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

- (void)parseNews:(NSArray*)jsonArray
{
  [self.searchArray removeAllObjects];
  for (NSDictionary* newsDico in jsonArray)
  {
    News* newsTmp = [[News alloc] init];
    newsTmp.iId = [[newsDico objectForKey:@"id"] intValue];
    newsTmp.uid = [newsDico objectForKey:@"uid"];
    newsTmp.subject = [newsDico objectForKey:@"subject"];
    newsTmp.author = [newsDico objectForKey:@"author"];
    newsTmp.creation_date = [newsDico objectForKey:@"creation_date"];

    [self.searchArray addObject:newsTmp];
  }
}

- (void)fetchDatas:(NSArray*)jsonArray isSearch:(BOOL)search
{
  NSLog(@"JSON: %@", jsonArray);
  if (search)
    [self parseNews:jsonArray];
  else
    [self parseNewsgroups:jsonArray];
  dispatch_async(dispatch_get_main_queue(), ^{
    if (search)
      [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
  });
}

- (void)parseNewsgroups:(NSArray*)jsonArray
{
  for (NSDictionary* newsDico in jsonArray)
  {
    Newsgroup* newsgroupTmp = [[Newsgroup alloc] init];
    newsgroupTmp.iId = [[newsDico objectForKey:@"id"] intValue];
    newsgroupTmp.group_name = [newsDico objectForKey:@"group_name"];
    newsgroupTmp.topic_nb = [[newsDico objectForKey:@"topic_nb"] intValue];

    //end of parsing
    [self.newsgroups addObject:newsgroupTmp];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.tableView)
    return [self.newsgroups count];
  else
    return [self.searchArray count];
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
  CGFloat ratio;
  if (tableView == self.tableView)
    ratio = (1. * indexPath.row) / [self.newsgroups count];
  else
    ratio = (1. * indexPath.row) / [self.searchArray count];
  CGFloat upRed = 2.;
  CGFloat downRed = 116.;
  CGFloat upGreen = 94.;
  CGFloat downGreen = 205.;
  CGFloat upBlue = 146.;
  CGFloat downBlue = 250.;

  CGFloat red = (ratio * (downRed - upRed) + upRed) / 255.;
  CGFloat green = (ratio * (downGreen - upGreen) + upGreen) / 255.;
  CGFloat blue = (ratio * (downBlue - upBlue) + upBlue) / 255.;
  return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

-(void)searchDisplayControllerWillBeginSearch:(nonnull UISearchDisplayController *)controller
{
  [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"NewsgroupCell"
                                                                                  bundle:[NSBundle mainBundle]]
                                            forCellReuseIdentifier:@"newsgroupCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsgroupCell"
                                                          forIndexPath:indexPath];

  if (tableView == self.tableView)
  {
    Newsgroup* newsgroup = [self.newsgroups objectAtIndex:indexPath.row];
    [cell.textLabel setText:[newsgroup group_name]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d news", [newsgroup topic_nb]]];
  }
  else
  {
    if ([self.searchArray count] > indexPath.row)
    {
      News* news = [self.searchArray objectAtIndex:indexPath.row];
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

-(void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
  if (scrollView.contentOffset.y < -64 && scrollView.contentOffset.y < self.lastContentOffset)
  {
    [self.searchBar becomeFirstResponder];
  }
  self.lastContentOffset = scrollView.contentOffset.y;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (tableView != self.tableView)
    [self performSegueWithIdentifier:@"accessNewsDetail"
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if (self.searchDisplayController.active)
  {
    NewsDetailVC* detail = [segue destinationViewController];
    NSIndexPath* index = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
    [detail setNews:[self.searchArray objectAtIndex: index.row]];
  }
  else
  {
    NewsTVC* news = [segue destinationViewController];
    NSIndexPath* index = [self.tableView indexPathForCell:sender];
    Newsgroup* newsgroup = [self.newsgroups objectAtIndex: index.row];
    [news setNewsgroup: [newsgroup group_name]];
    [news setTopicNb: [newsgroup topic_nb]];
  }
}

@end
