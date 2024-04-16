extends Control

var login_text = ""
var connected_users = []  # Liste pour stocker les IDs des utilisateurs connectés

func _ready():
	get_tree().connect("connected_to_server", self, "entered_room")
	get_tree().connect("network_peer_connected", self, "new_user_connected")
	get_tree().connect("network_peer_disconnected", self, "user_disconnected")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	

func entered_room():
	$Panel/chatBox.text += "Entered Room \n"

func new_user_connected(id):
	$Panel/chatBox.text += str(id) + " has entered Room \n"

func user_disconnected(id):
	$Panel/chatBox.text += str(id) + " has left room \n"

func server_disconnected():
	$Panel/chatBox.text += "server has disconnected \n"

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()

func send_message():
	var message = $Panel/inputMessage.text
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", id, message)
	$Panel/inputMessage.text = ""
	print(NetworkClock.CLOCK_CLIENT)

sync func receive_message(id, message):
	print("time serv " + str(NetworkClock.timeServeur))
	var time = convert_to_readable_time(int(NetworkClock.CLOCK_CLIENT))
	$Panel/chatBox.text += str(id) + " [" + str(time) + "] : " + message + "\n"

func convert_to_readable_time(unix_time):
	var datetime = OS.get_datetime_from_unix_time(unix_time)
	return "%02d:%02d:%02d" % [datetime.hour, datetime.minute, datetime.second]

func change_scene():
	var new_scene_path = "res://connection.tscn"  # Remplacez par le chemin correct de votre scène
	get_tree().change_scene(new_scene_path)

func _on_Button_button_up():
	get_tree().set_network_peer(null)
	change_scene()
	
remote func receive_user_list(users):
	connected_users = users
	$Panel/chatBox/listeUser.text = str(connected_users)


	

