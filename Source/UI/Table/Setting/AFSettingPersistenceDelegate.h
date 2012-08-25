@protocol AFSettingPersistenceDelegate

- (void)persistSettingValue:(NSData *)value forKey:(NSString *)key;

- (NSData *)restoreSettingValueForKey:(NSString *)key;

@end
