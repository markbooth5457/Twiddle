//
//  ContentView.swift
//  FizzBuzz WatchKit Extension
//
//  Created by Mark Booth on 17/11/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI
import WatchKit

struct FizzBuzz: View {
    @State private var count = 1
    @State private var score = 0
    @State private var hits = 0
    @State private var misses = 0
    private var watch = WKInterfaceDevice.current()
    private var isPlus1: Bool {
        return (count % 3 != 0) && (count % 5 != 0)
    }
    
    private var isFizz: Bool {
        return (count % 3 == 0) && (count % 5 != 0)
    }
    
    private var isBuzz: Bool {
        (count % 3 != 0) && (count % 5 == 0)
    }
    
    private var isFizzBuzz: Bool {
        (count % 3 == 0) && (count % 5 == 0)
    }
    
    var body: some View {
        VStack {
            Text("\(count)")
                .fontWeight(.bold)
            HStack {
                Text("Hits \(hits)")
                Spacer()
                Text("Misses \(misses)")
            }
            HStack {
                Button("+1"){
                    if self.isPlus1 {
                        self.hits += 1
                    } else {
                        self.watch.play(.failure)
                        self.misses += 1
                    }
                    self.count += 1
                    
                }
                .background(Color.gray)
                .clipShape(Capsule())
                
                Button("Fizz"){
                    if self.isFizz {
                        self.hits += 1
                    } else {
                        self.watch.play(.failure)
                        self.misses += 1
                    }
                    self.count += 1
                    
                }
                .background(Color.red)
                .clipShape(Capsule())
            }
            HStack {
                Button("Buzz"){
                    if self.isBuzz {
                        self.hits += 1
                    } else {
                        self.misses += 1
                        self.watch.play(.failure)
                    }
                    self.count += 1
                    
                }
                .background(Color.yellow)
                .clipShape(Capsule())
                
                Button("FizBuz"){
                    if self.isFizzBuzz {
                        self.hits += 1
                    } else {
                        self.watch.play(.failure)
                        self.misses += 1
                    }
                    self.count += 1
                }
                .background(Color.orange)
                .clipShape(Capsule())
            }
        }.font(.body)
            .foregroundColor(.white)
    }
}

struct FizzBuzz_Previews: PreviewProvider {
    static var previews: some View {
        FizzBuzz()
    }
}
