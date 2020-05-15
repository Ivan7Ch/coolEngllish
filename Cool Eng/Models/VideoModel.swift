//
//  VideoModel.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit


struct VideoModel {
    var id: Int
    var name: String
    var playlist: Int
    var placeholder: String
    var subtitlesId: Int = 0
    var subtitles: [SubtitleModel] = []
    var url: String
}
