//
//  HIstoryViewController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 14/05/24.
//

import UIKit

class HIstoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadSummaryDataArray()?.count ?? 0
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
