//
//  NLPBrain.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import Foundation
import NaturalLanguage

struct NLPBrain {
    func processSentimentAnalysis(input: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = input
        let sentiment = tagger.tag(at: input.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0
        return score
    }
}

var nlpBrain: NLPBrain = NLPBrain()
