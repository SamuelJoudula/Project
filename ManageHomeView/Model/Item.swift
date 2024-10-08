import UIKit

enum CellType: Equatable {
    case cardsCollection([CardImages])
    case searchBar(SearchValue)
    case details(Item)
    
    static func == (lhs: CellType, rhs: CellType) -> Bool {
        switch (lhs, rhs) {
        case (.cardsCollection(let lhsImages), .cardsCollection(let rhsImages)):
            return lhsImages == rhsImages
        case (.searchBar(let lhsSearch), .searchBar(let rhsSearch)):
            return lhsSearch == rhsSearch
        case (.details(let lhsItem), .details(let rhsItem)):
            return lhsItem == rhsItem
        default:
            return false
        }
    }
}

struct CardImages: Equatable {
    let imageName: UIImage
}

struct SearchValue: Equatable {
    let data: String
}

struct Item: Equatable {
    let imageName: String
    let title: String
}
