//
//  TabBarController.swift
//  Ai Analyzer
//
//  Created by Saif Mukadam on 13/05/24.
//

import UIKit
import VisionKit

class TabBarController: UITabBarController,UITabBarControllerDelegate, DataScannerViewControllerDelegate {
    
    func dataScannerDidZoom(_ dataScanner: DataScannerViewController) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        print(tabBarController.tabBar.tag)
        if viewController is CameraViewController {

            DispatchQueue.main.async {
                let scannerContainerVC = CameraViewController()
                self.present(scannerContainerVC, animated: true, completion: nil)
            }

            return false
        }

        // Tells the tab bar to select other view controller as normal
        return true
    }

}

