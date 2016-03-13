//
//  PokemonAnnotation.m
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "PokemonAnnotation.h"

@implementation PokemonAnnotation

- (id)initWithPokemon:(Pokemon *)pokemon {
    self = [super init];
    if (self) {
        self.pokemon = pokemon;
        self.title = self.pokemon.title;
        self.subtitle = self.pokemon.subtitle;
        self.coordinate = self.pokemon.coordinate;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"POKEMON_ANNOTATION"];
    view.enabled = YES;
    view.canShowCallout = YES;
    view.image = [UIImage imageNamed:self.pokemon.pinImageName];
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}

@end
