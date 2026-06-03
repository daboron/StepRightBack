extends Node

var objetos = {}

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
				"imagen": preload("res://arte/fotos/06_BOSS_POLAROID_BW.png"),
				"nombre": "Dueño del circo",
				"informacion": "placeholder2"
			},
			3: {
				"imagen": preload("res://arte/fotos/06_BOSS_POLAROID_BW.png"),
				"nombre": "Víctor Barnum",
				"informacion": "placeholder2"
			}
		}
	},
	"forzudo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/07_STRONGMAN_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			}
		}
	},
	"maga": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/04_MAGICIAN_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			}
		}
	},
	"payasa": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/03_CLOWN_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
			}
		}
	},
	"trapecista": {
		"fases": {
			1: {
				"imagen": preload("res://arte/fotos/05_AERIALIST_POLAROID.png"),
				"nombre": "???",
				"informacion": "placeholder"
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
				"imagen": 2,
				"nombre": "Exterior del circo",
				"informacion": "placeholder2"
			}
		}
	}
}
