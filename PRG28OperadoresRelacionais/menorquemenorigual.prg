/*
    Exemplos usando o operador "menor que" e "menor ou igual a"
    Tabela de classificação de impsto de renda
    Fonte: https://www.calcule.net/trabalhista/calculo-imposto-de-renda-irrf/

    Entrada: Base de cálculo
    Saída: Informa se o valor é isento de imposto ou não.
*/
#define valor_maximo_isento 1903.98
procedure main 
    local nSalario

    input "Informe o valor do salario: " to nSalario

    if nSalario <= valor_maximo_isento
        ? "Isento do imposto de renda."
    else
        ? "Voce tem imposto a pagar."
    end if
return