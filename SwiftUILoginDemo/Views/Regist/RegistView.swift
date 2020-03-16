//
//  RegistView.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/19.
//

import SwiftUI

struct RegistView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var store: Store
    var viewBinding: Binding<AppState.RegistViewState> {
        $store.state.registViewState
    }
    var viewState: AppState.RegistViewState {
        store.state.registViewState
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("auth.logo2").shadow(radius: 2)
            Text("Please register with your email").foregroundColor(Color("darkSkyBlue"))
            Spacer().frame(height: 30)

            VStack(spacing: 14) {
                HStack {
                    Spacer(minLength: 10)
                    Image("auth.account").renderingMode(.template).foregroundColor(Color("lightGray"))
                    TextField("Please enter email", text: viewBinding.email)
                        .frame(height: 44)
                        .foregroundColor(Color("darkSkyBlue"))
                }
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("lightGray"), lineWidth: 0.5))

                HStack {
                    Spacer(minLength: 10)
                    Image("auth.password").renderingMode(.template).foregroundColor(Color("lightGray"))
                    SecureField("Please enter password", text: viewBinding.password)
                        .frame(height: 44)
                        .foregroundColor(Color("darkSkyBlue"))
                }
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("lightGray"), lineWidth: 0.5))

                HStack {
                    Spacer(minLength: 10)
                    Image("auth.password").renderingMode(.template).foregroundColor(Color("lightGray"))
                    SecureField("Please enter password again", text: viewBinding.verifyPassword)
                        .frame(height: 44)
                        .foregroundColor(Color("darkSkyBlue"))
                }
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("lightGray"), lineWidth: 0.5))

                Button(action: {
                    self.store.dispatch(action: .regist(email: self.viewState.email,
                                                        password: self.viewState.password,
                                                        verifyPassword: self.viewState.verifyPassword))
                }) {
                    Spacer()
                    Text("Regist").foregroundColor(Color.white)
                    Spacer()
                }
                .frame(height: 50)
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("darkBlue")))
            }
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))

            Spacer()
        }
        .alert(item: viewBinding.registError) { error in
            Alert(title: Text(error.localizedDescription))
        }
        .modifier(LoadingModifier(isLoading: viewBinding.isRequesting))
        .navigationBarTitle("Regist", displayMode: .inline)
    }
}

struct RegistView_Previews: PreviewProvider {
    static var previews: some View {
        RegistView().environmentObject(Store.shared)
    }
}


