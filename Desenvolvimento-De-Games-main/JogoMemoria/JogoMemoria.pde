// Jogo da Memória em Processing
// Desenvolvido por Claude

// Variáveis globais
int estado = 0; // 0 = menu, 1 = jogo, 2 = fim de jogo
int tema = 0; // 0 = frutas, 1 = animais, 2 = objetos
int numPares = 8; // Número de pares de cartas
int numColunas = 4; // Número de colunas no tabuleiro
int numLinhas = 4; // Número de linhas no tabuleiro
int cartaLargura = 100; // Largura da carta
int cartaAltura = 100; // Altura da carta
int espacamento = 20; // Espaçamento entre cartas
int margemSuperior = 80; // Margem superior do tabuleiro
int margemLateral; // Margem lateral do tabuleiro (calculado automaticamente)

// Variáveis do jogo
Carta[] cartas; // Array de cartas
Carta primeiraCarta = null; // Primeira carta selecionada
Carta segundaCarta = null; // Segunda carta selecionada
int tempoVirada = 0; // Tempo para virar as cartas de volta
int pontos = 0; // Pontuação atual
int movimentos = 0; // Número de movimentos realizados
int paresEncontrados = 0; // Número de pares encontrados
int tempoInicio; // Tempo de início do jogo
int tempoDecorrido; // Tempo decorrido desde o início do jogo

// Efeitos
boolean mostrarEfeitoAcerto = false;
int tempoEfeito = 0;
float opacidadeEfeito = 255;

// Imagens
PImage[] imagensFrutas;
PImage[] imagensAnimais;
PImage[] imagensObjetos;
PImage imagemFundo; // Fundo das cartas

// Fontes
PFont fonteJogo;
PFont fonteTitulo;

// Configuração inicial
void setup() {
  size(700, 650);
  carregarImagens();
  
  // Definir fontes
  fonteJogo = createFont("Arial", 20);
  fonteTitulo = createFont("Arial Bold", 36);
  textFont(fonteJogo);
  
  // Calcular margem lateral para centralizar o tabuleiro
  margemLateral = (width - (numColunas * cartaLargura + (numColunas - 1) * espacamento)) / 2;
  
  // Não iniciar o jogo imediatamente, mostrar o menu primeiro
}

void draw() {
  background(50, 120, 180); // Fundo azul
  
  if (estado == 0) {
    desenharMenu();
  } else if (estado == 1) {
    desenharJogo();
    verificarCombinacao();
    verificarFimDeJogo();
    
    // Atualizar tempo decorrido
    tempoDecorrido = (millis() - tempoInicio) / 1000;
    
    // Desenhar efeito de acerto
    if (mostrarEfeitoAcerto) {
      desenharEfeitoAcerto();
    }
  } else if (estado == 2) {
    desenharFimDeJogo();
  }
}

void mousePressed() {
  if (estado == 0) {
    // Checar se clicou em algum botão do menu
    // Botão Frutas
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > 200 && mouseY < 250) {
      tema = 0;
      estado = 1;
      iniciarJogo();
    }
    // Botão Animais
    else if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > 280 && mouseY < 330) {
      tema = 1;
      estado = 1;
      iniciarJogo();
    }
    // Botão Objetos
    else if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > 360 && mouseY < 410) {
      tema = 2;
      estado = 1;
      iniciarJogo();
    }
  } else if (estado == 1) {
    // Lógica para virar cartas durante o jogo
    if (tempoVirada > 0) return; // Não permitir cliques enquanto cartas estão virando
    
    // Checar se clicou em alguma carta
    for (int i = 0; i < cartas.length; i++) {
      if (cartas[i].contem(mouseX, mouseY) && !cartas[i].encontrada && !cartas[i].virada) {
        virarCarta(cartas[i]);
        break;
      }
    }
  } else if (estado == 2) {
    // Voltar ao menu quando clicar no botão na tela final
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height - 100 && mouseY < height - 50) {
      estado = 0;
    }
  }
}

