import SwiftUI

struct Pos: Hashable {
    let row: Int
    let col: Int
}

struct ContentView: View {
    var body: some View {
        ShootingGameView()
    }
}

#Preview {
    ContentView()
}

