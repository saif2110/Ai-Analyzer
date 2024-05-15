//
//  HIstoryViewController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 14/05/24.
//

import UIKit

class HIstoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if loadSummaryDataArray()?.count == 0 {
            self.tableView.setEmptyMessage("The is no data in the list right now. History will be added here once you use the feature.")
        } else {
            self.tableView.restore()
        }
        
        return loadSummaryDataArray()?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.name, for: indexPath) as! HistoryCell
        
        let data = loadSummaryDataArray()?[indexPath.row]
        cell.titleText.text = data?.about
        cell.descriptionText.text = data?.about
        
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate  = self
        tableView.dataSource  = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = story.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
            vc.SummaryData = loadSummaryDataArray()?[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            vc.cameFromHistory = true
            self.present(vc, animated: true)
        }
    }
    
}


class HistoryCell:UITableViewCell {
    
    static var name : String {
        String(describing: self)
    }
    
    static var nib:UINib {
        UINib(nibName: name, bundle: Bundle.main)
    }
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
