import Foundation

class WeatherService: ObservableObject {
    @Published var weather: WeatherResponse?

    func fetchWeather(for city: String, countryCode: String) {
        let apiKey = "4650ba904aa638afe3024dfab5ed6b59"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city),\(countryCode)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.weather = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error fetching weather: \(error)")
            }
        }.resume()
    }
}
