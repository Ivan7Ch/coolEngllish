//
//  Dictionary.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 15.05.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Firebase
import SwiftyJSON


class DictionaryHelper {
    static let shared = DictionaryHelper()
    
    private init() {}
    
    func fetchFile() {
        let storage = Storage.storage()
        let fileRef = storage.reference(withPath: "sample.json")
        
        fileRef.getData(maxSize: Int64.max, completion: { data, error in
            guard let data = data else { return }
            let obj = try? JSONDecoder().decode([Word].self, from: data)
            print(obj)
        })
    }
}


struct Word: Codable {
    var id: Int
    var original: String
    var translated: String = ""
    var transcription: String = ""
    var audioPath: String = ""
    var sentence: String = ""
}
