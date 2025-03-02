//
//  test.swift
//  What If?
//
//  Created by ohoud on 02/09/1446 AH.
//

import SwiftUI
import NaturalLanguage

struct sentimentScore: View {
    @State private var generatedStory = ""
    @State private var sentimentScore: Double = 0.0

    let trainingText = """
    Once upon a time, in a distant kingdom, a fearless knight embarked on a journey through the enchanted forest. 
    The path was dark, with twisted trees whispering secrets of the past. A hidden treasure was said to be buried 
    beneath the ruins of an ancient castle, but few had dared to seek it. The knight, determined and brave, 
    ventured into the unknown. A fierce dragon guarded the entrance, its eyes glowing like embers. The battle was 
    intense, but with courage and wisdom, the knight prevailed. The village rejoiced, celebrating with feasts and songs. 

    Meanwhile, in a nearby town, a mysterious traveler spoke of an eerie cave where strange shadows danced. 
    Some claimed it held a portal to another world, while others feared the unknown forces within. A young girl, 
    filled with curiosity, decided to uncover the truth. With only a lantern and a map, she entered the cave, 
    feeling the air grow colder with each step. Suddenly, a whisper echoed through the darkness. Was it a spirit 
    or merely the wind? The girl pressed forward, her heart pounding with excitement and fear.  

    Back in the kingdom, the queen watched the stars, wondering about the fate of her lost brother. He had disappeared 
    years ago while searching for the fabled Crystal of Eternity. Legends said it granted eternal wisdom but came 
    at a great cost. Would he ever return, or had the crystal claimed another soul?  
    """

    var body: some View {
        VStack {
            Text("AI Story Generator")
                .font(.largeTitle)
                .padding()

            Text(generatedStory)
                .padding()
                .multilineTextAlignment(.center)

            Text("Sentiment Score: \(sentimentScore, specifier: "%.2f")")
                .font(.title2)
                .foregroundColor(sentimentScore >= 0 ? .green : .red)
                .padding()

            Button("Generate Story") {
                generateStory()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }

    func generateStory() {
        let markovChain = buildMarkovChain(from: trainingText)
        let story = generateTextWithStructure(from: markovChain, startPhrase: "Once upon", length: 20)
        generatedStory = story
        sentimentScore += analyzeSentiment(for: story) // Adjust score based on sentiment
    }

    // MARK: - HIGHER-ORDER MARKOV CHAIN (TRIGRAMS)
    func buildMarkovChain(from text: String) -> [String: [String]] {
        let words = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        var chain: [String: [String]] = [:]

        for i in 0..<words.count - 2 {
            let key = "\(words[i]) \(words[i + 1])" // Use 2-word sequences as keys
            let nextWord = words[i + 2]
            chain[key, default: []].append(nextWord)
        }
        return chain
    }

    func generateTextWithStructure(from chain: [String: [String]], startPhrase: String, length: Int) -> String {
        var currentPhrase = startPhrase
        var sentence = currentPhrase
        var wordCount = 0

        for _ in 0..<length {
            if let nextWords = chain[currentPhrase], !nextWords.isEmpty {
                let nextWord = nextWords.randomElement()!
                sentence += " \(nextWord)"
                wordCount += 1

                // Insert punctuation randomly after 10-15 words
                if wordCount % Int.random(in: 10...15) == 0 {
                    sentence += "."
                }

                let words = currentPhrase.components(separatedBy: " ")
                currentPhrase = "\(words.last!) \(nextWord)" // Shift to the next bigram
            } else {
                break
            }
        }
        return sentence + "."
    }

    // MARK: - IMPROVED SENTIMENT ANALYSIS
    func analyzeSentiment(for text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text

        var totalScore: Double = 0
        var count: Double = 0

        let sentences = text.components(separatedBy: ". ").filter { !$0.isEmpty }

        for sentence in sentences {
            tagger.string = sentence // Ensure the tagger is set per sentence
            let range = sentence.startIndex..<sentence.endIndex

            let sentiment = tagger.tag(at: sentence.startIndex, unit: .paragraph, scheme: .sentimentScore).0

            if let scoreString = sentiment?.rawValue, let score = Double(scoreString) {
                print("Sentence: \(sentence) | Sentiment Score: \(score)") // Debugging
                totalScore += score
                count += 1
            }
        }

        let averageScore = count > 0 ? totalScore / count : 0.0
        print("Final Sentiment Score: \(averageScore)") // Debugging

        return averageScore
    }

}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        sentimentScore()
    }
}
