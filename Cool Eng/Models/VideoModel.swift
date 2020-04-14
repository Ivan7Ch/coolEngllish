//
//  VideoModel.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


struct VideoModel {
    var id: String
    var name: String
    var playlist: String
    var placeholder: String
    var subtitles: [SubtitleModel]
    var url: String
}
