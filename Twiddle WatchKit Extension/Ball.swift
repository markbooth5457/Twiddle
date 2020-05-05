//
//  Ball.swift
//  Ping WatchKit Extension
//
//  Created by Mark Booth on 06/03/2020.
//  Copyright © 2020 Mark Booth. All rights reserved.
//

import SwiftUI

struct Ball : View {
    @ObservedObject var state = PState()

    var body: some View {
        return Circle()
            .frame(width: 10, height: 10)
            .modifier(moveBall(position: state.ballPosition))
            .animation(.easeInOut(duration:  state.transitTime))
    }
}

struct moveBall: AnimatableModifier {
    var position: CGPoint
    var animatableData: CGPoint {
        get {position}
        set { position = newValue}
    }
    
    func body(content: Content) -> some View{
        
        return content.position(position)
    }
}

struct Ball_Previews: PreviewProvider {
    static var previews: some View {
        Ball()
    }
}
