//
//  Estado.h
//  aula1001
//
//  Created by Aluno on 15/05/15.
//  Copyright (c) 2015 Glauber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Estado : NSManagedObject

@property (nonatomic, retain) NSString * imagem;
@property (nonatomic, retain) NSString * codigo;
@property (nonatomic, retain) NSString * titulo;

@end
