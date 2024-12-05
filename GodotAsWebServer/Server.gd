extends Node

# Port to listen on
const SERVER_PORT = 80
var server := TCPServer.new()
var clients: Array = []
var used_clients:int = 0
var moving:bool = false

func _ready():
	# Start listening for connections
	var result = server.listen(SERVER_PORT)
	if result != OK:
		print("Failed to start server: ", result)
	else:
		print("Server started on port ", SERVER_PORT)
	set_process(true)
	setup_grid()

func _process(delta):
	# Accept new client connections
	if server.is_connection_available():
		var client = server.take_connection()
		if client:
			clients.append(client)
			#print("New client connected.")

	# Handle client requests
	for client in clients:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			if client.get_available_bytes() > 0:
				var request = client.get_utf8_string(client.get_available_bytes())
				#print("Received request:\n", request)
				_handle_request(client, request)
		else:
			clients.erase(client)

const HEIGHT:int = 1200
const WIDTH:int = 1920
const STEPS:int = 80
func setup_grid():
	for i in range(0,HEIGHT+1,STEPS):
		var line = Line2D.new()
		line.add_point(Vector2(0,i))
		line.add_point(Vector2(WIDTH,i))
		line.width = 3
		line.self_modulate = Color.GRAY
		$Grid.add_child(line)
	for i in range(0,WIDTH+1,STEPS):
		var line = Line2D.new()
		line.add_point(Vector2(i,0))
		line.add_point(Vector2(i,HEIGHT))
		line.width = 3
		line.self_modulate = Color.GRAY
		$Grid.add_child(line)

func move_player(action:String):
	var new_position:Vector2
	if moving:
		return
	if action.contains("up"):
		if ($Sprite2D.position+ Vector2(0,-STEPS)).y < 0:
			return
		new_position = $Sprite2D.position+ Vector2(0,-STEPS)
	elif action.contains("down"):
		if ($Sprite2D.position+ Vector2(0,STEPS)).y > HEIGHT:
			return
		new_position = $Sprite2D.position+ Vector2(0,STEPS)
	elif action.contains("left"):
		if ($Sprite2D.position+ Vector2(-STEPS,0)).x < 0:
			return
		new_position = $Sprite2D.position+ Vector2(-STEPS,0)
	elif action.contains("right"):
		if ($Sprite2D.position+ Vector2(STEPS,0)).x > WIDTH:
			return
		new_position = $Sprite2D.position+ Vector2(STEPS,0)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position", new_position, .2)
	tween.tween_callback(done_moving)
	moving = true

func done_moving():
	moving = false
	
func _handle_request(client: StreamPeerTCP, request: String):
	# HTML response with corrected diamond-shaped D-pad layout
	var client_id_loc:int = request.find("client=",request.length()-30)
	var client_id:int = -1
	if client_id_loc > 0:
		client_id = int(request.substr(client_id_loc+7,request.length()-request.find("&",request.length()-30)))
		request.find("action",request.length())
		var action:String = request.substr(request.find("action"))
		print(action)
		move_player(action)
		client.disconnect_from_host()
		return
	else:
		used_clients+= 1
		client_id = used_clients
		print("New client connected... " + str(client_id))
		
		
		
	var body = """
<html>
	<head>
		<title>Controller</title>
		<style>
			body {
				font-family: Arial, sans-serif;
				margin: 0;
				background-color: #222;
				color: #fff;
				display: flex;
				justify-content: center;
				align-items: center;
				height: 100vh;
			}
			.container {
				display: flex;
				justify-content: space-between;
				width: 100%;
			}
			.dpad {
				position: relative;
				width: 450px;
				height: 450px;
			}
			#up, #down, #left, #right {
				position: absolute;
				width: 150px;
				height: 150px;
				border: none;
				border-radius: 10px;
				font-size: 32px;
				cursor: pointer;
				color: #fff;
			}
			#up { top: 0; left: 50%; transform: translateX(-50%); background-color: #9b59b6; }
			#down { bottom: 0; left: 50%; transform: translateX(-50%); background-color: #34495e; }
			#left { left: 0; top: 50%; transform: translateY(-50%); background-color: #f1c40f; }
			#right { right: 0; top: 50%; transform: translateY(-50%); background-color: #2ecc71; }
			.buttons {
				display: flex;
				flex-direction: row;
				align-items: center;
				gap: 10px;
			}
			#select, #back {
				width: 200px;
				height: 150px;
				font-size: 32px;
				border: none;
				border-radius: 10px;
				cursor: pointer;
				color: #fff;
			}
			#select { background-color: #3498db; }
			#back { background-color:  #e74c3c; }
			button:hover {
				opacity: 0.8;
			}
		</style>
		<script>
			function sendAction(action) {
				var xhr = new XMLHttpRequest();
				xhr.open("POST", "/", true);
				xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				xhr.send("action=" + action + "&client="""
				
	body += str(client_id)
	body += """");
			}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="dpad">	
				<button id="up" onclick="sendAction('up')"></button>
				<button id="down" onclick="sendAction('down')"></button>
				<button id="left" onclick="sendAction('left')"></button>
				<button id="right" onclick="sendAction('right')"></button>
			</div>
			<div class="buttons">
				<button id="select" onclick="sendAction('select')"></button>
				<button id="back" onclick="sendAction('back')"></button>	
			</div>
		</div>
	</body>
</html>
"""	
	# Ensure no extraneous characters before headers
	var response = "HTTP/1.1 200 OK\r\n"
	response += "Content-Type: text/html; charset=utf-8\r\n"
	response += "Content-Length: %d\r\n" % body.length()  # Correct content length
	response += "Connection: close\r\n"
	response += "\r\n"  # End of headers
	
	# Append the body content
	response += body
	client.put_data(response.to_utf8_buffer())
	client.disconnect_from_host()

