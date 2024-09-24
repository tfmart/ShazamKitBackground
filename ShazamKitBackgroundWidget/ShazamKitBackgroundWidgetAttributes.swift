//
//  ShazamKitBackgroundWidgetAttributes.swift
//  ShazamKitBackground
//
//  Created by Tomas Martins on 24/09/24.
//

import ActivityKit

struct ShazamKitBackgroundWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var title: String?
        var artist: String?
    }
}
