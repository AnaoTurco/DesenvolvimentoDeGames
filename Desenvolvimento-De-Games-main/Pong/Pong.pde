
// Variáveis para as posições da bola
float bolaX;
float bolaY;

// Variáveis para a velocidade da bola
float velocidadeX;
float velocidadeY;

// Tamanho da bola
float tamanhoBola = 20;

// Posições das palhetas
float palheta1Y;
float palheta2Y;

// Tamanho das palhetas
float alturaPalheta;
float larguraPalheta = 10;

// Placar
int placar1 = 0;
int placar2 = 0;

// Limite de pontos para vencer
int limitePlacar = 5;

// Estados do jogo
final int MENU = 0;
final int JOGANDO = 1;
final int VENCEDOR = 2;
int estadoJogo = MENU; // Começa no MENU

// Níveis de dificuldade
final int FACIL = 0;
final int MEDIO = 1;
final int DIFICIL = 2;
int nivelDificuldade = MEDIO;

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  // Inicializa as variáveis mas NÃO inicia o jogo
  inicializarVariaveis();
}

void inicializarVariaveis() {
  // Posição inicial da bola no centro
  bolaX = width / 2;
  bolaY = height / 2;
  
  // Definir velocidade de acordo com a dificuldade
  definirDificuldade();
  
  // Posição inicial das palhetas
  palheta1Y = height / 2 - alturaPalheta / 2;
  palheta2Y = height / 2 - alturaPalheta / 2;
}

void draw() {
  background(0);
  
  switch (estadoJogo) {
    case MENU:
      desenharMenu();
      break;
    case JOGANDO:
      atualizarJogo();
      desenharJogo();
      break;
    case VENCEDOR:
      desenharTelaVencedor();
      break;
  }
}

void desenharMenu() {
  fill(255);
  textSize(48);
  text("PONG", width/2, height/4);
  
  textSize(24);
  text("Selecione a dificuldade:", width/2, height/2 - 40);
  
  // Desenhar botões de dificuldade com espaçamento correto
  int btnWidth = 120;
  int btnHeight = 50;
  int btnY = height/2 + 20;
  int espacamento = 40; // Aumentado o espaçamento entre os botões
  
  // Botão Fácil - CORRIGIDO O POSICIONAMENTO
  fill(200);
  if (nivelDificuldade == FACIL) fill(255);
  rect(width/2 - btnWidth*1.5 - espacamento, btnY, btnWidth, btnHeight);
  fill(0);
  text("FÁCIL", width/2 - btnWidth*1.5 - espacamento + btnWidth/2, btnY + btnHeight/2);
  
  // Botão Médio - CORRIGIDO O POSICIONAMENTO
  fill(200);
  if (nivelDificuldade == MEDIO) fill(255);
  rect(width/2 - btnWidth/2, btnY, btnWidth, btnHeight);
  fill(0);
  text("MÉDIO", width/2, btnY + btnHeight/2);
  
  // Botão Difícil - CORRIGIDO O POSICIONAMENTO
  fill(200);
  if (nivelDificuldade == DIFICIL) fill(255);
  rect(width/2 + btnWidth/2 + espacamento, btnY, btnWidth, btnHeight);
  fill(0);
  text("DIFÍCIL", width/2 + btnWidth/2 + espacamento + btnWidth/2, btnY + btnHeight/2);
  
  // Botão Iniciar
  fill(255);
  rect(width/2 - 100, height/2 + 100, 200, 60);
  fill(0);
  text("INICIAR JOGO", width/2, height/2 + 130);
  
  // Instruções
  fill(255);
  textSize(16);
  text("Jogador 1: W e S para mover a palheta", width/2, height - 120);
  text("Jogador 2: Setas para cima e para baixo", width/2, height - 90);
  text("Pressione ESC para voltar ao menu", width/2, height - 60);
}

