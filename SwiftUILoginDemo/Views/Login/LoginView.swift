//
//  LoginView.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/12.
//

import SwiftUI

struct LoginNavigationView: View {
    var body: some View {
        NavigationView {
            LoginView()
                .environmentObject(Store.shared)
                .navigationBarTitle("Log in", displayMode: .inline)
        }
    }
}

struct LoginView: View {
    
    @EnvironmentObject var store: Store
    var viewBinding: Binding<AppState.LoginViewState> {
        $store.state.loginViewState
    }
    var viewState: AppState.LoginViewState {
        store.state.loginViewState
    }
    
    var body: some View {

        VStack {
            Spacer()
            Image("auth.logo")
            Spacer().frame(height: 30)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer(minLength: 10)
                    Image("auth.account")
                    TextField("Please enter email", text: viewBinding.email)
                        .frame(height: 50)
                        .foregroundColor(Color.white)
                }
                Divider().background(Color.white)
                HStack {
                    Spacer(minLength: 10)
                    Image("auth.password")
                    
                    if viewState.showPassword {
                        TextField("Please enter password", text: viewBinding.password)
                            .frame(height: 50)
                            .foregroundColor(Color.white)
                    }
                    else {
                        SecureField("Please enter password", text: viewBinding.password)
                            .frame(height: 50)
                            .foregroundColor(Color.white)
                    }
                    
                    Button(action: {
                        self.store.dispatch(action: .showHidePassword)
                    }) {
                        Image(viewState.showPassword ? "auth.showPassword" : "auth.hidePassword")
                            .foregroundColor(Color.white)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16).foregroundColor(Color("translucentWhite"))
            )
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
            
            
            Button(action: {
                self.store.dispatch(action: .login(email: self.viewState.email,
                                                   password: self.viewState.password))
            }) {
                Spacer()
                Text("Login").foregroundColor(Color.white)
                Spacer()
            }
            .frame(height: 50)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("darkBlue")))
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                        
            HStack {
                Button(action: {
                    print("Rest Password test")
                }) {
                    Text("Reset Password").foregroundColor(.white)
                }

                Spacer()
                
                NavigationLink(destination: RegistView().environmentObject(Store.shared), isActive: viewBinding.gotoRegisterView) {
                    Text("Regist").foregroundColor(.white)
                }
            }
            .frame(height: 50)
            .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))

            Spacer()
        }
        .background(Color("darkSkyBlue"))
        .edgesIgnoringSafeArea(.bottom)
        .alert(item: viewBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
        .modifier(LoadingModifier(isLoading: viewBinding.isRequesting))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(Store())
    }
}
