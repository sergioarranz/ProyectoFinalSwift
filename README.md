# Genome Social Network
## Introducción
Genome surge como idea de algo innovador y futurista en el mundo de las redes sociales, el nombre viene relacionado con el genoma humano y he considerado que es un nombre bastante original para una app de relación entre personas como pueda ser una red social.

La idea por el momento es hacer una base aprendiendo a realizar funcionalidades similares a otras redes sociales y además intentar darle un toque único como han hecho todas, en principio quiero orientarlo a entorno empresarial desde grandes multinacionales hasta pequeñas PyMES de modo que sirva de feeback para apoyarse entre sí.
## Contenido
En este repositorio para el trabajo final se ha desarrollado en paralelo durante los últimos meses tanto la aplicación propuesta por el profesor como cuatro pequeñas aplicaciones extra para reforzar muchos contenidos de Swift que considero imprescindibles y para aprender muchos otros nuevos por mi cuenta.

Todas estas han sido desarrolladas por mi en gran mayoría gracias a los videotutoriales de [Yony Bar-Magen](www.youtube.com/channel/UCmauq_2NaJPLlH5c-sJRmeA "Yony Bar-Magen") y teniendo como referencia otros contenidos nuevos aprendidos en cursos de Swift 3. Todos los códigos están documentados correctamente y entre otras muchas cosas quiero destacar los siguientes contenidos que he aprendido y reforzado:

- Uso de Arrays y Diccionarios en todas las aplicaciones
- Funcionamiento y uso de hilos en los permisos que piden las aplicaciones
- Uso avanzado de constraints y modificación de parámetros visuales tanto a través del IB como de código
- Tablas y Colecciones: personalización, reconocimiento: (slide, gesture recognizer, etc),diferente uso y acceso a las mismas a través de delegados o View Controllers, etc
- Transiciones, Segues, paso de información entre controladores
- Edición de la barra de navegación superior, animaciones, etc
- Uso de SpeechRecognizer para reconocimiento y transcripción de voz
- Patrón MVC


## Ejemplos

### Acceso en cadena a permisos a través de hilos

```
/* El sistema de permisos es asíncrono de modo que se realiza una petición y en un momento dado, cuando el usuario la acepta recibimos un callback/llamada de vuelta, estas no solo ocurren en el hilo principal si no que pueden ocurrir en cualquier hilo de ejecución, de modo que en algún callback se debe actualizar el hilo principal o la parte gráfica y evitar que ocurra en segundo plano. */
 
    // Creación de cadena de permisos a través de callbacks en vez de lanzar todas las peticiones de golpe. Estructura: Pedir permiso -> Esperar callback y así sucesivamente gestionando hilos de ejecución, recepción de respuestas, asignación de delegados, etc
    @IBAction func askForPermissions(_ sender: UIButton) {
        self.askForPhotosPermissions()
    }
    // Permisos de Fotos
    func askForPhotosPermissions() {
        
        PHPhotoLibrary.requestAuthorization { [unowned self] (authStatus) in // Pedir autorización a la clase de fotos pasando como handler el estado de la misma
            
            DispatchQueue.main.async { // Permite decidir en que hilo debe estar un bloque de código. Los completion handlers se ejecutan en segundo plano, por tanto  mandamos al hilo principal este bloque de modo que se actualize en tiempo real y no en hilos secundarios.
                
                if authStatus == .authorized { // Si el estado pasa a autorizado, sigue la cadena con el siguiente permiso o actualiza la etiqueta en caso contrario.
                    self.askForRecordPermissions()
                } else {
                    self.InfoLabel.text = "Has denegado el permiso de fotos. Por favor, activalo en los ajustes del dispositivo para continuar."
                }
            }
        }
        
    }
  }
```
## Desarrollado con

* [Swift 3](https://www.swift.org/) - Lenguaje de programación de desarrollo de la App
* [Firebase](https://www.firebase.google.com/) - Plataforma de acceso a base de datos
* [GitHub](https://www.github.com/) - Utilizado para llevar a cabo el control de versiones del proyecto entero

## Créditos

- Instagram, Facebook y Twitter por las ideas para realizar las funcionalidades principales de la aplicación
- Yony Bar-Magen Numhauser por sus videotutoriales y explicaciones en clase
- Cursos de Swift 3y videos random de Internet
- Compañeros de clase que me han ayudado con cosas puntuales
