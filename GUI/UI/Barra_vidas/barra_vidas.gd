extends TileMap

var vidas
var offset = 33
var heart_scene = preload("res://GUI/UI/Barra_vidas/corazon_barra.tscn")
var live_bar = []

func _ready():
	vidas=Jugador.vida
	fill_live_bar()
	crear_barra()
	Jugador.connect("hit",self,"remove_heart")
	Jugador.connect("heart_taken",self,"add_heart")
	pass
	
func fill_live_bar():
	#print(vidas)
	for i in vidas:
		var heart = heart_scene.instance()
		get_tree().get_nodes_in_group("spawner")[0].add_child(heart)
		heart.global_position = $spawner_hearts.global_position
		heart.global_position.x += offset*i
		live_bar.append(heart)
		#print(i)

func crear_barra():
	var tam = ceil(vidas/2)+2
	for i in tam:
		if i==0:
			set_cell(i,0,0,false,false,false,Vector2(0,0))
		elif i ==tam-1:
			set_cell(i,0,0,false,false,false,Vector2(2,0))
		else:
			set_cell(i,0,0,false,false,false,Vector2(1,0))
	
	for i in range(tam, 10):
		set_cell(i,0,0,false,false,false,Vector2(1,1))

func remove_heart():
	if not live_bar.empty():
		vidas -= 1
		live_bar[vidas].play("heart_lost")
		live_bar.resize(vidas)

func add_heart():
#	if vidas <5:
		var new_heart= heart_scene.instance()
		get_tree().get_nodes_in_group("spawner")[0].add_child(new_heart)
		new_heart.global_position = $spawner_hearts.global_position
		new_heart.global_position.x += offset* live_bar.size()
		live_bar.append(new_heart)
		Jugador.vida +=1
		vidas +=1
		crear_barra()
