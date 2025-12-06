@tool
extends EditorScript

# 这个脚本会自动为MainFloor场景中的祭坛添加脚本
# 在Godot编辑器中：File -> Run 选择此脚本运行

func _run():
	var scene_path = "res://Scenes/MainFloor.tscn"
	var packed_scene = load(scene_path) as PackedScene
	var scene = packed_scene.instantiate()

	var altar_script = load("res://Scenes/altar.gd")
	var altars_fixed = 0

	# 查找所有名为Altar的节点
	for child in scene.get_children():
		if child.name.begins_with("Altar"):
			if child.script == null:
				child.script = altar_script

				# 添加InteractPrompt标签
				var prompt = Label.new()
				prompt.name = "InteractPrompt"
				prompt.text = "按 F 打开商店"
				prompt.position = Vector2(0, -40)
				prompt.add_theme_color_override("font_color", Color(1, 1, 0, 1))
				child.add_child(prompt)
				prompt.owner = scene

				altars_fixed += 1
				print("已修复祭坛: ", child.name)

	if altars_fixed > 0:
		# 保存场景
		var new_packed = PackedScene.new()
		new_packed.pack(scene)
		ResourceSaver.save(new_packed, scene_path)
		print("场景已保存！共修复 ", altars_fixed, " 个祭坛")
	else:
		print("未找到需要修复的祭坛")

	scene.queue_free()
