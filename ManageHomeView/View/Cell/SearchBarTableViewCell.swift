import UIKit

protocol SearchBarDelegate: AnyObject {
    func didUpdateSearchText(_ searchText: String)
}

class SearchBarTableViewCell: UITableViewCell {
    static let identifier = "SearchBarTableViewCell"
    weak var delegate: SearchBarDelegate?
    // MARK: - Private Properties
    private lazy var  searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.clipsToBounds = true
        return searchBar
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(searchBar)
        setupConstraints()
        
        // Ensure the search bar delegate is set
        searchBar.delegate = self
        
        // Optional: Center align the placeholder text
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textAlignment = .left
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(searchBar: UISearchBar) {
        // If you want to customize the cell's search bar appearance, do it here.
        self.searchBar.placeholder = searchBar.placeholder
        // If you want to set the delegate, you can do so
        self.searchBar.delegate = searchBar.delegate
    }
}


// MARK: - UISearchBarDelegate
extension SearchBarTableViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.didUpdateSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
