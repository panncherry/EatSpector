//
//  BusinessCell.swift
//  EatSpector
//
//  Created by Pann Cherry on 4/18/19.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var gradingLabel: UILabel!
    @IBOutlet weak var gradingLabel2: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    /*:
     # Set table cell's attributes for each business
     */
    var business: Business!{
        willSet(business){
            self.businessNameLabel.text = business.name
            self.categoriesLabel.text = business.categories
            self.gradingLabel.text = business.grading
            self.gradingLabel2.text = business.grading

            //self.record_dateLabel.text = business.record_date
            
            let building = business.building_number + " "
            let street = business.street
            let boro = business.boro + ", NY "
            let zipcode = business.zipcode
            self.addressLabel.text = building + street
            self.addressLabel2.text = boro + zipcode
 
        }
    }
    
    
    /*:
     # Configure the view for selected state
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
