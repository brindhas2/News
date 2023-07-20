//
//  ViewController.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    private var newsListViewModel : NewsListViewModel!
    
    //private var dataSource : NewsTableDataSource<NewsListCell,NewsData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newsListViewModel =  NewsListViewModel()
        configureNavigationBar()
        callToViewModelForUIUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func configureNavigationBar() {
        self.title = LoginConstants.welcome + (UtilsCacheManager.shared.userName ?? "")
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(navigationBarBackButtonTapped))
    }
    
    func callToViewModelForUIUpdate(){
        indicator.startAnimating()
        newsListViewModel.getArticles { list, error in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if error == nil && list != nil{
                    self.handleSuccessResponse(list ?? [NewsDataModel]())
                } else {
                   
                    self.handleError(error: error)
                }
            }
            
        }
    }
    func handleSuccessResponse(_ list: [NewsDataModel]) {
        self.newsListViewModel.articles = list
        self.tableView.reloadData()
    }
    func handleError(error: ErrorDetail?) {
        //TODO: Create Commmon Alert controller
        let alert = UIAlertController(title: error?.title, message: error?.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertConstants.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc open func navigationBarBackButtonTapped() {
        //Clear all cache If necessory
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Navigation.fromListToDetail) {
            let vc = segue.destination as! NewsDetailViewController
            vc.newsDetailViewModel.article = newsListViewModel.selectedItem
        }
    }
}

extension NewsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier, for: indexPath) as? NewsListCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(newsDataModel: newsListViewModel.articles[indexPath.row])
        return cell
        
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = self.newsListViewModel.articles[indexPath.row]
        self.newsListViewModel.selectedItem = selectedItem
        self.newsListViewModel.articles[indexPath.row] = selectedItem
        performSegue(withIdentifier: Navigation.fromListToDetail, sender: self)
    }
}

extension NewsListViewController: NewsListCellDelegate {
    func didTapFavoriteIcon(state: Bool, cell: UITableViewCell?) {
        if  state {
            Toast.Builder()
                .title(NewsDetailConstants.status)
                .message(NewsDetailConstants.statusMessage)
                .titleColor(.green)
                 .build()
                 .show(on: self)
        }
    }
}
