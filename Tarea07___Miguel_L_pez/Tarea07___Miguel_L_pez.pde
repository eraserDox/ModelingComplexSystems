int cellSize = 20;
float probabilidadIniciarViva = 35;
int presion_media = 5;  //Presión media del sistema

// Variables para un timer (ralentizarlo)
int intervalo = 1;
int lastRecordedTime = 0;

// Color de celdas


int presion = presion_media-1;

color[] agua = new color[presion+1];


color aire = color(250);
color muro = color(0, 0, 0);

//espacio celular
int[][] espacio;
int[][] buffer;

boolean pause;

// Rejillas
void setup() {
  size(1280, 720);
  pause = false;
  espacio = new int[height/cellSize][width/cellSize];
  buffer = new int[height/cellSize][width/cellSize];
 for (int i = 0; i <= presion; i++) {
  agua[i] = color( 120 - i * 10,  250 - i * 20, 285 - i * 20);
}
  stroke(50);
  init();
}

void draw() {
  dibujarEspacio();

  int totalAgua = contarAgua();

  fill(0);
  textSize(20);
  text("Agua total: " + totalAgua, 40, 30);
  text("Presión media: " + presion_media, 80, 50);
  if (millis()-lastRecordedTime > intervalo) {
    if (!pause) {
      nextGeneration();
      lastRecordedTime = millis();
    }
  }

if (pause) {
  if (mousePressed) {
    int posI = int(map(mouseY, 0, height, 0, height / cellSize));
    int posJ = int(map(mouseX, 0, width, 0, width / cellSize));

    posI = constrain(posI, 0, height / cellSize - 1);
    posJ = constrain(posJ, 0, width / cellSize - 1);
   
    // Shift + click izquierdo: poner muro
    if (mouseButton == LEFT && keyPressed && keyCode == SHIFT) {
      espacio[posI][posJ] = -1;
    }

    // Click izquierdo: poner aire
    else if (mouseButton == LEFT) {
      espacio[posI][posJ] = 0;
    }

    // Click derecho: agregar agua acumulada
    else if (mouseButton == RIGHT) {
      if (espacio[posI][posJ] < 0) {
        espacio[posI][posJ] = 1;
      } else {
        espacio[posI][posJ] = espacio[posI][posJ] + 1;
      }
    }

  } else {
    actualizarBuffer();
  }
}
}

void nextGeneration() {
  // creando un buffer para tener un espacio intacto y
  // operar en el original para dibujarlo
  actualizarBuffer();
  reglas();

  }

void dibujarEspacio() {
  for (int i=0; i < height/cellSize; i++) {
    for (int j=0; j < width/cellSize; j++) {
      
      // Aire
      if (espacio[i][j]==0){
        fill(aire);
      }
      // Muro
      else if (espacio[i][j]==-1){
        fill(muro);
      }
      
      // Estados de agua
      for (int c=1; c<=presion; c++){
          if (espacio[i][j]==c) {
          fill(agua[c]);
        }  
      }
      if(espacio[i][j] > presion)
        fill(agua[presion]);
      
      rect (j*cellSize, i*cellSize, cellSize, cellSize);
      fill(0, 255, 0);
      textSize(12);
      text(
        espacio[i][j],
        j * cellSize + cellSize / 3,
        i * cellSize + cellSize / 3
      );
    }
  }
}

void init() {
  for (int i=0; i < height/cellSize; i++) {
    for (int j=0; j < width/cellSize; j++) {
      
      //Declarar espacio inicial del mundo

      if (j == 0 || j == (width/cellSize-1) ){
        int state = -1;
        espacio[i][j] = int(state);
      }
      
    }
  }
}

void keyPressed() {
  if ( key == 'r') { // reiniciar a condiciones iniciales aleatorias
    init();
  }
  if (key == ' ') {// pausar
    pause = !pause;
  }
}

void actualizarBuffer() {
  for (int i=0; i < height/cellSize; i++) {
    for (int j=0; j < width/cellSize; j++) {
      buffer[i][j] = espacio[i][j];
    }
  }
}

int contarAgua() {
  int total = 0;

  for (int i = 0; i < height/cellSize; i++) {
    for (int j = 0; j < width/cellSize; j++) {
      if (espacio[i][j] >= 1) {
        total += espacio[i][j];
      }
    }
  }

  return total;
}
