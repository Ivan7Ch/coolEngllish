//
//  PlaylistModel.swift
//  Cool Eng
//
//  Created by Ivan Chernetskiy on 13.04.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import Foundation


struct PlaylistModel {
    var id: Int
    var name: String
    var placeholder: String
    var views: Int = 2
    var videosCount = 0
    var isFree = true
}
