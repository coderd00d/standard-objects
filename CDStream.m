//
//  CDStream.m
//  standard library
//
//
// version 1.0.0-alpla
//
// The MIT License (MIT)
//
// Copyright (c) 2014 coderd00d
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "CDStream.h"

@implementation CDStream {
    unsigned int bufferSize;
    bool removeEOL;
}

/*******************************************************/

-(instancetype) init {
    return [self initWithBufferSize: DEFAULT_BUFFER_SIZE];
}

/*******************************************************/

-(instancetype) initWithBufferSize: (unsigned) n {
    self = [super init];
    if (self) {
        bufferSize = n;
        removeEOL = false;
    }
    return self;
}

/*******************************************************/

- (NSString *) getline {
    
    char *line = malloc(self->bufferSize);
    char *linep = line;
    unsigned long lenmax = self->bufferSize;
    unsigned long len = lenmax;
    int c;
    NSString *s = nil;
    
    if (line == NULL)
        return nil;
    
    for (;;) {
        c = fgetc(stdin);
        if (c == EOF)
            break;
        
        if (--len == 0) {
            len = lenmax;
            char *linen = realloc(linep, lenmax *= 2);
            
            if (linen == NULL) {
                free(linep);
                return nil;
            }
            line = linen + (line - linep);
            linep = linen;
        }
        if (c == '\n') {
            if (self->removeEOL) {
                self->removeEOL = false;
            } else {
                *line++ = c;
            }
            break;
        }
        *line++ = c;
    }
    *line = '\0';
    
    s = [[NSString alloc ] initWithCString: linep
                                  encoding: NSASCIIStringEncoding];
    return s;
}

/*******************************************************/

- (NSString *) getlineWithNoEOL {
    self->removeEOL = true;
    return [self getline];
}

/*******************************************************/


- (NSArray *) wordParseString: (NSString *) s {
    return [s componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
