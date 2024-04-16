extends Control


var host = NetworkedMultiplayerENet.new()

func _ready():
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")

func join_room():
	var ip = $Panel/ipInput.text  
	var error = host.create_client(ip, 2000)
	if error == OK:
		print("Connection success!")
	get_tree().set_network_peer(host)
	
	change_scene()
func change_scene():
	var new_scene_path = "res://Control.tscn"  
	get_tree().change_scene(new_scene_path)

func _on_connected_to_server():
	print("Connected to server. Can start RPC from now on.")
	NetworkClock.request_server_time()
func _on_join_button_up():
	join_room()


	

