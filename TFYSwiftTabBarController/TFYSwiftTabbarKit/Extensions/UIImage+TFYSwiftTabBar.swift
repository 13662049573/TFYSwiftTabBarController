//
//  UIImage+TFYSwiftTabBar.swift
//  TFYSwiftTabBarController
//
//  Converted from UIImage+CYLTabBarControllerExtention.h/.m
//

import UIKit

extension UIImage {

    static func tfy_image(withColor color: UIColor?, size: CGSize) -> UIImage? {
        guard let color, size.width > 0, size.height > 0 else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    }

    static func tfy_image(withColor color: UIColor?, size: CGSize, cornerRadius: CGFloat) -> UIImage? {
        let fillColor = color ?? .clear
        var alpha: CGFloat = 0
        fillColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        let opaque = cornerRadius == 0 && alpha == 1
        return tfy_image(withSize: size, opaque: opaque, scale: 0) { context in
            context.setFillColor(fillColor.cgColor)
            if cornerRadius > 0 {
                let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
                path.addClip()
                path.fill()
            } else {
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
    }

    static func tfy_getImageFromImageInfo(_ imageInfo: Any?) -> UIImage? {
        if let name = imageInfo as? String {
            return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
        }
        if let image = imageInfo as? UIImage {
            return image
        }
        return nil
    }

    static func tfy_imageNamed(_ imageInfo: Any?) -> UIImage? {
        if let imageInfo {
            return tfy_getImageFromImageInfo(imageInfo)
        }
        return tfy_tabItemPlaceholderImage()
    }

    static func tfy_tabItemPlaceholderImage() -> UIImage? {
        tfy_image(withColor: .white, size: CGSize(width: 1, height: 1))
    }

    static func tfy_lightOrDarkModeImage(lightImage: UIImage?, darkImage: UIImage?) -> UIImage? {
        tfy_lightOrDarkModeImage(owner: nil, lightImage: lightImage, darkImage: darkImage)
    }

    static func tfy_lightOrDarkModeImage(
        owner: (any UITraitEnvironment)?,
        lightImageName: String,
        darkImageName: String
    ) -> UIImage? {
        tfy_lightOrDarkModeImage(
            owner: owner,
            lightImage: UIImage(named: lightImageName),
            darkImage: UIImage(named: darkImageName)
        )
    }

    static func tfy_lightOrDarkModeImage(
        owner: (any UITraitEnvironment)?,
        lightImage: UIImage?,
        darkImage: UIImage?
    ) -> UIImage? {
        var isDark = false
        if #available(iOS 13.0, *) {
            let trait = owner?.traitCollection
                ?? tfy_getWindowScene()?.traitCollection
                ?? UITraitCollection.current
            isDark = trait.userInterfaceStyle == .dark
        }
        return isDark ? darkImage : lightImage
    }

    static func tfy_assetImageName(_ assetImageName: String, userInterfaceStyle: UIUserInterfaceStyle) -> UIImage? {
        guard var image = UIImage(named: assetImageName) else { return nil }
        if #available(iOS 13.0, *) {
            let trait = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
            image = image.imageAsset?.image(with: trait) ?? image
        }
        return image
    }

    private static func tfy_image(
        withSize size: CGSize,
        opaque: Bool,
        scale: CGFloat,
        actions: (CGContext) -> Void
    ) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        actions(context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