void carregarImagens() {
  // Carregar imagens de frutas
  imagensFrutas = new PImage[8];
  imagensFrutas[0] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8944295-apple-fruit-cartoon-colored-clipart-ilustracao-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8944295-apple-fruit-cartoon-colored-clipart-ilustracao-gratis-vetor.jpg") : createPlaceholderImage("Maçã", color(220, 0, 0));
  imagensFrutas[1] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/35524351-grupo-banana-desenho-animado-ilustracao-fruta-e-comida-conceito-projeto-plano-estilo-isolado-branco-fundo-grampo-arte-icone-projeto-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/35524351-grupo-banana-desenho-animado-ilustracao-fruta-e-comida-conceito-projeto-plano-estilo-isolado-branco-fundo-grampo-arte-icone-projeto-vetor.jpg") : createPlaceholderImage("Banana", color(255, 255, 0));
  imagensFrutas[2] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/3415769-laranja-fruta-desenho-ilustracao-em-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/3415769-laranja-fruta-desenho-ilustracao-em-vetor.jpg") : createPlaceholderImage("Laranja", color(255, 150, 0));
  imagensFrutas[3] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/15867081-ilustracao-de-arte-de-uva-de-desenho-animado-bonito-icone-de-estilo-de-desenho-animado-plano-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/15867081-ilustracao-de-arte-de-uva-de-desenho-animado-bonito-icone-de-estilo-de-desenho-animado-plano-vetor.jpg") : createPlaceholderImage("Uva", color(160, 32, 240));
  imagensFrutas[4] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/4557305-fruta-morango-desenho-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/4557305-fruta-morango-desenho-vetor.jpg") : createPlaceholderImage("Morango", color(220, 20, 60));
  imagensFrutas[5] = loadImage("https://static.vecteezy.com/ti/fotos-gratis/p2/30691021-abacaxi-2d-desenho-animado-ilustracao-em-branco-fundo-alto-gratis-foto.jpg") != null ? loadImage("https://static.vecteezy.com/ti/fotos-gratis/p2/30691021-abacaxi-2d-desenho-animado-ilustracao-em-branco-fundo-alto-gratis-foto.jpg") : createPlaceholderImage("Abacaxi", color(255, 223, 0));
  imagensFrutas[6] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/17580941-design-de-de-desenhos-animados-de-frutas-de-pera-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/17580941-design-de-de-desenhos-animados-de-frutas-de-pera-gratis-vetor.jpg") : createPlaceholderImage("Pêra", color(173, 255, 47));
  imagensFrutas[7] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/t1/23847140-melancia-ilustracao-todo-melancia-e-melancia-dentro-metade-fatia-e-triangel-e-peca-forma-metade-comido-melancia-verao-fruta-tema-e-conceito-plano-dentro-desenho-animado-estilo-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/t1/23847140-melancia-ilustracao-todo-melancia-e-melancia-dentro-metade-fatia-e-triangel-e-peca-forma-metade-comido-melancia-verao-fruta-tema-e-conceito-plano-dentro-desenho-animado-estilo-vetor.jpg") : createPlaceholderImage("Melancia", color(144, 238, 144));
  
  // Carregar imagens de animais
  imagensAnimais = new PImage[8];
  imagensAnimais[0] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/7916876-desenho-gato-fofo-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/7916876-desenho-gato-fofo-vetor.jpg") : createPlaceholderImage("Gato", color(200, 200, 200));
  imagensAnimais[1] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/5112815-bonito-bebe-cachorro-desenhos-posando-em-fundo-branco-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/5112815-bonito-bebe-cachorro-desenhos-posando-em-fundo-branco-gratis-vetor.jpg") : createPlaceholderImage("Cachorro", color(139, 69, 19));
  imagensAnimais[2] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/4805392-ilustracao-em-de-desenho-animado-em-pe-de-leao-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/4805392-ilustracao-em-de-desenho-animado-em-pe-de-leao-vetor.jpg") : createPlaceholderImage("Leão", color(255, 215, 0));
  imagensAnimais[3] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/20061619-fofa-elefante-desenho-animado-plano-ilustracao-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/20061619-fofa-elefante-desenho-animado-plano-ilustracao-vetor.jpg") : createPlaceholderImage("Elefante", color(169, 169, 169));
  imagensAnimais[4] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/18790711-bonito-desenho-animado-de-cobra-oriental-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/18790711-bonito-desenho-animado-de-cobra-oriental-vetor.jpg") : createPlaceholderImage("Cobra", color(0, 128, 0));
  imagensAnimais[5] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/3513751-ilustracao-desenho-desenho-arvore-macaco-bonito-pendurado-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/3513751-ilustracao-desenho-desenho-arvore-macaco-bonito-pendurado-gratis-vetor.jpg") : createPlaceholderImage("Macaco", color(139, 69, 19));
  imagensAnimais[6] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/7916720-bonito-panda-desenho-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/7916720-bonito-panda-desenho-vetor.jpg") : createPlaceholderImage("Panda", color(255, 255, 255));
  imagensAnimais[7] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8389985-desenho-tigre-sentado-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8389985-desenho-tigre-sentado-vetor.jpg") : createPlaceholderImage("Tigre", color(255, 165, 0));
  
  // Carregar imagens de objetos
  imagensObjetos = new PImage[8];
  imagensObjetos[0] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/26826063-pessoas-crianca-cadeira-desenho-animado-ilustracao-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/26826063-pessoas-crianca-cadeira-desenho-animado-ilustracao-vetor.jpg") : createPlaceholderImage("Cadeira", color(160, 82, 45));
  imagensObjetos[1] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/17590426-ilustracao-em-de-desenho-animado-de-jantar-de-mesa-moderna-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/17590426-ilustracao-em-de-desenho-animado-de-jantar-de-mesa-moderna-vetor.jpg") : createPlaceholderImage("Mesa", color(222, 184, 135));
  imagensObjetos[2] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/10567879-desenho-lampada-em-fundo-branco-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/10567879-desenho-lampada-em-fundo-branco-gratis-vetor.jpg") : createPlaceholderImage("Lâmpada", color(255, 255, 224));
  imagensObjetos[3] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/13117814-ilustracao-de-clipart-colorida-de-desenho-de-relogio-gratis-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/13117814-ilustracao-de-clipart-colorida-de-desenho-de-relogio-gratis-vetor.jpg") : createPlaceholderImage("Relógio", color(0, 0, 0));
  imagensObjetos[4] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/13215831-fotografo-de-mulher-com-estilo-de-desenho-de-camera-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/13215831-fotografo-de-mulher-com-estilo-de-desenho-de-camera-vetor.jpg") : createPlaceholderImage("Câmera", color(105, 105, 105));
  imagensObjetos[5] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/12183792-telefone-de-desenho-animado-de-estilo-de-cor-plana-bonito-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/12183792-telefone-de-desenho-animado-de-estilo-de-cor-plana-bonito-vetor.jpg") : createPlaceholderImage("Telefone", color(0, 0, 139));
  imagensObjetos[6] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8957263-green-car-icon-clipart-in-animated-cartoon-png-flat-vector-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/8957263-green-car-icon-clipart-in-animated-cartoon-png-flat-vector-vetor.jpg") : createPlaceholderImage("Carro", color(255, 0, 0));
  imagensObjetos[7] = loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/24681171-bicicleta-icone-projeto-bicicleta-ilustracao-veiculo-desenho-animado-grafico-vetor.jpg") != null ? loadImage("https://static.vecteezy.com/ti/vetor-gratis/p1/24681171-bicicleta-icone-projeto-bicicleta-ilustracao-veiculo-desenho-animado-grafico-vetor.jpg") : createPlaceholderImage("Bicicleta", color(0, 128, 0));
  
  // Carregar imagem do fundo da carta
  imagemFundo = loadImage("https://via.placeholder.com/100?text=?") != null ? loadImage("https://via.placeholder.com/100?text=?") : createPlaceholderImage("?", color(30, 50, 120));
}

