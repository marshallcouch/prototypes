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
	print(request.length())
	var client_id_loc:int = request.find("client=",request.length()-30)
	var client_id:int = -1
	if client_id_loc > 0:
		client_id = int(request.substr(client_id_loc+7,request.length()-request.find("&",request.length()-30)))
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
				width: 600px;
			}
			.dpad {
				position: relative;
				width: 150px;
				height: 150px;
			}
			#up, #down, #left, #right {
				position: absolute;
				width: 50px;
				height: 50px;
				border: none;
				border-radius: 10px;
				font-size: 16px;
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
				width: 100px;
				height: 50px;
				font-size: 16px;
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
	</head>
	<body>
		<div class="container">
			<div class="dpad">
				<form method="POST">	
					<button id="up" name="action" value="up">Up</button>
					<button id="down" name="action" value="down">Down</button>
					<button id="left" name="action" value="left">Left</button>
					<button id="right" name="action" value="right">Right</button>"""
	body += "<input type=\"hidden\" name=\"client\" value=\"" + str(client_id) + "\" />"
	body += """			
				
				</form>
			</div>
			<div class="buttons">
				<form method="POST">
					<button id="select" name="action" value="select">Start</button>
					<button id="back" name="action" value="back">Back</button>"""
	body += "<input type=\"hidden\" name=\"client\" value=\"" + str(client_id) + "\" />"
	body += """		
				</form>
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

