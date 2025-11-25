//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Boynurodova Marhabo on 25/11/25.
//

import UIKit
import SnapKit
extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    func setupSearchSuggestions() {
        view.addSubview(searchSuggestionsTableView)
        searchSuggestionsTableView.delegate = self
        searchSuggestionsTableView.dataSource = self
        searchSuggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        searchSuggestionsTableView.backgroundColor = .black
        searchSuggestionsTableView.separatorStyle = .none
        searchSuggestionsTableView.isHidden = true

        searchSuggestionsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? recentSearches.count : trendingSearches.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Recent" : "Trending"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = indexPath.section == 0 ? recentSearches[indexPath.row] : trendingSearches[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let query = indexPath.section == 0 ? recentSearches[indexPath.row] : trendingSearches[indexPath.row]
        searchBar.text = query
        searchBar.resignFirstResponder()
        searchSuggestionsTableView.isHidden = true
        searchPhotos(query: query)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchSuggestionsTableView.isHidden = false
        searchSuggestionsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()
        searchSuggestionsTableView.isHidden = true
        searchPhotos(query: query)
        if !recentSearches.contains(query) { recentSearches.insert(query, at: 0) }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchSuggestionsTableView.isHidden = true
        fetchDiscoverPhotos()
    }
}
