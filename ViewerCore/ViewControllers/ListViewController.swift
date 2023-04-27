//
//  ListViewController.swift
//  AnywhereDemo
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

protocol CharacterSelectionDelegate: AnyObject {
    func characterSelected(_ character: RelatedTopic)
}

class ListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    private var isSearchign: Bool = false
    
    weak var charSelDelegate: CharacterSelectionDelegate?
    private var apiService: APIService?
    private var dataSource: CharacterAPIResult?
    private var filteredDataSource: [RelatedTopic] = []
    private var cellHeightTracker: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        beginDownloadingImages()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        searchBar.delegate = self
        charSelDelegate = splitViewController?.viewController(for: .secondary) as? DetailViewController
    }
    
    // MARK: - Class Functions
    private func configureTableView() {
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "cell")
        let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Name Not Found"
        self.title = name
    }
    
    private func beginDownloadingImages() {
        apiService = APIService()
        apiService?.loadData(completion: { [weak self] result in
            switch result {
            case .success(let data):
                
                do {
                    self?.dataSource = try JSONDecoder().decode(CharacterAPIResult.self, from: data)
                    
                    if let charInfo = self?.dataSource?.relatedTopics {
                        self?.dataSource?.relatedTopics = charInfo.uniqued()
                    }
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                } catch (let error) {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchign {
            return filteredDataSource.count
        } else {
            return dataSource?.relatedTopics.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterCell
        
        let listItem: RelatedTopic?
        
        if isSearchign {
            listItem = filteredDataSource[indexPath.row]
        } else {
            listItem = dataSource?.relatedTopics[indexPath.row]
        }
       
        cell?.listItem = listItem
        
        if cellHeightTracker == 0.0 {
            cellHeightTracker = cell?.frame.height ?? 0.0
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightTracker + 16
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = charSelDelegate as? DetailViewController, splitViewController?.isCollapsed == true {
          splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
        
        if isSearchign {
            charSelDelegate?.characterSelected(filteredDataSource[indexPath.row])
        } else {
            if let charData = dataSource?.relatedTopics[indexPath.row] {
                charSelDelegate?.characterSelected(charData)
            }
        }
    }
}

// MARK: - Search Bar Delegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredDataSource = dataSource?.relatedTopics.filter({
            $0.text.range(of: searchText, options: .caseInsensitive) != nil
        }) ?? []
        tableView.reloadData()
        isSearchign = searchText.count > 0
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
        isSearchign = (searchBar.text?.count ?? 0) > 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
