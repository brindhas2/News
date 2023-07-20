//
//  NewsListCell.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import UIKit

class NewsListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    var newsData:NewsDataModel?
    weak var delegate: NewsListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(newsDataModel: NewsDataModel) {
        newsData = newsDataModel
        titleLabel.text = newsDataModel.title
        //favButton.isSelected = newsDataModel.isFavorite
        favButton.tintColor =  newsDataModel.isFavorite  ? .red : .black
        dateLabel.text = RSDateFormatter.stringFromDate(newsDataModel.publishedDate, toStringWithFormat: DateFormatterString.shortDateFormat2)
        nameLabel.text = newsDataModel.author
        if let url = URL(string: newsDataModel.imageUrl)  {
            imgView.load(url: url)
        } else {
            //load default image
        }
        
        let data = Data(newsDataModel.newsDescription.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            descriptionLabel.attributedText = attributedString
            let font = UIFont.systemFont(ofSize: 16)
            descriptionLabel.font = font
        }
    }
    
    @IBAction func favoriteIconTapped(_ sender: UIButton) {
        newsData?.isFavorite = !(newsData?.isFavorite ?? false)
        sender.tintColor =  (newsData?.isFavorite ?? false) ? .red : .black
        delegate?.didTapFavoriteIcon(state: newsData?.isFavorite ?? false, cell: self)
    }
}

protocol NewsListCellDelegate: NSObjectProtocol {
    func didTapFavoriteIcon(state: Bool, cell: UITableViewCell?)
}
