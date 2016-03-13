//
//  PokemonViewController.h
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pokemon.h"
#import "HistoryViewController.h"

@interface PokemonViewController : UIViewController

@property (strong, nonatomic) Pokemon *pokemon;
@property (strong, nonatomic) IBOutlet UIImageView *pokemonImageView;
@property (strong, nonatomic) IBOutlet UILabel *pokemonTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pokemonSubtitleLabel;

@end
