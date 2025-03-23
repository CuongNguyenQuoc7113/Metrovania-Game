@tool
extends Area2D

@export_enum('station', 'sky', 'underground') var level = 'station'
var levels = {}

func _ready():
	if not Engine.is_editor_hint():
		levels['station'] = "res://scenes/levels/station.tscn"
		levels['sky'] = "res://scenes/levels/sky.tscn"
		levels['underground'] = "res://scenes/levels/underground.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Transition triggered to:", levels[level])
		TransitionLayer.change_scene(levels[level])
