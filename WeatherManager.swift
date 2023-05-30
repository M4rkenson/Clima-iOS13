
import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(weather:WeatherModel)
}
struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6f65e34372c8c8528a1ac8fcecefbdae&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperature = decodedData.main.temp
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temperature)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
    
}
