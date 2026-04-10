extends Area2D

var distance = 500

const DAMAGE := 10
var direction = Vector2.LEFT

@onready var shoot_audio = $AudioStreamPlayer2D # define uma referência para o objeto

# chamado assim que o node e seus filhos terminam de ser instanciados
func _ready() -> void:
	shoot_audio.play() # toca o audio assim que o objeto é instanciado

# chamado todo frame na etapa de calculo de fisica
func _physics_process(_delta: float) -> void:
	var tween = create_tween() # cria um novo Tween

	# target_pos é um Vector2 (objeto com valor para eixos x e y). Nós calculamos
	# esse valor pegando a posição global do objeto e adicionando outro Vector2 (direction)
	# multiplicado por uma distancia em pixels. o vetor "direction" define para qual lado
	# a bala vai se movimentar
	var target_pos = global_position + (direction * distance)

	# um tween é um objeto que interpola uma propriedade de um node entre o 
	# valor atual até um valor final, durante um intervalo "delta" em segundos. 
	# Nesse caso ele interpola a posição atual até a target_pos, durante 1 segundo.
	tween.tween_property(self, "global_position", target_pos, 1)
	# tween_callback define uma função para ser chamada assim que a interpolacao
	# terminar de ser executada. Nesse caso, o tween chama "queue_free()", que 
	# adiciona o objeto atual em uma fila para ser deletado da cena.
	tween.tween_callback(queue_free)


# função que é chamada assim que o sinal "on_body_entered" e disparado, ou seja,
# sempre que algum objeto do tipo "body" entra na area de colisão
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # verifica se o objeto está no grupo "player"
		body.take_damage(DAMAGE) # chama a função "take_damage" do objeto
		queue_free() # adiciona a bala na fila para ser deletada
