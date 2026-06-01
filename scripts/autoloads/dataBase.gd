extends Node

var objetos = {}

var perfiles = {
	"protagonista": {
		"fases": {
			1: {
				"imagen": 1,
				"nombre": "Samuel Collins",
				"informacion": "placeholder"
			}
		}
	},
	"detective": {
		"fases": {
			1: {
				"imagen": 1,
				"nombre": "Claire Chandler",
				"informacion": "placeholder"
			}
		}
	},
	"duenyo": {
		"fases": {
			1: {
				"imagen": 1,
				"nombre": "Dueño del circo",
				"informacion": "placeholder"
			},
			2: {
				"imagen": 2,
				"nombre": "Víctor Barnum",
				"informacion": "placeholder2"
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
				"informacion": "placeholder"
			},
			2: {
				"imagen": 2,
				"nombre": "Exterior del circo",
				"informacion": "placeholder2"
			}
		}
	}
}
