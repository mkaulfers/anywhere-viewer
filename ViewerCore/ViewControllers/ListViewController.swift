//
//  ListViewController.swift
//  AnywhereDemo
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import UIKit

class ListViewController: UITableViewController {
    private var apiService: APIService?
    private var dataSource: CharacterAPIResult?
    private var cellHeightTracker: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        beginDownloadingImages()
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
        dataSource?.relatedTopics.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CharacterCell
        
        let listItem = dataSource?.relatedTopics[indexPath.row]
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
        if let detailVC = UIStoryboard(name: "DetailView", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.listItem = dataSource?.relatedTopics[indexPath.row]

            if let splitVC = splitViewController {
                if splitVC.isCollapsed {
                    navigationController?.pushViewController(detailVC, animated: true)
                } else {
                    if let detailNavController = splitVC.viewControllers.last as? UINavigationController {
                        detailVC.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
                        detailVC.navigationItem.leftItemsSupplementBackButton = true
                        detailNavController.setViewControllers([detailVC], animated: true)
                    }
                }
            }
        }
    }
}
