#import <Foundation/Foundation.h>

@interface AFMovingAverage : NSObject
{
    float *samples;
    int   index;
    int   maxSampleCount;
    int   currentSampleCount;
    float average;
    float total;
}

- (id)initWithSampleCount:(int)sampleCount;

- (float)average;

- (float)addSample:(float)sample;

@property(nonatomic) float average;

@end