void definirDificuldade() {
  // Ajustar parâmetros de acordo com a dificuldade
  switch (nivelDificuldade) {
    case FACIL:
      alturaPalheta = 150;
      velocidadeX = 3 * (random(1) > 0.5 ? 1 : -1);
      velocidadeY = 2 * (random(1) > 0.5 ? 1 : -1);
      break;
    case MEDIO:
      alturaPalheta = 100;
      velocidadeX = 5 * (random(1) > 0.5 ? 1 : -1);
      velocidadeY = 4 * (random(1) > 0.5 ? 1 : -1);
      break;
    case DIFICIL:
      alturaPalheta = 70;
      velocidadeX = 7 * (random(1) > 0.5 ? 1 : -1);
      velocidadeY = 6 * (random(1) > 0.5 ? 1 : -1);
      break;
  }
}

void reiniciarJogo() {
  // Posição inicial da bola no centro
  bolaX = width / 2;
  bolaY = height / 2;
  
  // Definir velocidade de acordo com a dificuldade
  definirDificuldade();
  
  // Posição inicial das palhetas
  palheta1Y = height / 2 - alturaPalheta / 2;
  palheta2Y = height / 2 - alturaPalheta / 2;
  
  // Resetar placar se necessário
  if (estadoJogo == VENCEDOR) {
    placar1 = 0;
    placar2 = 0;
  }
  
  // Mudar estado para jogando
  estadoJogo = JOGANDO;
}

void reiniciarAposPonto() {
  // Reposicionar a bola no centro
  bolaX = width / 2;
  bolaY = height / 2;
  
  // Definir nova direção aleatória
  velocidadeX = (random(1) > 0.5 ? 1 : -1) * abs(velocidadeX);
  velocidadeY = (random(1) > 0.5 ? 1 : -1) * abs(velocidadeY);
}

void atualizarJogo() {
  // Movimentação das palhetas pelo teclado
  // Jogador 1 (esquerda)
  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      palheta1Y -= 8;
    }
    if (key == 's' || key == 'S') {
      palheta1Y += 8;
    }
    
    // Jogador 2 (direita)
    if (keyCode == UP) {
      palheta2Y -= 8;
    }
    if (keyCode == DOWN) {
      palheta2Y += 8;
    }
  }
  
  // Limitar posição das palhetas
  if (palheta1Y < 0) palheta1Y = 0;
  if (palheta1Y > height - alturaPalheta) palheta1Y = height - alturaPalheta;
  if (palheta2Y < 0) palheta2Y = 0;
  if (palheta2Y > height - alturaPalheta) palheta2Y = height - alturaPalheta;
  
  // Atualizar posição da bola
  bolaX += velocidadeX;
  bolaY += velocidadeY;
  
  // Verificar colisão com as bordas superior e inferior
  if (bolaY < tamanhoBola/2 || bolaY > height - tamanhoBola/2) {
    velocidadeY *= -1;
  }
  
  // Verificar colisão com as palhetas
  // Palheta do jogador 1 (esquerda)
  if (bolaX - tamanhoBola/2 < larguraPalheta && 
      bolaY > palheta1Y && bolaY < palheta1Y + alturaPalheta) {
    // Inverter direção
    velocidadeX *= -1;
    
    // Adicionar efeito baseado em onde a bola atinge a palheta
    float relativePosicao = (bolaY - palheta1Y) / alturaPalheta;
    velocidadeY = map(relativePosicao, 0, 1, -5, 5);
  }
  
  // Palheta do jogador 2 (direita)
  if (bolaX + tamanhoBola/2 > width - larguraPalheta && 
      bolaY > palheta2Y && bolaY < palheta2Y + alturaPalheta) {
    // Inverter direção
    velocidadeX *= -1;
    
    // Adicionar efeito baseado em onde a bola atinge a palheta
    float relativePosicao = (bolaY - palheta2Y) / alturaPalheta;
    velocidadeY = map(relativePosicao, 0, 1, -5, 5);
  }
  
  // Verificar se a bola saiu pela esquerda (ponto para jogador 2)
  if (bolaX < 0) {
    placar2++;
    verificarVencedor();
    if (estadoJogo == JOGANDO) {
      reiniciarAposPonto();
    }
  }
  
  // Verificar se a bola saiu pela direita (ponto para jogador 1)
  if (bolaX > width) {
    placar1++;
    verificarVencedor();
    if (estadoJogo == JOGANDO) {
      reiniciarAposPonto();
    }
  }
}

