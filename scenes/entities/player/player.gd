extends Entity

@export_group('move')
@export var speed := 200
@export var acceleration := 700
@export var friction := 900
var direction := Vector2.ZERO
var can_move := true
var dash := false
@export_range(0.1,2) var dash_cooldown := 0.5
var ducking := false
var gamepad_active := true

@export_group('jump')
@export var jump_strength := 300
@export var gun_jump_strength := 180
@export var gravity := 600
@export var terminal_velocity := 500
var jump := false
var gun_jump := false
var faster_fall := false
var gravity_multiplier := 1

@export_group('gun')
var aim_direction := Vector2.RIGHT
@export var crosshair_distance := 20
const y_offset := 6
var current_gun = Global.guns.AK 
@export_range(0.2,2.0) var ak_cooldown := 0.5
@export_range(0.2,2.0) var shotgun_cooldown := 1.2
@export_range(0.2,2.0) var rocket_cooldown := 1.5

# Player mau
var max_hp = 100
var current_hp = max_hp
var is_dead = false

@onready var health_circle = get_tree().get_first_node_in_group('health_circle')
@onready var retry_screen = $RetryScreen
@onready var retry_button = $RetryScreen/RetryButton

# Hàm _ready() để thiết lập ban đầu
func _ready():
	$Timers/DashCooldown.wait_time = dash_cooldown
	$Timers/AKReload.wait_time = ak_cooldown
	$Timers/ShotgunReload.wait_time = shotgun_cooldown
	$Timers/RocketReload.wait_time = rocket_cooldown
	
	# Kiểm tra xem RetryScreen có tồn tại trong cây scene không
	if retry_screen == null:
		print("Lỗi: RetryScreen không tồn tại trong cây scene!")
	else:
		print("retry screen đã được tìm thấy")

	# Kết nối nút Retry với hàm _on_retry_button_pressed
	if retry_button:
		retry_button.connect("pressed", Callable(self, "_on_retry_button_pressed"))

func _process(delta):
	# Nếu nhân vật chết, không xử lý thêm
	if is_dead:
		return
	
	# Áp dụng lực hấp dẫn
	apply_gravity(delta)
	
	# Kiểm tra di chuyển nếu có thể
	if can_move:
		get_input()
		apply_movement(delta)
		animate()

# Cập nhật animation của nhân vật
func animate():
	$Crosshair.update(aim_direction, crosshair_distance, ducking)
	$PlayerGraphics.update_legs(direction, is_on_floor(), ducking)
	$PlayerGraphics.update_torso(aim_direction, ducking, current_gun)

# Lấy input từ người chơi (di chuyển, nhảy, dash, ...)

func get_input():
	# Di chuyển ngang
	direction.x = Input.get_axis("left", "right")
	
	# Nhảy
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or $Timers/Coyote.time_left:
			jump = true
		
		if velocity.y > 0 and not is_on_floor():
			$Timers/JumpBuffer.start()
	
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		faster_fall = true

	# Dash
	if Input.is_action_just_pressed("dash") and velocity.x and not $Timers/DashCooldown.time_left:
		dash = true
		$Timers/DashCooldown.start()
	
	# Ngồi (ducking)
	ducking = Input.is_action_pressed("duck") and is_on_floor()

	# Aim
	var aim_input_gamepad = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	var aim_input_mouse = get_local_mouse_position().normalized()
	var aim_input = aim_input_gamepad if gamepad_active else aim_input_mouse
	if aim_input.length() > 0.5:
		aim_direction = Vector2(round(aim_input.x), round(aim_input.y))

	# Switch vũ khí
	if Input.is_action_just_pressed("switch"):
		current_gun = Global.guns[Global.guns.keys()[(current_gun + 1) % len(Global.guns)]] 

	# Bắn súng
	if Input.is_action_just_pressed("shoot"):
		shoot_gun()

# Hàm nhập liệu cho gamepad/mouse
func _input(event):
	if event is InputEventMouseMotion:
		gamepad_active = false
	if Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down"):
		gamepad_active = true

