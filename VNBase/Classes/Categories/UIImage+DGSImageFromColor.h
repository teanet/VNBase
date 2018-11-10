@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DGSImageFromColor)

/*! Create UIImage with single color with fixed size
 *  \param color The color to fill image
 *  \param size The size of the image created
 **/
+ (UIImage *)dgs_newImageFromColor:(UIColor *)color ofSize:(CGSize)size;

/*! Create UIImage with single color with fixed size
 *  \param color The color to fill image
 **/
+ (UIImage *)dgs_newStretchableImageFromColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
