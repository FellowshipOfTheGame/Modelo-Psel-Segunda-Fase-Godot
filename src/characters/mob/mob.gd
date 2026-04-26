extends RigidBody2D

const SAFE_DISTANCE = 400

enum State {
	shooting,
	searching,
}

var curr_state = State.searching

@onready var gun_hand = $Marker2DL
@onready var timer = $Timer
@onready var bullet = preload("res://src/objects/bullet/bullet.tscn")


func _physics_process(_delta: float) -> void:
	# pega a distancia entre o inimigo e o jogador
	var distance_to_player = global_position.distance_to(Game.player_pos)

	# muda o estado dependendo da distância
	curr_state = State.shooting if distance_to_player < SAFE_DISTANCE else State.searching

	# verifica qual o estado atual
	match curr_state:
		State.shooting:
			if timer.is_stopped():
				timer.start() # por padrão o timer executa em loop
		State.searching:
			timer.stop() # nesse caso precisamos parar ele manualmente


func _on_timer_timeout() -> void:
	var new_bullet = bullet.instantiate() # instancia um packed_scene
	# aqui nós acessamos a posição do player através do autoload
	if Game.player_pos.x - global_position.x > 0:
		# "position" seria a posição relativa a origem do objeto, para acessar a
		# posição global na cena precisamos usar global_position
		new_bullet.global_position = $Marker2DR.global_position
		new_bullet.direction = Vector2.RIGHT
	else:
		new_bullet.global_position = $Marker2DL.global_position
		new_bullet.direction = Vector2.LEFT

	# adcionamos a instancia na arvore de nós como filho do node raiz
	get_tree().current_scene.add_child(new_bullet)
