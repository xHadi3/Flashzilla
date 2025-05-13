import SwiftUI

struct CardView: View {
    let card: Card
    
    
    @State private var isShowingAnswer = false
    
    // Tracks how much the card has been dragged
    @State private var offset = CGSize.zero
    
    // Optional closure to call when the card should be removed
    var removal: (() -> Void)? = nil
    
   
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(offset.width > 0 ? .green : .red)
                
                )
                .shadow(radius: 10)
            
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)  
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        
        // Rotate the card while dragging (adds realism)
        .rotationEffect(.degrees(offset.width / 5.0))
        
        // Move the card based on drag offset
        .offset(x: offset.width * 5)
        
        // Fade the card out as it's dragged further
        .opacity(2 - Double(abs(offset.width / 50)))
        
        // Handle drag gesture (swipe)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Update offset as the user drags
                    offset = gesture.translation
                }
                .onEnded { _ in
                    // If dragged far enough, trigger removal
                    if abs(offset.width) > 100 {
                        removal?()
                    } else {
                        // Otherwise, snap back to original position
                        offset = .zero
                    }
                }
        )
        
        // Toggle showing the answer when tapped
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.default, value: offset)
    }
        
    
}

#Preview {
    CardView(card: .example)
}
