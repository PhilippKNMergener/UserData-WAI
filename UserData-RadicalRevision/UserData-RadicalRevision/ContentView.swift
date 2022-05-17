//
//  ContentView.swift
//  UserData-RadicalRevision
//
//  Created by Philipp Mergener on 5/10/22.
//

import SwiftUI
import MapKit


struct UserDataView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let userName: String
    let dateOfBirth: Date
    
    
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.red, .orange]), center: .bottom, startRadius: 10, endRadius: 700)
                    .ignoresSafeArea()
                                    
                VStack {
                    Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding()
                        .background(.regularMaterial)
                        .clipped()
                        .shadow(color: .primary, radius: 5, x: 0, y: 0)
                        .onAppear {
                            viewModel.checkIfLocationServicesIsEnabled()
                        }
                    Text("DOB: \(dateOfBirth.formatted(date: .abbreviated, time: .omitted))")
                        .font(.body.bold())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipped()
                        .shadow(color: .primary, radius: 5, x: 0, y: 0)
        
                }
            }.navigationTitle(userName)
        }
    }
}

struct ContentView: View {
    @State private var first: String = ""
    @State private var last: String = ""
    @State private var dateOfBirth: Date = Date.now
    
    @State private var presentingDataView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .white]), center: .top, startRadius: 10, endRadius: 1000)
                    .ignoresSafeArea()
            
                VStack(spacing: 30) {
                    Spacer()
                    Text("Create Account")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .clipped()
                        .shadow(color: .primary, radius: 5, x: 0, y: 0)
                    Spacer()
                    VStack {
                        Section(header: Text("Name")) {
                            TextField("First Name", text: $first)
                            TextField("Last Name", text: $last)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipped()
                    .shadow(color: .primary, radius: 5, x: 0, y: 0)
                    VStack {
                        Section(header: Text("Date of Birth")) {
                            DatePicker("Please Enter Your Date of Birth", selection: $dateOfBirth, displayedComponents: [.date])
                                .labelsHidden()
                                .datePickerStyle(.wheel)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipped()
                    .shadow(color: .primary, radius: 5, x: 0, y: 0)
                    Spacer()
                    Button("Continue") {
                        presentDataView()
                    }
                    .fullScreenCover(isPresented: $presentingDataView) {
                        UserDataView(userName: "\(first) \(last)", dateOfBirth: self.dateOfBirth)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .shadow(color: .primary, radius: 5, x: 0, y: 0)
                    Spacer()
                }
                .navigationTitle(
                    Text("TheApp")
                )
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
    }
    
    func presentDataView() {
        self.presentingDataView.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37,
                                                                                  longitude: -121),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1,
                                                                          longitudeDelta: 0.1))
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("location services disabled alert")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location is restricted")
        case .denied:
            print("location permission denied, change in settings - location services")
        case .authorizedWhenInUse, .authorizedAlways:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                                                                             longitudeDelta: 0.05))
        @unknown default:
            return 
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
