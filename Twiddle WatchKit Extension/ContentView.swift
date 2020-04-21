//
//  ContentView.swift
//  Twiddle WatchKit Extension
//
//  Created by Mark Booth on 20/04/2020.
//  Copyright © 2020 Mark Booth. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        List {
            NavigationLink(destination: BillSplit()) {
                Text("BillSplit")
                
            }    .frame(height: 100.0)
                .listRowPlatterColor(Color.yellow)
            NavigationLink(destination: FizzBuzz()){
                Text("FizzBuzz")
            }    .frame(height: 100.0)
                .listRowPlatterColor(Color.yellow)
            NavigationLink(destination: Flags()){
                Text("Flags")
            }    .frame(height: 100.0)
                .listRowPlatterColor(Color.yellow)
            NavigationLink(destination: SimonSays()){
                Text("Simon")
            }    .frame(height: 100.0)
                .listRowPlatterColor(Color.yellow)
 
        }.foregroundColor(.black)
            .font(.system(size: 30))
        
        .listStyle(CarouselListStyle())
    
        .navigationBarTitle(Text("Compendium"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
