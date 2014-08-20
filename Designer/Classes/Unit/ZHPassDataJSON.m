//
//  ZHPassDataJSON.m
//  NetWork
//
//  Created by mbp  on 13-8-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHPassDataJSON.h"
#import "ZHDBData.h"





ZHPassDataJSON *instanceControl;

@implementation ZHPassDataJSON


+ (ZHPassDataJSON *)share
{
    if (instanceControl == nil)
    {
        instanceControl = [[ZHPassDataJSON alloc] init];
    }
    
    return instanceControl;
}


- (id) init
{
    self = [super init];
    if (self){
    }
    return self;
}



- (void)insertDBFromTableName:(NSString *)tableName columns:(NSArray *)columns data:(NSArray *)dataArray
{
    
    NSMutableString *sqlString = [NSMutableString string];
    
    
    
    for (NSDictionary *dict in dataArray) {
        
        [sqlString appendFormat:@"INSERT INTO %@ (", tableName];

        
        for (NSString *string in columns) {
            if (string == columns.lastObject) {
                [sqlString appendFormat:@"%@" , string];
            }
            else {
                [sqlString appendFormat:@"%@," , string];
            }
        }
        
        
        [sqlString appendString:@")"];
        [sqlString appendString:@"VALUES ("];
        
        
        
        for (NSString *string in columns) {
            if (string == columns.lastObject) {
                [sqlString appendFormat:@"'%@'", [dict objectForKey:string]];
            }
            else {
                [sqlString appendFormat:@"'%@',", [dict objectForKey:string][@"text"]];
            }
        }
        
        [sqlString appendString:@");"];

    }
    
    [[ZHDBData share] insertTable:sqlString];



}

/*
 
 判断该表数据是否存在后
 
 以   table  为键名的   取得表数据
 
 */
- (void)jsonToTableDB:(NSDictionary *)jsonDict
{
    

    
    NSString *detil = @"product_detil";
    NSArray *detilArray = @[@"detil_id", @"name", @"price", @"product_id", @"standard"];
    [self insertDBFromTableName:detil columns:detilArray data:[jsonDict objectForKey:@"detil"]];

    
    NSString *pic = @"picture";
    NSArray *picArray = @[@"picture_id", @"product_id", @"name", @"type", @"url"];
    [self insertDBFromTableName:pic columns:picArray data:[jsonDict objectForKey:@"picture"]];

    NSString *product = @"product_base";
    NSArray *produtionArray = @[@"cate_id", @"letter", @"number", @"product_id", @"remark", @"series_id"];
    [self insertDBFromTableName:product columns:produtionArray data:[jsonDict objectForKey:@"product"]];



}




- (void)jsonToDB:(NSDictionary *)jsonDict
{
    
    
    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        


        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate performSelector:@selector(passDidFinish)];
            
        });
        
        
    });
    

}


/*
 
 判断该表数据是否存在后
 
 以   table  为键名的   取得表数据
 
 */
- (void)xmlToTableDB:(NSDictionary *)jsonDict
{
    
    
    
    NSString *detil = @"product_detil";
    NSArray *detilArray = @[@"detil_id", @"name", @"price", @"product_id", @"standard"];
    [self insertDBFromTableName:detil columns:detilArray data:[jsonDict objectForKey:@"detil"]];
    
    
    NSString *pic = @"picture";
    NSArray *picArray = @[@"picture_id", @"product_id", @"name", @"type", @"url"];
    [self insertDBFromTableName:pic columns:picArray data:[jsonDict objectForKey:@"picture"]];
    
    NSString *product = @"product_base";
    NSArray *produtionArray = @[@"cate_id", @"letter", @"number", @"product_id", @"remark", @"series_id"];
    [self insertDBFromTableName:product columns:produtionArray data:[jsonDict objectForKey:@"product"]];
    
    
    
}


- (NSDictionary *)xmlConvertJson:(NSDictionary *)dict
{
    
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSDictionary *jsonDict = [jsonData objectFromJSONData];
    
    return jsonDict;
    
}

- (void)insertDesinger:(NSDictionary *)dict
{
//    设计师  name
//    设计师  照片
//     介绍
    NSString *fid = [dict objectForKey:@"fID"][@"text"];
    NSString *name = [dict objectForKey:@"designerName"][@"text"];
    NSString *pic = [dict objectForKey:@"designerPic"][@"text"];
    NSString *desc = [dict objectForKey:@"designerDes"][@"text"];
    
    
    

    NSMutableString *sqlString = [NSMutableString string];
    
    
   
    [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_designerInfo"];
    [sqlString appendFormat:@"%@," , @"fID"];
    [sqlString appendFormat:@"%@," , @"designerName"];
    [sqlString appendFormat:@"%@," , @"designerPic"];
    [sqlString appendFormat:@"%@" , @"designerDes"];
    [sqlString appendString:@")"];
    [sqlString appendString:@"VALUES ("];
    [sqlString appendFormat:@"'%@',", fid];
    [sqlString appendFormat:@"'%@',", name];
    [sqlString appendFormat:@"'%@',", pic];
    
    NSString *str = [desc stringByReplacingOccurrencesOfString:@";" withString:@"；"];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];

    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];

    

    [sqlString appendFormat:@"'%@'", str4];
    [sqlString appendString:@");"];

    
    
    [[ZHDBData share] insertTable:sqlString];


}

