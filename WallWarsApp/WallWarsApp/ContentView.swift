//
//  ContentView.swift
//  WallWarsApp
//
//  Created by Stefano  on 04/07/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene = GameScene()
    
    var body: some View {
      
        SpriteView(scene: scene)
            .ignoresSafeArea()  
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
