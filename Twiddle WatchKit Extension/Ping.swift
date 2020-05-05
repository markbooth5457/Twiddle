//
//  Ping.swift
//  Twiddle WatchKit Extension
//
//  Created by Mark Booth on 05/05/2020.
//  Copyright © 2020 Mark Booth. All rights reserved.
//

import SwiftUI

class PState: ObservableObject {
    enum RunState : String {
        case ready = "Ready"
        case running = "Running"
        case ended = "Ended"
    }
    @Published var paddlePosition = 0.0
    //@State private var ballDestination = CGPoint(x: 70.5, y: 70.5)
    @Published var ballPosition = CGPoint(x: 0, y: 0)
   var score = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    var runState = RunState.ready
    var radius : CGFloat = 1.0
    var circleCentre = CGPoint(x: 0, y: 0)
    var transitTime = 5.5
    var ballAngle = 0.0 // in: 0.0 ..< (2 * .pi)
    
    var collides : Bool {
        var paddleEnds = paddlePosition + Double.pi / 6
        if paddleEnds  < Double.pi * 2
        {
            return (paddlePosition <= ballAngle) && (ballAngle <= paddleEnds)
        }
        paddleEnds = paddleEnds - Double.pi * 2
        return ballAngle > paddlePosition || ballAngle < paddleEnds
    }

    func saveGeometry(geometry: GeometryProxy) {
        radius = min(geometry.size.width, geometry.size.height) / 2.0
        circleCentre = CGPoint(x: geometry.frame(in: .local).midX ,y: geometry.frame(in: .local).midY )
    }
    
    func edgePosFromAngle(_ angle: Double) -> CGPoint{
        self.ballAngle = angle // in: 0.0 ..< (2 * .pi)
        return CGPoint(x: self.circleCentre.x + (CGFloat(cos(angle)) * (self.radius - 5.0)) ,
                       y: self.circleCentre.y + (CGFloat(sin(angle)) * (self.radius - 5.0)))
    }
    func antipodeFromAngle(_ angle: Double) -> Double{
        return angle > Double.pi ? angle - Double.pi : angle + Double.pi
    }
    func reschedule() {
        DispatchQueue.main.asyncAfter(deadline: .now() + self.transitTime, execute: {
            if self.collides {
                self.score += 1
                self.transitTime -= 0.1
                let jitter = (Double.pi / 60) * Double.random(in: 0 ..< 2) // 0 ..< 6 degrees
                self.ballAngle = self.antipodeFromAngle(self.ballAngle + jitter)
                self.ballPosition = self.edgePosFromAngle(self.ballAngle)
                self.reschedule()
            } else {
                self.runState = .ended
            }
        })
    }
}

class ReadySetGo: ObservableObject {
    var rsg = "" {
        willSet {
            objectWillChange.send()
        }
    }
    init() {

    }
    func runRSG(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() +  seconds / 3 , execute: {self.rsg = "Ready"})
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds * 2 / 3 , execute: {self.rsg = "Set"})
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {self.rsg = "Go"})
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds + 0.5, execute: {
            self.rsg = ""
        })
    }
}


struct Ping: View {
    @ObservedObject var state = PState()
    @ObservedObject var rsg = ReadySetGo()
    
    fileprivate func doTap() {
        let dir = Double.random(in: 0.0 ..< (2 * .pi) )
        let newPos = state.edgePosFromAngle(dir)
        switch state.runState {
        case .ready:
        // pick a random direction and find the pos on the edge to move towards
            state.runState = .running
            state.transitTime = 0
            state.ballPosition = state.circleCentre
            state.transitTime = 4.0
            let rsgTime = 3.0
            rsg.runRSG(seconds: rsgTime)
            DispatchQueue.main.asyncAfter(deadline: .now() + rsgTime + state.transitTime, execute: {
                self.state.ballPosition = newPos
                self.state.reschedule()
            })
        case .running:
            state.runState = .ready
        case .ended:
            state.score = 0
            state.runState = .ready
        }
    }
    var body: some View {
        ZStack {
            VStack {
                Text(" \(self.state.score)")
                Text(rsg.rsg)
                Text("\(self.state.runState.rawValue )")
                }.opacity(0.5)
            ZStack{
                GeometryReader { geometry in
                    Circle()
                        .stroke(style: .init(lineWidth: 1))
                        .opacity(0.5)
                        .onAppear(){
                            self.state.saveGeometry(geometry: geometry)
                            self.state.ballPosition =  self.state.circleCentre
                            
                        } // onappear
                        
                    Arc(startAngle: Angle(radians: self.state.paddlePosition),
                        endAngle: Angle(radians: self.state.paddlePosition + Double.pi / 6),
                    clockwise: true)
                        .stroke(Color.white, lineWidth: CGFloat( 5.0))
                        .focusable()
                        .digitalCrownRotation(self.$state.paddlePosition,
                                              from: 0.0,
                                              through: Double.pi * 2,
                                              by: Double.pi / 360,
                                              sensitivity: .low,
                                              isContinuous: true)
                    
                    Ball(state: self.state)
                }// geometry
                
            } // zstack
                .padding(3)
        } // zstack
            .onTapGesture {
                self.doTap()
        }.font(.body)
        .foregroundColor(.white)
    }

}

struct Ping_Previews: PreviewProvider {
    static var previews: some View {
        Ping()
    }
}
