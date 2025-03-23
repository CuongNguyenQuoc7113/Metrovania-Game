extends Node2D

@onready var retry_button = $RetryButton
@onready var death_label = $DeathLabel

# Khai báo các biến cần thiết
var is_dead = false  # Biến kiểm tra trạng thái chết
var velocity = Vector2.ZERO  # Biến lưu trữ tốc độ di chuyển
var can_move = true  # Biến kiểm soát khả năng di chuyển của nhân vật (ban đầu là có thể di chuyển)

@onready var retry_screen =  $"." # Tham chiếu đến RetryScreen (hoặc bất kỳ node nào bạn sử dụng cho màn hình retry)

# Khai báo hàm block_movement để ngừng di chuyển
func block_movement():
	velocity = Vector2.ZERO  # Đặt tốc độ về 0
	can_move = false  # Ngừng khả năng di chuyển
	$PlayerGraphics/Legs.stop()  # Dừng chuyển động của nhân vật (tùy thuộc vào cách bạn xử lý animation)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false  # Ẩn màn hình retry khi bắt đầu game

	# Thiết lập nút Retry
	retry_button.connect("pressed", Callable(self, "_on_retry_button_pressed"))
	
	# Thiết lập label
	death_label.text = "You Died!"
	death_label.modulate = Color(1, 0, 0)  # Màu đỏ
	death_label.visible = false  # Ẩn label "You Died!" ban đầu
	retry_button.visible = false  # Ẩn nút Retry ban đầu

	retry_button.focus_mode = Control.FOCUS_ALL  # Thêm vào root của toàn bộ cây scene

func show_retry():
	print("Showing Retry Screen")
	visible = true  # Hiển thị màn hình Retry
	death_label.visible = true  # Hiển thị thông báo "You Died!"
	retry_button.visible = true  # Hiển thị nút Retry
	$RetryButton.grab_focus()  # Đưa tiêu điểm vào nút Retry

func on_player_died():
	if is_dead:
		return  # Nếu đã chết, không làm gì thêm
	# Đặt trạng thái chết
	is_dead = true
	block_movement()  # Ngừng di chuyển
	velocity = Vector2.ZERO
	
	if retry_screen:
		print("Showing retry screen...")
		retry_screen.show_retry()  # Gọi hàm show_retry() từ node RetryScreen
		get_tree().paused = true  # Dừng game
	else:
		print("Lỗi: RetryScreen không tồn tại!")

func _on_retry_button_pressed():
	print("Retry button pressed!")
	get_tree().paused = false  # Hủy bỏ trạng thái paused
	get_tree().reload_current_scene()  # Tải lại cảnh hiện tại (Retry)
