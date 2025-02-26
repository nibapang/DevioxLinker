//
//  HomeVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit
import SDWebImage

class DevioxHomeVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var constViewHeaderHeight: NSLayoutConstraint!
    
    var loadedIndexes: [IndexPath] = []
    
    var isChanging: Bool = false
    var isScrollUp: Bool = false{
        didSet{
            if isChanging{
                return
            }
            
        }
    }
    
    var imageURLs: [IndexPath: String] = [:]
    
    let arrCityNames = [
        "Los Angeles", "New York", "San Francisco", "Las Vegas", "San Diego", "San Jose",
        "Fort Worth", "San Antonio", "Kansas City", "Salt Lake", "New Orleans", "Santa Fe",
        "Virginia Beach", "Long Beach", "Grand Rapids", "Oklahoma City", "Boise City",
        "El Paso", "Colorado Springs", "Reno City", "Corpus Christi", "St. Louis", "Saint Paul",
        "San Bernardino", "Baton Rouge", "Buffalo Grove", "Raleigh Durham", "Huntington Beach",
        "West Palm", "Palm Springs", "Cape Coral", "Green Bay", "Lincoln Park", "Rock Hill",
        "Saint Petersburg", "South Bend", "North Charleston", "North Miami", "Little Rock",
        "Salt Lake", "Rapid City", "Ann Arbor", "Santa Rosa", "Santa Clara", "San Mateo",
        "West Covina", "Fort Collins", "Palm Harbor", "Sierra Vista", "El Monte", "Spring Hill",
        "Silver Spring", "Carson City", "Lake Charles", "Cedar Rapids", "Gainesville City",
        "Atlantic City", "Charleston City", "West Valley", "San Marcos", "San Clemente",
        "Mission Viejo", "Thousand Oaks", "Santa Cruz", "North Richland", "South Gate",
        "East Lansing", "Westminster City", "Huntington Park", "Beverly Hills", "Chula Vista",
        "Coconut Creek", "Cedar City", "Boca Raton", "South Miami", "Grand Prairie",
        "Jackson Hole", "Lake Forest", "Mount Pleasant", "New Haven", "New Braunfels",
        "Park Ridge", "Crown Point", "South Pasadena", "East Orange", "Sandy Springs",
        "North Olmsted", "Palm Bay", "Fair Lawn", "North Port", "Haines City", "Grove City",
        "Twin Falls", "Fort Smith", "Castle Rock", "Palm Beach", "Pine Bluff", "Grand Island",
        "North Haven", "South Plainfield", "East Moline", "Fairbanks City", "Rock Springs",
        "San Fernando", "Union City", "Sugar Land", "Redondo Beach", "Port Orange",
        "Manhattan Beach", "Mission Hills", "South Jordan", "Ocean Springs", "Lake Oswego",
        "North Augusta", "College Station", "South Windsor", "San Rafael", "Los Gatos",
        "South Holland", "Des Plaines", "Lake Worth", "West Babylon", "San Ramon",
        "Northbrook Village", "San Gabriel", "West Memphis", "Glen Burnie", "San Angelo",
        "West Monroe", "West Allis", "Grand Terrace", "Eagle Pass", "Temple Terrace",
        "North Lauderdale", "Rancho Cucamonga", "San Leandro", "West Lafayette",
        "South Lake Tahoe", "Lake Havasu", "Palm Desert", "La Crosse", "East Chicago",
        "South San Francisco", "West Hartford", "North Palm Beach", "New Rochelle",
        "Port Charlotte", "San Luis Obispo", "Castle Pines", "South Portland", "Los Altos",
        "West Springfield", "South El Monte", "Port Washington", "San Carlos", "North Myrtle Beach",
        "East Greenwich", "West Chester", "San Dimas", "West Covina", "South Charleston",
        "San Jacinto", "Santa Clarita", "East Haven", "South Elgin", "Northglenn City",
        "West Valley City", "North Royalton", "South Saint Paul", "South Ogden",
        "Lake Elsinore", "Mount Vernon", "Northfield City", "San Clemente", "Mount Dora",
        "North Bay Village", "West Park", "South Plainfield", "North Babylon", "North Tonawanda",
        "East Palo Alto", "Mount Prospect", "Santa Barbara", "South Daytona", "West Warwick",
        "East Lansing", "North Platte", "New Bedford", "South Burlington", "San Bruno",
        "South Beloit", "Santa Monica", "South Gate", "North Canton", "East Point",
        "North Little Rock", "North Versailles", "East Peoria", "West Bend", "South Lyon",
        "North Miami Beach", "San Rafael", "West Seneca", "South Houston", "West Memphis",
        "West Fargo", "East Providence", "South Pasadena", "North Port", "West Covina",
        "West Palm Beach", "West Chicago", "East Orange", "East Liverpool", "North Bethesda",
        "South Sioux City", "South Kingstown", "West Melbourne", "West Milford", "North Mankato",
        "South Lebanon", "West Monroe", "West Haven", "West Carrollton", "Westlake Village",
        "North Lauderdale", "North Brunswick", "South Euclid", "West Sacramento",
        "West Springfield", "South Salt Lake", "East Bridgewater", "South Kingstown",
        "East Ridge", "East Grand Forks", "Southgate City", "Westminster City", "Northampton City",
        "South Boston", "North Richland Hills", "South Beloit", "East Stroudsburg",
        "West Plains", "North Palm Beach", "South Pasadena", "West Monroe", "West Linn",
        "North Platte", "North Myrtle Beach", "South Hadley", "West Melbourne", "West Mifflin",
        "West Springfield", "North Augusta", "North Kingstown", "South Burlington",
        "North Canton", "North Little Rock", "North Ogden", "West Valley City",
        "North Adams", "North Andover", "North Attleboro", "North Branch", "North Chicago",
        "North College Hill", "North Decatur", "North Druid Hills", "North Fort Myers",
        "North Highlands", "North Lauderdale", "North Lynnwood", "North Miami",
        "North Miami Beach", "North Myrtle Beach", "North Olmsted", "North Plainfield",
        "North Platte", "North Port", "North Richland Hills", "North Royalton",
        "North Salt Lake", "North St. Paul", "North Syracuse", "North Tonawanda",
        "North Tustin", "North Valley Stream", "Northampton", "Northborough",
        "Northbridge", "Northbrook", "Northfield", "Northgate", "Northglenn",
        "Northridge", "Northville", "Norton Shores", "Norwalk", "Norwich",
        "Norwood", "Nottingham", "Nova", "Nuevo", "Oak Creek", "Oak Forest",
        "Oak Grove", "Oak Harbor", "Oak Hill", "Oak Lawn", "Oak Park", "Oak Ridge",
        "Oakdale", "Oakhurst", "Oakland Park", "Oakley", "Ocoee", "Ocean Acres",
        "Ocean City", "Ocean Pines", "Ocean Springs", "Oceanside", "Odessa",
        "Ogden", "Oil City", "Oklahoma City", "Olathe", "Old Bridge", "Old Saybrook",
        "Olean", "Olive Branch", "Olmsted Falls", "Olympia", "Omaha", "Onalaska",
        "Ontario", "Opa-locka", "Opelika", "Opelousas", "Orange City", "Orange Cove",
        "Orange Park", "Orangevale", "Orchard Park", "Orcutt", "Oregon City",
        "Orinda", "Orland Park", "Orlando", "Orleans", "Oro Valley", "Oroville",
        "Osceola", "Oshkosh", "Osprey", "Oswego", "Ottawa", "Overland Park", "Owasso",
        "Owatonna", "Oxford", "Oxon Hill", "Oyster Bay"
    ]
    
    var arrCategory = ["Abstract iphone wallpaper","Animals iphone wallpaper", "Nature iphone wallpaper"]
    var categoryImages: [String: [DevioxWallPaperModel.Hit]] = [:]
    
    // Add this property to track liked items
    private var likedItems: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl.delegate = self
        tbl.dataSource = self
        
        // Add double tap gesture recognizer to the table view
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        tbl.addGestureRecognizer(doubleTapGesture)
        
        prefetchImages()
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: tbl)
        if let indexPath = tbl.indexPathForRow(at: point) {
            toggleLike(for: indexPath)
        }
    }
    
    private func toggleLike(for indexPath: IndexPath) {
        if likedItems.contains(indexPath) {
            likedItems.remove(indexPath)
        } else {
            likedItems.insert(indexPath)
        }
        
        if let cell = tbl.cellForRow(at: indexPath) as? DevioxHomeListCell {
            cell.btnLike.isSelected = likedItems.contains(indexPath)
        }
    }
    
    private func prefetchImages() {
        for category in arrCategory {
            getApiData(for: category)
        }
    }
    
    func getApiData(for category: String) {
        guard let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding category: \(category)")
            return
        }
        
        let urlString = "https://pixabay.com/api/?key=41590966-3b6d86129f917e3f420f0b383&q=\(encodedCategory)&image_type=photo&pretty=true"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data for category \(category): \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received for category \(category)")
                return
            }
            
            do {
                let wallPaperdata = try JSONDecoder().decode(DevioxWallPaperModel.self, from: data)
                DispatchQueue.main.async {
                    self.categoryImages[category] = wallPaperdata.hits
                    self.tbl.reloadData()
                }
            } catch {
                print("Error decoding data for category \(category): \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension DevioxHomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let newHeight: CGFloat = currentOffset > 0 ? 0 : 60
        if constViewHeaderHeight.constant == newHeight || isChanging {
            return
        }
        isChanging = true
        UIView.animate(withDuration: 0.2, animations: {
            self.constViewHeaderHeight.constant = newHeight
            self.view.layoutIfNeeded()
        }) { _ in
            self.isChanging = false
        }
    }
}

