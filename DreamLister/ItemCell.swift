//
//  MyTVCell.swift
//  DreamLister
//
//  Created by Abhishek's iMac on 7/21/17.
//  Copyright © 2017 abhishek. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    public func configureCell(item: Item){
        
        title.text = item.title
        price.text = "$ \(item.price)"
        desc.text = item.details
        if let img = item.toImage?.image as? UIImage {
            thumb.image = img
        }
    }

}
