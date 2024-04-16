extends Control

var time
var connected_user = []

func _ready():
	get_tree().connect("connected_to_server", self, "entered_room")
	get_tree().connect("network_peer_connected", self, "new_user_connected")
	get_tree().connect("network_peer_disconnected", self, "user_disconnected")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	host_chat()
	time = Time.get_ticks_usec()

func entered_room():
	$Panel/chatBox.text += "Entered Room \n"

func new_user_connected(id):
	$Panel/chatBox.text += str(id) + " has entered Room \n"
	connected_user.append(id)  # Ajouter l'ID de l'utilisateur à la liste
	send_user_list_to_all()
	update_chatbox_with_user_list()  # Mise à jour du chatBox avec la liste des utilisateurs

func update_chatbox_with_user_list():
	var user_list_str =  str(connected_user) + "\n"
	$Panel/chatBox/listeUser.text = user_list_str  # Mise à jour du texte de chatBox

func send_user_list_to_all():
	for id in get_tree().get_network_connected_peers():
		rpc_id(id, "receive_user_list", connected_user)  # Utilisez `connected_user`


func user_disconnected(id):
	$Panel/chatBox.text += str(id) + " has left room \n"
	if id in connected_user:
		connected_user.erase(id)  # Retirer l'ID de l'utilisateur de la liste

func server_disconnected():
	$Panel/chatBox.text += "server has disconnected \n"

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()

func host_chat():
	print("try create server")
	var host = NetworkedMultiplayerENet.new()
	host.create_server(2000)
	get_tree().set_network_peer(host)
	

func join_room():
	var ip = OS.get_local_addresses()
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, 2000)
	get_tree().set_network_peer(host)

func send_message():
	var message = $Panel/inputMessage.text
	var id = get_tree().get_network_unique_id()
	rpc("receive_message", id, message)
	$Panel/inputMessage.text = ""

sync func receive_message(id, message):
	var timeN = convert_to_readable_time(int(OS.get_system_time_msecs() / 1000))
	$Panel/chatBox.text += str(id) + " [" + str(timeN) + "] : " + message + "\n"

func convert_to_readable_time(unix_time):
	var datetime = OS.get_datetime_from_unix_time(unix_time)
	return "%02d:%02d:%02d" % [datetime.hour, datetime.minute, datetime.second]

# Quand appelée, renvoie l'heure
remote func fetch_server_time(timeCli):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", int(OS.get_system_time_msecs()/1000), timeCli)
