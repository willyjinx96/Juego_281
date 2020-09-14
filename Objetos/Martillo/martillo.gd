extends Sprite


func _ready():
	Jugador.connect("attack",self, "start")
	pass

func start():
	$AnimationPlayer.play("recarga")
