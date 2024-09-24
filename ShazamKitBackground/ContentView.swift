//
//  ContentView.swift
//  ShazamKitBackground
//
//  Created by Tomas Martins on 24/09/24.
//

import SwiftUI
import ShazamKit
import ActivityKit

struct ContentView: View {
    @State var isRunning: Bool = false
    @State var session: SHManagedSession = .init()
    
    var body: some View {
        Button {
            Task { await toggleMatch() }
        } label: {
            Text(isRunning ? "Stop Matching" : "Start Matching")
        }
    }
    
    func toggleMatch() async {
        if isRunning {
            session.cancel()
            isRunning = false
        } else {
            isRunning = true
            await updateLiveActivity(title: nil, artist: nil)
            for await match in session.results {
                if case .match(let shMatch) = match,
                   let song = shMatch.mediaItems.first {
                    await updateLiveActivity(title: song.title, artist: song.artist)
                }
            }
        }
    }
    
    func updateLiveActivity(title: String?, artist: String?) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            fatalError("Live Activities are not authorized")
        }
        if let activity {
            await activity.update(.init(state: .init(title: title, artist: artist), staleDate: nil))
        } else {
            do {
                let attributes = ShazamKitBackgroundWidgetAttributes.init()
                _ = try Activity.request(attributes: attributes, content: .init(state: .init(title: title, artist: artist), staleDate: nil))
            } catch {
                let errorMessage = """
                                        Couldn't start activity
                                        ------------------------
                                        \(String(describing: error))
                                        """
                print(errorMessage)
            }
        }
    }
    
    var activity: Activity<ShazamKitBackgroundWidgetAttributes>? {
        return Activity<ShazamKitBackgroundWidgetAttributes>.activities.first
    }
}

#Preview {
    ContentView()
}
