extends Node

# Singleton instance
var instance
var timeServeur 



var DECIMAL_COLLECTOR = 0

var latency = 0
var CLOCK_CLIENT = 0

func _process(delta):
	CLOCK_CLIENT += delta
	
func _ready():
	# Set this instance as the Singleton
	instance = self

# Function to set server_time
func set_server_time(time):
	CLOCK_CLIENT = time

# Function to get server_time
func get_server_time():
	return CLOCK_CLIENT
	
func request_server_time():
	rpc_id(1, "fetch_server_time", OS.get_system_time_msecs())
	
remote func ReturnServerTime(timeSer, timeCli):
	print("server returned ")
	timeServeur = timeSer
	latency = (OS.get_system_time_msecs() - timeCli) / 2
	CLOCK_CLIENT = timeSer + latency
	
