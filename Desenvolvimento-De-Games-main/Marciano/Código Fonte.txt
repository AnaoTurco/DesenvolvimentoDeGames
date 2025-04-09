import java.util.Random;
import java.util.Scanner;

public class Marciano {
    public static void main(String[] args) {
        Random random = new Random();
        Scanner entrada = new Scanner(System.in);
        char resposta;
        int numeroAleatorio, numeroDigitado, tentativas;
        
        do {
            numeroAleatorio = random.nextInt(100) + 1;
            tentativas = 0;
            System.out.println("Ache onde está o marciano.");
            
            do {
                System.out.print("Digite um número: ");
                numeroDigitado = entrada.nextInt();
                tentativas++;
                
                if (numeroDigitado < numeroAleatorio) {
                    System.out.println("Tente um número maior.");
                } else if (numeroDigitado > numeroAleatorio) {
                    System.out.println("Tente um número menor.");
                } else {
                    System.out.println("Parabéns! Você achou o marciano.");
                    System.out.printf("Número de tentativas: %d%n", tentativas);
                }
                
                System.out.printf("Tentativas: %d%n", tentativas);
            } while (numeroDigitado != numeroAleatorio);
            
            entrada.nextLine(); // Consumir a quebra de linha pendente
            System.out.print("Deseja jogar novamente? [s/n]: ");
            resposta = entrada.nextLine().toUpperCase().charAt(0);
        } while (resposta == 'S');
        
        entrada.close();
    }
}
