import UIKit

class ManageHomeViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var originalItems: [CellType] = [
        .cardsCollection([CardImages(imageName: UIImage(named: "car") ?? UIImage()),
                          CardImages(imageName: UIImage(named: "vintageCar") ?? UIImage()),
                          CardImages(imageName: UIImage(named: "sportsCar") ?? UIImage())]),
        .searchBar(SearchValue(data: "")),
        .details(Item(imageName: "canara", title: "Bank of Innovation")),
        .details(Item(imageName: "car", title: "Global Trust Bank")),
        .details(Item(imageName: "sportsCar", title: "Citywide Savings")),
        .details(Item(imageName: "vintageCar", title: "Union Capital")),
        .details(Item(imageName: "overseas", title: "Pinnacle Financial")),
        .details(Item(imageName: "canara", title: "Harmony")),
        .details(Item(imageName: "car", title: "Evergreen")),
        .details(Item(imageName: "sportsCar", title: "Fortress")),
        .details(Item(imageName: "pnb", title: "Noble")),
        .details(Item(imageName: "vintageCar", title: "Silvergate")),
        .details(Item(imageName: "pnb", title: "Legacy")),
        .details(Item(imageName: "canara", title: "Unity Financial")),
        .details(Item(imageName: "overseas", title: "Crescent")),
        .details(Item(imageName: "pnb", title: "Summit")),
        .details(Item(imageName: "vintageCar", title: "Horizon Trust")),
        .details(Item(imageName: "pnb", title: "Oasis")),
        .details(Item(imageName: "canara", title: "Blue Sky")),
        .details(Item(imageName: "overseas", title: "Citadel")),
        .details(Item(imageName: "pnb", title: "Prime Financial")),
        .details(Item(imageName: "vintageCar", title: "Aspire"))
    ]
    private var filteredItems: [CellType] = []
    private var customView = UIView()
    private var isSearching: Bool = false
    private var flag: Bool = false
    private var previousContentOffset: CGPoint = .zero
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapGesture()
        filteredItems = originalItems
    }
}

// MARK: - Private Methods
private extension ManageHomeViewController {
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        homeTableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        setupHomeTableView()
        setupStickyHeader()
    }
    
    func setupHomeTableView() {
        view.addSubview(homeTableView)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
        // Register custom cells
        homeTableView.register(CardsCollectionTableViewCell.self, forCellReuseIdentifier: CardsCollectionTableViewCell.identifier)
        homeTableView.register(SearchBarTableViewCell.self, forCellReuseIdentifier: SearchBarTableViewCell.identifier)
        homeTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.identifier)
        
        // Constraints for the table view
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 15),
            homeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            homeTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            homeTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }
    
    func setupStickyHeader() {
        view.addSubview(customView)
        customView.backgroundColor = .white
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the table view
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:1),
            customView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            customView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            customView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(searchBar)
        customView.backgroundColor = UIColor(red: 0.95, green: 0.61, blue: 0.61, alpha: 1.0)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
        ])
        customView.isHidden = true
    }
    
    func updateFilteredItems(with searchText: String) {
        let previousFilteredItems = filteredItems // Save the previous state of filteredItems
        let contentOffset = homeTableView.contentOffset // Save the current content offset
        
        if searchText.isEmpty {
            // If search text is empty, show the initial data (originalItems)
            filteredItems = originalItems
        } else {
            // Filtering based on the search text
            let nonDetailItems = originalItems.filter {
                switch $0 {
                case .searchBar, .cardsCollection:
                    return true
                default:
                    return false
                }
            }
            
            let filteredDetailItems = originalItems.filter { item in
                switch item {
                case .details(let detail):
                    return detail.title.lowercased().contains(searchText.lowercased())
                default:
                    return false
                }
            }
            
            // Combine non-Detail items with filtered Detail items
            filteredItems = nonDetailItems + filteredDetailItems
        }
        
        // Perform the batch updates with the differences
        if flag {
            homeTableView.reloadData()
        }else{
            performBatchUpdates(previousFilteredItems: previousFilteredItems, newFilteredItems: filteredItems)
        }
        //        performBatchUpdates(previousFilteredItems: previousFilteredItems, newFilteredItems: filteredItems)
        //        homeTableView.reloadData()
        
        DispatchQueue.main.async {
            // Restore only if necessary
            if self.filteredItems.count != previousFilteredItems.count {
                self.homeTableView.setContentOffset(contentOffset, animated: false)
            }
        }
    }
    
    func performBatchUpdates(previousFilteredItems: [CellType], newFilteredItems: [CellType]) {
        let oldCount = previousFilteredItems.count
        let newCount = newFilteredItems.count
        homeTableView.beginUpdates()
        
        if oldCount > newCount {
            let indexPathsToDelete = (newCount..<oldCount).map { IndexPath(row: $0, section: 0) }
            homeTableView.deleteRows(at: indexPathsToDelete, with: .fade)
        }
        
        if newCount > oldCount {
            let indexPathsToInsert = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            homeTableView.insertRows(at: indexPathsToInsert, with: .fade)
        }
        
        let minCount = min(oldCount, newCount)
        for i in 0..<minCount {
            if previousFilteredItems[i] != newFilteredItems[i] {
                let indexPathToReload = IndexPath(row: i, section: 0)
                homeTableView.reloadRows(at: [indexPathToReload], with: .automatic)
            }
        }
        homeTableView.endUpdates()
    }
    
    // Setup Tap Gesture to Dismiss Keyboard
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allows interaction with other UI elements
        view.addGestureRecognizer(tapGesture)
    }
    // Dismiss keyboard function
    func dismissKeyboardWhileScrolling() {
        view.endEditing(true)
    }
}

