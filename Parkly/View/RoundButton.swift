//
//  RoundButton.swift
//  Parkly
//
//  Created by Ben Arteaga on 5/11/20.
//  Copyright © 2020 Ben Arteaga. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }

}
