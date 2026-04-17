// Evaluando cada celda en el espacio celular
// (i-1, j-1)   (i-1, j)   (i-1, j+1)
// (i,   j-1)   (i,   j)   (i,   j+1)
// (i+1, j-1)   (i+1, j)   (i+1, j+1)

void reglas() {

  int caida_presion = 1;
  int desplazamiento_presion = 2;
  int ascenso_presion = 2;
  
  int caida_sobrepresion = 1;
  int desplazamiento_sobrepresion = 2;
  int ascenso_sobrepresion = 2;
  int obligatorio_sobrepresion = 1;

  int filas = height / cellSize;
  int cols  = width / cellSize;
  int limite_estable = presion + 1;

  // Copiar buffer a espacio antes de aplicar reglas
  for (int i = 0; i < filas; i++) {
    for (int j = 0; j < cols; j++) {
      espacio[i][j] = buffer[i][j];
    }
  }

  // Aplicando reglas
  for (int i = filas - 1; i >= 0; i--) {
    for (int j = 0; j < cols; j++) {

      boolean pared_izq = (j - 1 < 0) || (buffer[i][j - 1] == -1);
      boolean pared_der = (j + 1 >= cols) || (buffer[i][j + 1] == -1);
      boolean puede_izq = !pared_izq;
      boolean puede_der = !pared_der;

      // Solo aplicar reglas si hay agua
      if (buffer[i][j] >= 1) {

        // =====================================================
        // 1) AGUA MENOR A PRESIÓN
        // =====================================================
        if (buffer[i][j] < presion) {

          // Caída y acumulación de agua
          if (i + 1 < filas &&
              buffer[i + 1][j] >= 0 &&
              buffer[i + 1][j] < presion) {
            espacio[i][j]     = espacio[i][j] - 1;
            espacio[i + 1][j] = espacio[i + 1][j] + 1;
            continue;
          }

          // Estoy en el borde
          if (pared_izq || pared_der) {
            if (pared_izq &&
                !pared_der &&
                buffer[i][j + 1] < buffer[i][j]) {

              espacio[i][j]     = espacio[i][j] - 1;
              espacio[i][j + 1] = espacio[i][j + 1] + 1;
            }

            if (pared_der &&
                !pared_izq &&
                buffer[i][j - 1] < buffer[i][j]) {

              espacio[i][j]     = espacio[i][j] - 1;
              espacio[i][j - 1] = espacio[i][j - 1] + 1;
            }
          }

          // No estoy en el borde
          else if (buffer[i][j] > 1 && puede_izq && puede_der) {

            if (buffer[i][j + 1] < buffer[i][j - 1]) {
              espacio[i][j]     = espacio[i][j] - 1;
              espacio[i][j + 1] = espacio[i][j + 1] + 1;
            }
            else if (buffer[i][j + 1] > buffer[i][j - 1]) {
              espacio[i][j]     = espacio[i][j] - 1;
              espacio[i][j - 1] = espacio[i][j - 1] + 1;
            }
            else if (buffer[i][j + 1] == buffer[i][j - 1]) {
              float decidir_lado = random(1);
              if (decidir_lado < 0.5) {
                espacio[i][j]     = espacio[i][j] - 1;
                espacio[i][j + 1] = espacio[i][j + 1] + 1;
              } else {
                espacio[i][j]     = espacio[i][j] - 1;
                espacio[i][j - 1] = espacio[i][j - 1] + 1;
              }
            }
          }
        }

        // =====================================================
        // 2) AGUA IGUAL A PRESIÓN
        // =====================================================
        else if (buffer[i][j] == presion) {

          // Primero intenta caer, pero sin pasar de presion + 1 abajo
          if (i + 1 < filas &&
              buffer[i + 1][j] >= 0 &&
              buffer[i + 1][j] < limite_estable) {

            int mover = min(caida_presion, limite_estable - buffer[i + 1][j]);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i + 1][j] = espacio[i + 1][j] + mover;
              continue;
            }
          }

          boolean movio = false;

          if (puede_izq && puede_der) {

            if (buffer[i][j - 1] < buffer[i][j + 1] &&
                buffer[i][j - 1] < buffer[i][j] &&
                buffer[i][j - 1] < limite_estable) {

              int mover = min(desplazamiento_presion, limite_estable - buffer[i][j - 1]);

              if (mover > 0) {
                espacio[i][j]     = espacio[i][j] - mover;
                espacio[i][j - 1] = espacio[i][j - 1] + mover;
                movio = true;
              }
            }
            else if (buffer[i][j + 1] < buffer[i][j - 1] &&
                     buffer[i][j + 1] < buffer[i][j] &&
                     buffer[i][j + 1] < limite_estable) {

              int mover = min(desplazamiento_presion, limite_estable - buffer[i][j + 1]);

              if (mover > 0) {
                espacio[i][j]     = espacio[i][j] - mover;
                espacio[i][j + 1] = espacio[i][j + 1] + mover;
                movio = true;
              }
            }
            else if (buffer[i][j - 1] == buffer[i][j + 1] &&
                     buffer[i][j - 1] < buffer[i][j] &&
                     buffer[i][j - 1] < limite_estable &&
                     buffer[i][j + 1] < limite_estable) {

              float decidir_lado = random(1);

              if (decidir_lado < 0.5) {
                int mover = min(desplazamiento_presion, limite_estable - buffer[i][j - 1]);

                if (mover > 0) {
                  espacio[i][j]     = espacio[i][j] - mover;
                  espacio[i][j - 1] = espacio[i][j - 1] + mover;
                  movio = true;
                }
              } else {
                int mover = min(desplazamiento_presion, limite_estable - buffer[i][j + 1]);

                if (mover > 0) {
                  espacio[i][j]     = espacio[i][j] - mover;
                  espacio[i][j + 1] = espacio[i][j + 1] + mover;
                  movio = true;
                }
              }
            }

          } else if (puede_izq &&
                     buffer[i][j - 1] < buffer[i][j] &&
                     buffer[i][j - 1] < limite_estable) {

            int mover = min(desplazamiento_presion, limite_estable - buffer[i][j - 1]);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i][j - 1] = espacio[i][j - 1] + mover;
              movio = true;
            }

          } else if (puede_der &&
                     buffer[i][j + 1] < buffer[i][j] &&
                     buffer[i][j + 1] < limite_estable) {

            int mover = min(desplazamiento_presion, limite_estable - buffer[i][j + 1]);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i][j + 1] = espacio[i][j + 1] + mover;
              movio = true;
            }
          }

          // Si no puede lateralmente, sube, pero sin pasar de presion + 1 arriba
          if (!movio &&
              i - 1 >= 0 &&
              buffer[i - 1][j] >= 0 &&
              buffer[i - 1][j] < buffer[i][j] &&
              buffer[i - 1][j] < limite_estable) {

            int mover = min(ascenso_presion, limite_estable - buffer[i - 1][j]);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i - 1][j] = espacio[i - 1][j] + mover;
            }
          }
        }

        // =====================================================
        // 3) AGUA MAYOR A PRESIÓN
        // =====================================================
        else if (buffer[i][j] > presion) {

          boolean movio = false;
          int exceso = buffer[i][j] - presion;

          // 0. Intenta mover uno hacia arriba siempre
          if (i - 1 >= 0 &&
              buffer[i - 1][j] >= 0 &&
              buffer[i - 1][j] < buffer[i][j] &&
              buffer[i][j] > (presion + 1)) {

            int mover = min(obligatorio_sobrepresion,
                            min(exceso, limite_estable - buffer[i - 1][j]));

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i - 1][j] = espacio[i - 1][j] + mover;
            }
          }

          // 1. Intentar desplazarse hacia abajo
          if (i + 1 < filas &&
              buffer[i + 1][j] >= 0 &&
              buffer[i + 1][j] < buffer[i][j] &&
              buffer[i + 1][j] < limite_estable) {

            int mover = min(exceso, limite_estable - buffer[i + 1][j]);
            mover = min(mover, caida_sobrepresion + exceso - 1);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i + 1][j] = espacio[i + 1][j] + mover;
              movio = true;
            }
          }

          // 2. Si no pudo bajar, intentar desplazarse hacia los lados
          if (!movio) {
            if (puede_izq && puede_der) {

              if (buffer[i][j - 1] < buffer[i][j + 1] &&
                  buffer[i][j - 1] < buffer[i][j] &&
                  buffer[i][j - 1] < limite_estable) {

                int mover = min(exceso, limite_estable - buffer[i][j - 1]);
                mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

                if (mover > 0) {
                  espacio[i][j]     = espacio[i][j] - mover;
                  espacio[i][j - 1] = espacio[i][j - 1] + mover;
                  movio = true;
                }
              }
              else if (buffer[i][j + 1] < buffer[i][j - 1] &&
                       buffer[i][j + 1] < buffer[i][j] &&
                       buffer[i][j + 1] < limite_estable) {

                int mover = min(exceso, limite_estable - buffer[i][j + 1]);
                mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

                if (mover > 0) {
                  espacio[i][j]     = espacio[i][j] - mover;
                  espacio[i][j + 1] = espacio[i][j + 1] + mover;
                  movio = true;
                }
              }
              else if (buffer[i][j - 1] == buffer[i][j + 1] &&
                       buffer[i][j - 1] < buffer[i][j]) {

                float decidir_lado = random(1);

                if (decidir_lado < 0.5 && buffer[i][j - 1] < limite_estable) {
                  int mover = min(exceso, limite_estable - buffer[i][j - 1]);
                  mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

                  if (mover > 0) {
                    espacio[i][j]     = espacio[i][j] - mover;
                    espacio[i][j - 1] = espacio[i][j - 1] + mover;
                    movio = true;
                  }
                } else if (buffer[i][j + 1] < limite_estable) {
                  int mover = min(exceso, limite_estable - buffer[i][j + 1]);
                  mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

                  if (mover > 0) {
                    espacio[i][j]     = espacio[i][j] - mover;
                    espacio[i][j + 1] = espacio[i][j + 1] + mover;
                    movio = true;
                  }
                }
              }

            } else if (puede_izq &&
                       buffer[i][j - 1] < buffer[i][j] &&
                       buffer[i][j - 1] < limite_estable) {

              int mover = min(exceso, limite_estable - buffer[i][j - 1]);
              mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

              if (mover > 0) {
                espacio[i][j]     = espacio[i][j] - mover;
                espacio[i][j - 1] = espacio[i][j - 1] + mover;
                movio = true;
              }

            } else if (puede_der &&
                       buffer[i][j + 1] < buffer[i][j] &&
                       buffer[i][j + 1] < limite_estable) {

              int mover = min(exceso, limite_estable - buffer[i][j + 1]);
              mover = min(mover, desplazamiento_sobrepresion + exceso - 1);

              if (mover > 0) {
                espacio[i][j]     = espacio[i][j] - mover;
                espacio[i][j + 1] = espacio[i][j + 1] + mover;
                movio = true;
              }
            }
          }

          // 3. Si no pudo moverse lateralmente ni bajar, intentar subir
          if (!movio &&
              i - 1 >= 0 &&
              buffer[i - 1][j] >= 0 &&
              buffer[i - 1][j] < buffer[i][j] &&
              buffer[i - 1][j] < limite_estable &&
              buffer[i][j] > presion) {

            int mover = min(exceso, limite_estable - buffer[i - 1][j]);
            mover = min(mover, ascenso_sobrepresion + exceso - 1);

            if (mover > 0) {
              espacio[i][j]     = espacio[i][j] - mover;
              espacio[i - 1][j] = espacio[i - 1][j] + mover;
            }
          }
        }
      }
    }
  }
}
