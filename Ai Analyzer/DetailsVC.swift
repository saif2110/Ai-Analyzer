//
//  DetailsVC.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 13/05/24.
//

import UIKit
import AVFoundation

class DetailsVC: UIViewController {
    
    @IBOutlet weak var SummaryTitle: UILabel!
    @IBOutlet weak var SummaryDeatils: UILabel!
    @IBOutlet weak var SummaryKeywords: UILabel!
    @IBOutlet weak var isAIGenereted: UILabel!
    let synth = AVSpeechSynthesizer()
    var cameFromHistory = false
    
    var SummaryData:SummaryData!
    var shareString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SummaryTitle.text = SummaryData.title?.capitalizingFirstLetter()
        SummaryDeatils.text = SummaryData.summary?.capitalizingFirstLetter()
        isAIGenereted.text = SummaryData.quickinsights?.capitalizingFirstLetter()
        
        for i in SummaryData.keywords ?? [] {
            SummaryKeywords.text = (SummaryKeywords.text ?? "") + i + " , "
        }
        
        if let currentText = SummaryKeywords.text, currentText.count > 2 {
            SummaryKeywords.text = String(currentText.dropLast(2)).capitalized
        } else {
            // Handle cases where text is nil or too short
            // Example: You could leave it unchanged or set it to an empty string
            SummaryKeywords.text = ""
        }
        
        
        
        shareString = (self.SummaryTitle.text ?? "") + "\n" + "\nDetails:\n \(self.SummaryDeatils.text ?? "")"  + "\n" + "\nKeywords:\n \(self.SummaryKeywords.text ?? "")"
        
        if !cameFromHistory {
            DispatchQueue.main.async {
                saveSummaryDataArray(self.SummaryData)
            }
        }
        
    }
    @IBAction func share(_ sender: Any) {
        DispatchQueue.main.async {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [self.shareString], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func play(_ sender: Any) {
        
        self.showAlertMessage(title: "Loading..", message: "Please wait for few seconds.")
        
        DispatchQueue.main.async {
            let string = self.shareString
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            self.synth.speak(utterance)
        }
        
    }
    
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func copyText(_ sender: Any) {
        UIPasteboard.general.string = shareString
        self.showAlertMessage(title: "Copied!", message: "The text has been copied to the clipboard.")
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }
}

extension UIViewController{
    
    public func showAlertMessage(title: String, message: String){
        
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertMessagePopUpBox, animated: true)
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
}



func saveSummaryDataArray(_ summaryData: SummaryData) {
    var loadArray = loadSummaryDataArray() ?? []  // Initialize to an empty array if nil
    loadArray.append(summaryData)
    
    // Ensure the array does not exceed 30 elements
    if loadArray.count > 30 {
        loadArray.removeFirst()  // Remove the oldest element
    }

    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(loadArray) {
        UserDefaults.standard.set(encoded, forKey: "SummaryDataArray")
    }
}


func loadSummaryDataArray() -> [SummaryData]? {
    if let savedSummaryData = UserDefaults.standard.object(forKey: "SummaryDataArray") as? Data {
        let decoder = JSONDecoder()
        if let loadedSummaryData = try? decoder.decode([SummaryData].self, from: savedSummaryData) {
            return loadedSummaryData.reversed()
        }
    }
    return nil
}

