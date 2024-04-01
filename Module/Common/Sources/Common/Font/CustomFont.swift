//
//  File.swift
//  
//
//  Created by rivaldo on 01/04/24.
//

import Foundation
import UIKit

public let commonBundle = Bundle.module

public enum CustomFonts {
    public static func registerCustomFonts() {
        let fontComfortaa = [
            "Comfortaa-Bold",
            "Comfortaa-Light",
            "Comfortaa-Medium",
            "Comfortaa-Regular",
            "Comfortaa-SemiBold"
        ]
        
        let fontPoppins = [
            "Poppins-Black",
            "Poppins-BlackItalic",
            "Poppins-Bold",
            "Poppins-BoldItalic",
            "Poppins-ExtraBold",
            "Poppins-ExtraBoldItalic",
            "Poppins-ExtraLight",
            "Poppins-ExtraLightItalic",
            "Poppins-Italic",
            "Poppins-Light",
            "Poppins-LightItalic",
            "Poppins-Medium",
            "Poppins-MediumItalic",
            "Poppins-Regular",
            "Poppins-SemiBold",
            "Poppins-SemiBoldItalic",
            "Poppins-Thin",
            "Poppins-ThinItalic",
        ]
        
        for font in (fontPoppins + fontComfortaa) {
            
            _ = UIFont.registerFont(bundle: commonBundle, fontName: font, fontExtension: "ttf")
        }
    }
}

extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            return false
        }

        return true
    }
}





