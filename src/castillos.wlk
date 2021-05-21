class Castillo{
	var property nombre
	var property rey
	var burocratas = []
	var guardias = []
	var ambientes = []
	var property muralla
	var property estabilidadMinima = 100
	var property estabilidad
//Instanciar objetos en la consola para probar el codigo 
 // Instancié algunos en el codigo


	method cantidadAmbientes(){
		return ambientes.size()
	}
	method agregarAmbiente(nuevoAmbiente){
    	ambientes.add(nuevoAmbiente)
	}
	//Derrota
	method esDerrotado(){
		return estabilidad<100
	}
	method permaneceEnPie(){
		return not self.esDerrotado()
	}

	method asignarGuardiasAmbiente(unGuardia,unAmbiente){
	//	guardias.forEach({guardia=>unAmbiente.asignarGuardias(unGuardia)})
		unAmbiente.asignarGuardia(unGuardia)
	}

	method prepararDefensas(){
		estabilidad = estabilidad + self.capacidadGuardias() + self.planificacionBurocratas()
	} //burocratas no entiende planificacion
	  // podes instanciar mas burocratas y agregarlos a la coleccion
	  
	method capacidadGuardias(){
		return guardias.sum({unGuardia=>unGuardia.capacidad()})
	}	
	method planificacionBurocratas(){
		// si los burocratas no tienen panico, aumentan en 10 la estabilidad del castillo
		return if (self.burocratasEnPanico()) 0 else 10
	}
	method burocratasEnPanico(){
		// si hay un burocrata en panico, se considera que todos lo estan tambien
		return burocratas.any({unBurocrata=>unBurocrata.estaEnPanico()})
	}
	
	// no se encuentra bajo amenaza (con una estabilidad al menos de un 25% superior de su estabilidad mínima)
	method estaBajoAmenaza(){
		return  estabilidad*1.25 < estabilidadMinima 
	}
	
	//Ataque
	method recibirAtaque(){
        estabilidad = estabilidad - 0.30 * (self.resistencia())
        guardias.forEach({ guardia => guardia.aumentarAgotamiento() })
        burocratas.forEach({ burocrata => burocrata.presenciarActoViolento()  })
      //  if (estabilidad<100) {return "castillo Derrotado "}
      // else {"Castillo Triunfante"}
	}
	method resistencia(){
		return  muralla + ambientes.size() + estabilidad

	}
}
const winterfell = new Castillo(nombre= "winterfell", rey="jhonSnow",burocratas=[rob,davos],guardias=[guardia1,guardia2],ambientes = [salon,torre],muralla=50,estabilidad = 200)
const kingslanding = new Castillo(nombre= "kingslanding",rey="robert",burocratas=[varys,tyrion],guardias=[guardia3,guardia4],ambientes = [jardin,dormitorio],muralla=80,estabilidad = 150)

class Guardia{
	var property capacidad 
	var property agotamiento
	
	method fiesta(){
		agotamiento = 0
	}
	method aumentarAgotamiento(){
        agotamiento = agotamiento + 6
    }
}
const guardia1 = new Guardia(capacidad=20,agotamiento=5)
const guardia2 = new Guardia(capacidad=30,agotamiento=10)
const guardia3 = new Guardia(capacidad=10,agotamiento=8)
const guardia4 = new Guardia(capacidad=15,agotamiento=9)

class Ambiente{
	var guardias=[]	
	method asignarGuardia(unGuardia){
		guardias.add(unGuardia)
	}
}
const salon = new Ambiente()
const torre = new Ambiente()
const jardin = new Ambiente()
const dormitorio = new Ambiente()


class Burocrata{
	var property nombre
	var property fechaNacimiento
	var property experiencia
	var property miedo
	
	
	method fiesta(){
        miedo = 0
        experiencia = experiencia + 3
    }
	
	method estaEnPanico(){
		return miedo>20
	}
	method presenciarActoViolento(){
        if (experiencia < 7){ miedo = miedo + 60}
    }
    method batalla(){
        miedo = miedo + 5
         if (miedo>25) {experiencia = 0}
    }
	
}
const varys = new Burocrata(nombre="varys",fechaNacimiento=1980,experiencia=20,miedo=15)
const tyrion = new Burocrata(nombre="tyrion",fechaNacimiento=1985,experiencia=15,miedo=10)
const davos = new Burocrata(nombre="davos",fechaNacimiento=1970,experiencia=30,miedo=5)
const rob = new Burocrata(nombre="rob",fechaNacimiento=1990,experiencia=10,miedo=8)

object rey{
	var property castillo = winterfell
	var popularidad
    var sequitos
    
    
	method participarEnFiesta(){
		fiesta.agregarParticipante(self)
	}
	method atacarCastillo(unCastillo){
		castillo.atacar(unCastillo)
	}
	method ordenarFiesta(){
		if (not castillo.estaBajoAmenaza() and not castillo.burocratasEnPanico())
			self.realizarFiesta(castillo)
	}
	method realizarFiesta(unCastillo){
		fiesta.agregarCastillo(unCastillo)
	}
	 method darFiesta(){
        if (0.25* castillo.estabilidad()>castillo.estabilidadMinima() and sequitos.sum({individuo => individuo.miedo()}) < 100)
        { popularidad = popularidad + 10
          sequitos.forEach({ individuo => individuo.fiesta() }) }
      }
}
object todoCastillos{
	var castillos = [winterfell,kingslanding]
	
	method resistenciaCastillo(unCastillo){
	// quiero saber la resistencia de un determ.castillo dentro del bloque
		return castillos.find({castillo=>castillo.nombre() == unCastillo}).resistencia()
	}	
}

object fiesta{
	var participantes=[]
	var castillos = []
	method agregarParticipante(participante){
		participantes.add(participante)
	}
	method agregarCastillo(castillo){
		castillos.add(castillo)
	}
	
}

// Punto 3. Explicar las ventajas que tiene utilizar clases para crear objetos, en lugar de definir los objetos individualmente. 
//			¿En qué casos no es necesario o es contraproducente utilizar clases? 
//	Rta: Las ventajas que existen al utilizar clases son :
//		* Nos permiten hacer una abstraccion de objetos que se comportan igual (aunque tengan diferentes estados internos)
//		* Nos ahorran espacio de código.
//		* Una clase sirve de fábrica de objetos. Modela las abstracciones de mi dominio (los conceptos que nos interesan), permitiéndome definir el comportamiento y los atributos de las instancias.
//	No es necesario utilizar clases cuando no existen objetos con comportamientos parecidos(metodos en comun)
