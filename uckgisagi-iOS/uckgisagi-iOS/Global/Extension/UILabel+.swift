//
//  UILabel+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import UIKit

extension UILabel {
    func bold(targetString: String, targetFont: UIFont? = nil) {
        let fontSize = font.pointSize
        let font = targetFont ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        let fullText = text ?? ""
        let fullRange = (fullText as NSString).range(of: fullText)
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedString.addAttribute(.foregroundColor, value: textColor ?? Color.black, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: Color.black, range: range)

        attributedText = attributedString
    }

    func highlighted(targetString: String, targetColor: UIColor? = nil) {
        let fullText = text ?? ""
        let fullRange = (fullText as NSString).range(of: fullText)
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: textColor ?? Color.black, range: fullRange)
        attributedString.addAttribute(.foregroundColor, value: targetColor ??  Color.black, range: range)

        attributedText = attributedString
    }

    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        return index
    }
}
