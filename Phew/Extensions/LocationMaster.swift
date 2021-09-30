//
//  LocationMaster.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

//import Foundation
////import GoogleMaps
//// import GooglePlaces
//
//protocol LocationDelegate: class {
//    func currentBus(speed: Double)
//    func centerMapOnUserLocation()
//    func locationUpdated(location: CLLocationCoordinate2D?)
//}
//
//extension LocationDelegate {
//    func currentBus(speed: Double) {}
//    func centerMapOnUserLocation() {}
//    func locationUpdated(location: CLLocationCoordinate2D?) {}
//}
//
//class LocationMaster: NSObject, CLLocationManagerDelegate {
//        
//    weak var delegate: LocationDelegate?
//    private var locationManger = CLLocationManager()
//    private var authorizationStatus = CLLocationManager.authorizationStatus()
//    
//    var isLocationEnabled: Bool {
//        return locationManger.location != nil
//    }
//    
//    var userLongitude: Double {
//        return locationManger.location?.coordinate.longitude ?? 0.0
//    }
//    
//    var userLatitude: Double {
//        return locationManger.location?.coordinate.latitude ?? 0.0
//    }
//    
//    var userLocation: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
//    }
//    
//    func fetchRoute(comp: @escaping (_ polyLineString: String) -> ()) {
//        
//        let url = URL(string: "https://nominatim.openstreetmap.org/search.php?q=New+York&polygon_geojson=1&format=json")!
//        
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!) // Here convert the data to show on map
//            comp(String(data: data, encoding: .utf8)!)
//        }
//        
//        task.resume()
//    }
//    
////    func getAddress(lat: Double, lng: Double, comp: @escaping (_ address: String?) -> ()) {
////        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&language=\(AuthService.instance.selectedLanguage ?? "en")&key=\(Constants.googleMapsKey)"
////        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) {(data, response, error) in
////            guard let data = data else { return }
////            let jsonDecoder = JSONDecoder()
////            jsonDecoder.dateDecodingStrategy = .iso8601
////            let dataModel = try? jsonDecoder.decode(LocationFetchModel.self, from: data)
////            comp(dataModel?.results?.first?.formattedAddress)
////        }
////        task.resume()
////    }
//    
//    init(delegate: LocationDelegate?) {
//        super.init()
//        self.delegate = delegate
//        locationManger.delegate = self
//        
//        if authorizationStatus == .notDetermined || authorizationStatus == .restricted {
//            locationManger.requestAlwaysAuthorization()
//            locationManger.desiredAccuracy = kCLLocationAccuracyBest
//            locationManger.requestWhenInUseAuthorization()
//            locationManger.allowsBackgroundLocationUpdates = true
//            locationManger.showsBackgroundLocationIndicator = true
//            locationManger.startUpdatingLocation()
//        } else {
//            locationManger.startUpdatingLocation()
//        }
//    }
//    
//    override init() {
//        super.init()
//        locationManger.delegate = self
//        
//        if authorizationStatus == .notDetermined || authorizationStatus == .restricted {
//            locationManger.requestAlwaysAuthorization()
//            locationManger.desiredAccuracy = kCLLocationAccuracyBest
//            locationManger.requestWhenInUseAuthorization()
//            locationManger.startUpdatingLocation()
//        } else {
//            locationManger.startUpdatingLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        delegate?.locationUpdated(location: locations.last?.coordinate)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        delegate?.centerMapOnUserLocation()
//    }
//}
//
//extension CLLocationCoordinate2D: Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}
//
//// MARK: - Welcome
//struct LocationFetchModel: Codable {
//    let plusCode: PlusCode?
//    let results: [ResultModel]?
//    let status: String?
//
//    enum CodingKeys: String, CodingKey {
//        case plusCode = "plus_code"
//        case results, status
//    }
//}
//
//// MARK: - PlusCode
//struct PlusCode: Codable {
//    let compoundCode, globalCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case compoundCode = "compound_code"
//        case globalCode = "global_code"
//    }
//}
//
//// MARK: - Result
//struct ResultModel: Codable {
//    let addressComponents: [AddressComponent]?
//    let formattedAddress: String?
//    let geometry: GeometryModel?
//    let placeID: String?
//    let plusCode: PlusCode?
//    let types: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case addressComponents = "address_components"
//        case formattedAddress = "formatted_address"
//        case geometry
//        case placeID = "place_id"
//        case plusCode = "plus_code"
//        case types
//    }
//}
//
//// MARK: - AddressComponent
//struct AddressComponent: Codable {
//    let longName, shortName: String?
//    let types: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case longName = "long_name"
//        case shortName = "short_name"
//        case types
//    }
//}
//
//// MARK: - Geometry
//struct GeometryModel: Codable {
//    let location: LocationModle?
//    let locationType: String?
//    let viewport, bounds: Bounds?
//
//    enum CodingKeys: String, CodingKey {
//        case location
//        case locationType = "location_type"
//        case viewport, bounds
//    }
//}
//
//// MARK: - Bounds
//struct Bounds: Codable {
//    let northeast, southwest: LocationModle?
//}
//
//// MARK: - Location
//struct LocationModle: Codable {
//    let lat, lng: Double?
//}
