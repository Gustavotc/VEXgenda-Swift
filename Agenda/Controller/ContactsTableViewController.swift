//
//  ContactsTableViewController.swift
//  Agenda
//
//  Created by INDB on 17/06/21.
//

import UIKit
import Alamofire
import Kingfisher

class ContactsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contactViewModel: ContactViewModel = ContactViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = RealmManager.getInstance()
        print("User Realm User file location: \(realm.configuration.fileURL!.path)")
        SyncManager.shared.syncDatabase()
        contactViewModel.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactViewModel.delegate = self
        searchBar.delegate = contactViewModel
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("finishSync"), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            let vc = segue.destination as! AddEditViewContoller
            vc.contact = contactViewModel.contacts?[tableView.indexPathForSelectedRow!.row]
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactViewModel.numberOfRowsInSection()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell

        let contact = contactViewModel.contacts![indexPath.row]
        cell.prepareCell(contact: contact)
        return cell
    }

}

extension ContactsTableViewController: ContactViewModelDelegate {
    
    @objc func reloadData() {
        tableView.reloadData()
    }
    
}
