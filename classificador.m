#
function classificador(desc,qtdImagens,numFrutas,totalFrutas)
  totalBananas = 0;
  totalLaranjas = 0;
  totalLimoes = 0;
  bananas = 0;
  laranjas = 0;
  limoes = 0;
  cont2 = 1;
  for i=1:qtdImagens
    disp(strcat("\nImagem \t",num2str(i)))
    for j=1:numFrutas(1,i)+1
      if desc(cont2,4) > 0.8000 #&& desc(cont2,3) > 11.5
        bananas = bananas + 1;
      elseif desc(cont2,1) < 45 && (desc(cont2,3) >= 5 && desc(cont2,3) <= 7)...
        && desc(cont2,4) < 0.8000
        limoes = limoes + 1;
      elseif desc(cont2,4) < 0.8000 && desc(cont2,1) >= 45 && desc(cont2,1) > 7
        laranjas = laranjas + 1;
      endif
      cont2 = cont2 + 1;
    endfor
    disp(strcat("Bananas\t",num2str(bananas)));
    disp(strcat("Limoes\t",num2str(limoes)));
    disp(strcat("Laranjas\t",num2str(laranjas)));
    totalBananas = totalBananas + bananas;
    totalLaranjas = totalLaranjas + laranjas;
    totalLimoes = totalLimoes + limoes;
    bananas = 0;
    laranjas = 0;
    limoes = 0;
  endfor
  disp("\nResultado Final")
  disp(strcat("Total de Bananas\t",num2str(totalBananas)))
  disp(strcat("Total de Laranjas\t",num2str(totalLaranjas)))
  disp(strcat("Total de Limoes   \t",num2str(totalLimoes)))
  
  pBananas = (totalBananas/totalFrutas) * 100;
  pLaranjas = (totalLaranjas/totalFrutas) * 100;
  pLimoes = (totalLimoes/totalFrutas) * 100;
  disp(strcat("\nPorcentagem de Bananas\t",num2str(pBananas),"\t%\n", ...
  "Porcentagem de Laranjas\t",num2str(pLaranjas),"\t%\n", ...
  "Porcentagem de Limões\t",num2str(pLimoes),"\t%"))
  
endfunction