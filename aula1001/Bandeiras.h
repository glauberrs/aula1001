//
//  Bandeiras.h
//  aula0502
//
//  Created by Aluno on 30/03/15.
//  Copyright (c) 2015 targettrust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface Bandeiras : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tabela;
@property NSMutableArray *bandeiras;
@property NSMutableArray *searchBandeiras;
@property bool filtered;
@property NSString *filePath;
//@property NSMutableDictionary *imagens;
- (IBAction)buscar:(id)sender;
@end
