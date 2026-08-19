#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Mirrors ObjC `cyl_valueForKey:` — NSException from KVC is not catchable in Swift.
id _Nullable TFYSwiftSafeValueForKey(NSObject *object, NSString *key);
void TFYSwiftSafeSetValueForKey(NSObject *object, id _Nullable value, NSString *key);

NS_ASSUME_NONNULL_END
