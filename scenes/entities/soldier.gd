extends Entity

var x_direction := 1
var speed = Global.enemy_parameters['soldier']['speed']
var speed_modifier := 1
var attack := false
var is_dead := false  # Thêm cờ trạng thái
@onready var player = get_tree().get_first_node_in_group('Player')

func _ready():
	health = Global.enemy_parameters['soldier']['health']

func _process(_delta):
	if is_dead:
		return  # Ngăn mọi logic nếu "soldier" đã chết
	if health > 0:
		velocity.x = x_direction * speed * speed_modifier
		check_cliff()
		check_player_distance()
		animate()
		move_and_slide()


func check_player_distance():
	if position.distance_to(player.position) < 120:
		attack = true
		speed_modifier = 0
	else:
		attack = false
		speed_modifier = 1


func animate():
	$Sprite2D.flip_h = x_direction < 0
	if attack:
		var side = 'right'
		var difference = (player.position - position).normalized()
		$Sprite2D.flip_h = difference.x < 0
		if difference.y < -0.5 and abs(difference.x) < 0.4:
			side = 'up'
		if difference.y > 0.5 and abs(difference.x) < 0.4:
			side = 'down'
		$AnimationPlayer.current_animation = 'shoot_'+ side
		return
	$AnimationPlayer.current_animation = 'run' if x_direction else 'idle'



func _on_wall_check_area_body_entered(_body):
	if not is_dead: #chỉ thay đổi hướng nếu chưa chết
		x_direction *= -1


func check_cliff():
	if not is_dead: # Chỉ kiểm tra vách đá nếu chưa chết
		if x_direction > 0 and not $FloorRays/Right.get_collider():
			x_direction = -1
		if x_direction < 0 and not $FloorRays/Left.get_collider():
			x_direction = 1


func trigger_attack():
	if not is_dead:  # Chỉ bắn nếu chưa chết
		var dir = (player.position - position).normalized()
		shoot.emit(position + dir * 20, dir, Global.guns.AK)

func get_sprites():
	return [$Sprite2D]


func trigger_death():
	if not is_dead:  # Chỉ xử lý nếu Soldier chưa chết
		var dir = (player.position - position).normalized()
		var bullet_pos = position + dir * 20
		
		# Lấy thông tin súng từ gun_data
		var gun_info = Global.gun_data[Global.guns.AK]
		var damage = gun_info['damage']  # Lấy sát thương từ súng AK
		
		# Gọi hàm giảm máu của player
		player.apply_damage(damage)
		
		# Phát tín hiệu bắn
		shoot.emit(bullet_pos, dir, Global.guns.AK)
		
		# Nếu Soldier chết
		if health <= 0:
			is_dead = true
			# Sử dụng call_deferred() để vô hiệu hóa collider sau khi xử lý xong va chạm
			call_deferred("disable_collisions")  
			$AnimationPlayer.play("death")  # Chơi animation chết
			velocity = Vector2.ZERO
			x_direction = 0  # Ngừng thay đổi hướng khi chết

func disable_collisions():
	$CollisionShape2D.disabled = true
	velocity = Vector2.ZERO  # Ngăn di chuyển sau khi chết

func setup(data):
	super.setup(data)
	speed_modifier = 0
	$AnimationPlayer.stop()
	$Sprite2D.frame = 22
