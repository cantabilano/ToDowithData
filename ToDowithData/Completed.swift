//
//  Completed.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import SwiftUI
import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, 
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
