//
//  SearchVC.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit
import SDWebImage
import StoreKit

class DevioxSearchVC: UIViewController {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var wallpaperCollectionView: UICollectionView!
    @IBOutlet weak var lblTokenCount: UILabel!

    var categoryImages: [String: [DevioxWallPaperModel.Hit]] = [:]
    
    var arrCategory = {
        let copyrightFreeImageTypes = [
            "Nature", "Sky", "Clouds", "Sunset", "Mountains", "Forests", "Rivers", "Lakes",
            "Beaches", "Waterfalls", "Ocean", "Flowers", "Trees", "Fields", "Desert", "Rain",
            "Snow", "Fog", "Stars", "Sunrise", "Moon", "Bubbles", "Butterflies", "Birds",
            "Wildlife", "Leaves", "Rocks", "Caves", "Coral Reefs", "Underwater", "Islands",
            "Rainbow", "Icebergs", "Storms", "Fireworks", "Waves", "Foggy Forests",
            "Dew Drops", "Misty Mountains", "Pond Reflections", "Rural Landscapes", "Volcanoes",
            "Canyons", "Sand Dunes", "Zen Gardens", "Windmills", "Hot Air Balloons",
            "Northern Lights", "Galaxy", "Aurora Borealis", "Meadows", "Water Ripples",
            "Autumn Leaves", "Spring Blossoms", "Sun Rays", "Dandelions", "Pebbles",
            "Butterfly Wings", "Crystal Clear Water", "Sunflower Fields", "Tropical Plants",
            "Bamboo Forest", "Garden Flowers", "Mushrooms", "Icicles", "Drifting Clouds",
            "Frost Patterns", "Rock Formations", "Sandy Beaches", "Pine Trees", "Bird Nests",
            "Horizon Views", "Rolling Hills", "Lavender Fields", "Cherry Blossoms",
            "Morning Mist", "Blue Skies", "Seashells", "Coconut Trees", "Floating Leaves",
            "Crescent Moon", "Bright Stars", "Raindrops on Leaves", "Glowing Fireflies",
            "Hiking Trails", "Cactus Plants", "Frozen Lakes", "Spring Waterfalls",
            "Coastal Waves", "Tropical Birds", "Mountain Reflections", "Coral Lagoons",
            "Sun-kissed Rocks", "Puffy Clouds", "Glaciers", "Sakura Trees", "Green Valleys",
            "Flower Petals", "Golden Wheat Fields", "Eucalyptus Trees", "Pinecones",
            "Driftwood", "Crystal Caves", "Orchards", "Lush Green Grass"
        ]
        var list: [String] = []
        for i in 0...6{
            list.append("\(copyrightFreeImageTypes.randomElement()!) iphone wallpaper")
        }
        return list
    }()

    private let tokenManager = DevioxTokenManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPCollectionView()
        updateTokenDisplay()
        fetchInitialData()
        viewSearch.isHidden = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTokensPurchased),
            name: NSNotification.Name("TokensPurchased"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTokenDisplay()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        viewSearch.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    func setUPCollectionView() {
        wallpaperCollectionView.dataSource = self
        wallpaperCollectionView.delegate = self
        wallpaperCollectionView.register(UINib(nibName: "HomeCVC", bundle: nil), forCellWithReuseIdentifier: "HomeCVC")
    }

    func fetchInitialData() {
        guard tokenManager.remainingTokens > 0 else {
            showTokenPurchaseAlert()
            return
        }
        
        self.categoryImages.removeAll()
        tokenManager.useToken()
        updateTokenDisplay()
        
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
                    self.wallpaperCollectionView.reloadData() // Reload data after fetching
                }
            } catch {
                print("Error decoding data for category \(category): \(error.localizedDescription)")
            }
        }.resume()
    }

    
    @IBAction func btnGo(_ sender: Any) {
        
        self.categoryImages.removeAll()
        
        self.arrCategory.removeAll()
        self.arrCategory.append(txtSearch.text ?? "")
        if txtSearch.text!.isEmpty {
            self.arrCategory = ["Abstract iphone wallpaper","Animals iphone wallpaper", "Nature iphone wallpaper"]
        }
        fetchInitialData()
        DispatchQueue.main.async {
            self.viewSearch.isHidden = true
        }
    }

    @IBAction func btnSearch(_ sender: Any) {
        viewSearch.isHidden = false
    }
    
    private func updateTokenDisplay() {
        lblTokenCount.text = "\(tokenManager.remainingTokens)⇩"
    }
    
    private func showTokenPurchaseAlert() {
        let alert = UIAlertController(
            title: "Out of Tokens",
            message: "You need download tokens to search for wallpapers. Would you like to purchase more?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Purchase", style: .default) { [weak self] _ in
            self?.showTokenPurchaseOptions()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showTokenPurchaseOptions() {
        
        let alertController = UIAlertController(title: "Select a Product", message: "Please choose a product to purchase for download tokens search", preferredStyle: .alert)
        
        // Product options
        let product1 = UIAlertAction(title: "100 Seach Tokens", style: .default) { _ in
            DevioxIAPManager.shared.presentTokenPurchaseOptions(from: self, tokenProductID: "100Tokens")
        }
        
        let product2 = UIAlertAction(title: "1000 Seach Tokens", style: .default) { _ in
            DevioxIAPManager.shared.presentTokenPurchaseOptions(from: self, tokenProductID: "1000Tokens")
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Add actions to the alert
        alertController.addAction(product1)
        alertController.addAction(product2)
        alertController.addAction(cancelAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleTokensPurchased() {
        updateTokenDisplay()
    }
}

extension DevioxSearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.values.flatMap { $0 }.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath) as? HomeCVC else {
            return UICollectionViewCell()
        }

        var totalCount = 0
        for (_, images) in categoryImages {
            if indexPath.item < totalCount + images.count {
                let imageIndex = indexPath.item - totalCount
                let options: SDWebImageOptions = [.scaleDownLargeImages]
                let placeholderImage = UIImage(named: "placeholder")
                if let largeImageURL = URL(string: images[imageIndex].largeImageURL) {
                    cell.imgWallPaper.sd_setImage(with: largeImageURL, placeholderImage: placeholderImage, options: options) { (image, error, cacheType, imageURL) in
                    }
                } else {
                    cell.imgWallPaper.image = placeholderImage
                }
                break
            }
            totalCount += images.count
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2 - 5
        return CGSize(width: width, height: width * 2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SDImageCache.shared.clearMemory()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedImageUrl: String?

        var totalCount = 0
        for (_, images) in categoryImages {
            if indexPath.item < totalCount + images.count {
                let imageIndex = indexPath.item - totalCount
                selectedImageUrl = images[imageIndex].largeImageURL
                break
            }
            totalCount += images.count
        }

        if let imageUrl = selectedImageUrl, let vc = storyboard?.instantiateViewController(withIdentifier: "WallpaperDownloadVC") as? DevioxWallpaperDownloadVC {
            vc.imageUrl = imageUrl
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
