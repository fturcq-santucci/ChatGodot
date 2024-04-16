extends Node


# Quand appelée, renvoie l'heure
remote func fetch_server_time(timeCli):
	print("client requested time")
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "ReturnServerTime", int(OS.get_system_time_msecs()/1000), timeCli)


