//
//  String+NSNumber.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 1.03.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import Foundation

extension String {
    var number: NSNumber? {
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .decimal
        guard let number = numberFormater.number(from: self.lowercased()) else {
            numberFormater.numberStyle = .spellOut
            return numberFormater.number(from: lowercased())
        }
        return number
    }
}
