//
//  SuperHeroView.swift
//  What If?
//
//  Created by ohoud on 02/09/1446 AH.
//

import SwiftUI

struct SuperHeroView: View {

  

    var body: some View {
   
            ZStack {
                    VStack(spacing: 20) {
                        GIFImage(name: "train1")
                            .rotationEffect(Angle(degrees: 90))
                             .edgesIgnoringSafeArea(.all)
                            .scaleEffect(CGSize(width: 0.67, height: 0.7))
                        Spacer()
                    }
                }
            }
    }

#Preview {
    SuperHeroView()
}
