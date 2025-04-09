// Jogo da Velha em Processing
// Utilize o mouse para jogar

int[][] tabuleiro = new int[3][3]; // 0 = vazio, 1 = X, 2 = O
boolean vezDoJogadorX = true; // true = X, false = O
boolean jogoTerminado = false;
int vencedor = 0; // 0 = ninguém, 1 = X, 2 = O, 3 = empate
boolean modoContraComputador = false; // true = contra computador, false = dois jogadores
boolean botaoContraComputadorPressionado = false;
boolean botaoDoisJogadoresPressionado = false;
boolean telaInicial = true; // Mostra a tela de seleção de modo de jogo

void setup() {
  size(400, 450);
  resetarJogo();
  textSize(32);
  textAlign(CENTER, CENTER);
  strokeWeight(4);
}

void draw() {
  background(240);
  
  if (telaInicial) {
    // Tela de seleção de modo
    desenharTelaInicial();
    return;
  }
  
  // Desenhar grade
  stroke(0);
  line(width/3, 0, width/3, height-50);
  line(2*width/3, 0, 2*width/3, height-50);
  line(0, height/3, width, height/3);
  line(0, 2*height/3, width, 2*height/3);
  
  // Desenhar X e O
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = i * width/3 + width/6;
      float y = j * height/3 + height/6;
      
      if (tabuleiro[i][j] == 1) {
        // Desenhar X
        stroke(255, 0, 0);
        line(x - 50, y - 50, x + 50, y + 50);
        line(x + 50, y - 50, x - 50, y + 50);
      } else if (tabuleiro[i][j] == 2) {
        // Desenhar O
        stroke(0, 0, 255);
        noFill();
        ellipse(x, y, 100, 100);
      }
    }
  }
  
  // Mostrar informações do jogo
  fill(0);
  rect(0, height-50, width, 50);
  fill(255);
  
  if (jogoTerminado) {
    if (vencedor == 1) {
      text("Jogador X venceu! Clique para reiniciar", width/2, height-25);
    } else if (vencedor == 2) {
      if (modoContraComputador) {
        text("Computador venceu! Clique para reiniciar", width/2, height-25);
      } else {
        text("Jogador O venceu! Clique para reiniciar", width/2, height-25);
      }
    } else {
      text("Empate! Clique para reiniciar", width/2, height-25);
    }
  } else {
    if (vezDoJogadorX) {
      text("Vez do Jogador X", width/2, height-25);
    } else {
      if (modoContraComputador) {
        text("Vez do Computador", width/2, height-25);
        // Fazer jogada do computador após um pequeno atraso
        if (frameCount % 60 == 0) { // Espera aproximadamente 1 segundo
          jogadaDoComputador();
        }
      } else {
        text("Vez do Jogador O", width/2, height-25);
      }
    }
  }
}

void desenharTelaInicial() {
  fill(0);
  textSize(32);
  text("Jogo da Velha", width/2, height/4);
  
  textSize(24);
  text("Selecione o modo de jogo:", width/2, height/4 + 50);
  
  // Botão de Dois Jogadores
  if (mouseX > width/4 && mouseX < 3*width/4 && 
      mouseY > height/2 - 30 && mouseY < height/2 + 30) {
    fill(200);
    botaoDoisJogadoresPressionado = true;
  } else {
    fill(220);
    botaoDoisJogadoresPressionado = false;
  }
  rect(width/4, height/2 - 30, width/2, 60, 10);
  
  // Botão de Jogar contra o Computador
  if (mouseX > width/4 && mouseX < 3*width/4 && 
      mouseY > height/2 + 50 && mouseY < height/2 + 110) {
    fill(200);
    botaoContraComputadorPressionado = true;
  } else {
    fill(220);
    botaoContraComputadorPressionado = false;
  }
  rect(width/4, height/2 + 50, width/2, 60, 10);
  
  fill(0);
  text("Dois Jogadores", width/2, height/2);
  text("Contra Computador", width/2, height/2 + 80);
}

