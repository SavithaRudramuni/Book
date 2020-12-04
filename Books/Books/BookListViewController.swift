//
//  BookListViewController.swift
//  Books
//
//  Created by Savitha Rudramuni on 03/12/20.
//

import Foundation
import UIKit

class BookListViewController:UIViewController, DateSelectionProtocol {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var searchFilterView:UIStackView!
    
    let viewModel =  BookListViewModel()
    
    var loadingController:BookLoadingController?
    var dateSelectionController:BookDateSelectionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title =  "Books"
        
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width:80, height: 50))
        rightButton.addTarget(self, action: #selector(showDatePicker), for: UIControl.Event.touchUpInside)
        rightButton.setTitle("Date", for: UIControl.State.normal)
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        let item1 = UIBarButtonItem()
        item1.customView = rightButton
        self.navigationItem.rightBarButtonItems = [item1]
        
        
        self.setUpTableView()
        self.fetchBooks()
        viewModel.currentSelectedIndex.bind { (value:Int) in
            self.updatefilterSelection()
        }
        
    }
    
    func fetchBooks() {
        self.showloader()
        viewModel.fetchBooks { (error:APIError?) in
            DispatchQueue.main.async {
                self.loadingController?.dismissLoader(animation: false)
                
                if self.viewModel.currentDisplayList.count == 0 {
                    self.showEmptyScreen()
                } else {
                    if self.viewModel.currentDisplayList.count > 0 {
                        self.setupFilterView()
                    }
                    self.tableView.reloadData()
                }
                
                
            }
        }
    }
    
    func showloader() {
        
        guard let loadingViewController =  self.storyboard?.instantiateViewController(identifier: "BookLoadingController") as? BookLoadingController else { return }
        self.loadingController = loadingViewController
        self.present(loadingViewController, animated: true, completion: nil)
    }
    
    func showEmptyScreen() {
        
        guard let loadingViewController =  self.storyboard?.instantiateViewController(identifier: "EmptyBookResultController") as? EmptyBookResultController else { return }
        self.present(loadingViewController, animated: true, completion: nil)
        
       let timer = Timer(fire: Date(), interval: 5, repeats: false) { (timer) in
            loadingViewController.dismissLoader()
        }
        timer.fire()
    }

    
    func setUpTableView() {
        self.tableView.dataSource =  self
        self.tableView.delegate  = self
        self.tableView.tableFooterView =  UIView()
        self.tableView.reloadData()
    }
    
    func setupFilterView() {
       
        var x:CGFloat = 0

        
        for (index,filter) in self.viewModel.searchFilters.enumerated() {
            
           
            let button = UIButton(frame: CGRect(x: x+10, y: 5, width:30, height: searchFilterView.frame.height -  10))
            button.setTitle(filter.capitalized, for: UIControl.State.normal)
            
            if viewModel.currentSelectedIndex.value ==  index {
                button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
            } else {
                button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            }
            
            button.tag =  index
            button.addTarget(self, action: #selector(updateCurrentFilter(button:)), for: UIControl.Event.touchUpInside)
        
            button.layer.borderColor =  UIColor.gray.cgColor
            
            button.layer.borderWidth =  0.5

            
            x = x + button.frame.width + 20
            
            self.searchFilterView.addArrangedSubview(button)
            
        }
    }
    
    @objc func updateCurrentFilter(button:UIButton) {
        
        self.viewModel.currentSelectedIndex.value = button.tag
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        
    }
    
    func updatefilterSelection() {
        
        for subView in self.searchFilterView.subviews where subView is UIButton {
            
            if let button =  subView as? UIButton {
                if viewModel.currentSelectedIndex.value ==  button.tag {
                button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
            } else {
                button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier ==  "bookInfo" {
            
            if let infoController =  segue.destination as? BookInfoViewController , let cell =  sender as? BookListCell {
                
                infoController.book =  cell.book
                
            }
        }
    }
    
    @IBAction func showDatePicker() {
        
        if dateSelectionController == nil {
        guard let loadingViewController =  self.storyboard?.instantiateViewController(identifier: "BookDateSelectionController") as? BookDateSelectionController else { return }
        loadingViewController.delegate =  self
        dateSelectionController = loadingViewController
        }
        
        if dateSelectionController != nil {
        self.present(dateSelectionController!, animated: true, completion: nil)
        }
    }
    
    func selectedDate(date:Date) {
        
        self.viewModel.currentDate =  date
        dateSelectionController?.dismissLoader()
        self.fetchBooks()
    }
}

extension BookListViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentDisplayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "bookListCell", for: indexPath)
        let book =  viewModel.currentDisplayList[indexPath.row]
        
        if let listCell =  cell as? BookListCell {
            listCell.book = book
        }
        return cell
    }
    
    
}

extension BookListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text =  searchBar.text {
            
            self.viewModel.searchBooks(keyword: text)
            self.tableView.reloadData()
        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.resetSeach()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel.resetSeach()
            self.tableView.reloadData()
        }
    }
}
