//
//  ArticleCell.swift
//  TestProject
//
//  Created by Yogesh on 08/12/18..
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import SDWebImage
class ArticleCell: UITableViewCell {
    @IBOutlet weak var clickableLink: UITextView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayData(articleModel : ArticleModel) {
        articleImage.image = nil
        articleImage.sd_setImage(with: articleModel.imageUrl, placeholderImage: nil)
        descriptionLabel.text = articleModel.descriptionText
        titleLabel.text = articleModel.titleText
        clickableLink.text = articleModel.clickableUrl?.absoluteString
        clickableLink.backgroundColor = .red
    }

}
