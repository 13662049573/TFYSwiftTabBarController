#import "TFYSwiftKVCCatch.h"

id TFYSwiftSafeValueForKey(NSObject *object, NSString *key) {
    if (object == nil || key.length == 0) {
        return nil;
    }
    id value = nil;
    @try {
        value = [object valueForKey:key];
    } @catch (NSException *exception) {
        return nil;
    }
    return value;
}

void TFYSwiftSafeSetValueForKey(NSObject *object, id value, NSString *key) {
    if (object == nil || key.length == 0) {
        return;
    }
    @try {
        [object setValue:value forKey:key];
    } @catch (NSException *exception) {
    }
}