PImage createPlaceholderImage(String texto, color cor) {
  // Cria uma imagem de placeholder quando as imagens não podem ser carregadas
  PGraphics pg = createGraphics(cartaLargura, cartaAltura);
  pg.beginDraw();
  pg.background(cor);
  pg.fill(0);
  pg.textAlign(CENTER, CENTER);
  pg.textSize(20);
  pg.text(texto, cartaLargura/2, cartaAltura/2);
  pg.endDraw();
  
  return pg.get();
}

void iniciarJogo() {
  // Reiniciar variáveis do jogo
  pontos = 0;
  movimentos = 0;
  paresEncontrados = 0;
  tempoVirada = 0;
  primeiraCarta = null;
  segundaCarta = null;
  tempoInicio = millis();
  
  // Criar cartas
  cartas = new Carta[numPares * 2];
  
  // Escolher imagens com base no tema
  PImage[] imagensTema = null;
  switch (tema) {
    case 0:
      imagensTema = imagensFrutas;
      break;
    case 1:
      imagensTema = imagensAnimais;
      break;
    case 2:
      imagensTema = imagensObjetos;
      break;
  }
  
  // Criar pares de cartas
  for (int i = 0; i < numPares; i++) {
    for (int j = 0; j < 2; j++) {
      cartas[i * 2 + j] = new Carta(0, 0, imagensTema[i]);
    }
  }
  
  // Embaralhar cartas
  embaralharCartas();
  
  // Posicionar cartas no tabuleiro
  posicionarCartas();
}

void embaralharCartas() {
  // Embaralhar as cartas aleatoriamente
  for (int i = 0; i < cartas.length; i++) {
    int j = int(random(cartas.length));
    Carta temp = cartas[i];
    cartas[i] = cartas[j];
    cartas[j] = temp;
  }
}

