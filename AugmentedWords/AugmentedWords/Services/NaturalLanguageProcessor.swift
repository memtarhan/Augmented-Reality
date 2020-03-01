//
//  NaturalLanguageProcessor.swift
//  AugmentedWords
//
//  Created by Mehmet Tarhan on 1.03.2020.
//  Copyright © 2020 Mehmet Tarhan. All rights reserved.
//

import UIKit

class NaturalLanguageProcessor {
    
    // MARK: - NSLinguisticTagScheme
    /*
     
     -> tokenType: Classifies tokens according to their broad type: word, punctuation, or whitespace.
     -> lexicalClass: Classifies tokens according to class: part of speech, type of punctuation, or whitespace.
     -> nameType: Classifies tokens according to whether they are part of a named entity.
     -> nameTypeOrLexicalClass: Classifies tokens corresponding to names according to nameType, and classifies all other tokens according to lexicalClass
     -> lemma: Supplies a stem form of a word token, if known.
     -> language: Supplies the language for a token, if one can be determined
     -> script: Supplies the script for a token, if one can be determined.
     
     Reference: https://developer.apple.com/documentation/foundation/nslinguistictagscheme
     
    */

    // MARK: - NSLinguisticTagger.Options
    /*
     
     -> omitWords: Omit tokens of type word (items considered to be words).
     -> omitPunctuation: Omit tokens of type punctuation (all punctuation).
     -> omitWhitespace: Omit tokens of type whitespace (whitespace of all sorts).
     -> omitOther: Omit tokens of type other (non-linguistic items, such as symbols).
     -> joinNames: Typically, multiple-word names will be returned as multiple tokens, following the standard tokenization practice of the tagger. If this option is set, then multiple-word names will be joined together and returned as a single token.
     
     Reference: https://developer.apple.com/documentation/foundation/nslinguistictagger/options

     */


    // MARK: - Identifying language of an input
    func identifyLanguage(_ input: String) -> String {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        tagger.string = input
        
        guard let identified = tagger.dominantLanguage else { return "No language identified" }
        guard let language = Locale.current.localizedString(forIdentifier: identified) else { return "No language identified" }
        return "Identified: \(language)"
    }


    // MARK: - Tokenizing an input
    func tokenize(_ input: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitWhitespace, .omitPunctuation, .joinNames]

        tagger.string = input
        
        let mRange = NSRange(location: 0, length: input.utf16.count)
        tagger.enumerateTags(in: mRange, unit: .word, scheme: .tokenType, options: options) { (tag, range, _) in
            let word = (input as NSString).substring(with: range)
            print(word)
        }
    }


    // MARK: Lemmatizing an input
    /*
     
     What is lemmatization?
        Lemmatization is the grouping together of different forms of the same word.
        In search queries, lemmatization allows end users to query any version of a base word and get relevant results.
        Because search engine algorithms use lemmatization, the user is free to query any inflectional form of a word and get relevant results.
        For example, if the user queries the plural form of a word (routers), the search engine knows to also return relevant content that uses the singular form of the same word (router).
     
     Reference: https://searchenterpriseai.techtarget.com/definition/lemmatization
     
    */

    func lemmatize(_ input: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitWhitespace, .omitPunctuation, .joinNames]

        tagger.string = input

        let mRange = NSRange(location: 0, length: input.utf16.count)
        tagger.enumerateTags(in: mRange, unit: .word, scheme: .lemma, options: options) { (tag, range, _) in
            if let lemma = tag?.rawValue {
                print(lemma)
            }
        }
    }

    // MARK: Recognizing Parts of Speech of an Input
    /*
     Prints out:
        Word: London -> Tag: Noun
        Word: the -> Tag: Determiner
        Word: capital -> Tag: Noun
        Word: of -> Tag: Preposition
        Word: England -> Tag: Noun
        Word: and -> Tag: Conjunction ...
    */

    func recognizePartsOfSpeech(_ input: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitWhitespace, .omitPunctuation, .joinNames]
        
        tagger.string = input
        
        let mRange = NSRange(location: 0, length: input.utf16.count)
        tagger.enumerateTags(in: mRange, unit: .word, scheme: .lexicalClass, options: options) { (tag, range, _) in
            if let tag = tag {
                let word = (input as NSString).substring(with: range)
                print("Word: \(word) -> Tag: \(tag.rawValue)")
            }
        }
    }

    // MARK: Recognizing Name Entities of an Input
    /*
     Prints out:
        Word: London -> Tag: PlaceName
        Word: England -> Tag: PlaceName
        Word: United Kingdom -> Tag: PlaceName
        Word: Roman -> Tag: PlaceName
        Word: Parliament -> Tag: OrganizationName
        Word: Ben -> Tag: PersonalName
        Word: Westminster Abbey -> Tag: PlaceName
        Word: London Eye -> Tag: PlaceName
        Word: South Bank -> Tag: OrganizationName
     */

    func recognizeNameEntities(_ input: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, .language, .lemma, .lexicalClass, .nameType], options: 0)
        let options: NSLinguisticTagger.Options = [NSLinguisticTagger.Options.omitWhitespace, .omitPunctuation, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        
        tagger.string = input
        
        let mRange = NSRange(location: 0, length: input.utf16.count)
        tagger.enumerateTags(in: mRange, unit: .word, scheme: .nameType, options: options) { (tag, range, _) in
            if let tag = tag,
                tags.contains(tag) {
                let name = (input as NSString).substring(with: range)
                print("Word: \(name) -> Tag: \(tag.rawValue)")
            }
        }
    }
}
