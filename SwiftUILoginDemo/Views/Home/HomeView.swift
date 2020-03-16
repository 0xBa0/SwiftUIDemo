//
//  HomeView.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import SwiftUI

struct HomeNavigationView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .environmentObject(Store.shared)
                .navigationBarTitle("Cats", displayMode: .large)
                .navigationBarItems(trailing: Button(action: {
                    Store.shared.dispatch(action: .logout)
                }, label: { () in
                    Text("Log out")
                }))
        }
    }
}


struct HomeView: View {
    
    @EnvironmentObject var store: Store
    
    var viewBinding: Binding<AppState.HomeViewState> {
        $store.state.homeViewState
    }
    var viewState: AppState.HomeViewState {
        store.state.homeViewState
    }
    
    var body: some View {
        List(viewState.cats) { (cat) in
            ListRow(image: RemoteImage(url: cat.imageURL))
        }
        .onAppear {
            self.store.dispatch(action: .getCats)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ListRow: View {
    
    @ObservedObject var image: RemoteImage
    var body: some View {
        Image(uiImage: (image.data.isEmpty ? UIImage(named: "com.placeholder") : UIImage(data: image.data))!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 150)
    }
}
