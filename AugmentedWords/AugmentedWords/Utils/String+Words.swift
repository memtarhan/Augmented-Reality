//
//  String+Words.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 29.02.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import Foundation

extension String {
    var tokenized: [String] {
        var tokens = [String]()

        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitWhitespace, .omitPunctuation, .joinNames]

        tagger.string = self

        let mRange = NSRange(location: 0, length: utf16.count)
        tagger.enumerateTags(in: mRange, unit: .word, scheme: .tokenType, options: options) { _, range, _ in
            let word = (self as NSString).substring(with: range)
            tokens.append(word)
        }

        return tokens
    }
}