void posicionarCartas() {
  // Posicionar cartas em uma grade
  for (int i = 0; i < cartas.length; i++) {
    int coluna = i % numColunas;
    int linha = i / numColunas;
    
    float x = margemLateral + coluna * (cartaLargura + espacamento);
    float y = margemSuperior + linha * (cartaAltura + espacamento);
    
    cartas[i].x = x;
    cartas[i].y = y;
  }
}

void virarCarta(Carta carta) {
  // Virar a carta clicada
  carta.virada = true;
  
  // Verificar se é a primeira ou segunda carta
  if (primeiraCarta == null) {
    primeiraCarta = carta;
  } else {
    segundaCarta = carta;
    movimentos++;
    tempoVirada = frameCount + 30; // Tempo para mostrar as cartas antes de virá-las novamente
  }
}

void verificarCombinacao() {
  // Verificar se duas cartas formam um par
  if (tempoVirada > 0 && frameCount >= tempoVirada) {
    if (primeiraCarta != null && segundaCarta != null) {
      if (primeiraCarta.id == segundaCarta.id) {
        // Par encontrado
        primeiraCarta.encontrada = true;
        segundaCarta.encontrada = true;
        paresEncontrados++;
        pontos += 100;
        mostrarEfeitoAcerto = true;
        tempoEfeito = frameCount;
        opacidadeEfeito = 255;
      } else {
        // Não é um par
        primeiraCarta.virada = false;
        segundaCarta.virada = false;
        pontos -= 5; // Penalidade leve
        if (pontos < 0) pontos = 0; // Evitar pontuação negativa
      }
      
      // Resetar cartas selecionadas
      primeiraCarta = null;
      segundaCarta = null;
      tempoVirada = 0;
    }
  }
}

void verificarFimDeJogo() {
  // Verificar se todos os pares foram encontrados
  if (paresEncontrados >= numPares) {
    // Calcular pontuação final com base no tempo e movimentos
    int pontuacaoTempo = max(0, 500 - tempoDecorrido * 2);
    int pontuacaoMovimentos = max(0, 500 - (movimentos - numPares) * 10);
    pontos += pontuacaoTempo + pontuacaoMovimentos;
    
    // Ir para a tela de fim de jogo
    estado = 2;
  }
}

void desenharEfeitoAcerto() {
  // Desenhar efeito de acerto (círculo expandindo)
  if (frameCount - tempoEfeito < 30) {
    float tamanho = map(frameCount - tempoEfeito, 0, 30, 50, 200);
    opacidadeEfeito = map(frameCount - tempoEfeito, 0, 30, 255, 0);
    
    noFill();
    stroke(0, 255, 0, opacidadeEfeito);
    strokeWeight(3);
    
    // Desenhar círculo em torno de cada carta encontrada
    if (primeiraCarta != null) {
      ellipse(primeiraCarta.x + cartaLargura/2, primeiraCarta.y + cartaAltura/2, tamanho, tamanho);
    }
    if (segundaCarta != null) {
      ellipse(segundaCarta.x + cartaLargura/2, segundaCarta.y + cartaAltura/2, tamanho, tamanho);
    }
  } else {
    mostrarEfeitoAcerto = false;
  }
}

void desenharMenu() {
  // Desenhar tela de menu
  textFont(fonteTitulo);
  fill(255);
  textAlign(CENTER, CENTER);
  text("JOGO DA MEMÓRIA", width/2, 100);
  
  textFont(fonteJogo);
  text("Selecione um tema:", width/2, 160);
  
  // Botões de tema
  desenharBotao(width/2 - 100, 200, 200, 50, "Frutas", color(220, 0, 0));
  desenharBotao(width/2 - 100, 280, 200, 50, "Animais", color(0, 150, 0));
  desenharBotao(width/2 - 100, 360, 200, 50, "Objetos", color(0, 0, 220));
  
  // Instruções
  textSize(16);
  fill(255);
  textAlign(CENTER, TOP);
  text("Como jogar: Encontre todos os pares de cartas iguais.\n" +
       "Clique em duas cartas para virá-las. Se formarem um par,\n" +
       "ficarão visíveis. Caso contrário, serão viradas novamente.\n" +
       "O jogo termina quando todos os pares forem encontrados.", 
       width/2, 450);
}