void mousePressed() {
  if (telaInicial) {
    if (botaoDoisJogadoresPressionado) {
      modoContraComputador = false;
      telaInicial = false;
      resetarJogo();
    } else if (botaoContraComputadorPressionado) {
      modoContraComputador = true;
      telaInicial = false;
      resetarJogo();
    }
    return;
  }
  
  if (jogoTerminado) {
    telaInicial = true;
    return;
  }
  
  // Verificar se o clique foi na grade do jogo
  if (mouseY < height-50) {
    int i = mouseX / (width/3);
    int j = mouseY / (height/3);
    
    // Verificar se a célula está vazia
    if (tabuleiro[i][j] == 0 && vezDoJogadorX) {
      tabuleiro[i][j] = 1;
      vezDoJogadorX = false;
      verificarVencedor();
      
      // Se for contra o computador e o jogo não terminou, o computador joga automaticamente
      if (modoContraComputador && !jogoTerminado) {
        // A jogada do computador é feita no draw() após um pequeno atraso
      }
    } else if (tabuleiro[i][j] == 0 && !vezDoJogadorX && !modoContraComputador) {
      // Jogador O só pode jogar no modo dois jogadores
      tabuleiro[i][j] = 2;
      vezDoJogadorX = true;
      verificarVencedor();
    }
  }
}

void jogadaDoComputador() {
  if (vezDoJogadorX || jogoTerminado) return;
  
  // Estratégia do computador
  
  // 1. Tentar vencer
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 2;
        if (checarVitoria(2)) {
          verificarVencedor();
          vezDoJogadorX = true;
          return;
        }
        tabuleiro[i][j] = 0;
      }
    }
  }
  
  // 2. Bloquear jogada de vitória do jogador
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 1;
        if (checarVitoria(1)) {
          tabuleiro[i][j] = 2;
          verificarVencedor();
          vezDoJogadorX = true;
          return;
        }
        tabuleiro[i][j] = 0;
      }
    }
  }
  
  // 3. Tentar o centro
  if (tabuleiro[1][1] == 0) {
    tabuleiro[1][1] = 2;
    verificarVencedor();
    vezDoJogadorX = true;
    return;
  }
  
  // 4. Tentar os cantos
  int[][] cantos = {{0,0}, {0,2}, {2,0}, {2,2}};
  for (int[] canto : cantos) {
    if (tabuleiro[canto[0]][canto[1]] == 0) {
      tabuleiro[canto[0]][canto[1]] = 2;
      verificarVencedor();
      vezDoJogadorX = true;
      return;
    }
  }
  
  // 5. Escolher qualquer posição vazia
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiro[i][j] = 2;
        verificarVencedor();
        vezDoJogadorX = true;
        return;
      }
    }
  }
}

boolean checarVitoria(int jogador) {
  // Verificar linhas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[0][i] == jogador && tabuleiro[1][i] == jogador && tabuleiro[2][i] == jogador) {
      return true;
    }
  }
  
  // Verificar colunas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][0] == jogador && tabuleiro[i][1] == jogador && tabuleiro[i][2] == jogador) {
      return true;
    }
  }
  
  // Verificar diagonais
  if (tabuleiro[0][0] == jogador && tabuleiro[1][1] == jogador && tabuleiro[2][2] == jogador) {
    return true;
  }
  
  if (tabuleiro[2][0] == jogador && tabuleiro[1][1] == jogador && tabuleiro[0][2] == jogador) {
    return true;
  }
  
  return false;
}

void resetarJogo() {
  // Limpar tabuleiro
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      tabuleiro[i][j] = 0;
    }
  }
  
  vezDoJogadorX = true;
  jogoTerminado = false;
  vencedor = 0;
}

void verificarVencedor() {
  // Verificar linhas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[0][i] != 0 && tabuleiro[0][i] == tabuleiro[1][i] && tabuleiro[1][i] == tabuleiro[2][i]) {
      jogoTerminado = true;
      vencedor = tabuleiro[0][i];
      return;
    }
  }
  
  // Verificar colunas
  for (int i = 0; i < 3; i++) {
    if (tabuleiro[i][0] != 0 && tabuleiro[i][0] == tabuleiro[i][1] && tabuleiro[i][1] == tabuleiro[i][2]) {
      jogoTerminado = true;
      vencedor = tabuleiro[i][0];
      return;
    }
  }
  
  // Verificar diagonais
  if (tabuleiro[0][0] != 0 && tabuleiro[0][0] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[2][2]) {
    jogoTerminado = true;
    vencedor = tabuleiro[0][0];
    return;
  }
  
  if (tabuleiro[2][0] != 0 && tabuleiro[2][0] == tabuleiro[1][1] && tabuleiro[1][1] == tabuleiro[0][2]) {
    jogoTerminado = true;
    vencedor = tabuleiro[2][0];
    return;
  }
  
  // Verificar empate
  boolean tabuleiroCompleto = true;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (tabuleiro[i][j] == 0) {
        tabuleiroCompleto = false;
        break;
      }
    }
  }
  
  if (tabuleiroCompleto) {
    jogoTerminado = true;
    vencedor = 3; // Empate
  }
}
