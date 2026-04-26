extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# @onready faz com que a variável seja declarada assim que o objeto terminar de ser configurado
# e todos seus filhos sejam instanciados. Como estamos pegando uma referência a um filho desse
# objeto, precisamos garantir que o filho já tenha sido instanciado, e por isso usamos o @onready
@onready var jump_audio := $AudioStreamPlayer2D


# executado todo frame de fisica antes de _process. Por padrão a fisica roda 60 frames
# por segundo, mesmo que seu jogo rode a um framerate maior
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): # verifica se o player está colidindo com o chão
		# velocity é uma variável padrão de nodes do tipo CharacterBody
		velocity += get_gravity() * delta # gravity é uma variavel predefinida na godot

	# Verifica se o input acabou de ser pressionado
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_audio.play()
		velocity.y = JUMP_VELOCITY

	# retorna um valor positivo ou negativo dependendo de qual input foi pressionado
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		# interpola a váriavel velocity.x até 0 por um décimo de SPEED
		# gerando um efeito de inércia onde o personagem para aos poucos.
		# Quanto menor o último valor, mas devagar o personagem para de se mover
		velocity.x = move_toward(velocity.x, 0, SPEED / 10)

	# função padrão da godot, usa a variável velocity para definir o movimento
	# e já aplica delta_time automáticamente
	move_and_slide()

	# Game é um atoload, usamos ele para guardar a posição do player para que
	# possa ser acessada pelo inimigo
	Game.player_pos = global_position


# executado todo frame "real" após _physics_process, diferente de _physics_process
# essa função não roda necessariamente 60 frames for segundo, se seu jogo rodar a um framerate
# maior, ela executará mais vezes.
func _process(_delta: float) -> void:
	# Não usaremos essa função nesse projeto
	pass


func take_damage():
	# um tween é um objeto que interpola uma propriedade de um node entre o
	# valor atual até um valor final, durante um intervalo "delta" em segundos.
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	# A segunda interpolação só é chamada quando a primeira terminar de executar
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

	# tween_callback é uma função que será chamada assim que o tween terminar de executar.
	# nesse caso estamos chamando a função "call_deferred" de get_tree(). Como call_deferred
	# espera um argumento, preciamos passar esse argumento através do método bind().
	#
	# call_deferred é uma função usada para fazer que alguma outra função seja executada somente
	# ao final do frame, após todos os outros processos já terem terminado de processar.
	# É importante usar call_deferred caso seu objeto esteja fazendo alguma ação que vá interferir
	# com todos os outros objetos, como por exemplo, recarregar a cena atual.
	tween.tween_callback(get_tree().call_deferred.bind("reload_current_scene"))
