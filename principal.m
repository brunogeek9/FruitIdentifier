close all
clear all
pkg load image
totalFrutas = 0;

qtdImagens = 54;
cont1 = 1;
image = 1;
for k=1:qtdImagens
  nomeImagem = strcat('im (',num2str(k),').jpg');
  frutaColor = imread(strcat('C:\Users\jamelli\Desktop\ProjetoFinal\Banco - PDI\',nomeImagem));
  sf = separaAzul(frutaColor);
  hist = imhist(sf);
  lim = limiar(hist);
  
  bw = binariza(sf,lim);
  #figure('Name','Fruta binarizada'), imshow(bw, [0 1])
  
  #definindo elemento estruturante da erosão
  #se = strel("square", 3);
  er = erode(bw);#imerode(bw,se);
  [imRotulos,qtdFrutas] = bwlabel(er);
  figure('Name','Fruta binarizada e erodida'), imshow(er, [0 1])
   
  rotulos = unique(imRotulos);
  pSep = separaObjetos(imRotulos,rotulos,qtdFrutas);
  qtdFrutas = qtdFrutas-1;
  disp(strcat("quantidade de frutas\t",num2str(qtdFrutas)))
  fruta = segmentacao(frutaColor,bw,bw);
  figure('name','imagem frutas segmentadas'), imshow(fruta)
  
  figure('NAME','Imagem Rotulada'), imshow(imRotulos,[]);
  colormap(jet), colorbar;
  areasRP = zeros(1,qtdFrutas);
  perimetro = zeros(1,qtdFrutas);
  eixoMaior = zeros(1,qtdFrutas);
  eixoMenor = zeros(1,qtdFrutas);
  ecce = zeros(1,qtdFrutas);
  #areasCM = zeros(1,qtdFrutas);
  totalFrutas = totalFrutas + qtdFrutas;
  numFrutas(1,k) = qtdFrutas;
  ################ Extraindo os descritores dos objetos ###################################
  for i=1:qtdFrutas+1
   areaRP(1,i) = regionprops(pSep(:,:,i),"Area").Area;
   perimetro(1,i) = regionprops(pSep(:,:,i),"Perimeter").Perimeter;
   eixoMaior(1,i) = regionprops(pSep(:,:,i),"MajorAxisLength").MajorAxisLength;
   #eixoMenor(1,i) = regionprops(pSep(:,:,i),"MinorAxisLength").MinorAxisLength;
   ecce(1,i) = regionprops(pSep(:,:,i),"Eccentricity").Eccentricity;
   #figure('NAME','Fruta Separada'), imshow(pSep(:,:,i));
  endfor
  ################ Calculando a metrica para cada descritor ###############################
  areaOrd = sort(areaRP);
  perimetroOrd = sort(perimetro);
  eixoMaiorOrd = sort(eixoMaior);
  eixoMenorOrd = sort(eixoMenor);
  area1Rcm = pi*(1.35 * 1.35);
  per1Rcm = (pi*pi)*1.35;
  metricaA = areaOrd(1,1)/area1Rcm;
  metricaP = perimetroOrd(1,1)/per1Rcm;
  metricaEMA = eixoMaiorOrd(1,1)/2.7;
  metricaEME = eixoMenorOrd(1,1)/2.7;
  #mostraDescritores(areaOrd,area1Rcm,metricaA,areaRP,perimetro,eixoMaior,eixoMenor,ecce);
  ################ Calculando os descritores em centimetros ###############################
  for j=1:qtdFrutas+1
    #Convertendo o velor em pixel para as respectivas metricas
    areaCM(1,j) = (areaRP(1,j)/metricaA);
    perimetroCM(1,j) = (perimetro(1,j)/metricaP);#
    eixoMaiorCM(1,j) = (eixoMaior(1,j)/metricaEMA);# 
    #eixoMenorCM(1,j) = (eixoMenor(1,j)/metricaEME);# 
  endfor
  #disp("#######################################")
  #mostraDescritoresCM(areaCM,perimetroCM,eixoMaiorCM,eixoMenorCM);
  ################ Colocando os descritores na matriz #####################################
  for z=1:qtdFrutas+1
    desc(cont1,1) = areaCM(1,z);#areaRP(1,z);;
    desc(cont1,2) = perimetroCM(1,z);#perimetro(1,z);
    desc(cont1,3) = eixoMaiorCM(1,z);#eixoMaior(1,z);
    #desc(cont1,4) = eixoMenorCM(1,z);#eixoMenor(1,z);
    desc(cont1,4) = double(ecce(1,z));
    #fE(1,cont1) = double(ecce(1,z));
    cont1 = cont1 +1;  
  endfor
  
  disp("#################################################################################")
  if(k<qtdImagens)
    close all
  endif  
endfor


#mostrando os descritores extraidos dos objetos
cont2 = 1;
disp("Meus descritores ")
for i=1:qtdImagens
  disp(strcat("\nImagem \t",num2str(i)))
  for j=1:numFrutas(1,i)+1
   disp(desc(cont2,:));
   cont2 = cont2 + 1;
  endfor
endfor
disp("########################## CLASSIFICANDO AS FRUTAS ##################################")
disp(strcat("quantidade total de frutas\t",num2str(totalFrutas)))
classificador(desc,qtdImagens,numFrutas,totalFrutas);