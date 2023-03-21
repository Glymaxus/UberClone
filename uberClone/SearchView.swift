//
//  SwiftUIView.swift
//  uberClone
//
//  Created by bastien giat on 22/07/2021.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SearchBar: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return SearchBar.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let view = UISearchBar()
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.delegate = context.coordinator
        
        return view
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        
    }
    
    class Coordinator : NSObject, UISearchBarDelegate {
        
        var parent : SearchBar
        
        init(parent1: SearchBar) {
            parent = parent1
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print(searchText)
        }
    }
}
