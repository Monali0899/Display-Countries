//
//  CountriesViewController.swift
//  FetchCountries
//
//  Created by Monali on 2/27/25.
//

import UIKit

class CountriesViewController: UITableViewController {
    
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        fetchCountries()
        
        // Add a title to the navigation bar
        self.title = "Countries"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or capital"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchCountries() {
        NetworkManager.shared.fetchCountries { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self?.countries = countries
                    self?.filteredCountries = countries
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = filteredCountries[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        // Use UIFontMetrics to scale fonts
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let captionFont = UIFont.preferredFont(forTextStyle: .caption1)
        
        content.text = "\(country.name), \(country.region)"
        content.textProperties.font = bodyFont
        content.secondaryText = "\(country.code) | \(country.capital)"
        content.secondaryTextProperties.font = captionFont
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        print("Search text: \(searchText)") // Debugging
        
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.lowercased().contains(searchText) || $0.capital.lowercased().contains(searchText)
            }
        }
        
        tableView.reloadData()
    }
}

