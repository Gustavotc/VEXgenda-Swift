//
//  ContactTableViewCell.swift
//  Agenda
//
//  Created by INDB on 18/06/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepareCell(contact: Contact) {
        
        lbName.text = contact.name == "" ? "Nome não cadastrado" : contact.name
        lbEmail.text = contact.email == "" ? "Nenhum email cadastrado" : contact.email
        
        if contact.imageName != nil {
            ivPhoto.image = ImageManager.findImageWithName(name: contact.imageName)
        } else {
            if let url = URL(string: contact.photo ?? "") {
                ivPhoto.kf.indicatorType = .activity
                ivPhoto.kf.setImage(with: url)
            } else {
                ivPhoto.image = nil
            }
        }
        
        ivPhoto.layer.cornerRadius = ivPhoto.frame.size.height/2
        ivPhoto.layer.borderColor = UIColor.black.cgColor
        ivPhoto.layer.borderWidth = 2
        ivPhoto.contentMode = .scaleToFill
        
    }
}
