//
//  CameraViewController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 13/05/24.
//

import UIKit
import AVFoundation
import Photos
import CoreFoundation
import VisionKit


class CameraViewController: UIViewController, DataScannerViewControllerDelegate {
    private var scannerViewController: DataScannerViewController!
    private let doneButton = UIButton()
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
           // print(text)
            placeholderLabel = text.transcript
            doneButtonTapped()
            
        case .barcode(let code):
            // Open the URL in the browser.
            break
        default:
            // Insert code to handle other data types.
            break
        }
    }
    
    var placeholderLabel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScannerViewController()
        setupDoneButton()
    }
    
    private func setupScannerViewController() {
        scannerViewController = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .fast,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isGuidanceEnabled: true, isHighlightingEnabled: true
        )
        
        scannerViewController.delegate = self
        addChild(scannerViewController)
        view.addSubview(scannerViewController.view)
        scannerViewController.view.frame = view.bounds
        scannerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scannerViewController.didMove(toParent: self)
        
        do {
            try scannerViewController.startScanning()
        } catch {
            print("Failed to start scanning: \(error)")
        }
    }
    
    private func setupDoneButton() {
        doneButton.setTitle("Scan the text and tap to summarize it", for: .normal)
        doneButton.backgroundColor = .clear
        doneButton.titleLabel?.textColor = .white
        doneButton.layer.cornerRadius = 12
        //doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.isUserInteractionEnabled = false
        doneButton.isEnabled = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 400),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func doneButtonTapped() {
        
        guard placeholderLabel.count > 3 else { return }
        
        let texts = splitTextIntoThreeParts(text: placeholderLabel)
        
        APIModels.shared.hitapi(params: ["startingText" : texts.start,"midText":texts.mid,"endText":texts.end, "length": "medium","isPRO" : String(Manager.isPro)])
        
        self.scannerViewController.stopScanning()
        
        self.dismiss(animated: true) {
            if let topController = UIApplication.topViewController() {
                DispatchQueue.main.async {
                    let story = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = story.instantiateViewController(withIdentifier: "Loading") as! Loading
                    vc.modalPresentationStyle = .fullScreen
                    topController.present(vc, animated: true)
                }
            }
        }
    }
}

