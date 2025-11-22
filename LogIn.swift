//
//  SwiftUIView.swift
//  SecondServe
//
//  Created by Marc Rodenas Guasch on 21/11/25.
//

import SwiftUI

struct LogIn: View {
    @State private var LogInEmail: String = ""
    @State private var LogInPassWord: String = ""
    @State private var isLoading = false
    @State private var status: String? = nil
    
    var body: some View {
        // Informative Text
        Text("Second Serve")
            .offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -140.0)
            .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
        Text("Sign into account")
            .offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -20)
            .font(.system(size: 19, design: .rounded))
            .bold()
        
        TextField("email@‎domain.com", text: $LogInEmail)
            .frame(width: 330, height: 47.0)
            .padding(26.0)
            .textFieldStyle(.roundedBorder)
            .offset(x:0.0, y:-28.0)
        TextField("password", text: $LogInPassWord)
            .frame(width: 330, height: 47.0)
            .padding(26.0)
            .textFieldStyle(.roundedBorder)
            .offset(x:0.0, y:-90.0)
        Button("Continue") {
            // INCLUDE ANY CONTINUE ACTIONS HERE --> this is for deepak
        }.padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/).frame(width: 330.0, height: 47.0).background(Color.black).foregroundColor(.white).font(.system(size: 19, design: .rounded)).clipShape(RoundedRectangle(cornerRadius: 10)).offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/-70.0/*@END_MENU_TOKEN@*/)
    }
    

}

#Preview {
    LogIn()
}
