// MapViewController.swift
import UIKit
import MapKit

class MapViewController: UIViewController {
    // MARK: - UI Components
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search countries"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var slideMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleSlideMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var slideMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 0)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private lazy var countriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Properties
    private var slideMenuLeadingConstraint: NSLayoutConstraint?
    private var isSlideMenuOpen = false
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    private var isSearching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadCountries()
        setupGestureRecognizers()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "World Map"
        view.backgroundColor = .white
        
        // Add searchBar and slideMenuButton to a toolbar
        let searchContainer = UIView()
        searchContainer.backgroundColor = .white
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchBar)
        searchContainer.addSubview(slideMenuButton)
        view.addSubview(mapView)
        
        // Add slide menu
        view.addSubview(slideMenuView)
        slideMenuView.addSubview(countriesTableView)
        
        // Initially position slide menu off-screen
        slideMenuLeadingConstraint = slideMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -280)
        
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchContainer.heightAnchor.constraint(equalToConstant: 56),
            
            slideMenuButton.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 8),
            slideMenuButton.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            slideMenuButton.widthAnchor.constraint(equalToConstant: 44),
            slideMenuButton.heightAnchor.constraint(equalToConstant: 44),
            
            searchBar.leadingAnchor.constraint(equalTo: slideMenuButton.trailingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            slideMenuView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            slideMenuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            slideMenuView.widthAnchor.constraint(equalToConstant: 280),
            slideMenuLeadingConstraint!,
            
            countriesTableView.topAnchor.constraint(equalTo: slideMenuView.topAnchor),
            countriesTableView.leadingAnchor.constraint(equalTo: slideMenuView.leadingAnchor),
            countriesTableView.trailingAnchor.constraint(equalTo: slideMenuView.trailingAnchor),
            countriesTableView.bottomAnchor.constraint(equalTo: slideMenuView.bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizers() {
        // Add tap gesture to dismiss slide menu
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideMenu(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func loadCountries() {
        // Create a comprehensive list of countries
        countries = [
            // Africa
            Country(name: "Nigeria", insects: ["Tsetse Fly", "Mosquito", "Driver Ant"], safetyTips: ["Use insect repellent", "Sleep under mosquito nets", "Wear protective clothing"]),
            Country(name: "South Africa", insects: ["Black Button Spider", "Sac Spider", "Tick"], safetyTips: ["Check bedding regularly", "Wear insect repellent", "Avoid tall grass"]),
            Country(name: "Egypt", insects: ["Death Stalker Scorpion", "Camel Spider", "Hornet"], safetyTips: ["Shake out shoes", "Avoid desert areas at night", "Use protective netting"]),
            Country(name: "Kenya", insects: ["Anopheles Mosquito", "Tsetse Fly", "African Honey Bee"], safetyTips: ["Use bed nets", "Apply repellent", "Wear long sleeves"]),
            Country(name: "Morocco", insects: ["Desert Scorpion", "Mediterranean Recluse", "Hornet"], safetyTips: ["Check bedding", "Inspect dark corners", "Use caution outdoors"]),
            
            // Americas
            Country(name: "United States", insects: ["Black Widow Spider", "Brown Recluse Spider", "Mosquitoes"], safetyTips: ["Wear insect repellent", "Avoid tall grass areas", "Check for ticks after outdoor activities"]),
            Country(name: "Brazil", insects: ["Brazilian Wandering Spider", "Kissing Bug", "Fire Ants"], safetyTips: ["Use bed nets while sleeping", "Inspect bedding regularly", "Wear closed-toe shoes outdoors"]),
            Country(name: "Canada", insects: ["Black Widow Spider", "Deer Tick", "Blackfly"], safetyTips: ["Check for ticks after hiking", "Use insect repellent", "Wear light-colored clothing"]),
            Country(name: "Mexico", insects: ["Bark Scorpion", "Black Widow", "Kissing Bug"], safetyTips: ["Shake out shoes", "Use bed nets", "Check sleeping areas"]),
            Country(name: "Argentina", insects: ["Assassin Bug", "South American Rattlesnake", "Mosquito"], safetyTips: ["Use repellent", "Avoid bushes", "Keep living areas clean"]),
            
            // Asia
            Country(name: "India", insects: ["Indian Red Scorpion", "Tiger Mosquito", "Giant Honeybee"], safetyTips: ["Use mosquito repellent", "Avoid outdoor activities at dawn/dusk", "Keep living areas clean"]),
            Country(name: "China", insects: ["Chinese Bird Spider", "Asian Giant Hornet", "Tick"], safetyTips: ["Avoid forest areas during hornet season", "Use repellent", "Check for ticks"]),
            Country(name: "Japan", insects: ["Asian Giant Hornet", "Japanese Wasp", "Tick"], safetyTips: ["Stay away from hornet nests", "Use caution in wooded areas", "Wear insect repellent"]),
            Country(name: "Thailand", insects: ["Malayan Pit Viper", "Asian Giant Hornet", "Mosquito"], safetyTips: ["Use bed nets", "Apply repellent", "Wear closed shoes"]),
            Country(name: "Vietnam", insects: ["Malaria Mosquito", "Giant Centipede", "Asian Giant Hornet"], safetyTips: ["Sleep under nets", "Check shoes", "Use repellent"]),
            
            // Europe
            Country(name: "United Kingdom", insects: ["False Widow Spider", "Horsefly", "Tick"], safetyTips: ["Check for ticks after hiking", "Use insect repellent", "Be aware in rural areas"]),
            Country(name: "France", insects: ["Asian Hornet", "Processionary Caterpillar", "Tick"], safetyTips: ["Avoid pine forests in spring", "Check for ticks", "Use caution outdoors"]),
            Country(name: "Germany", insects: ["Oak Processionary Moth", "Tick", "Hornet"], safetyTips: ["Check for ticks", "Avoid oak trees in summer", "Use repellent"]),
            Country(name: "Italy", insects: ["Violin Spider", "Tiger Mosquito", "Pine Processionary"], safetyTips: ["Use repellent", "Avoid pine forests", "Check dark corners"]),
            Country(name: "Spain", insects: ["Mediterranean Black Widow", "Processionary Caterpillar", "Tiger Mosquito"], safetyTips: ["Avoid pine trees", "Use repellent", "Be careful in rural areas"]),
            
            // Oceania
            Country(name: "Australia", insects: ["Funnel Web Spider", "Redback Spider", "Box Jellyfish"], safetyTips: ["Shake out shoes before wearing", "Avoid swimming during box jellyfish season", "Be cautious in wooded areas"]),
            Country(name: "New Zealand", insects: ["Katipo Spider", "White-tailed Spider", "Mosquito"], safetyTips: ["Check beach areas", "Use caution in garden areas", "Apply repellent"]),
            Country(name: "Fiji", insects: ["Mosquito", "Centipede", "Fire Ant"], safetyTips: ["Use bed nets", "Apply repellent", "Wear shoes outdoors"]),
            Country(name: "Papua New Guinea", insects: ["Centipede", "Scorpion", "Mosquito"], safetyTips: ["Use bed nets", "Check shoes", "Wear long sleeves"]),
            Country(name: "Solomon Islands", insects: ["Mosquito", "Centipede", "Scorpion"], safetyTips: ["Sleep under nets", "Apply repellent", "Check dark areas"])
        ]
        
        filteredCountries = countries
        countriesTableView.reloadData()
        addAnnotationsToMap()
    }
    
    private func addAnnotationsToMap() {
        // Clear existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Create and add annotations for each country
        for country in filteredCountries {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(country.name) { [weak self] placemarks, error in
                guard let self = self, error == nil, let placemark = placemarks?.first, let location = placemark.location else {
                    return
                }
                
                let annotation = CountryAnnotation(
                    coordinate: location.coordinate,
                    title: country.name,
                    subtitle: "\(country.insects.count) known dangerous insects",
                    country: country
                )
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        // Set default map region to show the whole world
        let initialLocation = CLLocation(latitude: 30.0, longitude: 0.0)
        let regionRadius: CLLocationDistance = 18000000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func filterCountries(with searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredCountries = countries
        } else {
            isSearching = true
            filteredCountries = countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
            // If search gave results, focus map on the first result
            if let firstCountry = filteredCountries.first {
                focusMapOnCountry(firstCountry.name)
            }
        }
        countriesTableView.reloadData()
        
        // Update map annotations
        addAnnotationsToMap()
    }
    
    private func focusMapOnCountry(_ countryName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(countryName) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first, let location = placemark.location else {
                return
            }
            
            // Zoom to country with animation
            let regionRadius: CLLocationDistance = 1500000 // 1500km
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.8) {
                    self.mapView.setRegion(coordinateRegion, animated: false)
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func toggleSlideMenu() {
        isSlideMenuOpen.toggle()
        
        // Animate slide menu
        slideMenuLeadingConstraint?.constant = isSlideMenuOpen ? 0 : -280
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleTapOutsideMenu(_ gesture: UITapGestureRecognizer) {
        if isSlideMenuOpen {
            let point = gesture.location(in: view)
            if !slideMenuView.frame.contains(point) {
                toggleSlideMenu()
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        
        let country = filteredCountries[indexPath.row]
        cell.configure(with: country)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = filteredCountries[indexPath.row]
        
        // Focus map on the selected country
        focusMapOnCountry(country.name)
        
        // Close slide menu
        if isSlideMenuOpen {
            toggleSlideMenu()
        }
        
        // Show country details
        let detailVC = CountryDetailViewController(country: country)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountries(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Skip user location annotation
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "CountryAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            // Add detail disclosure button
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        // Use a standard color for all pins
        if let markerAnnotationView = annotationView as? MKMarkerAnnotationView {
            markerAnnotationView.markerTintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let countryAnnotation = view.annotation as? CountryAnnotation {
            let detailVC = CountryDetailViewController(country: countryAnnotation.country)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Custom Annotation Class
class CountryAnnotation: MKPointAnnotation {
    let country: Country
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, country: Country) {
        self.country = country
        super.init()
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
