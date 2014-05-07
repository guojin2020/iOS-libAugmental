
#import "AFParseHTTPContentRange.h"

const NSString* AFContentRangeFormatErrorDescription = @"Content-Range header entry expected in format 'bytes start-end/total'";

AFRangeInfo* CreateAFRangeInfoFromHTTPHeaders(NSDictionary* httpHeaders)
{
    NSString
            *contentRangeFormatString = [httpHeaders objectForKey:@"Content-Range"],
            *contentLengthString      = [httpHeaders objectForKey:@"Content-Length"];

    if( contentRangeFormatString )
    {

        if(![contentRangeFormatString hasPrefix:@"bytes"])
        {
            @throw [NSException exceptionWithName:NSParseErrorException
                                           reason:@"Content-Range should be expressed in bytes"
                                         userInfo:nil];
        }

        NSCharacterSet *nonDataCharacters = [NSCharacterSet characterSetWithCharactersInString:@"bytes "];
        contentRangeFormatString = [contentRangeFormatString stringByTrimmingCharactersInSet:nonDataCharacters];

        NSArray* contentRangeItems = [contentRangeFormatString componentsSeparatedByString:@"/"];
        NSUInteger contentRangeItemCount = [contentRangeItems count];
        if(contentRangeItemCount!=2)
        {
            @throw([NSException exceptionWithName:NSParseErrorException
                                           reason:AFContentRangeFormatErrorDescription
                                         userInfo:httpHeaders]);
        }

        NSString
                *rangeFormatString  = contentRangeItems[0],
                *contentTotalString = contentRangeItems[1];

        NSArray* rangeItems = [rangeFormatString componentsSeparatedByString:@"-"];
        NSUInteger rangeItemCount = [rangeItems count];
        if(rangeItemCount!=2)
        {
            @throw([NSException exceptionWithName:NSParseErrorException
                                           reason:AFContentRangeFormatErrorDescription
                                         userInfo:httpHeaders]);
        }

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        NSUInteger
                rangeStart    = [[numberFormatter numberFromString:rangeItems[0]]       unsignedIntegerValue],
                rangeEnd      = [[numberFormatter numberFromString:rangeItems[1]]       unsignedIntegerValue],
                contentLength = [[numberFormatter numberFromString:contentLengthString] unsignedIntegerValue],
                contentTotal  = [[numberFormatter numberFromString:contentTotalString]  unsignedIntegerValue];

        if(contentLength!=(rangeEnd-rangeStart+1))
        {
            @throw([NSException exceptionWithName:NSRangeException
                                           reason:@"Content-Length and Content-Range headers were inconsistent"
                                         userInfo:httpHeaders]);
        }

        AFRangeInfo* rangeInfo = malloc(sizeof(AFRangeInfo));
        rangeInfo->contentRange = NSMakeRange(rangeStart, rangeEnd - rangeStart );
        rangeInfo->contentTotal = contentTotal;


        return rangeInfo;
    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        NSUInteger contentTotal  = [[numberFormatter numberFromString:contentLengthString] unsignedIntegerValue];

        AFRangeInfo* rangeInfo = malloc(sizeof(AFRangeInfo));
        rangeInfo->contentRange = NSMakeRange(0, contentTotal );
        rangeInfo->contentTotal = contentTotal;


        return rangeInfo;
    }
}
