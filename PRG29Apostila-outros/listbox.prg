procedure main()
    local getlist := {}
    local cCity

    cls 
    cCity = "Torino"

    @ 4,4,12,20 get cCity listbox { "Milano", "Genova", "Roma", "Pisa", "Torino"}

    @ 14,10 say "Voce selecionou: " + cCity

return