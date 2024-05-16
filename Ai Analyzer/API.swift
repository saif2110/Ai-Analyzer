//
//  API.swift
//  Lyrics Maker
//
//  Created by Admin on 20/09/23.
//

import Foundation
import CoreLocation
import UIKit


protocol GetDataProtocall {
    func getData(data:SummaryData)
}


class APIModels {
    
    static var shared = APIModels()
    
    var PlantDetailsDelegate: GetDataProtocall?
    
    func hitapi(params:[String:String]) {
        let URL = "https://apps15.com/Summariser/summariserapi.php";
        
        APIRequest().callAPI(URLstring: URL, model: SummaryData.self, parameters: params) { Success, data in
            
            if Success {
                if let data = data  {
                    self.PlantDetailsDelegate?.getData(data: data)
                }
            }
            
        }
        
    }
    
}

struct SummaryData: Codable {
    var title, summary, quickinsights: String?
    var keywords: [String]?
    var isEducational: String?

    enum CodingKeys: String, CodingKey {
        case title, summary
        case quickinsights = "quickinsights"
        case keywords, isEducational
    }
}
