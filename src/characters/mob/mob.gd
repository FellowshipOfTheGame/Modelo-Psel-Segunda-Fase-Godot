extends CharacterBody2D

const SAFE_DISTANCE = 400

@onready var gun_hand = $Marker2DL
@onready var timer = $Timer
@onready var bullet = preload("res://src/objects/bullet/bullet.tscn")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var distance_to_player = abs(global_position.x - Game.player_pos.x)
	
	if distance_to_player < SAFE_DISTANCE and timer.is_stopped():
		timer.start() # por padrão o timer executa em loop
	elif distance_to_player >= SAFE_DISTANCE:
		timer.stop() # nesse caso precisamos parar ele manualmente
		
	move_and_slide()

func _on_timer_timeout() -> void:
	var new_bullet = bullet.instantiate() # instancia um packed_scene
	# aqui nés acessamos a posição do player através do autoload
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
