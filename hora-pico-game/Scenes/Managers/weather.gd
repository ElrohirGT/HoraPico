extends Node2D

## Enum de los estados para el clima
enum WeatherStates {
	## Lluvioso
	RAINY,
	## Soleado
	SUNNY
}
# Traducción para los fans de Franco Escamilla          - Dan

##⠀⠀⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾⣻⣿⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾⠉⠳⠂⢲
##⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠁
##⠀⠀⣿⣿⣿⣿⣿⣿⡿⣿⡽⣿⣿⣿⣿⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀
##⠀⢰⣿⣿⣿⡿⢷⣤⣙⣿⣿⣿⣹⣿⣿⣿⣿⢿⣿⣯⣿⣿⣿⣿⣿⣿⢤⡎⠀⠀
## ⣴⣿⣟⠛⠋⣢⡤⣽⣿⣿⠯⠛⠟⠛⠏⠛⠣⡿⣿⡿⣿⣿⣿⣿⣿⣿⢺⠇⠀⠀
## ⣿⣿⣿⡩⠽⣻⢿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣾⣿⣿⣿⣿⠸⠀⠀⠀
## ⣿⣿⣿⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠉⠙⣿⣿⣿⣿⡆⣆⠀⠀
## ⣿⣿⠛⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠂⢕⣂⣤⢤⣄⠀⠈⣟⣿⣿⣿⣿⡄⠀
## ⢻⣿⡙⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠉⠁⠈⠛⢧⡠⢜⣿⣿⣿⣿⣧⠀
## ⢸⣿⢡⣀⡀⠀⠀⠀⠀⢀⠀⢀⣴⣿⠟⣁⠄⠂⣁⣄⠀⠀⢣⢈⢿⣿⣿⣿⡉⠀
## ⠀⢹⡟⠉⠛⠻⠿⣶⣄⡀⠉⢰⠞⢁⣨⠖⢿⠿⠉⠉⠁⠀⠀⣇⠘⣿⠝⣻⣇⠀
## ⠀⠀⣧⠀⣀⣤⣴⣴⣢⢼⠀⠀⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡏⢆⠃⣿⡀
## ⠀⠀⣿⠐⢏⠨⠋⠁⠀⡞⡆⠀⠱⡈⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⡇⠤⢠⣿⠁
## ⣠⣀⣿⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠱⣀⠀⠀⠀⠀⠀⠀⠀⢁⡖⠀⣿⣶⣿⠋⠀
## ⣿⣿⣿⣇⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⢳⠀⠀⠀⠀⠀⢠⡟⠀⠀⣿⣿⣿⣶⡇
## ⣿⣿⣿⣿⣆⠀⠀⠀⠀⠰⣳⣴⠖⢉⠭⠊⠀⠀⠀⠀⠀⠈⠀⠀⠀⣿⣿⣿⣿⡇
## ⣿⣿⣿⣿⣿⣷⣦⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠄⠀⠀⠀⠀⢰⣻⡿⣿⣿⣷
## ⣿⣿⣿⣿⣿⣿⣿⣯⡢⡀⠀⢤⡐⢉⡉⢭⡤⠘⡁⡕⠀⠀⠀⢀⡞⡂⣷⡘⢿⣿
## ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢯⠩⠑⠀⠁⠀⣀⠄⠄⠁⠀⠀⢀⣞⠚⠀⢸⣹⡘⣿
## ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⠒⠒⠚⠉⠁⠀⠀⠀⠀⣠⢿⠁⠀⠀⠀⡏⡇⢩
## ⣿⣿⣿⣿⣿⣿⣿⣿⡿⡵⢁⢾⣄⠀⠀⠀⠀⠀⠀⠀⣰⠏⠄⠀⠀⠀⠀⠃⢠⠀
## ⣿⣿⣿⣿⣿⣿⢟⠟⡌⠘⢅⣾⢻⠢⢄⣀⣀⣀⡤⠞⠁⠀⠀⠀⠀⠀⠀⡄⠘⠀
static var current_weather: WeatherStates = WeatherStates.values().pick_random()

func _on_weather_timer_timeout() -> void:
	current_weather = WeatherStates.values().pick_random()
	print("Weather changed to: ", WeatherStates.keys()[current_weather])
	EventBus.weather_changed.emit(current_weather)
