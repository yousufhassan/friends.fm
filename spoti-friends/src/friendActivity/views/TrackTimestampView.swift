import SwiftUI

/// The View that renders the time elapsed since a track was played or a playing now icon.
///
/// - Parameters:
///   - nowPlaying: True if the track was played within the last 15 minutes; false otherwise.
///   - timestamp: The `TimeInterval` for when the track was played.
///
/// - Returns: A View rendering a playing now icon or a string displaying when the track was played relative to now.
struct TrackTimestampView: View {
    let nowPlaying: Bool
    let timestamp: TimeInterval
    
    var body: some View {
        if nowPlaying {
            //            Image(.nowPlaying)
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .frame(width: 16, height: 16)
            AnimatedSoundbarsView()
                .frame(width: 16, height: 16)
        } else {
            let relativeTimeElapsed = getRelativeTime(since: timestamp)
            Text(relativeTimeElapsed)
        }
    }
}

struct AnimatedSoundbarsView: View {
    @State private var barHeights: [CGFloat] = Array(repeating: 10, count: 3)
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { index in
                Rectangle()
                    .frame(width: 2, height: barHeights[index] - 3)
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 0.4).repeatForever(autoreverses: true)) {
                barHeights = [
                    CGFloat.random(in: 7...15),
                    CGFloat.random(in: 15...22),
                    CGFloat.random(in: 7...15)
                ]
            }
        }
    }
}


#Preview {
    TrackTimestampView(nowPlaying: true, timestamp: 1720151150)
}
