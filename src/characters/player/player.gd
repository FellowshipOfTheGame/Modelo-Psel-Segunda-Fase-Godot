extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var hp = 500

@onready var jump_audio := $AudioStreamPlayer2D
@onready var life = $CanvasLayer/MarginContainer/Label

func _ready() -> void:
	life.text = str(hp)

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
		velocity.x = move_toward(velocity.x, 0, SPEED/10)  
		
	# função padrão da godot, usa a variável velocity para definir o movimento
	# e já aplica delta_time automáticamente
	move_and_slide() 
	
	# Game é um atoload, usamos ele para guardar a posição do player para que 
	# possa ser acessada pelo inimigo
	Game.player_pos = global_position


func take_damage(damage):
	hp -= damage
	life.text = str(hp)
	
	# um tween é um objeto que interpola uma propriedade de um node entre o 
	# valor atual até um valor final, durante um intervalo "delta" em segundos.
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	# A segunda interpolação só é chamada quando a primeira terminar de executar
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
