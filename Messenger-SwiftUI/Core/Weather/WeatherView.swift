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
                // Gradient background using light blue and indigo colors
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#B27179"), Color(hex: "#FFB37B"), Color(hex: "#FFF19C")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("Select a Division")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Picker("Division", selection: $selectedDivision) {
                        ForEach(divisions.keys.sorted(), id: \.self) { division in
                            Text(division)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)
                    .clipped()
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(15)
                    .padding()

                    Button(action: {
                        if let city = divisions[selectedDivision] {
                            weatherService.fetchWeather(for: city, countryCode: "BD")
                        }
                    }) {
                        Text("Get Weather")
                            .fontWeight(.bold)
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                    .padding()

                    if let weather = weatherService.weather {
                        // Weather card
                        VStack(spacing: 20) {
                            VStack {
                                Text("Temperature: \(kelvinToCelsius(weather.main.temp))°C")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Feels Like: \(kelvinToCelsius(weather.main.feels_like))°C")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                            .shadow(radius: 15)

                            // Weather icon and description
                            if let weatherIcon = weather.weather.first?.icon, let description = weather.weather.first?.description {
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png")) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                
                                Text(description.capitalized)
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                }
                .padding()
                .onAppear {
                    // Fetch weather for default division (Dhaka)
                    weatherService.fetchWeather(for: divisions["Dhaka"] ?? "Dhaka", countryCode: "BD")
                }
            }
            .navigationTitle("Weather Info") // Set a title for the navigation bar
            .navigationBarItems(leading: Button(action: {
                dismiss() // Dismiss the current view when back button is tapped
            }) {
                HStack {
                    Image(systemName: "chevron.left") // Back arrow icon
                    Text("Back")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
            })
        }
    }
}
