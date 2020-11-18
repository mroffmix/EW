//
//  CardView.swift
//  EW
//
//  Created by Ilya on 27.10.20.
//

import SwiftUI

struct CardView: View {
    var title: String
    var value: String
    var trend: Bool
    @State var opacity: CGFloat = 0
    let action: () -> ()?
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            GroupBox{
                VStack (alignment: .leading) {
                    HStack {
                        Text("\(title)")
                            .bold()
                            .font(.callout)
                            
                        Image(systemName: trend ? "arrow.up.right" : "arrow.down.right")
                            .foregroundColor(.yellow)
                            .colorMultiply(.yellow)
                            
                        Spacer()
                    }
                    Spacer().frame(height: 6)
                    HStack {
                    Text(value)
                        .bold()
                        .font(.system(size: 20))
                        
                    }
                }.frame(height: 40)
            }
        }).buttonStyle(PlainButtonStyle())
        
        .padding(5)
        .onAppear {
            let baseAnimation = Animation.easeInOut(duration: 1)
            let repeated = baseAnimation.delay(0.5)
            return withAnimation(repeated) {
                self.opacity = 1
            }
        }
        .opacity(Double(opacity))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(title: "Air", value: "15.6 cm", trend: true, action:{})
                .environment(\.sizeCategory, .extraSmall)
                .previewLayout(.fixed(width: 150, height: 100))
            
            CardView(title: "Air", value: "15.6 cm", trend: true, action: {})
                .environment(\.sizeCategory, .small)
                .previewLayout(.fixed(width: 150, height: 100))
          
            CardView(title: "Air", value: "15.6 cm", trend: true, action: {})
                .environment(\.sizeCategory, .extraLarge)
                .previewLayout(.fixed(width: 150, height: 100))
        }
        
    }
}
