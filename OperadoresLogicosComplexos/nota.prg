/*
    Operadores logicos complexos
    Avalia nota
*/
procedure Main
    local nNota1, nNota2, nNota3
    local media

    ? "Para que o aluno passe a media deve ser maior do que 6. "
    ? "Porem se tiver alguma nota menor do que 3 o aluno estara reprovado."

    input "Informe o valor da primeira nota: " to nNota1
    input "Informe o valor da segunda nota: " to nNota2
    input "Informe o valor da terceira nota: " to nNota3

    if (nNota1 >= 3 .and. nNota2 >= 3 .and. nNota3 >= 3)
        nMedia := (nNota1 + nNota2 + nNota3) / 3
        if nMedia >= 6
            ? "Aluno aprovado"
        else
            ? "Aluno de recuperacao "
            ?? "Aguardando o resultado da proxima prova."
        end if
    else
        ? "Aluno reprovado sem direito a recuperacao."
    end if
return