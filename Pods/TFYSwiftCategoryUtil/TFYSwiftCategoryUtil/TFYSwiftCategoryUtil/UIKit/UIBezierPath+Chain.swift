//
//  UIBezierPath+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension UIBezierPath {
    
    /// 从文本和字体创建UIBezierPath对象
    /// - Parameters:
    ///   - text: 要转换为路径的文本，不能为空
    ///   - font: 用于生成字形的字体，不能为空
    /// - Returns: 包含文本路径的UIBezierPath对象，如果参数无效则返回空路径
    /// - Note: 支持iOS 15+，适配iPhone和iPad
    class func bezierPath(with text: String, font: UIFont) -> UIBezierPath {
        // 参数验证
        guard !text.isEmpty, font != UIFont.systemFont(ofSize: 0) else {
            print("⚠️ UIBezierPath: 无效的文本或字体参数")
            return UIBezierPath()
        }
        
        // 安全检查字体转换
        guard let ctFont = font.toCTFont() else {
            print("⚠️ UIBezierPath: 字体转换失败")
            return UIBezierPath()
        }
        
        // 创建属性字典
        let attrs = [kCTFontAttributeName: ctFont]
        let attrString = NSAttributedString(string: text, attributes: attrs as [NSAttributedString.Key : Any])
        
        // 创建CTLine
        let line = CTLineCreateWithAttributedString(attrString)
        
        let cgPath = CGMutablePath()
        let runs = CTLineGetGlyphRuns(line)
        let iRunMax = CFArrayGetCount(runs)
        
        // 遍历所有字形运行
        for iRun in 0..<iRunMax {
            guard let runPointer = CFArrayGetValueAtIndex(runs, iRun) else { continue }
            let run = Unmanaged<CTRun>.fromOpaque(runPointer).takeUnretainedValue()
            
            // 获取运行字体
            guard let fontPointer = CFDictionaryGetValue(CTRunGetAttributes(run), Unmanaged.passRetained(kCTFontAttributeName).autorelease().toOpaque()) else { continue }
            let runFont = unsafeBitCast(fontPointer, to: CTFont.self)
            
            let iGlyphMax = CTRunGetGlyphCount(run)
            
            // 遍历字形
            for iGlyph in 0..<iGlyphMax {
                let glyphRange = CFRangeMake(iGlyph, 1)
                
                // 分配内存并初始化
                let glyph = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                
                let position = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: CGPoint.zero)
                
                defer {
                    // 确保内存被释放
                    glyph.deallocate()
                    position.deallocate()
                }
                
                // 获取字形和位置
                CTRunGetGlyphs(run, glyphRange, glyph)
                CTRunGetPositions(run, glyphRange, position)
                
                // 创建字形路径
                if let glyphPath = CTFontCreatePathForGlyph(runFont, glyph.pointee, nil) {
                    let transform = CGAffineTransform(translationX: position.pointee.x, y: position.pointee.y)
                    cgPath.addPath(glyphPath, transform: transform)
                }
            }
        }
        
        // 创建最终路径
        let path = UIBezierPath(cgPath: cgPath)
        let boundingBox = cgPath.boundingBox
        
        // 应用变换
        path.apply(CGAffineTransform(scaleX: 1.0, y: 1.0))
        path.apply(CGAffineTransform(translationX: 0.0, y: boundingBox.size.height))
        
        return path
    }
}

