//
//  VideoView.swift
//  Bijutune
//
//  Created by 堀内浩樹 on 2022/08/16.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var player: AVPlayer
    
    @State var thumnailVisible = true
    
    var body: some View {
        VideoPlayer(player: player)
            .onTapGesture {
                switch player.timeControlStatus {
                case .playing:
                    player.pause()
                case .paused:
                    player.play()
                default: break
                }
            }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(player: AVQueuePlayer(items: []))
    }
}
