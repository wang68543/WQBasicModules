//
//  ExampleViewCell.swift
//  WQBasicModules_Example
//
//  Created by HuaShengiOS on 2019/2/12.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WQBasicModules
class ExampleViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var exampleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - -- cell reuse
extension ExampleViewCell {
    static let identifier = "reuse"
    public class func register(for tableView: UITableView, bundle: Bundle? = nil) {
        //        tableView.register(self, forCellReuseIdentifier: identifier)
        tableView.register(UINib(nibName: String(describing: self), bundle: bundle), forCellReuseIdentifier: identifier)
    }
    public class func cell(for tableView: UITableView, with indexPath: IndexPath) -> ExampleViewCell {
        return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ExampleViewCell
    }
}

//// MARK: - -- cell reuse
//extension <#type#> {
//    static let identifier = "reuse"
//    public class func register(for collectionView: UICollectionView, bundle: Bundle? = nil) {
//        //collectionView.register(UINib(nibName: String(describing: self), bundle: bundle), forCellWithReuseIdentifier: identifier)
//        collectionView.register(self, forCellWithReuseIdentifier: identifier)
//    }
//    public class func cell(for collectionView: UICollectionView, with indexPath: IndexPath) -> <#type#> {
//        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! <#type#>
//    }
//}
