import Personas.*
import Construcciones.*

class Planeta {
	const habitantes = []
	const construcciones = []
	
	method habitanteConMasRecursos() = habitantes.max({habitante => habitante.cantidadRecursos()})
	
	method habitantesDestacados() = habitantes.filter({integrante => integrante.esDestacada()})
	
	method delegacionDiplomatica() { 
		const destacados = self.habitantesDestacados()
	  	destacados.add(self.habitanteConMasRecursos())
	    return destacados.withoutDuplicates()
	}
	
	method cantidadGenteDelegacion() = self.delegacionDiplomatica().size()
	
	method agregarConstruccion(construccion) = construcciones.add(construccion)
	
	method valorConstrucciones() = construcciones.sum({construccion => construccion.valor()})
	
	method esValioso() = self.valorConstrucciones() > 100
	
	method delegacionDiplomaticaTrabaja(planeta, tiempo) = self.delegacionDiplomatica().forEach({delegado => delegado.trabajar(self, tiempo)})
	
	method invadirPlaneta(invadido, tiempo) = self.delegacionDiplomaticaTrabaja(invadido, tiempo)
	
}