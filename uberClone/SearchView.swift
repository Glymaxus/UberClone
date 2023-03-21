//
//  SwiftUIView.swift
//  uberClone
//
//  Created by bastien giat on 22/07/2021.
//

import SwiftUI
import CoreLocation
import MapKit

struct SearchView: View {
    @State var result : [SearchData] = []
    @State var map = MKMapView()
    @State var source : CLLocationCoordinate2D!
    @State var destination: CLLocationCoordinate2D!
    @State var name = ""
    @State var distance = ""
    @State var time = ""
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                SearchBar(map: self.$map, source: self.$source, destination: self.$destination, result: self.$result, name: self.$name, distance: self.$distance, time: self.$time)
                 Divider()
                if self.result.isEmpty {
                    List(self.result) { i in
                        VStack(alignment: .leading) {
                            Text(i.name)
                            
                            Text(i.adress)
                                .font(.caption)
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                }
            }
            .padding(.horizontal, 25)
        }
        .background(Color.black.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}

struct SearchBar: UIViewRepresentable {
    
    @Binding var map : MKMapView
    @Binding var source : CLLocationCoordinate2D!
    @Binding var destination: CLLocationCoordinate2D!
    @Binding var result : [SearchData]
    @Binding var name : String
    @Binding var distance: String
    @Binding var time: String
    
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
            let req = MKLocalSearch.Request()
            req.naturalLanguageQuery = searchText
            req.region = self.parent.map.region
            
            let search = MKLocalSearch(request: req)
            
            DispatchQueue.main.async {
                self.parent.result.removeAll()
            }
            
            search.start { res, err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                
                for i in 0..<res!.mapItems.count {
                    let temp = SearchData(id: i, name: res!.mapItems[i].name!, adress: res!.mapItems[i].placemark.title!, coordinate: res!.mapItems[i].placemark.coordinate)
                    
                    self.parent.result.append(temp)
                }
            }
        }
    }
}

struct SearchData : Identifiable {
    var id: Int
    var name: String
    var adress: String
    var coordinate : CLLocationCoordinate2D
}
