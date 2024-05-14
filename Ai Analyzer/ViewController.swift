//
//  ViewController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 12/05/24.
//

import UIKit

class ViewController: UIViewController, GetDataProtocall {
    
    func getData(data: SummaryData) {
        print(data)
    }
    
    var lengthOfSummary = "medium"
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var placeholderLabel:UITextView!
    
    let Placeholder = "\n\nEnter or paste your long text here to get summary."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Manager.isWelcomeDone {
            DispatchQueue.main.async {
                let main = UIStoryboard(name: "Welcome", bundle: Bundle.main)
                let vc = main.instantiateViewController(identifier: "WelcomeVC")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
        
        if !Manager.isPro {
            showIAP()
        }
        
        placeholderLabel.delegate = self
        placeholderLabel.text = Placeholder
        placeholderLabel.textColor = UIColor.lightGray
        APIModels.shared.PlantDetailsDelegate = self
    }
    
    private func showIAP(){
        DispatchQueue.main.async {
            let vc = IAPViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    @IBAction func pasteBut(_ sender: Any) {
        makeTextFilled()
        self.placeholderLabel.text = UIPasteboard.general.string
        self.textCount.text = String(self.placeholderLabel.text.count)
    }
    
    @IBAction func clearBut(_ sender: Any) {
        placeholderLabel.text = ""
        makeClear()
    }
    
    @IBAction func lenghtSumaary(_ sender: UISlider) {
        
        if sender.value < 1 {
            lengthOfSummary = "very short"
        }else if sender.value < 2 {
            lengthOfSummary = "short"
        }else if sender.value < 3 {
            lengthOfSummary = "medium"
        }else if sender.value < 4 {
            lengthOfSummary = "long"
        }else if sender.value < 5 {
            lengthOfSummary = "very long"
        }
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        guard placeholderLabel.text.count > 3 else { return }
        guard placeholderLabel.text != Placeholder else { return }
        
        let texts = splitTextIntoThreeParts(text: placeholderLabel.text)
        
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = story.instantiateViewController(withIdentifier: "Loading") as! Loading
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
       
        APIModels.shared.hitapi(params: ["startingText" : texts.start,"midText":texts.mid,"endText":texts.end, "length": lengthOfSummary])
        
    }
    
    
}

extension ViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if placeholderLabel.text == Placeholder {
            makeTextFilled()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if placeholderLabel.text == "" {
            makeClear()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textCount.text = String(textView.text.count)
    }
    
    func makeTextFilled(){
        placeholderLabel.text = ""
        placeholderLabel.textColor = UIColor.white
        placeholderLabel.font = .systemFont(ofSize: 16)
        placeholderLabel.textAlignment = .left
        textCount.text = String(placeholderLabel.text.count)
    }
    
    func makeClear(){
        placeholderLabel.text = Placeholder
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = .systemFont(ofSize: 14)
        placeholderLabel.textAlignment = .center
        textCount.text = "0"
    }
    
}

func splitTextIntoThreeParts(text: String) -> (start: String, mid: String, end: String) {
    if text.count > 500 {
        let partLength = text.count / 3
        let startIndex = text.index(text.startIndex, offsetBy: partLength)
        let endIndex = text.index(text.endIndex, offsetBy: -partLength)
        
        let startText = String(text[..<startIndex])
        let midText = String(text[startIndex..<endIndex])
        let endText = String(text[endIndex...])
        
        return (start: startText, mid: midText, end: endText)
    } else {
        // If text is not longer than 500 characters, return it as is in the start, and leave mid and end empty.
        return (start: text, mid: text, end: text)
    }
}
