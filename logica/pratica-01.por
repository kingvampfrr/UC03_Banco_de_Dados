programa {
    funcao inicio() {
        inteiro quantidadeCaixas, paletes, caixasRestantes
        real pesoCaixa, pesoTotal, temperatura
        const inteiro CAIXAS_POR_PALETE = 40

    escreva("Digite a quantidade de caixas produzidas: ")
    leia(quantidadeCaixas)

    escreva("Digite o peso de cada caixa em kg: ")
    leia(pesoCaixa)

    escreva("Digite a temperatura da camara fria em °C: ")
    leia(temperatura)

    pesoTotal = quantidadeCaixas * pesoCaixa
    paletes = quantidadeCaixas / CAIXAS_POR_PALETE
    caixasRestantes = quantidadeCaixas % CAIXAS_POR_PALETE

    escreva("\nPeso total produzido: ", pesoTotal, " kg\n")
    escreva("Paletes completos: ", paletes, "\n")
    escreva("Caixas restantes: ", caixasRestantes, "\n")

    se (temperatura <= -18 e paletes >= 1) {
    escreva("Carregamento liberado\n")
    } senao {
    se (temperatura > -18) {
    escreva("Bloqueado: camara acima de -18 °C\n")
    }

    se (paletes < 1) {
    escreva("Bloqueado: nenhum palete completo\n")
    }
      }
    }
}
