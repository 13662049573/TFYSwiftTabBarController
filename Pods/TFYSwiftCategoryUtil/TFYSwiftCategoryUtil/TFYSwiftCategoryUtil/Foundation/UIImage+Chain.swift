//
//  UIImage+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/15.
//  用途：UIImage 链式编程扩展，支持图片处理、GIF 动画、滤镜效果等功能。
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import UIKit
import Accelerate

public extension UIImage {
    /// 圆角图片处理
    func image(corners:UIRectCorner = .allCorners, cornerRadii radii:CGSize) -> UIImage {
        let bounds = CGRect(origin: .zero, size: size)
        
        let opaque:Bool = false
        let scale:CGFloat = 0
        
        let layer = CALayer()
        layer.frame = bounds
        layer.contents = self
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, scale)
        if radii.width != 0 || radii.height != 0 {
            
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
            //  进行路劲裁切   后续的绘图都会出现在圆形内  外部的都被干掉
            path.addClip()
        }
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage ?? self
    }
    
    /// 根据颜色生成图片
    func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 2, height: 2)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let insets: UIEdgeInsets  = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        return image
    }

    /// 调整图片大小
    func resizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage ?? self
    }
    
    /// 压缩图片
    func compressSize() -> UIImage {
        guard let data = self.jpegData(compressionQuality: 1) else { return self }
        let imageLength = data.count
        if imageLength > 300000 {
            let rate = max(0.1, min(1.0, 300000.0 / Double(imageLength)))
            guard let data = self.jpegData(compressionQuality: CGFloat(rate)) else { return self }
            let image = UIImage(data: data) ?? self
            return image
        }
        return self
    }
    
    /// 压缩图片到指定大小
    /// - Parameter maxSize: 最大文件大小（字节）
    /// - Returns: 压缩后的图片
    func compressToSize(_ maxSize: Int) -> UIImage {
        guard maxSize > 0 else { return self }
        guard let data = self.jpegData(compressionQuality: 1) else { return self }
        let imageLength = data.count
        if imageLength > maxSize {
            let rate = max(0.1, min(1.0, Double(maxSize) / Double(imageLength)))
            guard let data = self.jpegData(compressionQuality: CGFloat(rate)) else { return self }
            let image = UIImage(data: data) ?? self
            return image
        }
        return self
    }

    /// 从Data创建GIF图片
    class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    /// 从URL创建GIF图片
    class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    /// 从Bundle创建GIF图片
    class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    @available(iOS 9.0, *)
    class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}

