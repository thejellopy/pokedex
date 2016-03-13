//
//  WorldMapViewController.m
//  Pokédex
//
//  Created by Jellopy on 12/1/2558 BE.
//  Copyright © 2558 Jellopy. All rights reserved.
//

#import "WorldMapViewController.h"

@interface WorldMapViewController () {
    BOOL isFetchPokemonData;
    AppDelegate *appDelegate;
}

@end

@implementation WorldMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mapView.delegate = self;
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(willDragMap:)];
    self.panRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:self.panRecognizer];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self toggleTrackButton:YES];
}

- (void)fetchPokemonDataOnce {
    if (!isFetchPokemonData) {
        [self fetchPokemonData];
        isFetchPokemonData = YES;
    }
}

- (void)fetchPokemonData {
    NSURL *url = [NSURL URLWithString:@"https://cdn.exe.in.th/jellopy/pokedex/pokedex.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError = nil;
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"setupPokemons loading json error");
            NSLog(@"%@", [jsonError localizedDescription]);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"fetchPokemonDatas finished");
            [self setupPokemons:result];
            [self pinPokemonAnnotation];
        });
    }] resume];
}

- (void)setupPokemons:(NSArray *)datas {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *pokemon in datas) {
        Pokemon *tmpPokemon = [[Pokemon alloc] initWithDictionary:pokemon];
        if ([appDelegate isCatchedPokemon:tmpPokemon.slug]) {
            NSLog(@"catched pokemon :%@", tmpPokemon.title);
            continue;
        }
        
        double latitude = self.locationManager.location.coordinate.latitude;
        double longitude = self.locationManager.location.coordinate.longitude;
        tmpPokemon.coordinate = CLLocationCoordinate2DMake(latitude + [self randomFloatBetween:-0.05 and:0.05],
                                                           longitude + [self randomFloatBetween:-0.05 and:0.05]);
        
        [tmp addObject:tmpPokemon];
        NSLog(@"%@", [NSString stringWithFormat:@"setupPokemon slug: %@, at: latitude: %f, longitude: %f",
                      tmpPokemon.slug,
                      tmpPokemon.coordinate.latitude,
                      tmpPokemon.coordinate.longitude]);
    }
    self.pokemons = [NSArray arrayWithArray:tmp];
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void)pinPokemonAnnotation {
    for (Pokemon *pokemon in self.pokemons) {
        PokemonAnnotation *pokemonAnnotation = [[PokemonAnnotation alloc] initWithPokemon:pokemon];
        [self.mapView addAnnotation:pokemonAnnotation];
    }
    
    NSLog(@"pinPokemonAnnotation");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[PokemonAnnotation class]]) {
        PokemonAnnotation *newAnnotation = (PokemonAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"POKEMON_ANNOTATION"];
        
        if (annotationView) {
            annotationView.annotation = annotation;
            NSLog(@"using existing PokemonAnnotation with reuseIdentifier");
        } else {
            annotationView = newAnnotation.annotationView;
            NSLog(@"creating new PokemonAnnotation with reuseIdentifier");
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    PokemonAnnotation *pokemonAnnotation = (PokemonAnnotation *) view.annotation;
    if (pokemonAnnotation.pokemon.iconImage) {
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:pokemonAnnotation.pokemon.iconImage];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"start downloading iconImageName: %@", pokemonAnnotation.pokemon.iconImageName);
            NSString *urlString = [NSString stringWithFormat:@"https://cdn.exe.in.th/jellopy/pokedex/%@",
                                   pokemonAnnotation.pokemon.iconImageName];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
            pokemonAnnotation.pokemon.iconImage = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished download iconImageName: %@", pokemonAnnotation.pokemon.iconImageName);
                view.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:pokemonAnnotation.pokemon.iconImage];
            });
        });
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[PokemonAnnotation class]]) {
        PokemonAnnotation *pokemonAnnotaion = view.annotation;
        NSString *message = [NSString stringWithFormat:@"Wild %@ appeared!", [pokemonAnnotaion.pokemon.title uppercaseString]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pokédex" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Catch 'em!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"catch pokemon :%@", pokemonAnnotaion.pokemon.title);
            [appDelegate.pokedex addObject:pokemonAnnotaion.pokemon];
            [appDelegate saveData];
            [self.mapView removeAnnotation:pokemonAnnotaion];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"RUN" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 800, 800);
        [self.mapView setRegion:region animated:YES];
        
        NSLog(@"%@", [NSString stringWithFormat:@"didUpdateLocations latitude: %f, longitude: %f",
                      location.coordinate.latitude,
                      location.coordinate.longitude]);
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    if (coordinate.latitude == 0.0 && coordinate.longitude == 0.0) {
        NSLog(@"regionDidChangeAnimated at latitude: 0.0, longitude: 0.0");
    } else {
        [self fetchPokemonDataOnce];
    }
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
}

- (IBAction)switchMapTypeTapped:(UIButton *)sender {
    [self.standardButton setSelected:NO];
    [self.satelliteButton setSelected:NO];
    [self.hybridButton setSelected:NO];
    
    [sender setSelected:YES];
    switch (sender.tag) {
        case 1:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
        case 3:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        default:
            break;
    }
}

- (IBAction)trackButtonTapped:(UIButton *)sender {
    [self toggleTrackButton:![sender isSelected]];
}

- (void)toggleTrackButton:(BOOL)toggle {
    if (toggle) {
        [self.trackButton setSelected:YES];
        [self.locationManager startUpdatingLocation];
        NSLog(@"startUpdatingLocation");
    } else {
        [self.trackButton setSelected:NO];
        [self.locationManager stopUpdatingLocation];
        NSLog(@"stopUpdatingLocation");
    }
}

- (void)willDragMap:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"willDragMap");
        [self toggleTrackButton:NO];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
