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
//  GrowingFMResultSet.h
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

#import <Foundation/Foundation.h>
#import <SQLCipher/sqlite3.h>

#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

@class GrowingFMDatabase;
@class GrowingFMStatement;

/** Represents the results of executing a query on an `<FMG3Database>`.
 
 ### See also
 
 - `<FMG3Database>`
 */

@interface GrowingFMResultSet : NSObject {
    GrowingFMDatabase          *_parentDB;
    GrowingFMStatement         *_statement;
    
    NSString            *_query;
    NSMutableDictionary *_columnNameToIndexMap;
}

///-----------------
/// @name Properties
///-----------------

/** Executed query */

@property (atomic, retain) NSString *query;

/** `NSMutableDictionary` mapping column names to numeric index */

@property (readonly) NSMutableDictionary *columnNameToIndexMap;

/** `GrowingFMStatement` used by result set. */

@property (atomic, retain) GrowingFMStatement *statement;

///------------------------------------
/// @name Creating and closing database
///------------------------------------

/** Create result set from `<GrowingFMStatement>`
 
 @param statement A `<GrowingFMStatement>` to be performed
 
 @param aDB A `<FMG3Database>` to be used
 
 @return A `GrowingFMResultSet` on success; `nil` on failure
 */

+ (instancetype)resultSetWithStatement:(GrowingFMStatement *)statement usingParentDatabase:(GrowingFMDatabase*)aDB;

/** Close result set */

- (void)close;

- (void)setParentDB:(GrowingFMDatabase *)newDb;

///---------------------------------------
/// @name Iterating through the result set
///---------------------------------------

/** Retrieve next row for result set.
 
 You must always invoke `next` or `nextWithError` before attempting to access the values returned in a query, even if you're only expecting one.

 @return `YES` if row successfully retrieved; `NO` if end of result set reached
 
 @see hasAnotherRow
 */

- (BOOL)next;

/** Retrieve next row for result set.
 
  You must always invoke `next` or `nextWithError` before attempting to access the values returned in a query, even if you're only expecting one.
 
 @param outErr A 'NSError' object to receive any error object (if any).
 
 @return 'YES' if row successfully retrieved; 'NO' if end of result set reached
 
 @see hasAnotherRow
 */

- (BOOL)nextWithError:(NSError **)outErr;

/** Did the last call to `<next>` succeed in retrieving another row?

 @return `YES` if the last call to `<next>` succeeded in retrieving another record; `NO` if not.
 
 @see next
 
 @warning The `hasAnotherRow` method must follow a call to `<next>`. If the previous database interaction was something other than a call to `next`, then this method may return `NO`, whether there is another row of data or not.
 */

- (BOOL)hasAnotherRow;

///---------------------------------------------
/// @name Retrieving information from result set
///---------------------------------------------

/** How many columns in result set
 
 @return Integer value of the number of columns.
 */

- (int)columnCount;

/** Column index for column name

 @param columnName `NSString` value of the name of the column.

 @return Zero-based index for column.
 */

- (int)columnIndexForName:(NSString*)columnName;

/** Column name for column index

 @param columnIdx Zero-based index for column.

 @return columnName `NSString` value of the name of the column.
 */

- (NSString*)columnNameForIndex:(int)columnIdx;

/** Result set integer value for column.

 @param columnName `NSString` value of the name of the column.

 @return `int` value of the result set's column.
 */

- (int)intForColumn:(NSString*)columnName;

/** Result set integer value for column.

 @param columnIdx Zero-based index for column.

 @return `int` value of the result set's column.
 */

- (int)intForColumnIndex:(int)columnIdx;

/** Result set `long` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `long` value of the result set's column.
 */

- (long)longForColumn:(NSString*)columnName;

/** Result set long value for column.

 @param columnIdx Zero-based index for column.

 @return `long` value of the result set's column.
 */

- (long)longForColumnIndex:(int)columnIdx;

/** Result set `long long int` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `long long int` value of the result set's column.
 */

- (long long int)longLongIntForColumn:(NSString*)columnName;

/** Result set `long long int` value for column.

 @param columnIdx Zero-based index for column.

 @return `long long int` value of the result set's column.
 */

- (long long int)longLongIntForColumnIndex:(int)columnIdx;

/** Result set `unsigned long long int` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `unsigned long long int` value of the result set's column.
 */

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName;

/** Result set `unsigned long long int` value for column.

 @param columnIdx Zero-based index for column.

 @return `unsigned long long int` value of the result set's column.
 */

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx;

/** Result set `BOOL` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `BOOL` value of the result set's column.
 */

- (BOOL)boolForColumn:(NSString*)columnName;

/** Result set `BOOL` value for column.

 @param columnIdx Zero-based index for column.

 @return `BOOL` value of the result set's column.
 */

- (BOOL)boolForColumnIndex:(int)columnIdx;

/** Result set `double` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `double` value of the result set's column.
 
 */

- (double)doubleForColumn:(NSString*)columnName;

/** Result set `double` value for column.

 @param columnIdx Zero-based index for column.

 @return `double` value of the result set's column.
 
 */

- (double)doubleForColumnIndex:(int)columnIdx;

/** Result set `NSString` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `NSString` value of the result set's column.
 
 */

- (NSString*)stringForColumn:(NSString*)columnName;

/** Result set `NSString` value for column.

 @param columnIdx Zero-based index for column.

 @return `NSString` value of the result set's column.
 */

