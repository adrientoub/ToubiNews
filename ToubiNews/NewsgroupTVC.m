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

@interface NewsgroupTVC ()

@end

@implementation NewsgroupTVC

- (void)viewDidLoad {
    [super viewDidLoad];

  self.newsgroups = [[NSMutableArray alloc] init];
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

- (void)getNewsgroups
{
  NSString* strURL = [NSString stringWithFormat:@"https://42portal.com/ng-notifier/api/news.epita.fr"];
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
        if ([arrayJson count] == 0)
        {
          [self displayError];
        }
        else
        {
          if (!jsonError)
          {
            [self fetchDatas:arrayJson];
          }
          else
          {
            NSLog(@"json convertion error");
          }
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
  [self parseNewsgroups:jsonArray];
  dispatch_async(dispatch_get_main_queue(), ^{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.newsgroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsgroupCell" forIndexPath:indexPath];

  Newsgroup* newsgroup = [self.newsgroups objectAtIndex:indexPath.row];
  [cell.textLabel setText:[newsgroup group_name]];
  [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d news", [newsgroup topic_nb]]];

  // Configure the cell...
    
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
  NewsTVC* news = [segue destinationViewController];
  NSIndexPath* index = [self.tableView indexPathForCell:sender];
  Newsgroup* newsgroup = [self.newsgroups objectAtIndex: index.row];
  [news setNewsgroup:[newsgroup group_name]];
  [news setTopicNb: [newsgroup topic_nb]];
}

@end
