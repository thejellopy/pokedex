//
//  PokemonViewController.m
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "PokemonViewController.h"

@interface PokemonViewController ()

@end

@implementation PokemonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.title = self.pokemon.title;
    self.pokemonTitleLabel.text = self.pokemon.title;
    self.pokemonSubtitleLabel.text = self.pokemon.subtitle;
    
    if (self.pokemon.modelImage) {
        self.pokemonImageView.image = self.pokemon.modelImage;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"start downloading modelImageName: %@", self.pokemon.modelImageName);
            NSString *urlString = [NSString stringWithFormat:@"https://cdn.exe.in.th/jellopy/pokedex/%@",
                                   self.pokemon.modelImageName];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            self.pokemon.modelImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished download modelImageName: %@", self.pokemon.modelImageName);
                self.pokemonImageView.image = self.pokemon.modelImage;
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SHOW_HISTORY"]) {
        HistoryViewController *historyViewController = segue.destinationViewController;
        historyViewController.pokemon = self.pokemon;
    }
}

@end
