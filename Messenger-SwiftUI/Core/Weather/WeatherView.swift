import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherService = WeatherService()
    @State private var selectedDivision: String = "Dhaka" // Default division (Dhaka)
    @Environment(\.dismiss) private var dismiss // Environment action for back button

    
    let divisions = [
        "Dhaka": "Dhaka",
        "Chittagong": "Chittagong",
        "Khulna": "Khulna",
        "Rajshahi": "Rajshahi",
        "Barisal": "Barisal",
        "Sylhet": "Sylhet",
        "Rangpur": "Rangpur",
        "Mymensingh": "Mymensingh"
    ]
    
    // Convert Kelvin to Celsius with two decimal places
    func kelvinToCelsius(_ kelvin: Double) -> String {
        let celsius = kelvin - 273.15
        return String(format: "%.2f", celsius) // Format to two decimal points
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(gradient: Gradient(colors: [
                    Color(hex: "#1a1a1a"),
                    Color(hex: "#2d3436")
                ]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 25) {
                        // City Selection Card
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Location")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Picker("Division", selection: $selectedDivision) {
                                ForEach(divisions.keys.sorted(), id: \.self) { division in
                                    Text(division)
                                        .font(.title3)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                            .onChange(of: selectedDivision) { newDivision in
                                if let city = divisions[newDivision] {
                                    weatherService.fetchWeather(for: city, countryCode: "BD")
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Weather Display
                        if let weather = weatherService.weather {
                            // Main Weather Card
                            HStack(spacing: 20) {
                                // Left side - Temperature
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(kelvinToCelsius(weather.main.temp))
                                        .font(.system(size: 60, weight: .bold))
                                        .foregroundColor(.white)
                                    + Text("°C")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                    Text("Feels like \(kelvinToCelsius(weather.main.feels_like))°C")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                // Right side - Weather Icon
                                if let weatherIcon = weather.weather.first?.icon {
                                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png")) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .background(
                                                Circle()
                                                    .fill(Color.white.opacity(0.1))
                                                    .frame(width: 110, height: 110)
                                            )
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                            .padding(25)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#4a90e2"), Color(hex: "#3742fa")]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                            .shadow(color: Color(hex: "#4a90e2").opacity(0.3), radius: 15, x: 0, y: 10)
                            .padding(.horizontal)
                            
                            // Weather Details Card
                            if let description = weather.weather.first?.description {
                                HStack {
                                    VStack(alignment: .leading, spacing: 15) {
                                        Label(
                                            description.capitalized,
                                            systemImage: "cloud.fill"
                                        )
                                        .font(.system(size: 18, weight: .medium))
                                        
                                        Label(
                                            selectedDivision,
                                            systemImage: "location.fill"
                                        )
                                        .font(.system(size: 16))
                                    }
                                    .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.white)
            })
            .onAppear {
                weatherService.fetchWeather(for: divisions["Dhaka"] ?? "Dhaka", countryCode: "BD")
            }
        }
    }
}