// MARK: - IBAction
extension ManageHomeViewController {
    @objc private func dismissKeyboard() {
        // This will dismiss the keyboard
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ManageHomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredItems[indexPath.row]
        switch item {
        case .cardsCollection(let imageArray):
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: CardsCollectionTableViewCell.identifier, for: indexPath) as? CardsCollectionTableViewCell else {
                fatalError("The Table View couldn't dequeue a card cell in vc")
            }
            cell.imageArray = imageArray.map{$0.imageName}
            cell.backgroundColor = UIColor(red: 0.68, green: 0.85, blue: 0.9, alpha: 1.0)
            return cell
        case .searchBar:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableViewCell.identifier, for: indexPath) as? SearchBarTableViewCell else {
                fatalError("The Table View couldn't dequeue a card cell in vc")
            }
            cell.delegate = self
            cell.backgroundColor = UIColor(red: 0.95, green: 0.61, blue: 0.61, alpha: 1.0)
            return cell
        case .details(let item):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as? DetailsTableViewCell else {
                fatalError("The Table View couldn't dequeue a card cell in vc")
            }
            cell.configure(with: item)
            cell.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 0.75, alpha: 1.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = filteredItems[indexPath.row]
        switch item {
        case .cardsCollection:
            return 200
        case .searchBar:
            return 75
        case .details:
            return 50
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // If searching, prevent scrolling
        if isSearching {
            scrollView.contentOffset = previousContentOffset // Maintain previous offset
            return
        }
        
        // Show/hide customView based on the scroll position
        if scrollView.contentOffset.y > 197 {
            if customView.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.customView.isHidden = false
                    self.customView.alpha = 1.0
                }
            }
        } else {
            if !customView.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.customView.isHidden = true
                    self.customView.alpha = 0.0
                }
            }
        }
        print(scrollView.contentOffset.y)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboardWhileScrolling()
    }
    
    func saveContentOffsetIntial() {
        previousContentOffset = homeTableView.contentOffset
    }
}

// MARK: - SearchBarDelegate
extension ManageHomeViewController: SearchBarDelegate {
    func didUpdateSearchText(_ searchText: String) {
        isSearching = !searchText.isEmpty
        if isSearching {
            saveContentOffsetIntial()
        }
        updateFilteredItems(with: searchText)
    }
}

// MARK: -  UISearchBarDelegate
extension ManageHomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Start searching
        isSearching = !searchText.isEmpty
        
        if isSearching {
            // saveContentOffset()
            saveContentOffsetIntial()
        }
        
        // Update the filtered items
        updateFilteredItems(with: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // When editing starts, save content offset and prevent scroll jumps
        saveContentOffset()
        isSearching = true
        flag =  true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        updateFilteredItems(with: "")
        customView.isHidden = true
        homeTableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // End searching, resume normal scrolling behavior
        isSearching = false
        return true
    }
    
    func saveContentOffset() {
        previousContentOffset = homeTableView.contentOffset
        if homeTableView.contentOffset.y > 233 {
            homeTableView.contentOffset.y = 205
        }
    }
}

