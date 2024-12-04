extends Node

# Port to listen on
const SERVER_PORT = 80
var server := TCPServer.new()
var clients: Array = []
var used_clients:int = 0

func _ready():
	# Start listening for connections
	var result = server.listen(SERVER_PORT)
	if result != OK:
		print("Failed to start server: ", result)
	else:
		print("Server started on port ", SERVER_PORT)
	set_process(true)

func _process(delta):
	# Accept new client connections
	if server.is_connection_available():
		var client = server.take_connection()
		if client:
			clients.append(client)
			print("New client connected.")

	# Handle client requests
	for client in clients:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			if client.get_available_bytes() > 0:
				var request = client.get_utf8_string(client.get_available_bytes())
				print("Received request:\n", request)
				_handle_request(client, request)
		else:
			clients.erase(client)


func _handle_request(client: StreamPeerTCP, request: String):
	# HTML response with corrected diamond-shaped D-pad layout
	var client_id_loc:int = request.find("client=",request.length()-30)
	var client_id:int = -1
	if client_id_loc > 0:
		client_id = int(request.substr(client_id_loc+7,request.length()-request.find("&",request.length()-30)))
		
		return
	else:
		used_clients+= 1
		client_id = used_clients
		
		
		
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
			#up { top: 0; left: 50%; transform: translateX(-50%); background-color: #3498db; }
			#down { bottom: 0; left: 50%; transform: translateX(-50%); background-color: #e74c3c; }
			#left { left: 0; top: 50%; transform: translateY(-50%); background-color: #f1c40f; }
			#right { right: 0; top: 50%; transform: translateY(-50%); background-color: #2ecc71; }
			.buttons {
				display: flex;
				flex-direction: column;
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
			#select { background-color: #9b59b6; }
			#back { background-color: #34495e; }
			button:hover {
				opacity: 0.8;
			}
		</style>
		<script>
			function sendAction(action) {
				var xhr = new XMLHttpRequest();
				xhr.open("POST", "/", true);
				xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				xhr.onload = function() {
					if (xhr.status === 200) {
						// You can process the response here
						console.log('Response:', xhr.responseText);
					}
				};
				xhr.send("action=" + action + "&client="""
				
	body += str(client_id)
	body += """");
			}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="dpad">	
				<button id="up" onclick="sendAction('up')">Up</button>
				<button id="down" onclick="sendAction('down')">Down</button>
				<button id="left" onclick="sendAction('left')">Left</button>
				<button id="right" onclick="sendAction('right')">Right</button>
			</div>
			<div class="buttons">
				<button id="select" onclick="sendAction('select')">Start</button>
				<button id="back" onclick="sendAction('back')">Back</button>	
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

