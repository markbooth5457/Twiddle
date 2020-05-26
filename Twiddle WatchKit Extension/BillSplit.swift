//
//  BillSplit.swift
//  Compendium WatchKit Extension
//
//  Created by Mark Booth on 24/11/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI

struct BillSplit: View {
    let tipPercentages = [10, 15, 20, 0]
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2.0
    @State private var tipPercentage = [0.0, 10.0, 12.5, 15.0, 20]
    @State private var tipIndex = defaults.double(forKey: "tipIndex")
    @State private var checkAmountHasFocus = false
    @State private var numberOfPeopleHasFocus = false
    @State private var tipPercentageHasFocus = false
    var grandTotal: Double {
        let tipSelection = Double(tipPercentage[Int(tipIndex)])
        let orderAmount = Double(checkAmount)
        let tipValue = orderAmount / 100 * tipSelection
        return orderAmount + tipValue
    }
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople )
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    var body: some View {
        VStack(alignment: .center, spacing: 8.0){
            HStack {
                Text("Bill")
                Spacer()
                Text("£\(checkAmount, specifier: "%.2f")")
            }
            .focusable(true, onFocusChange: { param in
                self.checkAmountHasFocus = param
                
            })
                .border(checkAmountHasFocus ?  Color.green : Color.black, width: 1)

                .digitalCrownRotation($checkAmount.animation(),
                                  from: 0.0,
                                  through: 2000.0,
                                  by: 0.01, sensitivity: .high)
            
            HStack(alignment: .center) {
                Text("Tip")
                Spacer()
                Text("%\(tipPercentage[Int(tipIndex)], specifier: "%.1f")")
            }
            .focusable(true, onFocusChange: { param in
                self.tipPercentageHasFocus = param
                defaults.set(self.tipIndex, forKey: "tipIndex")
            })
                .border(tipPercentageHasFocus ?  Color.green : Color.black, width: 1)
                .digitalCrownRotation($tipIndex,
                                      from: 0,
                                      through: 4,
                                  by: 1, sensitivity: .medium)
            
            HStack {
                Text("Total")
                Spacer()
                Text("£\(grandTotal, specifier: "%.2f")")
            }
            HStack {
                Text("People # ")
                Spacer()
                Text("\(Int(numberOfPeople))")
            }
             .focusable(true, onFocusChange: { param in
                self.numberOfPeopleHasFocus = param
                
            })
                .border(numberOfPeopleHasFocus ?  Color.green : Color.black, width: 1)
                .digitalCrownRotation($numberOfPeople.animation(),
                                      from: 2.0,
                                      through: 20.0,
                                      by: 1, sensitivity: .medium)
            
            HStack {
                Text("= \(totalPerPerson, specifier: "%.2f")")
                    .fontWeight(.bold)
                Spacer()
                Text("Each")
            }
        } .padding(.horizontal, 5.0)
            .foregroundColor(.white)
            .font(.body)
    }

}

struct BillSplit_Previews: PreviewProvider {
    static var previews: some View {
        BillSplit()
    }
}
