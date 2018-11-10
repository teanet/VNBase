#import "UIImage+DGSImageFromColor.h"

@implementation UIImage(DGSImageFromColor)

+ (UIImage *)dgs_newImageFromColor:(UIColor *)color ofSize:(CGSize)size
{
	const CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage *)dgs_newStretchableImageFromColor:(UIColor *)color
{
	UIImage *fixedSizeImage = [UIImage dgs_newImageFromColor:color ofSize:CGSizeMake(1, 1)];
	return [fixedSizeImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
}

@end