void verificarVencedor() {
  if (placar1 >= limitePlacar || placar2 >= limitePlacar) {
    estadoJogo = VENCEDOR;
  }
}

void desenharJogo() {
  // Desenhar linha central pontilhada
  stroke(255);
  for (int y = 0; y < height; y += 20) {
    line(width/2, y, width/2, y + 10);
  }
  noStroke();
  
  // Desenhar as palhetas
  fill(255);
  rect(0, palheta1Y, larguraPalheta, alturaPalheta);
  rect(width - larguraPalheta, palheta2Y, larguraPalheta, alturaPalheta);
  
  // Desenhar a bola
  fill(255);
  ellipse(bolaX, bolaY, tamanhoBola, tamanhoBola);
  
  // Desenhar o placar
  textSize(64);
  text(placar1, width/4, 60);
  text(placar2, 3*width/4, 60);
  
  // Mostrar nível de dificuldade
  textSize(16);
  String dificuldadeTexto = "";
  switch (nivelDificuldade) {
    case FACIL: dificuldadeTexto = "FÁCIL"; break;
    case MEDIO: dificuldadeTexto = "MÉDIO"; break;
    case DIFICIL: dificuldadeTexto = "DIFÍCIL"; break;
  }
  text("Dificuldade: " + dificuldadeTexto, width/2, 30);
}

void desenharTelaVencedor() {
  fill(255);
  textSize(64);
  
  String vencedor = (placar1 > placar2) ? "JOGADOR 1" : "JOGADOR 2";
  text("VENCEDOR:", width/2, height/3);
  text(vencedor, width/2, height/2);
  
  // Mostrar o placar final
  textSize(32);
  text("Placar Final: " + placar1 + " - " + placar2, width/2, height/2 + 80);
  
  // Botão para reiniciar
  fill(255);
  rect(width/2 - 120, height*3/4, 240, 60);
  fill(0);
  textSize(24);
  text("JOGAR NOVAMENTE", width/2, height*3/4 + 30);
}

void mousePressed() {
  if (estadoJogo == MENU) {
    // Verificar clique nos botões de dificuldade
    int btnY = height/2 + 20;
    int btnHeight = 50;
    int btnWidth = 120;
    int espacamento = 40; // Atualizado para corresponder ao novo espaçamento
    
    // Botão Fácil - CORRIGIDO O POSICIONAMENTO
    if (mouseX > width/2 - btnWidth*1.5 - espacamento && mouseX < width/2 - btnWidth*1.5 - espacamento + btnWidth &&
        mouseY > btnY && mouseY < btnY + btnHeight) {
      nivelDificuldade = FACIL;
    }
    
    // Botão Médio
    if (mouseX > width/2 - btnWidth/2 && mouseX < width/2 + btnWidth/2 &&
        mouseY > btnY && mouseY < btnY + btnHeight) {
      nivelDificuldade = MEDIO;
    }
    
    // Botão Difícil - CORRIGIDO O POSICIONAMENTO
    if (mouseX > width/2 + btnWidth/2 + espacamento && mouseX < width/2 + btnWidth/2 + espacamento + btnWidth &&
        mouseY > btnY && mouseY < btnY + btnHeight) {
      nivelDificuldade = DIFICIL;
    }
    
    // Botão Iniciar Jogo
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
        mouseY > height/2 + 100 && mouseY < height/2 + 160) {
      definirDificuldade();
      reiniciarJogo();
    }
  } else if (estadoJogo == VENCEDOR) {
    // Verificar clique no botão de jogar novamente
    if (mouseX > width/2 - 120 && mouseX < width/2 + 120 &&
        mouseY > height*3/4 && mouseY < height*3/4 + 60) {
      estadoJogo = MENU;
    }
  }
}

void keyPressed() {
  // Pressionar ESC para voltar ao menu
  if (key == ESC) {
    key = 0; // Prevenir o comportamento padrão de fechar o programa
    estadoJogo = MENU;
  }
}
