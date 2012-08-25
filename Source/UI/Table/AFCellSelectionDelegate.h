@class AFTableCell;

@protocol AFCellSelectionDelegate

- (void)cellSelected:(AFTableCell *)cellObject;

// @optional
//-(void)cellAccessorySelected:(AFTableCell*)cellObject;

@end
