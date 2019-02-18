extends Control

var title_arr = []
var desc_arr = []
var link_arr = []


func _ready():
	#pass # Replace with function body.
	load_data()

# event handlers

func _on_Open_Url_pressed():
	$HTTPRequest.request($InputRSS.text)
	
	title_arr.clear()
	desc_arr.clear()
	link_arr.clear()
	$ItemList.clear() #this doesnt seem to be working
	$DescriptionField.text = ""
	$LinkButton.text = ""
	
	for x in $ItemList.get_item_count():
		$ItemList.remove_item(x)
	


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var p = XMLParser.new()
	var in_item_node = false
	var in_title_node = false
	var in_description_node = false
	var in_link_node = false

	
	
	p.open_buffer(body)
	

	$RSSField.set_text(body.get_string_from_utf8())

	while p.read() == OK:
		
		var node_name = p.get_node_name()
		var node_data = p.get_node_data()
		var node_type = p.get_node_type()
		
		
		if(node_name == "item"):
			in_item_node = !in_item_node #toggle item mode

		if (node_name == "title") and (in_item_node == true):
			in_title_node = !in_title_node
			continue
		
		if(node_name == "description") and (in_item_node == true):
			in_description_node = !in_description_node
			continue
			
		if(node_name == "link") and (in_item_node == true):
			in_link_node = !in_link_node
			continue
		
		
		if(in_description_node == true):
			# print("description-data" + node_data)
			if(node_data != ""):
				desc_arr.append(node_data)
			else:
				# print("description:" + node_name)
				desc_arr.append(node_name)
		
		if(in_title_node == true):
			# print("Title-data:"+ node_data)
			if(node_data !=""):
				title_arr.append(node_data)
			else:
				# print("Title:" + node_name)
				title_arr.append(node_name)

		if(in_link_node == true):
			# print("link-desc" + node_data)
			if(node_data != ""):
				link_arr.append(node_data)
			else:
				# print("link" + node_name)
				link_arr.append(node_name)
		
	for i in title_arr: 
	#	print(i)
		$ItemList.add_item(i,null,true)
	
	


func _on_ItemList_item_selected(index):
	print("item selected"+ str(index))
	print(desc_arr[index])
	$DescriptionField.text = desc_arr[index]
	$LinkButton.text = link_arr[index]
	 # Replace with function body.


func _on_LinkButton_pressed():
	OS.shell_open($LinkButton.text)
	pass # Replace with function body.


func _on_ConfigButton_pressed():
	$ConfigWindow.popup()
	pass # Replace with function body.

# Replace with function body.


func _on_DeleteButton_pressed():
	print("delete rss feed")
	#pass # Replace with function body.
	$ConfigWindow/InputDelRSS.text = ""



func _on_SaveButton_pressed():
	print("save button pressed")
	var save_game = File.new()
	save_game.open("user://save_game.save", File.WRITE)
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#    	# Now we can call our save function on each node.
#		var node_data = i.call("save")
#		save_game.store_line(to_json(node_data))
	var node_data = save()
	print(str(node_data))
	save_game.store_line(to_json(node_data))
	save_game.close()

func save():
	print("save called")
	var save_dict = {
		"url" : $ConfigWindow/InputDelRSS.text
	}
	return save_dict
	
	#pass # Replace with function body.

func load_data(): 
	print("load_data called")
	var save_game = File.new()
	if not save_game.file_exists("user://save_game.save"):
		return #error no save game!
	save_game.open("user://save_game.save", File.READ)
	print("opened save")
	var text = save_game.get_as_text()
	print(text)
	print(parse_json(text)['url'])
	$ConfigWindow/InputDelRSS.text = parse_json(text)['url']
	$InputRSS.text = $ConfigWindow/InputDelRSS.text
	
#	while not save_game.eof_reached():
#		print("found a line")
#		print("line"+ save_game.get_line())
		#var current_line = parse_json(save_game.get_line())
		#print("current_line" + current_line['url'])
		# $ConfigWindow/InputDelRSS.text = current_line["url"]
	save_game.close()
		