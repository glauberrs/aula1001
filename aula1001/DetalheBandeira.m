//
//  DetalheBandeira.m
//  aula0502
//
//  Created by Aluno on 11/05/15.
//  Copyright (c) 2015 targettrust. All rights reserved.
//

#import "DetalheBandeira.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetalheBandeira ()

@end

@implementation DetalheBandeira

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d", _linhaSelecionada);
    _labelCodigo.text = [NSString stringWithFormat:@"%@", [_estado objectForKey:@"codigo"]];
    _fieldNome.text = [_estado objectForKey:@"titulo"];

    //_labelTitulo.text =     //[_imagemBandeira setImage: _image];
    [_imagemBandeira sd_setImageWithURL:[NSURL URLWithString:_estado[@"imagem"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)excluir:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bandeiras.plist"];
    NSMutableArray *bandeiras = [[NSMutableArray alloc] initWithContentsOfFile:filePath];

    [bandeiras removeObjectAtIndex:_linhaSelecionada];
    
    [bandeiras writeToFile:filePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)salvar:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"bandeiras.plist"];
    NSMutableArray *bandeiras = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    
    
    if (_insercao) {
        NSMutableDictionary *novoEstado = [[NSMutableDictionary alloc] init];
        [novoEstado setValue:_fieldNome.text forKey:@"titulo"  ];
        [novoEstado setValue:[NSNumber numberWithInt:0]  forKey:@"codigo"  ];
        [bandeiras addObject:novoEstado];
    } else {
        [_estado setValue:_fieldNome.text forKey:@"titulo"  ];
        [bandeiras replaceObjectAtIndex:_linhaSelecionada withObject:_estado];
    }
    
    
    //[bandeiras insertObject:_estado atIndex:_linhaSelecionada];
    
    [bandeiras writeToFile:filePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
@end