void desenharJogo() {
  // Desenhar tela de jogo
  
  // Desenhar informações do jogo
  fill(255);
  textAlign(LEFT, TOP);
  textSize(20);
  
  String temaAtual = "";
  switch (tema) {
    case 0: temaAtual = "Frutas"; break;
    case 1: temaAtual = "Animais"; break;
    case 2: temaAtual = "Objetos"; break;
  }
  
  text("Tema: " + temaAtual, 20, 20);
  text("Pontos: " + pontos, 20, 50);
  
  textAlign(RIGHT, TOP);
  text("Movimentos: " + movimentos, width - 20, 20);
  text("Tempo: " + tempoDecorrido + "s", width - 20, 50);
  
  // Desenhar progresso
  textAlign(CENTER, TOP);
  text("Pares: " + paresEncontrados + "/" + numPares, width/2, 20);
  
  // Desenhar cartas
  for (int i = 0; i < cartas.length; i++) {
    cartas[i].desenhar();
  }
}

void desenharFimDeJogo() {
  // Desenhar tela de fim de jogo
  background(50, 100, 150);
  
  textFont(fonteTitulo);
  fill(255);
  textAlign(CENTER, CENTER);
  text("JOGO COMPLETADO!", width/2, 120);
  
  textFont(fonteJogo);
  text("Pontuação Final: " + pontos, width/2, 180);
  
  textSize(20);
  text("Tempo: " + tempoDecorrido + " segundos", width/2, 220);
  text("Movimentos: " + movimentos, width/2, 250);
  text("Pares Encontrados: " + paresEncontrados, width/2, 280);
  
  // Calcular e mostrar estatísticas
  float precisao = float(paresEncontrados) / float(movimentos) * 100;
  text("Precisão: " + nf(precisao, 0, 1) + "%", width/2, 310);
  
  // Mensagem personalizada com base na performance
  textSize(24);
  if (precisao >= 80) {
    text("Excelente memória!", width/2, 360);
  } else if (precisao >= 60) {
    text("Muito bom!", width/2, 360);
  } else if (precisao >= 40) {
    text("Bom trabalho!", width/2, 360);
  } else {
    text("Continue praticando!", width/2, 360);
  }
  
  // Botão para voltar ao menu
  desenharBotao(width/2 - 100, height - 100, 200, 50, "Menu", color(0, 100, 200));
}

void desenharBotao(float x, float y, float w, float h, String texto, color cor) {
  // Desenhar um botão colorido com texto
  noStroke();
  
  // Verificar se o mouse está sobre o botão
  boolean hover = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  
  // Desenhar fundo do botão
  if (hover) {
    fill(cor, 230); // Mais brilhante quando hover
  } else {
    fill(cor, 180);
  }
  rect(x, y, w, h, 10); // Retângulo com cantos arredondados
  
  // Desenhar borda
  stroke(255, 180);
  strokeWeight(2);
  noFill();
  rect(x, y, w, h, 10);
  
  // Desenhar texto
  fill(255);
  textAlign(CENTER, CENTER);
  text(texto, x + w / 2, y + h / 2);
}

// Classe Carta
class Carta {
  float x, y;
  PImage imagem;
  boolean virada = false;
  boolean encontrada = false;
  int id; // ID para identificar pares (baseado no endereço da imagem)
  
  Carta(float x, float y, PImage img) {
    this.x = x;
    this.y = y;
    this.imagem = img;
    this.id = img.hashCode(); // Usar o hashCode da imagem como ID
  }
  
  void desenhar() {
    // Desenhar a carta
    rectMode(CORNER);
    strokeWeight(2);
    
    if (virada || encontrada) {
      // Carta virada - mostrar imagem
      image(imagem, x, y, cartaLargura, cartaAltura);
      
      // Destacar cartas encontradas
      if (encontrada) {
        noFill();
        stroke(0, 255, 0, 150);
        strokeWeight(4);
        rect(x, y, cartaLargura, cartaAltura, 5);
      } else {
        stroke(255);
        noFill();
        rect(x, y, cartaLargura, cartaAltura, 5);
      }
    } else {
      // Carta não virada - mostrar verso
      image(imagemFundo, x, y, cartaLargura, cartaAltura);
      stroke(200);
      noFill();
      rect(x, y, cartaLargura, cartaAltura, 5);
      
      // Desenhar padrão no verso da carta
      fill(255, 100);
      noStroke();
      for (int i = 0; i < 5; i++) {
        ellipse(x + cartaLargura/2, y + cartaAltura/2, 
                80 - i*15, 80 - i*15);
      }
    }
  }
  
  boolean contem(float mx, float my) {
    // Verificar se o ponto (mx, my) está dentro da carta
    return mx >= x && mx <= x + cartaLargura && 
           my >= y && my <= y + cartaAltura;
  }
}
