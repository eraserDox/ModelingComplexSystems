// Parámetros del Autómata Celular
int columnas, filas;
int resolucion = 25; // Aumentamos el tamaño para que se vea bien la "personita" :v

// Matriz principal (0: Ignorante, 1: Chismoso, 2: No chismoso)
int[][] poblacion;

// Paleta de colores solicitada
color colorIgnorante = color(46, 204, 113);     // Verde (Susceptible)
color colorChismoso = color(231, 76, 60);       // Rojo (Infectado / Esparciendo)
color colorNoChismoso = color(241, 196, 15);    // Amarillo (Inmune / Ya no esparce)

void setup() {
  size(800, 800); 
  
  columnas = width / resolucion;
  filas = height / resolucion;
  poblacion = new int[columnas][filas];
  
  // Inicializamos a toda la población como "Ignorantes" (0)
  for (int i = 0; i < columnas; i++) {
    for (int j = 0; j < filas; j++) {
      poblacion[i][j] = 0;
    }
  }
}

void draw() {
  background(30, 35, 40); // Un fondo oscuro azulado para contraste :)
  
  // Dibujar el estado actual de la población
  for (int i = 0; i < columnas; i++) {
    for (int j = 0; j < filas; j++) {
      int x = i * resolucion;
      int y = j * resolucion;
      
      color colorActual = color(0);
      
      // Seleccionar color según el estado
      if (poblacion[i][j] == 0) colorActual = colorIgnorante;
      else if (poblacion[i][j] == 1) colorActual = colorChismoso;
      else if (poblacion[i][j] == 2) colorActual = colorNoChismoso;
      
      // Llamamos a nuestra función personalizada para dibujar a la persona
      dibujarPersona(x, y, resolucion, colorActual);
    }
  }
  
  // aplicarReglasDelRumor(); 
}

// ======================================================================
// Función personalizada para dibujar humanitos
// ======================================================================
void dibujarPersona(float x, float y, float tamano, color c) {
  fill(c);
  noStroke();
  
  // Proporciones para la cabeza y el cuerpo
  float tamanoCabeza = tamano * 0.4;
  float anchoCuerpo = tamano * 0.7;
  float altoCuerpo = tamano * 0.5;
  
  // Posición ajustada para centrar en la celda
  float centroX = x + tamano / 2;
  float centroY = y + tamano / 2;
  
  // Dibujar la cabeza (círculo superior)
  ellipse(centroX, centroY - tamano*0.15, tamanoCabeza, tamanoCabeza);
  
  // Dibujar el cuerpo (un semicírculo o arco en la parte inferior)
  arc(centroX, centroY + tamano*0.3, anchoCuerpo, altoCuerpo, PI, TWO_PI);
}

// Función para pintar el paciente cero
void mouseDragged() {
  iniciarRumor();
}

void mousePressed() {
  iniciarRumor();
}

void iniciarRumor() {
  // Convertir las coordenadas del mouse a índices de la matriz
  int i = floor(mouseX / resolucion);
  int j = floor(mouseY / resolucion);
  
  // Prevenir errores si el mouse sale de la ventana
  if (i >= 0 && i < columnas && j >= 0 && j < filas) {
    poblacion[i][j] = 1; // Cambiamos el estado a Chismoso (Rojo)
  }
}
