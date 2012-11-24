@protocol AFField;

@protocol AFFieldObserver

- (void)settingChanged:(NSObject <AFField> *)setting;

@end
