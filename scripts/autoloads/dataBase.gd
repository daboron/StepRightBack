extends Node

var pistas = {
	"marca_horizontal": {
		"fases": {
			1: {
				"imagen": preload("res://arte/objetos/marca_horizontal.png"),
				"nombre": "Marca horizontal",
				"informacion": "placeholder"
			}
		}
	},
	"equimosis_faciales": {
		"fases": {
			1: {
				"imagen": preload("res://arte/objetos/equimosis_faciales.png"),
				"nombre": "Equimosis faciales",
				"informacion": "placeholder"
			}
		}
	},
	"espada": {
		"fases": {
			1: {
				"imagen": preload("res://arte/objetos/equimosis_faciales.png"),
				"nombre": "Espada",
				"informacion": "placeholder"
			}
		}
	},
	"guirnalda": {
		"fases": {
			1: {
				"imagen": preload("res://arte/objetos/equimosis_faciales.png"),
				"nombre": "Guirnalda",
				"informacion": "placeholder"
			}
		}
	},
	"caja_magica": {
		"fases": {
			1: {
				"imagen": preload("res://arte/objetos/equimosis_faciales.png"),
				"nombre": "Caja magica",
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
	"fortachon": {
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
				"informacion": "placeholder",
				"escena": "res://escenas/despacho.tscn"
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

var acciones = {
	"murio": {
		"fases": {
			1: {
				"imagen": preload("res://arte/verbos/puzzle1/murio.png"),
				"nombre": "Murió por"
			}
		}
	},
	"sorprendio": {
		"fases": {
			1: {
				"imagen": preload("res://arte/verbos/puzzle1/sorprendio.png"),
				"nombre": "Se sorprendió por"
			}
		}
	},
	"creo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/verbos/puzzle1/sorprendio.png"),
				"nombre": "Creó"
			}
		}
	},
	"utilizo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/verbos/puzzle1/sorprendio.png"),
				"nombre": "Utilizó"
			}
		}
	},
	"escondio": {
		"fases": {
			1: {
				"imagen": preload("res://arte/verbos/puzzle1/sorprendio.png"),
				"nombre": "Escondió"
			}
		}
	}
}

var puzzles = {
	"dialogos": preload("res://dialogos/puzzles.dialogue"),
	"texto_fallos": [
		"fallo_generico_1",
		"fallo_generico_2",
		"fallo_generico_3"
	],
	"puzzles": {
		"puzzle1": {
			"pregunta": "¿Cuál fue la causa de la muerte?",
			"elementos": {
				"perfiles": ["protagonista", "detective", "duenyo"],
				"acciones": ["murio", "sorprendio"],
				"pistas": ["marca_horizontal", "equimosis_faciales"]
			},
			"plantilla": [
				{"tipo": "perfiles", "flecha": true},
				{"tipo": "acciones", "flecha": true},
				{"tipo": "deduccion", "flecha": false}
			],
			"deduccion": {
				"dialogo": "puzzle1",
				"requisitos_activacion": ["marca_horizontal", "equimosis_faciales"],
				"envenenamiento": preload("res://arte/deducciones/puzzle1/envenenamiento.png"),
				"asfixia": preload("res://arte/deducciones/puzzle1/asfixia.png"),
				"puñalada": preload("res://arte/deducciones/puzzle1/apuñalamiento.png")
			},
			"solucion": ["duenyo", "murio", "asfixia"],
			"dialogo_solucion": {
				"dialogo": preload("res://dialogos/escenarios/carpa_ini.dialogue"),
				"nombre_dialogo": "carpa3"
			}
		},
		"puzzle2": {
			"pregunta": "¿Cómo funciona el truco de magia?",
			"elementos": {
				"perfiles": ["maga", "detective", "duenyo"],
				"acciones": ["creo", "utilizo", "escondio"],
				"pistas": ["espada", "guirnalda", "caja_magica"]
			},
			"plantilla": [
				{"tipo": "perfiles", "flecha": true},
				{"tipo": "acciones", "flecha": true},
				{"tipo": "deduccion", "flecha": false}
			],
			"deduccion": {
				"dialogo": "puzzle2",
				"requisitos_activacion": ["espada", "caja_magica"],
				"espadas_trucadas": preload("res://arte/deducciones/puzzle1/envenenamiento.png"),
				"fuerza_bruta": preload("res://arte/deducciones/puzzle1/asfixia.png"),
				"efecto_optico": preload("res://arte/deducciones/puzzle1/apuñalamiento.png")
			},
			"solucion": ["maga", "utilizo", "espadas_trucadas"],
			"dialogo_solucion": {
				"dialogo": preload("res://dialogos/escenarios/carpa.dialogue"),
				"nombre_dialogo": "carpa1"
			}
		}
	}
}

var simbolos = {
	"perfiles": preload("res://arte/iconos/perfil_bn.png"),
	"acciones": preload("res://arte/iconos/action_bn.png"),
	"deduccion": preload("res://arte/iconos/deduction_bn.png"),
	"pistas": preload("res://arte/iconos/object_bn.png"),
	"lugares": preload("res://arte/iconos/place_bn.png")
}

var dialogos_personajes = {
	"dialogo": preload("res://dialogos/personajes.dialogue"),
	"personajes": {
		"maga": {
			"dialogos": {
				"dialogo1": {
					"nombre": "placeholder",
					"dialogo": "maga1"
				},
				"dialogo2": {
					"nombre": "placeholder2",
					"dialogo": "maga2"
				},
				"dialogo3": {
					"nombre": "placeholder3",
					"dialogo": "maga3"
				}
			},
			"deducciones": {
				#aqui van los puzzles y sus condiciones de acctivacion
				"deduccion1": {
					"puzzle": "puzzle2",
					"condiciones": ["caja", "espada", "guirnalda"]
				},
				"deduccion2": {}
			}
		}
	}
}

func get_objeto(id_objeto: String, fase: int) -> Dictionary:
	var resultado = {}
	var data = pistas.get(id_objeto, {}).get("fases", {})
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

func get_elemento(tipo: String, id: String, fase: int = 99) -> Dictionary:
	var categoria = get(tipo)
	if categoria == null:
		return {}
	var resultado := {}
	if not categoria.has(id):
		return resultado
	var fases = categoria[id]["fases"]
	for i in range(1, fase + 1):
		if fases.has(i):
			resultado.merge(fases[i], true)
	return resultado

func get_puzzle(id: String) -> Dictionary:
	return puzzles["puzzles"].get(id, {})

func get_dialogo(id: String) -> Dictionary:
	return dialogos_personajes["personajes"].get(id, {})
