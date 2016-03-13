//
//  HistoryAnnotation.m
//  Pokédex
//
//  Created by Jellopy on 12/9/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "HistoryAnnotation.h"

@implementation HistoryAnnotation

- (id)initWithPokemon:(Pokemon *)pokemon {
    self = [super init];
    if (self) {
        self.pokemon = pokemon;
        self.coordinate = self.pokemon.coordinate;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"HISTORY_ANNOTATION"];
    view.enabled = YES;
    view.canShowCallout = NO;
    
    if (self.pokemon.iconImage) {
        view.image = self.pokemon.iconImage;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"start downloading iconImageName: %@", self.pokemon.iconImageName);
            NSString *urlString = [NSString stringWithFormat:@"https://cdn.exe.in.th/jellopy/pokedex/%@",
                                   self.pokemon.iconImageName];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            self.pokemon.iconImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished download iconImageName: %@", self.pokemon.iconImageName);
                view.image = self.pokemon.iconImage;
            });
        });
    }
    
    return view;
}

@end
