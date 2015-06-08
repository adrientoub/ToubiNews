//
//  GameTVC.m
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import "GameTVC.h"
#import "GameDetailVC.h"
#import "News.h"

@interface GameTVC ()

@end

@implementation GameTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gamesArray = [[NSMutableArray alloc] init];

    [self getGames];
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

- (void)getGames
{
    NSString* strURL = @"https://42portal.com/ng-notifier/api/news.epita.fr/epita.assistants";
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
    [self parseGames:jsonArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)parseGames:(NSArray*)jsonArray
{
    for (NSDictionary* gameDico in jsonArray)
    {
        News* gameTmp = [[News alloc] init];
        gameTmp.iId = [[gameDico objectForKey:@"id"] intValue];
        gameTmp.uid = [gameDico objectForKey:@"uid"];
        gameTmp.subject = [gameDico objectForKey:@"subject"];
        gameTmp.author = [gameDico objectForKey:@"author"];
        
        //end of parsing
        [_gamesArray addObject:gameTmp];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.gamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsName" forIndexPath:indexPath];
    
    [cell.textLabel setText: [[self.gamesArray objectAtIndex:indexPath.row] subject]];
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
    // Pass the selected object to the new view
    GameDetailVC* detail = [segue destinationViewController];
    NSIndexPath* index = [self.tableView indexPathForCell:sender];
    [detail setNews:[self.gamesArray objectAtIndex: index.row]];
}

@end
