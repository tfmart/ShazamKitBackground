//
//  ShazamKitBackgroundWidgetLiveActivity.swift
//  ShazamKitBackgroundWidget
//
//  Created by Tomas Martins on 24/09/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ShazamKitBackgroundWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ShazamKitBackgroundWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                if let title = context.state.title, let artist = context.state.artist {
                    Text("\(title) by \(artist)")
                } else {
                    Text("Listening...")
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    if let title = context.state.title, let artist = context.state.artist {
                        Text("\(title) by \(artist)")
                    } else {
                        Text("Listening...")
                    }
                }
            } compactLeading: {
                if context.state.title != nil, context.state.artist != nil {
                    Image(systemName: "checkmark")
                } else {
                    Image(systemName: "magnifyingglass")
                }
            } compactTrailing: {
                Image(systemName: "waveform.badge.mic")
            } minimal: {
                Image(systemName: "waveform.badge.mic")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ShazamKitBackgroundWidgetAttributes {
    fileprivate static var preview: ShazamKitBackgroundWidgetAttributes {
        ShazamKitBackgroundWidgetAttributes()
    }
}

extension ShazamKitBackgroundWidgetAttributes.ContentState {
    fileprivate static var noMatch: ShazamKitBackgroundWidgetAttributes.ContentState {
        ShazamKitBackgroundWidgetAttributes.ContentState(title: nil, artist: nil)
     }
     
     fileprivate static var match: ShazamKitBackgroundWidgetAttributes.ContentState {
         ShazamKitBackgroundWidgetAttributes.ContentState(title: "One More Time", artist: "Daft Punk")
     }
}

#Preview("Notification", as: .content, using: ShazamKitBackgroundWidgetAttributes.preview) {
   ShazamKitBackgroundWidgetLiveActivity()
} contentStates: {
    ShazamKitBackgroundWidgetAttributes.ContentState.noMatch
    ShazamKitBackgroundWidgetAttributes.ContentState.match
}
