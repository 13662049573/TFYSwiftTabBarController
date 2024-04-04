//
//  UIBezierPath+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2022/5/22.
//

import Foundation
import UIKit

public extension UIBezierPath {
    /**
      Creates and returns a new UIBezierPath object initialized with the text glyphs
      generated from the specified font.
     */
    class func bezierPath(with text: String, font: UIFont) -> UIBezierPath{
        let ctFont = font.toCTFont()
        let attrs = [kCTFontAttributeName: ctFont]
        let attrString = NSAttributedString(string: text, attributes: attrs as [NSAttributedString.Key : Any])
        
        let line = CTLineCreateWithAttributedString(attrString)
        let cgPath = CGMutablePath()
        let runs = CTLineGetGlyphRuns(line)
        let iRunMax = CFArrayGetCount(runs)
        for iRun in 0..<iRunMax {
            let run = Unmanaged<CTRun>.fromOpaque(CFArrayGetValueAtIndex(runs, iRun)).takeUnretainedValue()
            let runFont = unsafeBitCast(CFDictionaryGetValue(CTRunGetAttributes(run), Unmanaged.passRetained(kCTFontAttributeName).autorelease().toOpaque()), to: CTFont.self)
            let iGlyphMax = CTRunGetGlyphCount(run)
            for iGlyph in 0..<iGlyphMax {
                let glyphRange = CFRangeMake(iGlyph, 1)
                let glyph: UnsafeMutablePointer<CGGlyph> = UnsafeMutablePointer<CGGlyph>.allocate(capacity: 1)
                glyph.initialize(to: 0)
                let position: UnsafeMutablePointer<CGPoint> = UnsafeMutablePointer<CGPoint>.allocate(capacity: 1)
                position.initialize(to: CGPoint.zero)
                CTRunGetGlyphs(run, glyphRange, glyph)
                CTRunGetPositions(run, glyphRange, position)

                if let glyphPath = CTFontCreatePathForGlyph(runFont, glyph.pointee, nil) {
                    let transform = CGAffineTransform(translationX: position.pointee.x, y: position.pointee.y)
                    cgPath.addPath(glyphPath, transform: transform)
                }
            }
        }
        let path = UIBezierPath(cgPath: cgPath)
        let boundingBox = cgPath.boundingBox
        path.apply(CGAffineTransform(scaleX: 1.0, y: 1.0))
        path.apply(CGAffineTransform(translationX: 0.0, y: boundingBox.size.height))
        
        return path
    }
}

