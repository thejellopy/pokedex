//
//  AppDelegate.h
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *pokedex;

- (void)saveData;
- (BOOL)isCatchedPokemon:(NSString *)slug;
@end

