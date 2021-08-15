//
//  RecordTableViewCell.swift
//  RacingGameApp
//
//  Created by alexKoro on 7/2/21.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var mainVIew: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainVIew.backgroundColor = .systemRed
        mainVIew.layer.cornerRadius = 10
    }

    func showRecord(record: Record) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        dateLabel.text = dateFormatter.string(from: record.date)
        playerLabel.text = record.playerName
        recordLabel.text = "\(record.score)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
