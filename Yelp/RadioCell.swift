//
//  RadioCell.swift
//  Yelp
//
//  Created by vu on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol RadioCellDelegate {
    optional func radioCell(radioCell: RadioCell, didChangeValue value: Bool)
}

class RadioCell: UITableViewCell {

    
    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    
    var radioSet = Bool()
    
    weak var delegate: RadioCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("radioValueChanged"))
        singleTap.numberOfTapsRequired = 1
        
        radioImageView.userInteractionEnabled = true
        radioImageView.addGestureRecognizer(singleTap)
        
        radioSet = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func radioValueChanged() {
        print("in radio value changed")
        if radioSet {
            print("in radio value changed, radioset true")
            radioSet = false
            radioImageView.image = UIImage(named: "checkbox-16.png")
        } else {
            print("in radio value changed, radioset false")
            radioSet = true
            radioImageView.image = UIImage(named: "checkbox-selected-16.png")
        }
        
        delegate?.radioCell?(self, didChangeValue: radioSet)
    }

}