public extension UIImage {
    /// 应用亮光效果
    func applyLightEffect() -> UIImage? {
        return applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    /// 应用超亮效果
    func applyExtraLightEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    /// 应用暗光效果
    func applyDarkEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    /// 应用指定颜色的色调效果
    func applyTintEffectWithColor(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    /// 应用模糊效果
    func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        guard let cgImage = self.cgImage else {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(Float.ulpOfOne)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            guard let effectInContext = UIGraphicsGetCurrentContext() else { return  nil }
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(cgImage, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            
            guard let effectOutContext = UIGraphicsGetCurrentContext() else { return  nil }
            var effectOutBuffer = createEffectBuffer(effectOutContext)
            
            
            if hasBlur {
                let inputRadius = blurRadius * screenScale
                let d = floor(inputRadius * 3.0 * Double(sqrt(2 * Double.pi) / 4 + 0.5))
                var radius = UInt32(d)
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        
        guard let outputContext = UIGraphicsGetCurrentContext() else { return nil }
        
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext.draw(cgImage, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext.saveGState()
            if let maskCGImage = maskImage?.cgImage {
                outputContext.clip(to: imageRect, mask: maskCGImage);
            }
            outputContext.draw(effectImage.cgImage!, in: imageRect)
            outputContext.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext.saveGState()
            outputContext.setFillColor(color.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    /// 根据系统主题创建适配图片
    static func image(light: UIImage?, dark: UIImage?) -> UIImage? {
        if #available(iOS 13.0, *) {
            guard let weakLight = light, let weakDark = dark, let config = weakLight.configuration else { return light }
            let lightImage = weakLight.withConfiguration(config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.light)))
            lightImage.imageAsset?.register(weakDark, with: config.withTraitCollection(UITraitCollection(userInterfaceStyle: UIUserInterfaceStyle.dark)))
            return lightImage.imageAsset?.image(with: UITraitCollection.current) ?? light
        } else {
            return dark
        }
    }
    
    /// 从字符串创建二维码
    convenience init?(qrCodeFrom string: String) {
        guard !string.isEmpty else { return nil }
        if let data = string.data(using: .ascii), let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform) {
                self.init(ciImage: output)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// 绘制星形图片
    static func withStarShape(size: CGSize, strokeColor: UIColor = .clear, lineWidth: CGFloat = 2.0, fillColor: UIColor?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        let starPath = UIBezierPath()
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let numberOfPoints = CGFloat(5.0)
        let numberOfLineSegments = Int(numberOfPoints * 2.0)
        let theta = .pi / numberOfPoints
        
        let circumscribedRadius = center.x
        let outerRadius = circumscribedRadius * 1.039
        let excessRadius = outerRadius - circumscribedRadius
        let innerRadius = CGFloat(outerRadius * 0.382)
        
        let leftEdgePointX = (center.x + cos(4.0 * theta) * outerRadius) + excessRadius
        let horizontalOffset = leftEdgePointX / 2.0
        
        // Apply a slight horizontal offset so the star appears to be more
        // centered visually
        let offsetCenter = CGPoint(x: center.x - horizontalOffset, y: center.y)
        
        // Alternate between the outer and inner radii while moving evenly along the
        // circumference of the circle, connecting each point with a line segment
        for i in 0..<numberOfLineSegments {
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            
            let pointX = offsetCenter.x + cos(CGFloat(i) * theta) * radius
            let pointY = offsetCenter.y + sin(CGFloat(i) * theta) * radius
            let point = CGPoint(x: pointX, y: pointY)
            
            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
        }
        
        starPath.close()
        
        // Rotate the path so the star points up as expected
        var pathTransform  = CGAffineTransform.identity
        pathTransform = pathTransform.translatedBy(x: center.x, y: center.y)
        pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
        pathTransform = pathTransform.translatedBy(x: -center.x, y: -center.y)
        
        starPath.apply(pathTransform)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.addPath(starPath.cgPath)
            context.setLineWidth(lineWidth)
            context.setStrokeColor(strokeColor.cgColor)
            if let fillColor = fillColor {
                context.setFillColor(fillColor.cgColor)
            }
            context.drawPath(using: CGPathDrawingMode.fillStroke)
            
        } else {
            print("Error: UIGraphicsGetCurrentContext() returns nil when drawing star shape!")
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    }
    
    
    /// 返回指定色调颜色的相同图片
    func withTintColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let maskImage = cgImage, let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.colorBurn)
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    }
    
    /// 是否为正方形
    var isSquare: Bool {
        return size.height == size.width
    }
    
    /// 磁盘上的大小（KB或MB）
    var sizeOnDisk: String {
        guard let data = self.jpegData(compressionQuality: 1.0) else { return "0KB" }
        var length = Double(data.count) / 1024 / 1024
        if length < 1.0 {
            length *= 1024
            return "\(length)KB"
        } else {
            return "\(length)MB"
        }
    }
    
    
    /// 屏幕宽度对应的高度
    var heightForScreenWidth: CGFloat {
        return aspectHeight(for: UIScreen.main.bounds.width)
    }
    
    /// 按比例缩放给定宽度的高度
    func aspectHeight(for width: CGFloat) -> CGFloat {
        guard width > 0 else { return 0 }
        return width / size.width * size.height
    }
    
    
    /// 按比例缩放给定高度的宽度
    func aspectWidth(for height: CGFloat) -> CGFloat {
        guard height > 0 else { return 0 }
        return height / size.height * size.width
    }
    
    
    /// 保持宽高比并返回给定大小的适配尺寸
    func aspectFitSize(forBindingSize binding: CGSize) -> CGSize {
        let rw = size.width / binding.width
        let rh = size.height / binding.height
        if rw < rh {
            return CGSize(width: size.width / rh, height: binding.height)
        } else {
            return CGSize(width: binding.height, height: size.height / rw)
        }
    }
    
    /// 获取纯色图片
    class func image(withPureColor color: UIColor, for rect: CGRect, rounded: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        if rounded {
            context?.fillEllipse(in: rect)
        } else {
            context?.fill(rect)
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// 修正图片方向
    var orientationFixed: UIImage {
        
        if imageOrientation == .up {
            return self
        }
        
        guard let cgImage = cgImage else {
            return self
        }
        
        let width = size.width
        let height = size.height
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: .pi)

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: .pi / 2)

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -(.pi / 2))

        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break
        }
        
        guard let space = cgImage.colorSpace else { return self }
        let ctx = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: space,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        guard let cgimg = ctx.makeImage() else {
            return self
        }
        return UIImage(cgImage: cgimg)
    }
    
    
    /// 获取图片的特定部分
    func subImage(in rect: CGRect) -> UIImage? {
        if let cgimage = cgImage, let image = cgimage.cropping(to: rect) {
            return UIImage(cgImage: image, scale: 1.0, orientation: .up)
        }
        return nil
    }

    
    /// 重绘图片到指定尺寸
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizedImageWithAspectFitSize(forBindingSize binding: CGSize) -> UIImage? {
        return resized(to: aspectFitSize(forBindingSize: binding))
    }
    
    
    /// 调整图片大小使其宽高相等
    func square() -> UIImage? {
        let edgeLength = max(size.width, size.height)
        let contextSize = CGSize(width: edgeLength, height: edgeLength)
        
        UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        let origin = CGPoint(x: (contextSize.width - size.width) / 2, y: (contextSize.height - size.height) / 2)
        draw(in: CGRect(origin: origin, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 根据给定要求重绘新图片
    func with(backgroundColor: UIColor, cornerRadius: CGFloat, insets: UIEdgeInsets) -> UIImage? {
        let contextSize = CGSize(width: size.width + insets.left + insets.right,
                                 height: size.height + insets.top + insets.bottom)
        UIGraphicsBeginImageContextWithOptions(contextSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
       
        let context = UIGraphicsGetCurrentContext()
        let contextRect = CGRect(origin: .zero, size: contextSize)
        let backgroundPath = UIBezierPath(roundedRect: contextRect, cornerRadius: cornerRadius)
        context?.addPath(backgroundPath.cgPath)
        context?.setFillColor(backgroundColor.cgColor)
        context?.fillPath()
        draw(in: CGRect(origin: CGPoint(x: insets.left, y: insets.top), size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    enum ArrowDirection {
        case up, down, left, right
    }
    
    /// 创建箭头图片
    static func arrowHead(direction: ArrowDirection, color: UIColor, size: CGSize, lineWidth: CGFloat = 2.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        
        switch direction {
        case .up:
            context?.move(to: rect.bottomLeft)
            context?.addLine(to: rect.topMiddle)
            context?.addLine(to: rect.bottomRight)

        case .down:
            context?.move(to: rect.topLeft)
            context?.addLine(to: rect.bottomMiddle)
            context?.addLine(to: rect.topRight)

        case .left:
            context?.move(to: rect.topRight)
            context?.addLine(to: rect.leftMiddle)
            context?.addLine(to: rect.bottomRight)

        case .right:
            context?.move(to: rect.topLeft)
            context?.addLine(to: rect.rightMiddle)
            context?.addLine(to: rect.bottomLeft)
        }
        
        context?.setLineCap(.round)
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(color.cgColor)
        context?.strokePath()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// 绘制带边框的图片
    class func borderImage(size: CGSize, backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(borderColor.cgColor)
        context?.setLineWidth(borderWidth)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size).insetBy(dx: borderWidth / 2, dy: borderWidth / 2), cornerRadius: cornerRadius)
        context?.addPath(path.cgPath)
        context?.strokePath()
        context?.setFillColor(backgroundColor.cgColor)
        context?.fillPath()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// 绘制背景图片
    class func buttonBackgroundBorderImage(backgroundColor: UIColor, borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) -> UIImage? {
        let inset = borderWidth + cornerRadius + 2
        let width = inset * 2 + 1
        return borderImage(size: CGSize(width: width, height: width), backgroundColor: backgroundColor, borderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius)?.resizableImage(withCapInsets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset), resizingMode: .stretch)
    }
    
    /// 高斯模糊
    static func gaussianBlur(image: UIImage, sigma: Float) -> UIImage? {
        guard let beginImage = CIImage(image: image) else { return nil }
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(beginImage, forKey: kCIInputImageKey)
        blurFilter.setValue(sigma, forKey: "inputRadius")
     
        let resultImage = blurFilter.outputImage
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(resultImage!, from: resultImage!.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    /// 获取pod bundle图片资源
    convenience init?(named name: String, podClass: AnyClass, bundleName: String? = nil) {
        let bName = bundleName ?? "\(podClass)"
        if let image = UIImage(named: "\(bName).bundle/\(name)"), let cgImage = image.cgImage{
            self.init(cgImage: cgImage)
        } else {
            let filePath = Bundle(for: podClass).resourcePath! + "/\(bName).bundle"
            guard let bundle = Bundle(path: filePath) else { return nil}
            self.init(named: name, in: bundle, compatibleWith: nil)
        }
    }

    /// 获取pod bundle图片资源
    convenience init?(named name: String, podName: String, bundleName: String? = nil) {
        let bName = bundleName ?? podName
        if let image = UIImage(named: "\(bName).bundle/\(name)"), let cgImage = image.cgImage{
            self.init(cgImage: cgImage)
        } else {
            let filePath = Bundle.main.resourcePath! + "/Frameworks/\(podName).framework/\(bName).bundle"
            guard let bundle = Bundle(path: filePath) else { return nil}
            self.init(named: name, in: bundle, compatibleWith: nil)
        }
    }
    
    /// 生成二维码图片
    static func generateQRCode(_ string: String, width: CGFloat, height: CGFloat) -> UIImage? {
        guard !string.isEmpty, width > 0, height > 0 else { return nil }
        guard let data: Data = string.data(using: .isoLatin1, allowLossyConversion: false),
            let filter = CIFilter(name: "CIQRCodeGenerator") else {
                return nil
        }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        
        guard let qrcodeImage = filter.outputImage else {
            return nil
        }
        
        // 消除模糊
        let scaleX: CGFloat = width/qrcodeImage.extent.size.width
        // extent 返回图片的frame
        let scaleY: CGFloat = height/qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transformedImage)
    }

    /// 生成带Logo的二维码图片
    static func generateQRCodeImage(_ string: String, size: CGSize, logo: UIImage?) -> UIImage? {
        guard !string.isEmpty, size.width > 0, size.height > 0 else { return nil }
        guard let data: Data = string.data(using: .isoLatin1, allowLossyConversion: false),
            let filter = CIFilter(name: "CIQRCodeGenerator") else {
                return nil
        }

        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel")
        guard let qrcodeImage = filter.outputImage else {
            return nil
        }
        // 消除模糊
        let scaleX: CGFloat = size.width/qrcodeImage.extent.size.width
        // extent 返回图片的frame
        let scaleY: CGFloat = size.height/qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        // 返回二维码图片
        var qrImage = UIImage(ciImage: transformedImage)
        if let colorFilter = CIFilter(name: "CIFalseColor") {
            // 创建颜色滤镜
            colorFilter.setDefaults()
            colorFilter.setValue(transformedImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            if let outputImage = colorFilter.outputImage {
                qrImage = UIImage(ciImage: outputImage)
            }
        }
                
        let imageRect = size.width > size.height ?
            CGRect(x: (size.width - size.height) / 2, y: 0, width: size.height, height: size.height) :
            CGRect(x: 0, y: (size.height - size.width) / 2, width: size.width, height: size.width)
            UIGraphicsBeginImageContextWithOptions(imageRect.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        qrImage.draw(in: imageRect)
        if let logo = logo {
            let logoSize = size.width > size.height ?
                CGSize(width: size.height * 0.25, height: size.height * 0.25) :
                CGSize(width: size.width * 0.25, height: size.width * 0.25)
            logo.draw(in: CGRect(x: (imageRect.size.width - logoSize.width)/2,
                                 y: (imageRect.size.height - logoSize.height)/2,
                                 width: logoSize.width,
                                 height: logoSize.height))
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
