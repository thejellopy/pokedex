//
//  AppDelegate.m
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "AppDelegate.h"
#import "Pokemon.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    NSLog(@"loading appData from :%@", filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([savedData objectForKey:@"pokedex"]) {
            self.pokedex = [[NSMutableArray alloc] initWithArray:[savedData objectForKey:@"pokedex"]];
        }
    }
    
    if (!self.pokedex) {
        self.pokedex = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"appDelegate launched with pokedex: %@", self.pokedex);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveData];
}

- (void)saveData {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    if (self.pokedex) {
        [dataDict setObject:self.pokedex forKey:@"pokedex"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:filePath];
    NSLog(@"savedData pokedex: %@", self.pokedex);
}

- (BOOL)isCatchedPokemon:(NSString *)slug {
    for (Pokemon *pokemon in self.pokedex) {
        if ([slug isEqualToString:pokemon.slug]) {
            return YES;
        }
    }
    return NO;
}

@end
