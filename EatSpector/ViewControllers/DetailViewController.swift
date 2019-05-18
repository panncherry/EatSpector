//
//  DetailViewController.swift
//  EatSpector
//
//  Created by Pann Cherry on 4/21/19.
//

import UIKit

class DetailViewController: UIViewController {

    var businesses: [Business] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var businessProfilePic: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabel2: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var gradingLabel: UILabel!
    @IBOutlet weak var gradeDateLabel: UILabel!
    @IBOutlet weak var criticalFlagLabel: UILabel!
    @IBOutlet weak var violationCodeLabel: UILabel!
    @IBOutlet weak var violationDescriptionLabel: UILabel!
    
    
    var business: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let business = business {
            businessNameLabel.text = business.name
            categoriesLabel.text = business.categories
            let building = business.building_number
            let street = business.street
            let boro = business.boro
            let zipcode = business.zipcode
            addressLabel.text = building + " " + street
            addressLabel2.text = boro + ", NY " + zipcode
            
            phoneNumberLabel.text = arrangeUSFormat(strPhone: business.phone)
            gradingLabel.text = business.grading
            gradeDateLabel.text = business.record_date
            
            criticalFlagLabel.text = business.critical_flag
            violationCodeLabel.text = business.violation_code
            violationDescriptionLabel.text = business.violation_Description
            
        }
        
    }
    
    
    //Format phone number reterive from API
    func arrangeUSFormat(strPhone : String)-> String {
        var strUpdated = strPhone
        if strPhone.count == 10 {
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
        }
        return strUpdated
    }


}
