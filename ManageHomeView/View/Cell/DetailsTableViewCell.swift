import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    static let identifier = "DetailsTableViewCell"
    // MARK: - Private Properties
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageViewLeft: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true // Set desired width
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true // Set desired height
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    func setupUI() {
        // Add subviews to the stack view
        stackView.addArrangedSubview(imageViewLeft)
        stackView.addArrangedSubview(titleLabel)
        
        // Add the stack view to the cell's content view
        contentView.addSubview(stackView)
        contentView.addSubview(bottomLineView)
        
        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bottomLineView.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 8),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -4),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configure
    func configure(with item: Item) {
        imageViewLeft.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }
}
