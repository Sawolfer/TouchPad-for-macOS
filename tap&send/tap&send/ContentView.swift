import SwiftUI
import MultipeerConnectivity


struct ContentView: View {
    
    @StateObject var colorSession = ColorMultipeerSession()
    
    var body: some View {
        ZStack {
            Color(.darkGray)
                .edgesIgnoringSafeArea(.all)
            
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
