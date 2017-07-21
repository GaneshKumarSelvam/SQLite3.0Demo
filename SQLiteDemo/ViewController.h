
//
//  ViewController.h
//  SQLiteDemo
//
//  Created by Manjunadh Bommisetty on 07/11/14.
//  Copyright (c) 2013 Manjunadh Bommisetty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface ViewController : UIViewController

@property UILabel * nameLbl;
@property UILabel * addressLbl;
@property UILabel * phoneLbl;
@property UILabel * statusLbl;
@property UITextField * nameTF;
@property UITextField * addressTF;
@property UITextField * phoneTF;

@property  NSString *databasePath;

@property UIButton * saveBtn;

@property UIButton * findBtn;

@property sqlite3 * contactDB;

@property UIButton * getAllRecords;


@end
