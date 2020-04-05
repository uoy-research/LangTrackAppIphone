//
//  InsetLabel.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import UIKit

class InsetLabel: UILabel {

    var contentInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }

    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }

}
