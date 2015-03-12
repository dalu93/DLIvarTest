//
//  RuntimeUtilities.h
//  GetIvarForTest
//
//  Created by Luca D'Alberti on 12/03/15.
//  Copyright (c) 2015 Luca D'Alberti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeUtilities : NSObject

-(void)methodInjectionOnObject: (id)object WithCompletionHandler: (void (^)(BOOL finished))completion;
+(id)getInstanceFromIvar:(NSString *)ivarName inClass:(id)callingObject;

@end
