import SwiftUI

/// A SwiftUI view that allows users to select a time range (e.g., 4 weeks, 6 months, 1 year)
/// for displaying top tracks or artists.
///
/// - Parameters:
///   - selectedTimeRange: A binding to the currently selected `TimeRange`, which is updated when
///     the user taps one of the options.
///
/// This view displays buttons for each time range and highlights the selected option.
struct TimeRangeSelector: View {
    @Binding var selectedTimeRange: ProfileViewModel.TimeRange
    
    var body: some View {
        HStack {
            ForEach(ProfileViewModel.TimeRange.allCases, id: \.self) { timeRange in
                Button(action: {
                    selectedTimeRange = timeRange
                }) {
                    Text(timeRange.displayLabel)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .foregroundColor(Color.PresetColour.whitePrimary)
                        .background(selectedTimeRange == timeRange ? Color.PresetColour.spotifyGreen : Color.PresetColour.blackSecondary)
                        .font(.subheadline)
                }
            }
        }
        .background(Color.PresetColour.blackSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

#Preview {
    TimeRangeSelector(selectedTimeRange: .constant(.sixMonths))
}
