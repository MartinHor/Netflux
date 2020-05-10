//
//  UIButtonExtension.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

extension UIButton {
    
    func loadingState() {
       
        let pulse               = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration          = 0.6
        pulse.fromValue         = 0.95
        pulse.toValue           = 1.0
        pulse.autoreverses      = true
        pulse.repeatCount       = 2
        pulse.initialVelocity   = 0.5
        pulse.damping           = 1.0
        
        layer.add(pulse, forKey: nil)
        
    }
    
}
