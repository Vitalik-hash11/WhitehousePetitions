//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by newbie on 15.08.2022.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var petitions = [Petition]()
    var filteredData = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfo))

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                filteredData = petitions
                tableView.reloadData()
                return
            }
        }
        
        showConnectionError()
    }
    
    // MARK: - Search Bar Delegation
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? petitions : petitions.filter { petition in
            return petition.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    // MARK: - Table View Configuration

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = filteredData[indexPath.row].title
        contentConfiguration.secondaryText = filteredData[indexPath.row].body
        contentConfiguration.textProperties.numberOfLines = 1
        contentConfiguration.secondaryTextProperties.numberOfLines = 2
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.detailItem = filteredData[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Private methods

    @objc private func showInfo() {
        let ac = UIAlertController(title: "Application data comes from \"We The People API of the Whitehouse.\"", message: "https://petitions.obamawhitehouse.archives.gov/developers/", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func showConnectionError() {
        let ac = UIAlertController(title: "Something went wrong!", message: "Try a bit later", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func parse(json: Data) {
        if let petitionResult = try? JSONDecoder().decode(PetitionResult.self, from: json) {
            petitions = petitionResult.results
        }
    }
}

