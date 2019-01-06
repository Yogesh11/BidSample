//
//  HomeCell.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeCellDelegate: class {
    func startBid(index : Int)
}

class HomeCell1: UITableViewCell {
    
    @IBAction func startBid(_ sender: Any) {
         delegate?.startBid(index: indexValue)
    }
    
    @IBOutlet weak var startBidButton: UIButton!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var carMileage: UILabel!
    weak var delegate: HomeCellDelegate?
    var indexValue : Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        startBidButton.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0);
        startBidButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayData(model : HomeModel) {
        if let url =  model.carUrl , let url1 = URL.init(string: url){
            carImage.sd_setImage(with: url1, placeholderImage: nil)
        }else{
            carImage.image = nil
        }
        nameLabel.text  =  "Name    : " + model.modelName
        yearLabel.text  =  "Year    : " + model.year
        carMileage.text =  "Mileage : " + model.mileage
    }

}
