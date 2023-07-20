//
//  NewsDetailViewController.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var newsDetailViewModel = NewsDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetails()
        
        // Do any additional setup after loading the view.
    }
    
    func displayDetails() {
        if let newsDataModel = newsDetailViewModel.article {
            self.title = newsDataModel.title
           // favButton.isSelected = newsDataModel.isFavorite
            favButton.tintColor =  newsDataModel.isFavorite  ? .red : .black
            dateLabel.text = RSDateFormatter.stringFromDate(newsDataModel.publishedDate, toStringWithFormat: DateFormatterString.shortDateFormat2)
            authorLabel.text = newsDataModel.author
            if let url = URL(string: newsDataModel.imageUrl)  {
                imgView.load(url: url)
            } else {
                //load default image
            }
            
            let data = Data(newsDataModel.content.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                contentLabel.attributedText = attributedString
                let font = UIFont.systemFont(ofSize: 16)
                contentLabel.font = font
            }
            
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
       
        newsDetailViewModel.article?.isFavorite =  !(newsDetailViewModel.article?.isFavorite ?? false)
        if  newsDetailViewModel.article?.isFavorite ?? false {
            Toast.Builder()
                .title(NewsDetailConstants.status)
                .message(NewsDetailConstants.statusMessage)
                .titleColor(.green)
                 .build()
                 .show(on: self)
        }
        sender.tintColor =  (newsDetailViewModel.article?.isFavorite ?? false) ? .red : .black
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
