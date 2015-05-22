//
//  DetalheBandeira.h
//  aula0502
//
//  Created by Aluno on 11/05/15.
//  Copyright (c) 2015 targettrust. All rights reserved.
//

#import "ViewController.h"

@interface DetalheBandeira : ViewController
@property (weak, nonatomic) IBOutlet UIImageView *imagemBandeira;
@property NSDictionary *estado;
@property NSInteger *linhaSelecionada;
@property (weak, nonatomic) IBOutlet UILabel *labelCodigo;
@property (weak, nonatomic) IBOutlet UITextField *fieldNome;
- (IBAction)excluir:(id)sender;
- (IBAction)salvar:(id)sender;
@property bool insercao;
@end
