extends Node

var objetos = {
	"marca_horizontal": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/02_PROTAGONIST_POLAROID.png"),
				"nombre": "Marca horizontal",
				"informacion": "placeholder"
			}
		}
	},
	"equimosis_faciales": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/01_DETECTIVE_POLAROID.png"),
				"nombre": "Equimosis faciales",
				"informacion": "placeholder"
			}
		}
	}
}

var perfiles = {
	"protagonista": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/02_PROTAGONIST_POLAROID.png"),
				"nombre": "Samuel Collins",
				"informacion": "placeholder"
			}
		}
	},
	"detective": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/01_DETECTIVE_POLAROID.png"),
				"nombre": "Claire Chandler",
				"informacion": "placeholder"
			}
		}
	},
	"duenyo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/06_BOSS_POLAROID.png"),
				"nombre": "Dueño del circo",
				"informacion": "placeholder"
			},
			2: {
				"imagen": preload("res://arte/fotos/06_BOSS_POLAROID_BW.png")
			},
			3: {
				"nombre": "Víctor Barnum"
			}
		}
	},
	"forzudo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/07_STRONGMAN_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			},
			2: {
				"nombre": "Eugen Hart"
			}
		}
	},
	"maga": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/04_MAGICIAN_POLAROID.png"),
				"nombre": "Adelaide",
				"informacion": "placeholder"
			},
			2: {
				"nombre": "Rebecca Barnum"
			}
		}
	},
	"payasa": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/03_CLOWN_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			},
			2: {
				"nombre": "Gaby"
			}
		}
	},
	"trapecista": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/05_AERIALIST_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			},
			2: {
				"nombre": "Jules Laurent"
			}
		}
	}
}

var lugares = {
	"exterior": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fondos/SET_Exterior.png"),
				"nombre": "Exterior del circo",
				"informacion": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
			},
			2: {
				"imagen": preload("res://arte/fondos/SET_Exterior_Hot.png"),
				"informacion": "placeholder"
			}
		}
	},
	"carpa": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fondos/SET_Escenario.png"),
				"nombre": "Interior del circo",
				"informacion": "placeholder"
			}
		}
	},
	"despacho": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fondos/SET_Despacho.png"),
				"nombre": "Despacho",
				"informacion": "placeholder"
			}
		}
	},
	"cuarto_chicas": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fondos/SET_CuartoChicas.png"),
				"nombre": "Cuarto de las chicas",
				"informacion": "placeholder"
			}
		}
	},
	"cuarto_chicos": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fondos/SET_CuartoChicos.png"),
				"nombre": "Cuarto de los chicos",
				"informacion": "placeholder"
			}
		}
	}
}

var puzzles = {
	"dialogos": preload("res://dialogos/puzzles.dialogue"),
	"puzzle1": {
		"pregunta": "¿Cuál fue la causa de la muerte?",
		"elementos": {
			"perfiles": ["protagonista", "detective", "dueño"],
			"verbos": ["murió por", "se sorprendió por"],
			"objetos": ["marca_horizontal", "equimosis_faciales"]
		},
		"plantilla": ["perfil", "verbo", "deduccion"],
		"deducciones": {
			"causa_muerte": {
				"dialogo": "puzzle1",
				"requisitos_activacion": ["marca_horizontal", "equimosis_faciales"]
			}
		},
		"solucion": ["duenyo", "murió por", "asfixia"]
	}
}

func get_objeto(id_objeto: String, fase: int) -> Dictionary:
	var resultado = {}
	var data = objetos.get(id_objeto, {}).get("fases", {})
	for i in range(1, fase + 1):
		if data.has(i):
			for key in data[i]:
				resultado[key] = data[i][key]
	return resultado

func get_perfil(id_perfil: String, fase: int) -> Dictionary:
	var resultado = {}
	var data = perfiles.get(id_perfil, {}).get("fases", {})
	for i in range(1, fase + 1):
		if data.has(i):
			for key in data[i]:
				resultado[key] = data[i][key]
	return resultado

func get_lugar(id_lugar: String, fase: int) -> Dictionary:
	var resultado = {}
	var data = lugares.get(id_lugar, {}).get("fases", {})
	for i in range(1, fase + 1):
		if data.has(i):
			for key in data[i]:
				resultado[key] = data[i][key]
	return resultado
