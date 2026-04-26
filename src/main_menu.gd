extends Control

# preload carrega uma cena e mantém ela em memória para ser acessada depois
@onready var game = preload("res://src/level/level.tscn")


func _on_play_btn_pressed() -> void:
	# muda a cena atual para uma packed_scene. Uma packed_scene é um recurso que
	# guarda um cena que ainda não foi instanciada.
	get_tree().change_scene_to_packed(game)


func _on_quit_btn_pressed() -> void:
	get_tree().quit(0) # sai do jogo com valor de retorno "0"
