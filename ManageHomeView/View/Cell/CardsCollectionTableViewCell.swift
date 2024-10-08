import UIKit

class CardsCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "CardsCollectionTableViewCell"
    
    // MARK: - Private Properties
    private var imageViews: [UIImageView] = []
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(red: 0.68, green: 0.85, blue: 0.9, alpha: 1.0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5 // Assuming 5 pages of data
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    var imageArray: [UIImage] = [] {
        didSet {
            pageControl.numberOfPages = imageArray.count
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageData: [CardImages]) {
        // Clear existing image views if needed
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        // Create and add image views based on the image data
        for cardImage in imageData {
            let imageView = UIImageView(image: cardImage.imageName)
            // Configure image view properties (e.g., content mode, frame)
            imageView.contentMode = .scaleAspectFit
            imageViews.append(imageView)
            contentView.addSubview(imageView)
        }
        
        // Layout image views as needed
        layoutImageViews()
    }
    
    private func layoutImageViews() {
        // Layout logic for your image views, possibly using Auto Layout
        // Example: arrange image views in a horizontal stack
        for (index, imageView) in imageViews.enumerated() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(index * 100)),
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 80),
                imageView.heightAnchor.constraint(equalToConstant: 80)
            ])
        }
    }
}
// MARK: - Private Methods
private extension CardsCollectionTableViewCell {
    func setupCollectionView() {
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CardsCollectionCell.self, forCellWithReuseIdentifier: CardsCollectionCell.identifier)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension CardsCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionCell.identifier, for: indexPath) as?  CardsCollectionCell else {
            fatalError("The Collection View couldn't dequeue a card cell")
        }
        cell.configure(with: imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.9, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