extension DevioxHomeVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryImages.values.flatMap { $0 }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbl.dequeueReusableCell(withIdentifier: "HomeListCell", for: indexPath)as! DevioxHomeListCell
        
        cell.lblName.text = "user_\(UUID())"
        cell.lblTime.text = "\((1...59).randomElement()!)m ago"
        cell.lblAddress.text = arrCityNames.randomElement()
        
        cell.setShare = { i in
            guard let img = i else { return }
            let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        // Set the like button state
        cell.btnLike.isSelected = likedItems.contains(indexPath)
        
        // Configure like button action
        cell.likeAction = { [weak self] in
            self?.toggleLike(for: indexPath)
        }
        
        var totalCount = 0
        for (_, images) in categoryImages {
            if indexPath.item < totalCount + images.count {
                let imageIndex = indexPath.item - totalCount
                
                // Setting SDWebImage options for compression
                let options: SDWebImageOptions = [.scaleDownLargeImages]
                let placeholderImage = UIImage(named: "placeholder")
                if let largeImageURL = URL(string: images[imageIndex].largeImageURL) {
                    cell.img.sd_setImage(with: largeImageURL, placeholderImage: placeholderImage, options: options) { (image, error, cacheType, imageURL) in
                    }
                } else {
                    cell.img.image = placeholderImage
                }
                break
            }
            totalCount += images.count
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item," CLICKED.")
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let act = UIContextualAction(style: .normal, title: "SWIPE LEFT") { _, _, _ in
            print("Swiped.")
        }
        
        let conf = UISwipeActionsConfiguration(actions: [act])
        
        return conf
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let act = UIContextualAction(style: .normal, title: "SWIPE RIGHT") { _, _, _ in
            print("Swiped.")
        }
        
        let conf = UISwipeActionsConfiguration(actions: [act])
        
        return conf
    }
}
