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

@interface NewsTVC ()

@end

@implementation NewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsArray = [[NSMutableArray alloc] init];
    //self.newsgroup = @"epita.assistants";

    [self getNews];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayError
{
}

- (void)getNews
{
    NSString* strURL = [NSString stringWithFormat:@"https://42portal.com/ng-notifier/api/news.epita.fr/%@", self.newsgroup];
    //2
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    //3
    NSURLSession *session = [NSURLSession sharedSession];
    //4
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
                    //6
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
    [self parseNews:jsonArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)parseNews:(NSArray*)jsonArray
{
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsName" forIndexPath:indexPath];

  News* news = [self.newsArray objectAtIndex:indexPath.row];
  [cell.textLabel setText: [news subject]];
  [cell.detailTextLabel setText:[news author]];

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
    // Pass the selected object to the new view
    NewsDetailVC* detail = [segue destinationViewController];
    NSIndexPath* index = [self.tableView indexPathForCell:sender];
    [detail setNews:[self.newsArray objectAtIndex: index.row]];
}

@end
