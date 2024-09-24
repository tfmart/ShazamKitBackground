//
//  ContentView.swift
//  ShazamKitBackground
//
//  Created by Tomas Martins on 24/09/24.
//

import SwiftUI
import ShazamKit
import ActivityKit
import os.log

struct ContentView: View {
    @State var isRunning: Bool = false
    let session: SHManagedSession = .init()
    
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
            os_log("Matching stopped", log: .default, type: .info)
            
            await endLiveActivity()
        } else {
            isRunning = true
            os_log("Starting matching", log: .default, type: .info)
            await updateLiveActivity(title: nil, artist: nil)
            for await match in session.results {
                if case .match(let shMatch) = match,
                   let song = shMatch.mediaItems.first {
                    os_log("Match found: %{public}@ by %{public}@", log: .default, type: .info, song.title ?? "Unknown", song.artist ?? "Unknown")
                    await updateLiveActivity(title: song.title, artist: song.artist)
                } else {
                    os_log("No match found in this iteration", log: .default, type: .debug)
                }
            }
            os_log("Exited matching loop", log: .default, type: .info)
        }
    }
    
    func updateLiveActivity(title: String?, artist: String?) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            os_log("Live Activities are not authorized", log: .default, type: .error)
            return
        }
        if let activity = Activity<ShazamKitBackgroundWidgetAttributes>.activities.first {
            await activity.update(.init(state: .init(title: title, artist: artist), staleDate: nil))
            os_log("Updated existing Live Activity. Title: %{public}@, Artist: %{public}@", log: .default, type: .info, title ?? "nil", artist ?? "nil")
        } else {
            do {
                let attributes = ShazamKitBackgroundWidgetAttributes()
                _ = try Activity.request(attributes: attributes, content: .init(state: .init(title: title, artist: artist), staleDate: nil))
                os_log("Requested new Live Activity. Title: %{public}@, Artist: %{public}@", log: .default, type: .info, title ?? "nil", artist ?? "nil")
            } catch {
                os_log("Couldn't start activity: %{public}@", log: .default, type: .error, error.localizedDescription)
            }
        }
    }
    
    func endLiveActivity() async {
        guard let activity = Activity<ShazamKitBackgroundWidgetAttributes>.activities.first else {
            os_log("No Live Activity to end", log: .default, type: .info)
            return
        }
        
        await activity.end(nil, dismissalPolicy: .immediate)
        os_log("Live Activity ended successfully", log: .default, type: .info)
    }
}

#Preview {
    ContentView()
}
