class Grupo {
	const integrantes = []
	
	method quienesPuedenSalir(sala) = integrantes.filter({integrante => integrante.puedeSalir(sala)})
	
	method puedenSalir(sala) = self.quienesPuedenSalir(sala).size() > (integrantes.size() / 2)
	
	method cantidadIntegrantes() = integrantes.size()
	
	method balanceTotalGrupo() = integrantes.sum({integrante => integrante.saldoDisponible()})
	
	method puedenPagar(sala) = self.balanceTotalGrupo() >= sala.valor()
	
	method condicionesParaJugar(sala) = self.puedenPagar(sala) && self.puedenSalir(sala)
	
	method agregarlesSala(sala) = integrantes.forEach({integrante => integrante.agregarSala(sala)})
	
	
	
	method pagar(sala){
		
		const valorSala = sala.valor() / self.cantidadIntegrantes()
		if(self.puedenPagar(sala)){
			integrantes.forEach({integrante => integrante.descontar(valorSala)})
			
		} else throw new Exception (message = "No alcanza el presupuesto")
	}
	method jugar(sala){
		if(self.condicionesParaJugar(sala)){
			
			integrantes.forEach({integrante => integrante.subirNivel()})
			self.agregarlesSala(sala)
			
		} else integrantes.forEach({integrante => integrante.bajarNivel()})
	}
}