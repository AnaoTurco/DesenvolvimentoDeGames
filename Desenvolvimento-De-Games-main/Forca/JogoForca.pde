String[] palavras = {"BRASIL", "COMPUTADOR", "PROGRAMACAO", "PROCESSING",
"ALGORITMO", "AULA", "JOGO", "FORCA"};
String palavraSecreta;
char[] letrasReveladas;
ArrayList<Character> letrasErradas;
int erros;
int maxErros = 6;
boolean jogoAcabou;
boolean ganhou;
void setup() {
size(700, 500);
textAlign(CENTER, CENTER);
iniciarJogo();
}
void iniciarJogo() {
// Escolhe uma palavra aleatória
palavraSecreta = palavras[int(random(palavras.length))];
// Inicializa o array de letras reveladas com underscores
letrasReveladas = new char[palavraSecreta.length()];
for (int i = 0; i < palavraSecreta.length(); i++) {
letrasReveladas[i] = '_';
}
letrasErradas = new ArrayList<Character>();
erros = 0;
jogoAcabou = false;
ganhou = false;
}
void draw() {
background(240);
// Desenha a forca
desenharForca();
// Desenha o boneco de acordo com número de erros
desenharBoneco();
// Mostra a palavra com as letras adivinhadas
fill(0);
textSize(40);
String palavraAtual = new String(letrasReveladas);
text(palavraAtual, width/2, 350);
// Mostra as letras erradas
textSize(24);
fill(200, 0, 0);
text("Letras erradas: " + letrasErradasString(), width/2, 400);
// Mostra o status do jogo
if (jogoAcabou) {
textSize(32);
if (ganhou) {
fill(0, 150, 0);
text("VOCÊ GANHOU!", width/2, 450);
} else {
fill(200, 0, 0);
text("VOCÊ PERDEU! A palavra era: " + palavraSecreta, width/2, 450);
}
// Instruções para reiniciar
textSize(20);
fill(0);
text("Pressione ENTER para jogar novamente", width/2, 480);
}
}
String letrasErradasString() {
String resultado = "";
for (Character c : letrasErradas) {
resultado += c + " ";
}
return resultado;
}
void keyPressed() {
if (jogoAcabou) {
if (keyCode == ENTER) {
iniciarJogo();
}
return;
}
// Converte a tecla para maiúscula
char tecla = Character.toUpperCase(key);
// Verifica se é uma letra
if (tecla >= 'A' && tecla <= 'Z') {
// Verifica se a letra já foi tentada antes
if (!letraJaTentada(tecla)) {
boolean acertou = false;
// Verifica se a letra está na palavra
for (int i = 0; i < palavraSecreta.length(); i++) {
if (palavraSecreta.charAt(i) == tecla) {
letrasReveladas[i] = tecla;
acertou = true;
}
}
// Se não acertou, adiciona aos erros
if (!acertou) {
letrasErradas.add(tecla);
erros++;
}
// Verifica se ganhou (todas as letras reveladas)
boolean todasLetrasReveladas = true;
for (char c : letrasReveladas) {
if (c == '_') {
todasLetrasReveladas = false;
break;
}
}
if (todasLetrasReveladas) {
ganhou = true;
jogoAcabou = true;
}
// Verifica se perdeu (máximo de erros atingido)
if (erros >= maxErros) {
jogoAcabou = true;
}
}
}
}
boolean letraJaTentada(char letra) {
// Verifica se a letra já está nas letras reveladas
for (char c : letrasReveladas) {
if (c == letra) return true;
}
// Verifica se a letra já está nas letras erradas
for (Character c : letrasErradas) {
if (c == letra) return true;
}
return false;
}
void desenharForca() {
stroke(0);
strokeWeight(4);
// Base
line(100, 300, 200, 300);
// Poste vertical
line(150, 300, 150, 100);
// Topo
line(150, 100, 300, 100);
// Corda
line(300, 100, 300, 130);
}
void desenharBoneco() {
stroke(0);
strokeWeight(2);
// Cabeça
if (erros >= 1) {
fill(255);
ellipse(300, 150, 40, 40);
}
// Corpo
if (erros >= 2) {
line(300, 170, 300, 230);
}
// Braço esquerdo
if (erros >= 3) {
line(300, 180, 270, 200);
}
// Braço direito
if (erros >= 4) {
line(300, 180, 330, 200);
}
// Perna esquerda
if (erros >= 5) {
line(300, 230, 270, 270);
}
// Perna direita
if (erros >= 6) {
line(300, 230, 330, 270);
}
}
