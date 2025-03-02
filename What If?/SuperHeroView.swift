//
//  SuperHeroView.swift
//  What If?
//
//  Created by ohoud on 02/09/1446 AH.
//


import Foundation
import SwiftUI
import SwiftData

struct SuperHeroView: View {
    @Environment(\.modelContext) private var modelContext
   

    var userName: String
    @State private var isTaskSheetPresented: Bool = false
    @State private var showCompletedTasks: Bool = false

    var body: some View {
   
            ZStack {
               
                    // Show original home content when all tasks are completed
                    VStack(spacing: 20) {
                
//                        Spacer()
                        
                        Text("YOU ARE A SUPERHERO!")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Tasks done and spark never sparked brighter!")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 50)
//                        Spacer()
                        
                        GIFImage(name: "dogGif")
                            .frame(width: 200, height: 200)
                            .edgesIgnoringSafeArea(.all)
                            .offset(x: 0,y: 850)
                            .scaleEffect(CGSize(width: 0.06, height: 0.06))
                        Spacer()
                    }
                }
                
                
                // Button to view completed tasks
                VStack {
                    Spacer()
                    Button(action: {
                        showCompletedTasks.toggle()
                    }) {
                        HStack{
                            Text("")
                                .underline()
                        }
                        .font(.callout)
                        .foregroundColor(.orange)
                        .padding(.bottom, 20)
                    }
                                    }
            }
    }




#Preview {
    SuperHeroView(userName: "x")
}
