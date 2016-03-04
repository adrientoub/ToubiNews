//
//  SearchTVC.m
//  ToubiNews
//
//  Created by Adrien on 09/06/15.
//  Copyright © 2015 Toub. All rights reserved.
//

#import "SearchTVC.h"
#import "News.h"
#import "NewsDetailVC.h"
#import "ApiConstants.h"

@interface SearchTVC ()

@end

@implementation SearchTVC

- (void)viewDidLoad {
  [super viewDidLoad];

  self.newsArray = [[NSMutableArray alloc] init];

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.newsArray count];
}

-(void)searchDisplayControllerWillBeginSearch:(nonnull UISearchDisplayController *)controller
{
  [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"Cell"
                                                                                  bundle:[NSBundle mainBundle]]
                                            forCellReuseIdentifier:@"resultCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"
                                                          forIndexPath:indexPath];

  if ([self.newsArray count] > indexPath.row)
  {
    News* news = [self.newsArray objectAtIndex:indexPath.row];
    [cell.textLabel setText: [news subject]];
    [cell.detailTextLabel setText:[news author]];
  }
  return cell;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  NewsDetailVC* detail = [segue destinationViewController];
  NSIndexPath* index;
  if (self.searchDisplayController.active == YES)
    index = [self.searchDisplayController.searchResultsTableView indexPathForCell:sender];
  else
    index = [self.tableView indexPathForCell:sender];
  [detail setNews:[self.newsArray objectAtIndex: index.row]];
}

- (void) displayError
{
}

- (void)getNews:(NSString*)term withScope:(NSString*)scope
{
  NSString* strURL;
  if ([scope isEqual: @"Title"])
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&title", kAPI_BASE_URL, kAPI_SEARCH, term];
  else if ([scope isEqual: @"Author"])
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&author", kAPI_BASE_URL, kAPI_SEARCH, term];
  else
    strURL = [NSString stringWithFormat:@"%@%@?term=%@&content", kAPI_BASE_URL, kAPI_SEARCH, term];

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
          [self fetchDatas:arrayJson];
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

- (void)fetchDatas:(NSArray*)jsonArray
{
  NSLog(@"JSON: %@", jsonArray);
  [self parseNews:jsonArray];
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self.searchDisplayController.active == YES)
      [self.searchDisplayController.searchResultsTableView reloadData];
    [self.tableView reloadData];
  });
}

- (void)parseNews:(NSArray*)jsonArray
{
  [self.newsArray removeAllObjects];
  for (NSDictionary* newsDico in jsonArray)
  {
    News* newsTmp = [[News alloc] init];
    newsTmp.iId = [[newsDico objectForKey:@"id"] intValue];
    newsTmp.uid = [newsDico objectForKey:@"uid"];
    newsTmp.subject = [newsDico objectForKey:@"subject"];
    newsTmp.author = [newsDico objectForKey:@"author"];

    //end of parsing
    [self.newsArray addObject:newsTmp];
  }
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  if (tableView != self.tableView)
    [self performSegueWithIdentifier:@"toNewsDetail" sender:[tableView cellForRowAtIndexPath:indexPath]];
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
