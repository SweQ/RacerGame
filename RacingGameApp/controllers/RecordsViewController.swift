//
//  RecordsViewController.swift
//  RacingGameApp
//
//  Created by alexKoro on 5/4/21.
//

import UIKit

class RecordsViewController: UIViewController {

    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var recordLabel: UILabel!

    private var records: [Record] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        records = RecordController.shared.getRecords()
        recordLabel.text = "RECORDS".localized()
        recordsTableView.dataSource = self
        let nib = UINib(nibName: "RecordTableViewCell", bundle: nil)
        recordsTableView.register(nib, forCellReuseIdentifier: "RecordTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}

extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "RecordTableViewCell") as? RecordTableViewCell else { return UITableViewCell()}
        cell.showRecord(record: records[indexPath.row]
        )
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        return cell
    }

}
