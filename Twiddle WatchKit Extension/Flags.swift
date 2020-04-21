//
//  ContentView.swift
//  watch1 WatchKit Extension
//
//  Created by Mark Booth on 11/11/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI

struct Flags: View {
    @State private var flagDict = ["Malta": "🇲🇹" ,"Argentina": "🇦🇷",
    "Mauritius":"🇲🇺", "Austria":"🇦🇹", "Maldives":"🇲🇻",
    "Australia":"🇦🇺","Tajikistan":"🇹🇯","Thailand":"🇹🇭",
    "Chad":"🇹🇩","Martinique":"🇲🇶","Mauritania":"🇲🇷",
    "Antarctica":"🇦🇶","Montserrat":"🇲🇸","Togo":"🇹🇬",
    "Malawi":"🇲🇼","Mexico":"🇲🇽","Malaysia":"🇲🇾",
    "Timor-Leste":"🇹🇱","Hong Kong":"🇭🇰",
    "Afghanistan":"🇦🇫", "United Nations":"🇺🇳",
    "Albania":"🇦🇱", "Algeria":"🇩🇿", "Angola":"🇦🇴",
    "Andorra":"🇦🇩", "Tunisia":"🇹🇳", "Azerbaijan":"🇦🇿",
    "Turkey":"🇹🇷", "Tonga":"🇹🇴", "Croatia":"🇭🇷",
    "Hungary":"🇭🇺", "Taiwan":"🇹🇼", "Côte d'Ivoire":"🇨🇮",
    "Tanzania":"🇹🇿", "Cook Islands":"🇨🇰", "Oman":"🇴🇲",
    "Chile":"🇨🇱", "Vatican City":"🇻🇦", "Cameroon":"🇨🇲",
    "Luxembourg":"🇱🇺","Guernsey":"🇬🇬","Slovenia":"🇸🇮",
    "Latvia":"🇱🇻","Ghana":"🇬🇭","Gibraltar":"🇬🇮",
    "Slovakia":"🇸🇰","Libya":"🇱🇾","Greenland":"🇬🇱",

    "South Africa":"🇿🇦","Senegal":"🇸🇳","Gambia":"🇬🇲",
    "China":"🇨🇳", "Colombia":"🇨🇴", "Venezuela":"🇻🇪"
    ]
    
    // set default first selection of keys - gets reset when alert is dismissed
    @State private var keys = ["Malta", "Argentina", "Austria", "Maldives"]
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var showingScore = false
    @State private var played = 0
    @State private var correct = 0
    @State private var scoreTitle = ""
    @State private var numberTapped = 0
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // doesn't seem to work
            VStack(spacing: 5.0){
                VStack {
                    Text("Tap the flag of")
                    Text(keys[correctAnswer])
                        .foregroundColor(.white)
                        .font(.headline)
                }
                HStack{
                    Button(action: {self.flagTapped(0)
                    }) {
                        Text(self.flagDict[keys[0]]! )
                    }.font(.largeTitle)
                    
                    Button(action: {self.flagTapped(1)}
                    ) {
                        Text(self.flagDict[keys[1]]! )
                    }.font(.largeTitle)
                }
                HStack{
                    Button(action: {self.flagTapped(2)}
                    ) {
                        Text(self.flagDict[keys[2]]!)
                    }.font(.largeTitle)
                    
                    Button(action: {self.flagTapped(3)}
                    ) {
                        Text(self.flagDict[keys[3]]!)
                    }.font(.largeTitle)
                }
                Spacer()
            }
        }
        .foregroundColor(.white)
        .font(.body)
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle ), message:
                Text("\( self.flagDict [self.keys[self.numberTapped]] ?? "That " )is the flag of \n \(self.keys[self.numberTapped] )\n \(correct) out of \(played)"),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                } )
        }
    }
    func flagTapped(_ number : Int)  {
        played += 1
        numberTapped = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            correct += 1
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    func askQuestion() {
       //countries.shuffle()
        keys = flagDict.keys.shuffled()
        
        correctAnswer = Int.random(in: 0...3)
    }
    
    
    
}




struct Flags_Previews: PreviewProvider {
    static var previews: some View {
        Flags()
    }
}
