@protocol AFFieldPersistenceDelegate

- (void)persistFieldValue:(NSData *)value forKey:(NSString *)key;

- (NSData *)restoreSettingValueForKey:(NSString *)key;

@end
