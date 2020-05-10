//
//  RoundedViews.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class LoginRoundedButton : UIButton {
   override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius  = 5
        layer.borderColor   = UIColor.white.cgColor
        layer.borderWidth   = 1.5
    }
}



