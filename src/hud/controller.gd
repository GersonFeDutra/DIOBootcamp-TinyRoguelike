extends Node

@onready var player := %Player
@onready var player_hurt_area := %Player/HurtArea
@onready var life_label := %LifeLabel
@onready var gold_label := %GoldLabel


func _unhandled_input(event: InputEvent) -> void:
	# Is Game Over
	if event.is_action_pressed(&"interact") or \
			event.is_action_pressed(&"ui_cancel"):
		%GameOver.fade_out()
		get_viewport().set_input_as_handled()


func _ready() -> void:
	set_process_input(false)
	
	var health_max := str(player_hurt_area.health_max)
	life_label.text = health_max
	%MaxLifeLabel.text = health_max
	
	gold_label.text = str(player.gold)


func _on_player_health_changed(to: int) -> void:
	life_label.text = str(to)


func _on_player_gold_changed(to: int) -> void:
	gold_label.text = str(to)


func _on_player_health_depleated() -> void:
	%GameOver.fade_in(player.gold, %Levelling.current_wave, player.kills)
