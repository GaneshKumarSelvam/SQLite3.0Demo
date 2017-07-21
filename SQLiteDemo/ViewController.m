//
//  ViewController.m
//  SQLiteDemo
//
//  Created by Manjunadh Bommisetty on 29/03/15.
//  Copyright (c) 2015 Manjunadh Bommisetty. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeUIElements];
    [self createDBIfNotExist];
    
    
   // NSString * studentNamesPath = [[NSBundle mainBundle]pathForResource:@"stateNames" ofType:@"plist"];
    
    
    
    //NSArray * studentNamesArr = [[NSArray alloc]initWithContentsOfFile:studentNamesPath];
    
    
    //NSString * filePath = [[NSBundle mainBundle]pathForResource:@"States" ofType:@"plist"];
    
    //NSArray * myArr = [[NSArray alloc]initWithContentsOfFile:filePath];
    
    //NSLog(@"array contents are %@",myArr);
    
    
}


-(void)createDBIfNotExist
{
    NSString *docsDir;
    NSArray *dirPaths;

    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSLog(@"dirPaths is %@",dirPaths);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    NSLog(@"docsDir is %@",docsDir);
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"contacts.db"]];
    
    NSLog(@"database path-->%@",_databasePath);
    
    
    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
		const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)";
            
            if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                _statusLbl.text = @"Failed to create table";
            }
            
            sqlite3_close(_contactDB);
            
        } else {
            _statusLbl.text = @"Failed to open/create database";
        }    }

}



-(void)initializeUIElements
{

    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 100, 30)];
    _nameLbl.text = @"Name";
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 30, 100, 30)];
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:_nameLbl];
    [self.view addSubview:_nameTF];
    
    
    _addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 100, 30)];
    _addressLbl.text = @"Address";
    
    _addressTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 80, 100, 30)];
    _addressTF.borderStyle = UITextBorderStyleRoundedRect;
    
    
    [self.view addSubview:_addressLbl];
    [self.view addSubview:_addressTF];
    
    
    
    _phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 100, 30)];
    _phoneLbl.text = @"Phone";
    
    _phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 130, 100, 30)];
    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:_phoneLbl];
    [self.view addSubview:_phoneTF];

    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveBtn.frame = CGRectMake(50, 180, 100, 30);
    [_saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_saveBtn];

    
    _findBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _findBtn.frame = CGRectMake(170, 180, 100, 30);
    [_findBtn setTitle:@"Find" forState:UIControlStateNormal];
    [_findBtn addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_findBtn];
    
    
    _getAllRecords = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getAllRecords.frame = CGRectMake(170, 220, 100, 30);
    [_getAllRecords setTitle:@"GetAll" forState:UIControlStateNormal];
    [_getAllRecords addTarget:self action:@selector(onButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_getAllRecords];

    
    _statusLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 300, 30)];
    _statusLbl.text = @"Status of SQL lite updates";
    
        
    [self.view addSubview:_statusLbl];
    
    

}

-(void) onButtonTap:(UIButton*)sender
{
    
    [_nameTF resignFirstResponder];
    [_addressTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    
    if(sender == _findBtn)
    {
        [self findContact];
        
    } else if(sender == _saveBtn)
    {
        [self saveData];
    }else if(sender == _getAllRecords)
    {
        [self getAllRecordsFromDB];
    }
    
}




- (void) saveData
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO CONTACTS (name, address, phone) VALUES (\"%@\", \"%@\", \"%@\")", _nameTF.text, _addressTF.text, _phoneTF.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(_contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _statusLbl.text = @"Contact added";
            _nameTF.text = @"";
            _addressTF.text = @"";
            _phoneTF.text = @"";
        } else {
            _statusLbl.text = @"Failed to add contact";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_contactDB);
    }
}

- (void) findContact
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT address, phone FROM contacts WHERE name=\"%@\"", _nameTF.text];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                _addressTF.text = addressField;
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                _phoneTF.text = phoneField;
                
                _statusLbl.text = @"Match found";
                
            } else {
                _statusLbl.text = @"Match not found";
                _addressTF.text = @"";
                _phoneTF.text = @"";
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
}


- (void) getAllRecordsFromDB
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT * from contacts"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"columns count is %i",sqlite3_data_count(statement));
                
                NSString *idField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                NSString *addressField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                
                NSLog(@"record is ID:%@ Name: %@ Address: %@ Phone:%@",idField,nameField,addressField,phoneField);
                
            }
            

            sqlite3_finalize(statement);
        }
        sqlite3_close(_contactDB);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
