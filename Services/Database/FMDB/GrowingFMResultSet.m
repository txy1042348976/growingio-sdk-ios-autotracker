// Copyright (c) 2008-2014 Flying Meat Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  GrowingFMResultSet.m
//  GrowingAnalytics
//
//  Created by GrowingIO on 10/30/05.
//  Copyright (C) 2020 Beijing Yishu Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "GrowingFMResultSet.h"
#import "GrowingFMDatabase.h"
#import "unistd.h"

@interface GrowingFMDatabase ()
- (void)resultSetDidClose:(GrowingFMResultSet *)resultSet;
@end


@implementation GrowingFMResultSet
@synthesize query=_query;
@synthesize statement=_statement;

+ (instancetype)resultSetWithStatement:(GrowingFMStatement *)statement usingParentDatabase:(GrowingFMDatabase*)aDB {
    
    GrowingFMResultSet *rs = [[GrowingFMResultSet alloc] init];
    
    [rs setStatement:statement];
    [rs setParentDB:aDB];
    
    NSParameterAssert(![statement inUse]);
    [statement setInUse:YES]; // weak reference
    
    return FMG3DBReturnAutoreleased(rs);
}

#if ! __has_feature(objc_arc)
- (void)finalize {
    [self close];
    [super finalize];
}
#endif

- (void)dealloc {
    [self close];
    
    FMG3DBRelease(_query);
    _query = nil;
    
    FMG3DBRelease(_columnNameToIndexMap);
    _columnNameToIndexMap = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)close {
    [_statement reset];
    FMG3DBRelease(_statement);
    _statement = nil;
    
    // we don't need this anymore... (i think)
    //[_parentDB setInUse:NO];
    [_parentDB resultSetDidClose:self];
    _parentDB = nil;
}

- (int)columnCount {
    return sqlite3_column_count([_statement statement]);
}

- (NSMutableDictionary *)columnNameToIndexMap {
    if (!_columnNameToIndexMap) {
        int columnCount = sqlite3_column_count([_statement statement]);
        _columnNameToIndexMap = [[NSMutableDictionary alloc] initWithCapacity:(NSUInteger)columnCount];
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            [_columnNameToIndexMap setObject:[NSNumber numberWithInt:columnIdx]
                                      forKey:[[NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)] lowercaseString]];
        }
    }
    return _columnNameToIndexMap;
}

- (void)kvcMagic:(id)object {
    
    int columnCount = sqlite3_column_count([_statement statement]);
    
    int columnIdx = 0;
    for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        
        const char *c = (const char *)sqlite3_column_text([_statement statement], columnIdx);
        
        // check for a null row
        if (c) {
            NSString *s = [NSString stringWithUTF8String:c];
            
            [object setValue:s forKey:[NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)]];
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (NSDictionary*)resultDict {
    
    NSUInteger num_cols = (NSUInteger)sqlite3_data_count([_statement statement]);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        NSEnumerator *columnNames = [[self columnNameToIndexMap] keyEnumerator];
        NSString *columnName = nil;
        while ((columnName = [columnNames nextObject])) {
            id objectValue = [self objectForColumnName:columnName];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return FMG3DBReturnAutoreleased([dict copy]);
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}

#pragma clang diagnostic pop

- (NSDictionary*)resultDictionary {
    
    NSUInteger num_cols = (NSUInteger)sqlite3_data_count([_statement statement]);
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        int columnCount = sqlite3_column_count([_statement statement]);
        
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            
            NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name([_statement statement], columnIdx)];
            id objectValue = [self objectForColumnIndex:columnIdx];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return dict;
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}




- (BOOL)next {
    return [self nextWithError:nil];
}

- (BOOL)nextWithError:(NSError **)outErr {
    
    int rc = sqlite3_step([_statement statement]);
    
    if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
        NSLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [_parentDB databasePath]);
        NSLog(@"Database busy");
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    else if (SQLITE_DONE == rc || SQLITE_ROW == rc) {
        // all is well, let's return.
    }
    else if (SQLITE_ERROR == rc) {
        NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    else if (SQLITE_MISUSE == rc) {
        // uh oh.
        NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            if (_parentDB) {
                *outErr = [_parentDB lastError];
            }
            else {
                // If 'next' or 'nextWithError' is called after the result set is closed,
                // we need to return the appropriate error.
                NSDictionary* errorMessage = [NSDictionary dictionaryWithObject:@"parentDB does not exist" forKey:NSLocalizedDescriptionKey];
                *outErr = [NSError errorWithDomain:@"FMG3Database" code:SQLITE_MISUSE userInfo:errorMessage];
            }
            
        }
    }
    else {
        // wtf?
        NSLog(@"Unknown error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([_parentDB sqliteHandle]));
        if (outErr) {
            *outErr = [_parentDB lastError];
        }
    }
    
    
    if (rc != SQLITE_ROW) {
        [self close];
    }
    
    return (rc == SQLITE_ROW);
}

- (BOOL)hasAnotherRow {
    return sqlite3_errcode([_parentDB sqliteHandle]) == SQLITE_ROW;
}

- (int)columnIndexForName:(NSString*)columnName {
    columnName = [columnName lowercaseString];
    
    NSNumber *n = [[self columnNameToIndexMap] objectForKey:columnName];
    
    if (n) {
        return [n intValue];
    }
    
    NSLog(@"Warning: I could not find the column named '%@'.", columnName);
    
    return -1;
}



- (int)intForColumn:(NSString*)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int)intForColumnIndex:(int)columnIdx {
    return sqlite3_column_int([_statement statement], columnIdx);
}

