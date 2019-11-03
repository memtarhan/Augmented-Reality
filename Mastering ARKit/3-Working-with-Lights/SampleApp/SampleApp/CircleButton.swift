//
//  CircleButton.swift
//  SampleApp
//
//  Created by Mehmet Tarhan on 16.10.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.height / 2
    }

}
