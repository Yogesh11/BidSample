//
//  DetailCell.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

protocol DetailCellDelegate: class {
    func placeBid()
}


class DetailCell: UITableViewCell {
    @IBAction func placeBid(_ sender: Any) {
        delegate?.placeBid()
    }
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var liveBid: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var makeABid: UIButton!
    @IBOutlet weak var carMileage: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: DetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeABid.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0);
        makeABid.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func displayData(data : HomeModel, bidStart : Bool){
        if let url =  data.carUrl , let url1 = URL(string: url){
            carImage.sd_setImage(with: url1, placeholderImage: nil)
        }else{
            carImage.image = nil
        }
        nameLabel.text  =  "Name    : " + data.modelName
        yearLabel.text  =  "Year    : " + data.year
        carMileage.text =  "Mileage : " + data.mileage
        liveBid.text    =  "LiveBid : " + data.bidPrice
        makeABid.isEnabled = bidStart
    }
}