- (void)insertWorker:(NSDictionary *)dict
{

    NSArray *worker = [dict objectForKey:@"designerWorks"][@"DesignerWorks"];
    
    
    
    NSMutableString *sqlString = [NSMutableString string];
    
    
    for (NSDictionary *dict in worker) {
        
        
        [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_designerWorks"];
        [sqlString appendFormat:@"%@," , @"fID"];
        [sqlString appendFormat:@"%@," , @"Price"];
        [sqlString appendFormat:@"%@," , @"Room"];
        [sqlString appendFormat:@"%@," , @"setMeal"];
        [sqlString appendFormat:@"%@," , @"workPicUrls"];
        [sqlString appendFormat:@"%@," , @"workStyle"];
        [sqlString appendFormat:@"%@," , @"area"];
        [sqlString appendFormat:@"%@," , @"description"];
        [sqlString appendFormat:@"%@," , @"areaInterval"];
        [sqlString appendFormat:@"%@" , @"priceInterval"];
        [sqlString appendString:@")"];
        [sqlString appendString:@"VALUES ("];
        [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict [@"Price"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"Room"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"setMeal"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"worksUrl"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"workStyle"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"area"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"description"][@"text"]];
        [sqlString appendFormat:@"'%@',", dict[@"areaInterval"][@"text"]];
        [sqlString appendFormat:@"'%@'", dict[@"priceInterval"][@"text"]];
        [sqlString appendString:@");"];
        
        
        NSArray *array = [dict objectForKey:@"designerWorksContent"][@"DesignerWorksContent"];
        
        if ([[array class] isSubclassOfClass:[NSMutableDictionary class]]) {
            NSDictionary *d = [dict objectForKey:@"designerWorksContent"][@"DesignerWorksContent"];
            [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_designerWorksContent"];
            [sqlString appendFormat:@"%@," , @"fID"];
            [sqlString appendFormat:@"%@," , @"designerWorksID"];
            [sqlString appendFormat:@"%@" , @"worksContentPic"];
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];

            [sqlString appendFormat:@"'%@',", d [@"designerWorksID"][@"text"]];
            [sqlString appendFormat:@"'%@'", d [@"worksContentPic"][@"text"]];
            [sqlString appendString:@");"];
        }
        else {
            for (NSDictionary *dict in array) {
                [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_designerWorksContent"];
                [sqlString appendFormat:@"%@," , @"fID"];
                [sqlString appendFormat:@"%@," , @"designerWorksID"];
                [sqlString appendFormat:@"%@" , @"worksContentPic"];
                [sqlString appendString:@")"];
                [sqlString appendString:@"VALUES ("];
                [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];
                [sqlString appendFormat:@"'%@',", dict [@"designerWorksID"][@"text"]];
                [sqlString appendFormat:@"'%@'", dict[@"worksContentPic"][@"text"]];
                [sqlString appendString:@");"];
                
            }
        }
        

    }

    
    
    
    [[ZHDBData share] insertTable:sqlString];
    
}

- (NSString *)inserWork360Item:(NSDictionary *)dict
{

    NSMutableString *sqlString = [NSMutableString string];

    [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_360Works"];
    [sqlString appendFormat:@"%@," , @"fID"];
    [sqlString appendFormat:@"%@," , @"Price"];
    [sqlString appendFormat:@"%@," , @"Room"];
    [sqlString appendFormat:@"%@," , @"setMeal"];
    [sqlString appendFormat:@"%@," , @"workPicUrls"];
    [sqlString appendFormat:@"%@," , @"houseTypeUrls"];
    [sqlString appendFormat:@"%@," , @"description"];
    [sqlString appendFormat:@"%@," , @"workStyle"];
    [sqlString appendFormat:@"%@," , @"area"];
    [sqlString appendFormat:@"%@," , @"areaInterval"];
    [sqlString appendFormat:@"%@" , @"priceInterval"];
    [sqlString appendString:@")"];
    [sqlString appendString:@"VALUES ("];
    [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict [@"Price"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"Room"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"setMeal"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"workPicUrls"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"houseTypeUrls"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"description"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"workStyle"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"area"][@"text"]];
    [sqlString appendFormat:@"'%@',", dict[@"areaInterval"][@"text"]];
    [sqlString appendFormat:@"'%@'", dict[@"priceInterval"][@"text"]];

    [sqlString appendString:@");"];
    
    
    NSArray *array = [dict objectForKey:@"workspace360"][@"Work360Space"];
    
    if ([[array class] isSubclassOfClass:[NSMutableDictionary class]]) {
        NSDictionary *d = [dict objectForKey:@"workspace360"];
        [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_360WorksSpace"];
        [sqlString appendFormat:@"%@," , @"fID"];

        [sqlString appendFormat:@"%@," , @"WorksID"];
        [sqlString appendFormat:@"%@" , @"workPicUrl"];
        [sqlString appendString:@")"];
        [sqlString appendString:@"VALUES ("];
        [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];

        [sqlString appendFormat:@"'%@',", d [@"WorksID"][@"text"]];
        [sqlString appendFormat:@"'%@'", d [@"workPicUrl"][@"text"]];
        [sqlString appendString:@");"];
    }
    else {
        for (NSDictionary *dict in array) {
            [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_360WorksSpace"];
            [sqlString appendFormat:@"%@," , @"fID"];

            [sqlString appendFormat:@"%@," , @"WorksID"];
            [sqlString appendFormat:@"%@" , @"StyleRoom"];
            [sqlString appendString:@")"];
            [sqlString appendString:@"VALUES ("];
            [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];

            [sqlString appendFormat:@"'%@',", dict [@"WorksID"][@"text"]];
            [sqlString appendFormat:@"'%@'", dict[@"StyleRoom"][@"text"]];
            [sqlString appendString:@");"];
            
            NSArray *array = [dict objectForKey:@"workcontent360"][@"Work360PICsContent"];
            
            if ([[array class] isSubclassOfClass:[NSMutableDictionary class]]) {
                NSDictionary *d = [dict objectForKey:@"workspace360"];
                [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_360WorksContent"];
                [sqlString appendFormat:@"%@," , @"fID"];
                [sqlString appendFormat:@"%@," , @"WorksSpaceID"];
                [sqlString appendFormat:@"%@" , @"WorksContentPic"];
                [sqlString appendString:@")"];
                [sqlString appendString:@"VALUES ("];
                [sqlString appendFormat:@"'%@',", d [@"fID"][@"text"]];
                [sqlString appendFormat:@"'%@',", d [@"WorksSpaceID"][@"text"]];
                [sqlString appendFormat:@"'%@'", d[@"WorksContentPic"][@"text"]];
                [sqlString appendString:@");"];
            }
            else {
                for (NSDictionary *dict in array) {
                    [sqlString appendFormat:@"INSERT INTO %@ (", @"APP_360WorksContent"];
                    [sqlString appendFormat:@"%@," , @"fID"];
                    [sqlString appendFormat:@"%@," , @"WorksSpaceID"];
                    [sqlString appendFormat:@"%@" , @"WorksContentPic"];
                    [sqlString appendString:@")"];
                    [sqlString appendString:@"VALUES ("];
                    [sqlString appendFormat:@"'%@',", dict [@"fID"][@"text"]];
                    [sqlString appendFormat:@"'%@',", dict [@"WorksSpaceID"][@"text"]];
                    [sqlString appendFormat:@"'%@'", dict[@"WorksContentPic"][@"text"]];
                    [sqlString appendString:@");"];
                }
            }

            
            
        }
    }
    
    return sqlString;

}

- (void)insertWork360:(NSDictionary *)dict
{
    NSArray *worker = [dict objectForKey:@"Works360"] [@"Works360PICs"];
    

    
    NSMutableString *sqlString = [NSMutableString string];
    if ([[worker class] isSubclassOfClass:[NSMutableDictionary class]]) {
        
        NSDictionary *dict = ((NSDictionary *)worker);
        [sqlString appendString: [self inserWork360Item:dict]];
        
    }
    else {
        
        for (NSDictionary *dict in worker) {
           
           

            [sqlString appendString:[self inserWork360Item:dict]];
            
        }
        
    }

    [[ZHDBData share] insertTable:sqlString];
}



- (void)xmlToDB:(NSDictionary *)xmlDict
{
    
    
    dispatch_queue_t queue = dispatch_queue_create("com.ple.queue", NULL);
    dispatch_async(queue, ^(void) {
        
        
        [[ZHDBData share] deleteAllData];
        
        
        
        [self insertDesinger:xmlDict];
        [self insertWorker:xmlDict];

        [self insertWork360:xmlDict];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate performSelector:@selector(passDidFinish)];
            
        });
        
        
    });
    
    
}



@end