- (NSString*)stringForColumnIndex:(int)columnIdx;

/** Result set `NSDate` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `NSDate` value of the result set's column.
 */

- (NSDate*)dateForColumn:(NSString*)columnName;

/** Result set `NSDate` value for column.

 @param columnIdx Zero-based index for column.

 @return `NSDate` value of the result set's column.
 
 */

- (NSDate*)dateForColumnIndex:(int)columnIdx;

/** Result set `NSData` value for column.
 
 This is useful when storing binary data in table (such as image or the like).

 @param columnName `NSString` value of the name of the column.

 @return `NSData` value of the result set's column.
 
 */

- (NSData*)dataForColumn:(NSString*)columnName;

/** Result set `NSData` value for column.

 @param columnIdx Zero-based index for column.

 @return `NSData` value of the result set's column.
 */

- (NSData*)dataForColumnIndex:(int)columnIdx;

/** Result set `(const unsigned char *)` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `(const unsigned char *)` value of the result set's column.
 */

- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName;

/** Result set `(const unsigned char *)` value for column.

 @param columnIdx Zero-based index for column.

 @return `(const unsigned char *)` value of the result set's column.
 */

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;

/** Result set object for column.

 @param columnName `NSString` value of the name of the column.

 @return Either `NSNumber`, `NSString`, `NSData`, or `NSNull`. If the column was `NULL`, this returns `[NSNull null]` object.

 @see objectForKeyedSubscript:
 */

- (id)objectForColumnName:(NSString*)columnName;

/** Result set object for column.

 @param columnIdx Zero-based index for column.

 @return Either `NSNumber`, `NSString`, `NSData`, or `NSNull`. If the column was `NULL`, this returns `[NSNull null]` object.

 @see objectAtIndexedSubscript:
 */

- (id)objectForColumnIndex:(int)columnIdx;

/** Result set object for column.
 
 This method allows the use of the "boxed" syntax supported in Modern Objective-C. For example, by defining this method, the following syntax is now supported:
 
    id result = rs[@"employee_name"];
 
 This simplified syntax is equivalent to calling:
 
    id result = [rs objectForKeyedSubscript:@"employee_name"];
 
 which is, it turns out, equivalent to calling:
 
    id result = [rs objectForColumnName:@"employee_name"];

 @param columnName `NSString` value of the name of the column.

 @return Either `NSNumber`, `NSString`, `NSData`, or `NSNull`. If the column was `NULL`, this returns `[NSNull null]` object.
 */

- (id)objectForKeyedSubscript:(NSString *)columnName;

/** Result set object for column.

 This method allows the use of the "boxed" syntax supported in Modern Objective-C. For example, by defining this method, the following syntax is now supported:

    id result = rs[0];

 This simplified syntax is equivalent to calling:

    id result = [rs objectForKeyedSubscript:0];

 which is, it turns out, equivalent to calling:

    id result = [rs objectForColumnName:0];

 @param columnIdx Zero-based index for column.

 @return Either `NSNumber`, `NSString`, `NSData`, or `NSNull`. If the column was `NULL`, this returns `[NSNull null]` object.
 */

- (id)objectAtIndexedSubscript:(int)columnIdx;

/** Result set `NSData` value for column.

 @param columnName `NSString` value of the name of the column.

 @return `NSData` value of the result set's column.

 @warning If you are going to use this data after you iterate over the next row, or after you close the
result set, make sure to make a copy of the data first (or just use `<dataForColumn:>`/`<dataForColumnIndex:>`)
If you don't, you're going to be in a world of hurt when you try and use the data.
 
 */

- (NSData*)dataNoCopyForColumn:(NSString*)columnName NS_RETURNS_NOT_RETAINED;

/** Result set `NSData` value for column.

 @param columnIdx Zero-based index for column.

 @return `NSData` value of the result set's column.

 @warning If you are going to use this data after you iterate over the next row, or after you close the
 result set, make sure to make a copy of the data first (or just use `<dataForColumn:>`/`<dataForColumnIndex:>`)
 If you don't, you're going to be in a world of hurt when you try and use the data.

 */

- (NSData*)dataNoCopyForColumnIndex:(int)columnIdx NS_RETURNS_NOT_RETAINED;

/** Is the column `NULL`?
 
 @param columnIdx Zero-based index for column.

 @return `YES` if column is `NULL`; `NO` if not `NULL`.
 */

- (BOOL)columnIndexIsNull:(int)columnIdx;

/** Is the column `NULL`?

 @param columnName `NSString` value of the name of the column.

 @return `YES` if column is `NULL`; `NO` if not `NULL`.
 */

- (BOOL)columnIsNull:(NSString*)columnName;


/** Returns a dictionary of the row results mapped to case sensitive keys of the column names. 
 
 @returns `NSDictionary` of the row results.
 
 @warning The keys to the dictionary are case sensitive of the column names.
 */

- (NSDictionary*)resultDictionary;
 
/** Returns a dictionary of the row results
 
 @see resultDictionary
 
 @warning **Deprecated**: Please use `<resultDictionary>` instead.  Also, beware that `<resultDictionary>` is case sensitive! 
 */

- (NSDictionary*)resultDict  __attribute__ ((deprecated));

///-----------------------------
/// @name Key value coding magic
///-----------------------------

/** Performs `setValue` to yield support for key value observing.
 
 @param object The object for which the values will be set. This is the key-value-coding compliant object that you might, for example, observe.

 */

- (void)kvcMagic:(id)object;

 
@end

