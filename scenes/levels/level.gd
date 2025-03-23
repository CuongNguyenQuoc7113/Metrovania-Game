extends Node2D

const explosion_scene := preload("res://scenes/projectiles/explosion.tscn")
const bullet_scene := preload("res://scenes/projectiles/bullet.tscn")
@export var camera_limit: Vector4i
@onready var camera: Camera2D = get_tree().get_first_node_in_group('Player').get_cam()

func _ready():
	# camera
	camera.limit_left = camera_limit.x
	camera.limit_top = camera_limit.y
	camera.limit_right = camera_limit.z
	camera.limit_bottom = camera_limit.w
	
	for i in $Main/Entities.get_child_count():
		var entity = $Main/Entities.get_child(i)
		if entity.has_signal('shoot'):
			entity.connect('shoot', create_bullet)
		
		if entity.has_signal('detonate'):
			entity.connect('detonate', create_explosion)

		var scene_name = get_tree().current_scene.name
		if scene_name in Global.enemy_data:
			#print("Scene name: ", scene_name)
			#print("Enemy data for scene: ", Global.enemy_data[scene_name])
			#print("Index i: ", i)
			#print("Size of Enemy Data: ", Global.enemy_data[scene_name].size())
			for index in range(Global.enemy_data[scene_name].size()):
				if index < Global.enemy_data[scene_name].size():
					entity.setup(Global.enemy_data[scene_name][index])
				else:
					print("Index out of range: ", index)

# Hàm tạo bullet, sử dụng call_deferred để trì hoãn việc thêm bullet vào cây scene
func create_bullet(pos, dir, bullet_type):
	var bullet = bullet_scene.instantiate()
	# Sử dụng call_deferred để thêm bullet vào sau khi va chạm được xử lý
	call_deferred("_add_bullet", bullet, pos, dir, bullet_type)

# Hàm riêng để thêm bullet vào cây scene
func _add_bullet(bullet, pos, dir, bullet_type):
	$Main/Projectiles.add_child(bullet)
	bullet.setup(pos, dir, bullet_type)
	if bullet_type == Global.guns.ROCKET:
		bullet.connect('detonate', create_explosion)

# Hàm tạo explosion, sử dụng call_deferred để trì hoãn việc thêm explosion vào cây scene
func create_explosion(pos):
	var explosion = explosion_scene.instantiate()
	# Sử dụng call_deferred để thêm explosion vào sau khi va chạm được xử lý
	call_deferred("_add_explosion", explosion, pos)

# Hàm riêng để thêm explosion vào cây scene
func _add_explosion(explosion, pos):
	$Main/Projectiles.add_child(explosion)
	explosion.position = pos

func _exit_tree():
	@warning_ignore("unassigned_variable")
	var current_enemy_data: Array
	for entity in $Main/Entities.get_children():
		current_enemy_data.append([entity.position, entity.velocity, entity.health])
	Global.enemy_data[get_tree().current_scene.name] = current_enemy_data