# Áp dụng lực hấp dẫn cho nhân vật
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)

# Xử lý di chuyển của nhân vật
func apply_movement(delta):
	# Di chuyển trái/phải
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	
	if ducking:
		velocity.x = 0
	
	# Nhảy
	if jump or $Timers/JumpBuffer.time_left and is_on_floor():
		velocity.y = -jump_strength
		jump = false
		faster_fall = false
	
	# Gun jump
	if gun_jump:
		velocity.y = -gun_jump_strength
		gun_jump = false
		faster_fall = false
		
	var on_floor = is_on_floor()
	move_and_slide()
	if on_floor and not is_on_floor() and velocity.y >= 0:
		$Timers/Coyote.start()
	
	# Dash
	if dash:
		$DashSound.play()
		dash = false
		$PlayerGraphics.dash_particles(direction)
		flash(get_sprites())  # Gọi hàm get_sprites() để lấy các sprite
		var dash_tween = create_tween()
		dash_tween.tween_property(self, 'velocity:x', velocity.x + direction.x * 600, 0.3)
		dash_tween.connect("finished", on_dash_finish)
		gravity_multiplier = 0

# Kết thúc dash
func on_dash_finish():
	velocity.x = move_toward(velocity.x, 0, 500)
	gravity_multiplier = 1
	
# Hàm block di chuyển khi nhân vật chết
func block_movement():
	can_move = false
	velocity = Vector2.ZERO
	$PlayerGraphics/Legs.stop()

# Hàm bắn súng
func shoot_gun():
	var pos = position + aim_direction * crosshair_distance
	pos = pos if not ducking else pos + Vector2(0,y_offset)
	if current_gun == Global.guns.AK and not $Timers/AKReload.time_left:
		shoot.emit(pos, aim_direction, current_gun) 
		$Timers/AKReload.start()
	if current_gun == Global.guns.ROCKET and not $Timers/RocketReload.time_left:
		shoot.emit(pos, aim_direction, current_gun) 
		$Timers/RocketReload.start()
	if current_gun == Global.guns.SHOTGUN and not $Timers/ShotgunReload.time_left:
		shoot.emit(pos, aim_direction, current_gun) 
		$Timers/ShotgunReload.start()
		$GPUParticles2D.position = $Crosshair.position
		$GPUParticles2D.process_material.set('direction', aim_direction)
		$GPUParticles2D.emitting = true
		
		if aim_direction.y == 1 and velocity.y >= 0:
			gun_jump = true

# Hàm xử lý khi nhân vật chết
func on_player_died():
	if is_dead:
		return  # Nếu đã chết, không làm gì thêm

	is_dead = true  # Đánh dấu trạng thái chết của Player
	block_movement()  # Ngừng di chuyển
	velocity = Vector2.ZERO

	# Hiển thị Retry chỉ khi Player chết
	if current_hp <= 0:
		if retry_screen:
			print("Showing retry screen...")
			retry_screen.show_retry()  # Gọi hàm show_retry() từ node RetryScreen
			get_tree().paused = true  # Dừng game
		else:
			print("Lỗi: RetryScreen không tồn tại!")

# Hàm cho nút retry
func _on_retry_button_pressed():
	get_tree().reload_current_scene()

# Hàm áp dụng sát thương
func apply_damage(damage):
	if is_dead:
		return  # Nếu nhân vật đã chết, không làm gì thêm

	current_hp -= damage
	current_hp = clamp(current_hp, 0, max_hp)  # Đảm bảo máu không giảm dưới 0

	# Nếu máu bằng 0, xử lý nhân vật chết
	if current_hp <= 0:
		on_player_died()  # Gọi hàm on_player_died() khi Player chết

# Hàm get_sprites() trả về các sprite node
func get_sprites():
	return [$PlayerGraphics/Legs, $PlayerGraphics/Torso]

@onready var camera = $Camera2D  # Đảm bảo Camera2D là node con của player

func get_cam():
	return camera
