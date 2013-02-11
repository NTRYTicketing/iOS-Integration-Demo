//
//  BITBarcodeView.m
//  NTRY Integration Demo
//
//  Created by Klaus Kuehnhammer on 2/11/13.
//  Copyright (c) 2013 Bitstem Software. All rights reserved.
//

#import "BITBarcodeView.h"
@interface BITBarcodeView ()
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,assign) CGFloat cellWidth;
@end

@implementation BITBarcodeView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ( self.aztecData && self.aztecData.count) {
        if ( self.cellHeight == 0 ) {
            //calculate cell dimensions
            self.cellHeight = rect.size.height / self.aztecData.count;
            self.cellWidth = rect.size.width / ((NSArray*)[self.aztecData objectAtIndex:0]).count;
        }
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        float x = 0, y = 0;
        for (int row = 0; row < self.aztecData.count; ++row) {
            for (int col = 0; col < ((NSArray*)self.aztecData[row]).count; ++col) {
                if ( [self.aztecData[row][col] intValue] == 1 ) {
                    CGRect cell = CGRectMake(x, y, self.cellWidth, self.cellHeight);
                    CGContextFillRect(c, cell);
                }
                x += self.cellWidth;
            }
            y += self.cellHeight;
            x = 0;
        }
    }

}


@end