- (long)longForColumn:(NSString*)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long)longForColumnIndex:(int)columnIdx {
    return (long)sqlite3_column_int64([_statement statement], columnIdx);
}

- (long long int)longLongIntForColumn:(NSString*)columnName {
    return [self longLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (long long int)longLongIntForColumnIndex:(int)columnIdx {
    return sqlite3_column_int64([_statement statement], columnIdx);
}

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName {
    return [self unsignedLongLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx {
    return (unsigned long long int)[self longLongIntForColumnIndex:columnIdx];
}

- (BOOL)boolForColumn:(NSString*)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL)boolForColumnIndex:(int)columnIdx {
    return ([self intForColumnIndex:columnIdx] != 0);
}

- (double)doubleForColumn:(NSString*)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double)doubleForColumnIndex:(int)columnIdx {
    return sqlite3_column_double([_statement statement], columnIdx);
}

- (NSString*)stringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    const char *c = (const char *)sqlite3_column_text([_statement statement], columnIdx);
    
    if (!c) {
        // null row.
        return nil;
    }
    
    return [NSString stringWithUTF8String:c];
}

- (NSString*)stringForColumn:(NSString*)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*)dateForColumn:(NSString*)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*)dateForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    return [_parentDB hasDateFormatter] ? [_parentDB dateFromString:[self stringForColumnIndex:columnIdx]] : [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
}


- (NSData*)dataForColumn:(NSString*)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    const char *dataBuffer = sqlite3_column_blob([_statement statement], columnIdx);
    int dataSize = sqlite3_column_bytes([_statement statement], columnIdx);

    if (dataBuffer == NULL) {
        return nil;
    }
    
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}


- (NSData*)dataNoCopyForColumn:(NSString*)columnName {
    return [self dataNoCopyForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
  
    const char *dataBuffer = sqlite3_column_blob([_statement statement], columnIdx);
    int dataSize = sqlite3_column_bytes([_statement statement], columnIdx);
    
    NSData *data = [NSData dataWithBytesNoCopy:(void *)dataBuffer length:(NSUInteger)dataSize freeWhenDone:NO];
    
    return data;
}


- (BOOL)columnIndexIsNull:(int)columnIdx {
    return sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL;
}

- (BOOL)columnIsNull:(NSString*)columnName {
    return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }
    
    return sqlite3_column_text([_statement statement], columnIdx);
}

- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName {
    return [self UTF8StringForColumnIndex:[self columnIndexForName:columnName]];
}

- (id)objectForColumnIndex:(int)columnIdx {
    int columnType = sqlite3_column_type([_statement statement], columnIdx);
    
    id returnValue = nil;
    
    if (columnType == SQLITE_INTEGER) {
        returnValue = [NSNumber numberWithLongLong:[self longLongIntForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_FLOAT) {
        returnValue = [NSNumber numberWithDouble:[self doubleForColumnIndex:columnIdx]];
    }
    else if (columnType == SQLITE_BLOB) {
        returnValue = [self dataForColumnIndex:columnIdx];
    }
    else {
        //default to a string for everything else
        returnValue = [self stringForColumnIndex:columnIdx];
    }
    
    if (returnValue == nil) {
        returnValue = [NSNull null];
    }
    
    return returnValue;
}

- (id)objectForColumnName:(NSString*)columnName {
    return [self objectForColumnIndex:[self columnIndexForName:columnName]];
}

// returns autoreleased NSString containing the name of the column in the result set
- (NSString*)columnNameForIndex:(int)columnIdx {
    return [NSString stringWithUTF8String: sqlite3_column_name([_statement statement], columnIdx)];
}

- (void)setParentDB:(GrowingFMDatabase *)newDb {
    _parentDB = newDb;
}

- (id)objectAtIndexedSubscript:(int)columnIdx {
    return [self objectForColumnIndex:columnIdx];
}

- (id)objectForKeyedSubscript:(NSString *)columnName {
    return [self objectForColumnName:columnName];
}


@end
