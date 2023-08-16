//
//  ContentView.swift
//  MC3_FullApp
//
//  Created by Michael Wijaya Sutrisna on 08/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        @ObservedObject var arDelegate = ARDelegate()
        
        NavigationStack {
            VStack {
                Text("Apple Feature Apps")
                    .font(.title)
                    .padding(.bottom)
                
                NavigationLink(destination: {
                    // Card Flip Game
                    ARViewRepresentable(arDelegate: arDelegate, theItem: 1)
                }, label: {
                    Text("Card Flip Feature")
                })
                .padding(.bottom)
                
                Button {
//                    MultipeerSetup(arView: SapimanARView)
                } label: {
                    Text("Check Multipeer")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
