//
//  RuntimeUtilities.m
//  GetIvarForTest
//
//  Created by Luca D'Alberti on 12/03/15.
//  Copyright (c) 2015 Luca D'Alberti. All rights reserved.
//

#import "RuntimeUtilities.h"
#import <objc/runtime.h>

@implementation RuntimeUtilities

-(void)methodInjectionOnObject:(id)object WithCompletionHandler:(void (^)(BOOL))completion
{
    Method function = class_getClassMethod([self class], @selector(getValueForIvar:));
    BOOL finished = (class_addMethod([object class], @selector(getValueForIvar:), class_getMethodImplementation([self class], @selector(getValueForIvar:)), method_getTypeEncoding(function)));
    
    completion(finished);
}

-(id)getValueForIvar: (NSString *)ivar_name
{
    id obj = [RuntimeUtilities getInstanceFromIvar: ivar_name inClass: self];
    return obj;
}

+(id)getInstanceFromIvar:(NSString *)ivarName inClass:(id)callingObject
{
    unsigned int i, outCount;
    
    // Salvo in un array di Ivar la IvarList dell'oggetto.
    // In outCount viene memorizzato il numero di elementi
    Ivar *properties = class_copyIvarList([callingObject class], &outCount);
    
    // Itero sull'array
    for(i = 0; i < outCount; i++)
    {
        // Prendo la singola ivar
        Ivar property = properties[i];
        // Chiedo il suo nome
        const char *propName = ivar_getName(property);
        if(propName)
        {
            NSString *prop = [NSString stringWithCString: propName encoding: [NSString defaultCStringEncoding]];
            // Se il nome è uguale a quello ricercato
            if ([prop isEqualToString: ivarName])
            {
                // Ritorno il valore dell'Ivar
                return object_getIvar(callingObject,  property);
            }
        }
    }
    return nil;
}

@end
