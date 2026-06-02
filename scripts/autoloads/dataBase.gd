extends Node

var objetos = {}

var perfiles = {
	"protagonista": {
		"fases": {
			1: {
				"imagen": preload("res://arte/animaciones/protagonista/02_cold/protagonista_notebook_cold_0001.png"), # Placeholder
				"nombre": "Samuel Collins",
				"informacion": "placeholder"
			}
		}
	},
	"detective": {
		"fases": {
			1: {
				"imagen": preload("res://arte/animaciones/detective/02_cold/detective_neutral_cold_0001.png"), # Placeholder
				"nombre": "Claire Chandler",
				"informacion": "placeholder"
			}
		}
	},
	"duenyo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/animaciones/jefe/01_neutral/jefe_neutral_0001.png"), # Placeholder
				"nombre": "Dueño del circo",
				"informacion": "placeholder"
			},
			2: {
				"imagen": 2,
				"nombre": "Víctor Barnum",
				"informacion": "placeholder2"
			}
		}
	},
	"forzudo": {
		"fases": {
			1: {
				"imagen": preload("res://arte/animaciones/fortachon/02_cold/fortachon_neutral_cold_0001.png"), # Placeholder
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
