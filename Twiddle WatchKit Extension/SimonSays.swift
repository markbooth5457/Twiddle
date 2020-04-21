//
//  SimonSays.swift
//  Simon WatchKit Extension
//
//  Created by Mark Booth on 22/03/2020.
//  Copyright © 2020 Mark Booth. All rights reserved.
//

import SwiftUI

enum Say : String, CaseIterable {
    case red
    case yellow
    case green
    case blue
}

class SimonSpeaks: ObservableObject {
    @Published var word : Say = .blue
    @Published var siSpeaking = false
     var wordList : [Say] = []
    func append(newWord : Say) {
        wordList.append(newWord)
    }
    
    func addRead() {
        append(newWord: Say.allCases.randomElement() ?? .red)
        self.word = self.wordList[0]
        self.siSpeaking.toggle()
        readAloud()
    }
    
    func clear() {
        wordList = []
    }
    
    func restart(){
        self.clear()
        self.addRead()
    }
    
    func readAloud() {
        for i in 0 ..< wordList.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i + 1) * 1.25) {
                self.word = self.wordList[i]
                playEnum(word: self.word)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.wordList.count + 1) * 1.25) {
            self.siSpeaking.toggle()
        }
    }
    func iSay(color : Say, at : Int) -> Bool {
        return wordList[at] == color
    }
}

func playEnum(word : Say){
    switch word {
        case .blue :
            playSound(sound: "Tink", type: "aiff")
        case .green :
            playSound(sound: "Submarine", type: "aiff")
        case .red :
            playSound(sound: "Glass", type: "aiff")
        case .yellow :
            playSound(sound: "Ping", type: "aiff")
    }
}


struct SimonSays: View {
    @ObservedObject var reader = SimonSpeaks()
    @State var score = 0
    @State var hiScore = 0
    @State var slipUp = false
    @State var this = 0

    fileprivate func buttonPress(say: Say, sound: String ) {
        if self.reader.wordList.count > 0 &&
            self.reader.iSay(color: say, at: self.this) {
            playSound(sound: sound, type: "aiff")
            self.score += 1
            self.this += 1
            if self.this == self.reader.wordList.count { //matched last in list, so add another
                self.this = 0
                self.reader.addRead()
            }
        } else { // match failed
            playSound(sound: "Basso", type: "aiff")
            self.slipUp.toggle()
        }
    }
    
    fileprivate func siButton(colour: Say, sound : String, image: String) -> some View {
        return Button(action: {
            self.buttonPress(say: colour, sound: sound )
        }, label: {
            Image(systemName: image)
            
        })
            .background(colour == .red ? Color.red :
                colour == .blue ? Color.blue :
                colour == .green ? Color.green :
                Color.yellow
        )
            .clipShape(Capsule())
            .scaleEffect(reader.word == colour && reader.siSpeaking ? 1.25 : 1.0)
         .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
         .foregroundColor(reader.siSpeaking ? .gray : .black)
        .disabled(reader.siSpeaking)

    }
    
    var body: some View {
        VStack {
            Text("\(score == 0 ? "Tap text to start" : score.description)")
                .onTapGesture(count: 1){
                    self.score = 0
                    self.this = 0
                    self.reader.restart()
            }.foregroundColor(.white)
                .font(.body)

            VStack{
                HStack {
                    siButton(colour: .red, sound: "Glass", image: "hexagon" )
                    siButton(colour: .yellow, sound: "Ping", image: "square")
                }
                HStack {
                    siButton(colour: .green, sound: "Submarine", image: "circle")
                    siButton(colour: .blue, sound: "Tink", image: "triangle")
                }
           }
        } .sheet(isPresented: $slipUp, onDismiss: {
            if self.score > self.hiScore {
                self.hiScore = self.score
            }
            self.score = 0
            self.this = 0
            self.reader.clear()
        }){
            Text("Oooppss!\nYou scored \(self.score)\nHigh Score: \(self.hiScore)")
        }
    }
}



struct SimonSays_Previews: PreviewProvider {
    static var previews: some View {
        Group{
        SimonSays()
            .environment(\.colorScheme, .light)
        }
    }
}
