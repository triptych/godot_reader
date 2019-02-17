extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var title_arr = []
var desc_arr = []
var link_arr = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Open_Url_pressed():
	#$HTTPRequest.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")
	#$HTTPRequest.request("https://www.google.com")
	#$HTTPRequest.request("https://abcnews.go.com/abcnews/topstories")
	$HTTPRequest.request($InputRSS.text)
	
	title_arr.empty()
	desc_arr.empty()
	link_arr.empty()
	$ItemList.clear()
	
	for x in $ItemList.get_item_count():
		$ItemList.remove_item(x)
	


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var p = XMLParser.new()
	var in_item_node = false
	var in_title_node = false
	var in_description_node = false
	var in_link_node = false

	
	
	p.open_buffer(body)
	#print(p.get_current_line())
#	print("------")
#	print(p.is_empty())
#	print(p.get_attribute_count())
#	print(p.get_node_data())
#	p.read()
#	print("get node data")
#	print(p.get_node_data())
#	print("---")
#	print(p.get_node_name())
#	print(p.get_attribute_count())
#	print(p.get_attribute_name(2))
#	p.read()
#	print("---")
#	print(p.get_node_name())
#	print(p.get_attribute_count())
#	print(p.get_attribute_name(0))
	#print(response_code)
	#print(body.size())
	#print(body.get_string_from_ascii())
	# print(body)
	#print (body.get_string_from_utf8())
	#var json = JSON.parse(body.get_string_from_utf8())
	$RSSField.set_text(body.get_string_from_utf8())
	#print(json.result)
#	p.read()
#	p.read()
	#print(p.get_node_name())
	#print("seek")
	#p.seek(1)
	#print(p.get_node_name())
	while p.read() == OK:
		
		var node_name = p.get_node_name()
		var node_data = p.get_node_data()
		var node_type = p.get_node_type()
		
		# print("START: --")
		# print("node_name: " + node_name)
		# print("node_type: " + str(node_type))
		# print("node_data: " + node_data)
		
		if(node_name == "item"):
			in_item_node = !in_item_node #toggle item mode
			#print("found item!")
			#print("- in_item_node " + str(in_item_node))
		if (node_name == "title") and (in_item_node == true):
			in_title_node = !in_title_node
			#print("found title!")	
			#print("-- in_title_node " + str(in_title_node))
			continue
#		if (node_name == '') and (in_title_node):
#			print("Title: " + node_data)
				
		# print("-- :END")
		#p.read()
		#print(p.get_node_name())
		
		if(node_name == "description") and (in_item_node == true):
			in_description_node = !in_description_node
			continue
			
		if(node_name == "link") and (in_item_node == true):
			in_link_node = !in_link_node
			continue
		
		
		if(in_description_node == true):
			print("description-data" + node_data)
			if(node_data != ""):
				desc_arr.append(node_data)
			else:
				print("description:" + node_name)
				desc_arr.append(node_name)
		
		if(in_title_node == true):
			print("Title-data:"+ node_data)
			if(node_data !=""):
				title_arr.append(node_data)
			else:
				print("Title:" + node_name)
				title_arr.append(node_name)
		#print("node_data:" + node_data)
		if(in_link_node == true):
			print("link-desc" + node_data)
			if(node_data != ""):
				link_arr.append(node_data)
			else:
				print("link" + node_name)
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
