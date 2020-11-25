//
//  ViewWithIcon.swift
//  EWWidgetsExtension
//
//  Created by Ilya on 19.11.20.
//

import SwiftUI
import WidgetKit

struct ViewWithIcon: View {
    @State var imageName: String
    @State var value: String
    @State var trend: Bool
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
            
            
//            Image(systemName: trend ? "arrow.up.right" : "arrow.down.right")
//                .resizable()
//                .frame(width: 8, height: 8, alignment: .center)
//                .foregroundColor(.yellow)
//                .colorMultiply(.yellow)
//                .padding(.trailing, 8)
            
            Text(value)
                .bold()
                .font(.callout)
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct ViewWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ViewWithIcon(imageName: "water", value: "145cm", trend: true)
                .previewLayout(.fixed(width: 150, height: 100))
            ViewWithIcon(imageName: "air", value: "145cm", trend: false)
                .previewLayout(.fixed(width: 150, height: 100))
            ViewWithIcon(imageName: "waterlevel", value: "145cm/dd", trend: true)
                .previewLayout(.fixed(width: 150, height: 100))
        }.previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
