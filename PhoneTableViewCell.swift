//
//  PhoneTableViewCell.swift
//  Agenda
//
//  Created by INDB on 05/07/21.
//

import UIKit
import TLCustomMask

class PhoneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfType: UITextField!
        
    let pickerData = ["Celular","Residencial","Empresarial"]
    var phoneMask = TLCustomMask()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tfPhone.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createPicker() {
        tfType.inputView = pickerView
    }
}

extension PhoneTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfType.text = pickerData[row]
        tfType.resignFirstResponder()
    }
    
}

extension PhoneTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        phoneMask.formattingPattern = "($$) $$$$$-$$$$"
      
        if textField.text!.count == 13 {
            phoneMask.formattingPattern = "($$) $$$$-$$$$"
        }
        
        tfPhone.text = phoneMask.formatStringWithRange(range: range, string: string)
        
        return false
    }
    
}
