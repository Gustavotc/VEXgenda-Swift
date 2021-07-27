//
//  AddEditViewContoller.swift
//  Agenda
//
//  Created by INDB on 17/06/21.
//

import UIKit
import Kingfisher
import TLCustomMask

class AddEditViewContoller: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddPhone: UIButton!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    var API = PeopleAPI()
    var contactViewModel: ContactViewModel = ContactViewModel()
    let addEditViewModel: AddEditViewModel = AddEditViewModel()
    var btnDelete : UIBarButtonItem!
    var btnEdit : UIBarButtonItem!
    var contact: Contact!
    var rows: Int = 1
    var imageName: String?
    var canEdit: Bool = false

    //MARK:- VIEW FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addEditViewModel.delegate = self
        
        configureView()
    
        //Se contato != nil, é uma edição
        if contact != nil {
            fillInfo()
            showMenuItens(show: true)
        }
    
    }
    
    
    @IBAction func chooseSource(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a sua foto?", preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }

        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = addEditViewModel
        present(imagePicker, animated: true, completion: nil)
    }

    //MARK:- BTNSAVE FUNCTION
    @IBAction func saveContact(_ sender: UIButton) {
        
        let name = tfName.text ?? ""
        let email = tfEmail.text ?? ""
        
        tableView.indexPathsForVisibleRows?.forEach({ indexPath in
            
            if let cell = tableView.cellForRow(at: indexPath) as? PhoneTableViewCell {
                
                //Valida se a célula está preenchida
                if !cell.tfPhone.text!.isEmpty {
                    let phone = cell.tfPhone.text ?? ""
                    let type = cell.tfType.text ?? ""
                    addEditViewModel.addPhone(phoneNumber: phone, type: type)
                }
            }
        })
        
        let phones = addEditViewModel.getPhones()
        
        if validateInfo(name: name, email: email, phones: phones) {
            
            if contact == nil {
                contactViewModel.createContact(name: name, email: email, phones: phones, imageName: imageName)
                canEdit = false
                configureInputs()
                showToast(message: "Contato criado!")
            } else {
                contactViewModel.editContact(name: name, email: email, phones: phones, oldContact: contact, imageName: imageName)
                canEdit = false
                configureInputs()
                showToast(message: "Contato editado!")
            }
            
        } else {
            addEditViewModel.clearPhones()
        }
    
    }
    
    @IBAction func addPhoneRow(_ sender: UIButton) {
        
        rows += 1
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: rows-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
    }
    
    
    
    //MARK:- BAR BUTTON ITEMS
    func showMenuItens(show: Bool = false) {
        self.btnDelete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteContact))
        self.btnEdit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editContact))
        
        if show == true{
            self.navigationItem.setRightBarButtonItems([btnDelete, btnEdit], animated: true)
        } else {
            self.navigationItem.setRightBarButtonItems([], animated: true)
        }
        
    }
    
    //MARK:- BAR BUTTON FUNCTIONS
    @objc func deleteContact(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Excluir", message: "Certeza que deseja remover \(contact.name) de seus contatos?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
            self.contact.deleteContact()
            self.navigationController?.popViewController(animated: true)
            self.showToast(message: "Contato deletado!")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func editContact(sender: UIBarButtonItem) {
        canEdit = true
        configureInputs()
    }
    
    //MARK:- LAYOUT CONFIGURATIONS
    func configureView() {
        
        //ImageView layout
        ivPhoto.layer.cornerRadius = ivPhoto.frame.size.height/2
        ivPhoto.layer.borderColor = UIColor.black.cgColor
        ivPhoto.layer.borderWidth = 2
        
        canEdit = contact != nil ? false : true
        
        configureInputs()
        
    }
    
    func configureInputs() {
        tfName.isEnabled = canEdit
        tfEmail.isEnabled = canEdit
        btnSave.isEnabled = canEdit
        btnSave.backgroundColor =  canEdit ? .blue : .gray
        btnSave.tintColor = canEdit ? .white : .black
        btnAddPhone.isEnabled = canEdit
        btnAddPhoto.isEnabled = canEdit
        tableView.reloadData()
    }
    
    @IBAction func closeKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //Fecha o teclado ao tocar em algum lugar da tela
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- CONTACT INFOS
    func fillInfo() {
        title = "Detalhes do contato"
        tfName.text = contact.name
        tfEmail.text = contact.email
    
        rows = contact.phones.count
        
        tableView.reloadData()
        
        if contact.imageName != nil {
            if let image = ImageManager.findImageWithName(name: contact.imageName) {
                ivPhoto.image = image
            }
        } else {
            if let url = URL(string: contact.photo ?? "") {
                ivPhoto.kf.indicatorType = .activity
                ivPhoto.kf.setImage(with: url)
            }
        }

    }
    
    //MARK:- VALIDATE CONTACT INFOS
    func validateInfo(name: String, email: String, phones: [Phone]) -> Bool {
                
        var validate = true
        
        if name.isEmpty {
            showToast(message: "Insira um nome")
            return false
        }
        
        if !email.isEmail {
            showToast(message: "Email inválido")
            return false
        }
        
        if !phones.isEmpty {
            
            phones.forEach { phone in
                
                if !phone.phone.isPhoneNumber {
                    showToast(message: "Telefone inválido: \(phone.phone)")
                    validate = false
                }
                
            }
            
        } else {
            showToast(message: "Insira um telefone")
            return false
        }
        
        return validate
    }
    
}

// MARK: ViewModel Delegates
extension AddEditViewContoller: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhoneTableViewCell
        
        cell.createPicker()
        cell.pickerView.reloadAllComponents()
        
        if contact != nil && indexPath.row <= contact.phones.count-1 {
            cell.tfPhone.text = contact.phones[indexPath.row].phone
            cell.tfType.text = contact.phones[indexPath.row].type
            cell.tfPhone.isUserInteractionEnabled = canEdit
            cell.tfType.isUserInteractionEnabled = canEdit
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if rows > 1 {
                rows -= 1
                addEditViewModel.removePhone(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
    
}

extension AddEditViewContoller: AddEditViewModelDelegate {
    
    func addContactPhoto(photo: UIImage?) {
        ivPhoto.image = photo
        imageName = Contact.savePhoto(newPhoto: photo)
    }
    
}
