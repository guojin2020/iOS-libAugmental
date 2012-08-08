#import "AFMovingAverage.h"

@implementation AFMovingAverage

-(id)initWithSampleCount:(int)sampleCount
{
	if((self = [super init]))
	{
		maxSampleCount = sampleCount;
		currentSampleCount = 0;
		total = 0.0f;
		samples = malloc(sizeof(float)*sampleCount);
	}
	return self;
}

-(float)addSample:(float)sample
{
	samples[index]=sample;
	total+=samples[index];
	int oldestIndex = 0;
	if(currentSampleCount==maxSampleCount)
	{
		oldestIndex = index+1;
		if(oldestIndex>=maxSampleCount) oldestIndex-=maxSampleCount;
		total-=samples[oldestIndex];
	}
	if(currentSampleCount<maxSampleCount) currentSampleCount++;
	if(++index==currentSampleCount)index=0;
	average = (float)((float)total/(float)currentSampleCount);
	return average;
}

-(void)dealloc
{
	free(samples);
	[super dealloc];
}

@synthesize average;

@end
