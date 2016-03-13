//
//  PokedexTableViewController.m
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "PokedexTableViewController.h"

@interface PokedexTableViewController () {
    AppDelegate *appDelegate;
}

@end

@implementation PokedexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
    self.counterLabel.text = [NSString stringWithFormat:@"You got %lu/151 Pokémons!", appDelegate.pokedex.count];
}

- (void)setupUI {
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appDelegate.pokedex.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POKEDEX_TABLE_CELL" forIndexPath:indexPath];
    
    Pokemon *pokemon = [appDelegate.pokedex objectAtIndex:indexPath.row];
    cell.textLabel.text = pokemon.title;
    cell.detailTextLabel.text = pokemon.subtitle;
    if (pokemon.iconImage) {
        cell.imageView.image = pokemon.iconImage;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"start downloading iconImageName: %@", pokemon.iconImageName);
            NSString *urlString = [NSString stringWithFormat:@"https://cdn.exe.in.th/jellopy/pokedex/%@",
                                   pokemon.iconImageName];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            pokemon.iconImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished download iconImageName: %@", pokemon.iconImageName);
                cell.imageView.image = pokemon.iconImage;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            });
        });
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SHOW_POKEMON"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        PokemonViewController *pokemonViewController = segue.destinationViewController;
        Pokemon *pokemon = [appDelegate.pokedex objectAtIndex:indexPath.row];
        pokemonViewController.pokemon = pokemon;
    }
}

@end
