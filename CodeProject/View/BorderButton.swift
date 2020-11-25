//
//  BorderButton.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import UIKit

class BorderButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.separator.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}
