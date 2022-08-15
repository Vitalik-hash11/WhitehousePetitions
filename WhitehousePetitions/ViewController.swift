//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by newbie on 15.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = petitions[indexPath.row].title
        contentConfiguration.secondaryText = petitions[indexPath.row].body
        contentConfiguration.textProperties.numberOfLines = 1
        contentConfiguration.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    
    private func parse(json: Data) {
        if let petitionResult = try? JSONDecoder().decode(PetitionResult.self, from: json) {
            petitions = petitionResult.results
            tableView.reloadData()
        }
    }
}

