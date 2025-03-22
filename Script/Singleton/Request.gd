extends Node

signal received_image_gif

var http: HTTPRequest = HTTPRequest.new()
var image_gif: AnimatedTexture

func _ready() -> void:
	add_child(http)

func get_image_tenor(_key: String = "cat") -> AnimatedTexture:
	http.request_completed.connect(request_completed)
	http.request(str("https://g.tenor.com/v1/search?q=",_key,"&key=LIVDSRZULELA&limit=8"))
	
	await received_image_gif
	return image_gif


func request_completed(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if _response_code == 200:
		var response = JSON.parse_string(_body.get_string_from_ascii())
		
		var results = response.results
		if results.size() > 0:
			var gif_url = results[0]["media"][0]["gif"]["url"]
			
			http.request_completed.disconnect(request_completed)
			http.request_completed.connect(request_completed_gif)
			
			http.request(gif_url)
	else:
		print("Erro na requisição: ", _response_code)

func request_completed_gif(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if _response_code == 200:
		
		image_gif = GifManager.animated_texture_from_buffer(_body, 256)
		received_image_gif.emit()
		
		http.request_completed.disconnect(request_completed_gif)
