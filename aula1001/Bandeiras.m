//
//  Bandeiras.m
//  aula0502
//
//  Created by Aluno on 30/03/15.
//  Copyright (c) 2015 targettrust. All rights reserved.
//

#import "Bandeiras.h"
#import "BandeiraTableViewCell.h"
#import "DetalheBandeira.h"
#import "Reachability.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Estado.h"
#define BGQUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface Bandeiras ()

@end

@implementation Bandeiras

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            
            NSData *BandeirasData = [[NSData alloc] initWithContentsOfURL:
                                     [NSURL URLWithString:@"https://gist.githubusercontent.com/jacksonfdam/68dd8e61b0316d029ea8/raw/a6424e22695e2f96651bc0502bcb61e973f8b0be/bandeiras.json"]];
            
            NSError *error;
            NSMutableArray *bandeirasJSON = [NSJSONSerialization
                          JSONObjectWithData:BandeirasData
                          options:NSJSONReadingMutableContainers
                          error:&error];
            
            //_imagens = [[NSMutableDictionary alloc]initWithCapacity:[_bandeiras count]];
            if( error )
            {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                for ( NSDictionary *estado in bandeirasJSON )
                {
                    NSLog(@"----");
                    NSLog(@"codigo: %@", estado[@"codigo"] );
                    NSLog(@"titulo: %@", estado[@"titulo"] );
                    NSLog(@"imagem: %@", estado[@"imagem"] );
                    NSLog(@"----");
                    
                    NSManagedObject *novoEstado;
                    novoEstado = [NSEntityDescription insertNewObjectForEntityForName:@"Estado" inManagedObjectContext:context];
                    [novoEstado setValue:[NSString stringWithFormat:@"%@", estado[@"codigo"] ] forKey:@"codigo"];
                    [novoEstado setValue:estado[@"titulo"] forKey:@"titulo"];
                    [novoEstado setValue:estado[@"imagem"] forKey:@"imagem"];
                    
                    
                    [context save:&error];
                    
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Estado" inManagedObjectContext:context];
                    [fetchRequest setEntity:entity];
                    NSError *error = nil;
                    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
                    for (Estado *estado in objects) {
                        NSLog(@"%@", estado.titulo);
                    }
                    //[_bandeiras removeAllObjects];
                    _bandeiras = [objects mutableCopy];
                    [_tabela reloadData];
                    
                }
            }
            //[_tabela reloadData];
            NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
            
        });
    };
    
    
    
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");

        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Estado" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
        for (Estado *estado in objects) {
            NSLog(@"%@", estado.titulo);
        }
        //[_bandeiras removeAllObjects];
        _bandeiras = [objects mutableCopy];
        [_tabela reloadData];

    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    

    

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rowCount;
    if(_filtered)
        rowCount = (int)[_searchBandeiras count];
    else
        rowCount = (int)[_bandeiras count];
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"bandeiraItemCell";
    
    BandeiraTableViewCell *cell = (BandeiraTableViewCell * )[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[BandeiraTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //NSDictionary *estado = [_bandeiras objectAtIndex:indexPath.row];
    Estado *estado = nil;
    
    if(_filtered){
        estado = [_searchBandeiras objectAtIndex:indexPath.row];
        //estado = [_searchBandeiras objectAtIndex:indexPath.row];
        NSLog(@"Filtrado");
    }else{
        estado = [_bandeiras objectAtIndex:indexPath.row];
        //estado = [_bandeiras objectAtIndex:indexPath.row];
        NSLog(@"Não Filtrado");
    }
    cell.titulo.text = estado.titulo;
    [cell.imagem sd_setImageWithURL:[NSURL URLWithString:[estado imagem]]];
    
    //cell.titulo.text = [estado objectForKey:@"titulo"] ;

    //[cell.imagem sd_setImageWithURL:[NSURL URLWithString:estado[@"imagem"]]];

    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetalheBandeira * tela = [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"linha"]) {
        NSIndexPath *indexPath = [self.tabela indexPathForSelectedRow];
        [tela setLinhaSelecionada:indexPath.row];
        if(_filtered){
            [tela setEstado: [_searchBandeiras objectAtIndex:indexPath.row]];
            //[tela setImage:[_imagens objectForKey: [[_searchBandeiras objectAtIndex:indexPath.row] objectForKey:@"codigo"]  ]];
        } else {
            [tela setEstado: [_bandeiras objectAtIndex:indexPath.row]];
            //[tela setImage:[_imagens objectForKey: [[_bandeiras objectAtIndex:indexPath.row] objectForKey:@"codigo"]  ]];
        }

    } else if ([[segue identifier] isEqualToString:@"adicionar"]) {
        [tela setInsercao:YES];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"Atualizei a Tela");
    _bandeiras = [[NSMutableArray alloc] initWithContentsOfFile:_filePath];
    [_tabela reloadData];
}


- (IBAction)buscar:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pesquisar" message:@"Informe o nome do Estado" delegate:self cancelButtonTitle:@"Buscar" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeAlphabet;
    alertTextField.placeholder = @"Nome do Estado";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"Button Index =%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        NSString *search =[[alertView textFieldAtIndex:0] text];
        NSLog(@"Buscar por: %@", search);
        
        if(search.length == 0){
            _filtered = NO;
            NSLog(@"Não Filtrado");
        }else{
            NSLog(@"Filtrado por: %@", search);
            _filtered = YES;
            _searchBandeiras = [[NSMutableArray alloc] init];
            
            for (NSDictionary* bandeira in _bandeiras){
                NSRange nameRange = [[bandeira objectForKey:@"titulo"] rangeOfString:search options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound){
                    [_searchBandeiras addObject:bandeira];
                }
            }
        }
        
        [_tabela reloadData];
    }
}
@end
