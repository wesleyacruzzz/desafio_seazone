## OBS: Não adicionei acentuação de acordo com a norma da lingua portuguesa nos comentarios para garantir uma melhor visualizacao em qualquer computador.

# Pacotes relevantes para a analise
library(ggcorrplot) # Gera uma visualização para a matriz de correlação
library(gridExtra)  # Permite criar grids de gráficos
library(tidyverse)  # Coleção de diversos pacotes para fins gerais
library(polycor)    # Gera a matriz de correlação heterogênea
library(scales)     # Permite formatar os valores nos eixos dos gráficos

# Lendo os arquivos desafio_priceav.csv e desafio_details.csv no R
price <- read.csv("desafio_priceav.csv")
details <- read.csv("desafio_details.csv",encoding = "UTF-8")

# Retirando variaveis que não tem importancia para a analise
price <- price[,-c(1,2)]
details <- details[,-1]

# Alterando os nomes das colunas para melhor visualizacao
names(price) <- c("listing_id","booked_on","date",
                  "price_string","available")
names(details)[1] <- "listing_id"

# Visualização das 6 primeiras colunas
head(price)
head(details)

dim(price)
dim(details)
dim(price_details)

min(as.Date(price$date)) # Primeiro dia considerado nos dados
max(as.Date(price$date)) # Ultimo dia considerado nos dados

############################################################################
#PRIMEIRA INFORMACAO: ORDENACAO DOS BAIRROS POR ORDEM CRESCENTE DE LISTINGS#
############################################################################

# Calculando o numero de listings por bairro
listing_bairro <- details %>% 
  group_by(suburb) %>%        # Agrupando os dados por bairro
  select(listing_id) %>%      # Selecionando os ids
  count() %>%                 # Contando os ids por bairro
  arrange(n)                  # Ordenando os resultados

listing_bairro

# Grafico de barras com valores acima das barras do numero de listing por bairro 
ggplot(listing_bairro, aes(x=reorder(suburb,n),y=n))+
  geom_col(fill="#FF585D")+
  geom_text(aes(label=paste(n,"(",round(100*n/4691,1),"%)")),
            vjust=-0.5,size=3, color="#484848",) +
  ylim(0,2800)+
  labs(x = "Bairros", y = "Total",
       title = "Número de listings por bairro")+
  theme_light()+
  theme(panel.grid = element_blank(),
        axis.title = element_text(colour = "#484848"))

##################################################################
#SEGUNDA INFORMACAO: ORDENACAO DOS BAIRROS POR ORDEM CRESCENTE DO# 
#FATURAMENTO MÉDIO DE LISTINGS                                   #
##################################################################

# Mesclando os conjuntos de dados price e details usando como conectivo a variável listing_id
price_details <- left_join(price,details, by = "listing_id")

# Visualizando o novo conjunto de dados
head(price_details)

# Calculando o faturamento total por bairro
faturamento_total <- price_details %>%
  group_by(listing_id,suburb) %>% # Agrupando por listing_id e bairro
  summarise_at(vars("price_string"),
               list(faturamento=sum)) # Somando os preços ofertados

price_details$listing_id %>%
  unique() %>% length() # Número total de listings_id em price_details
faturamento_total$listing_id %>%
  unique() %>% length() # Número total de listings_id em faturamento_total

# Calculando o faturamento medio por bairro
faturamento_medio <- faturamento_total %>%
  group_by(suburb) %>%               # Agrupando por bairro
  summarise_at(vars("faturamento"),
               list(media=mean)) %>% # Media de faturamento por bairro
  arrange(media)                     # Ordenando as medias

faturamento_medio

# Grafico de barras com valores acima das barras do faturamento medio de listing por bairro 
ggplot(faturamento_medio, aes(x=reorder(suburb,media),y=media))+
  geom_col(fill="#FF585D")+
  geom_text(aes(label=dollar(round(media),prefix = "R$ ")),
            vjust=-0.5,size=3, color="#484848")+
  scale_y_continuous(labels=dollar_format(prefix="R$ "),
                     limits=c(0,50000))+
  labs(x = "Bairros", y = "Faturamento médio",
       title = "Faturamento médio dos listings por bairro")+
  theme_light()+
  theme(panel.grid = element_blank(),
        axis.title = element_text(colour = "#484848"))

#########################################################################
#TERCEIRA INFORMACAO: EXISTEM CORRELACOES ENTRE AS CARACTERISTICAS DE UM# #ANUNCIO E SEU FATURAMENTO                                              # 
#########################################################################

# Mesclando os conjuntos de dados price_details e faturamento_total
price_details <- left_join(price_details,
                           faturamento_total[c(1,3)],
                           by = "listing_id")

price_details$available <- as.factor(price_details$available)
price_details$suburb <- as.factor(price_details$suburb)
price_details$is_superhost <- as.factor(price_details$is_superhost)
price_details$star_rating <- as.factor(price_details$star_rating)

# Calculando a matriz de correlação heterogenea
correlacao <- hetcor(price_details[,c(4,5,8:13)])

# Visualizando a matriz de correlacao heterogenea de forma grafica
ggcorrplot(correlacao$correlations,
           method = "square",
           type = "upper",
           lab = T)+
  theme_light()+
labs(x = "", y = "")+
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(angle = 90,vjust = 0.6))

# Função que encontra valores que não pertencem em um vetor
`%notin%` <- Negate(`%in%`)

# Função para gerar boxplots entre o faturamento e variaveis categoricas
boxp <- function(var,var_n,tt){
  num <- which(names(price_details)==var)
  price_details$vari <- price_details[,num]
  
  price_details <- price_details %>% filter(is.na(vari) == F)
  
  ggplot(price_details, aes(x=as.factor(vari),y=faturamento))+
    geom_boxplot(fill="#FF585D")+
    scale_y_continuous(labels=dollar_format(prefix="R$ "))+
    labs(x = var_n, y = "Faturamento",title = tt)+
    theme_light()+
    theme(panel.grid = element_blank())
}

# Função para gerar boxplots entre o faturamento e variaveis categoricas retirando os outliers
boxp_out <- function(var,var_n,tt){
  num <- which(names(price_details)==var)
  price_details$vari <- price_details[,num]
  
  outliers <- boxplot(price_details$faturamento,plot = F)$out
  
  price_details <- price_details %>% filter(is.na(vari) == F)
  price_details <- price_details %>% filter(faturamento %notin% outliers)
  
  ggplot(price_details, 
         aes(x=as.factor(vari),y=faturamento))+
    geom_boxplot(fill="#FF585D",outlier.shape = NA)+
    scale_y_continuous(limits = quantile(price_details$faturamento, c(0.1, 0.9)))+
    scale_y_continuous(labels=dollar_format(prefix="R$ "))+
    labs(x = var_n, y = "Faturamento",title=tt)+
    theme_light()+
    theme(panel.grid = element_blank())
}

p1_1 <- boxp(names(price_details)[5],"Disponibilidade","Com outliers")
p1_2 <- boxp(names(price_details)[6],"Bairro","Com outliers")
p1_3 <- boxp(names(price_details)[10],"Star rating","Com outliers")
p1_4 <- boxp(names(price_details)[11],"Superhost","Com outliers")
p1_5 <- boxp(names(price_details)[8],"Número de quartos","Com outliers")
p1_6 <- boxp(names(price_details)[9],"Número de banheiros","Com outliers")

p2_1 <- boxp_out(names(price_details)[5],"Disponibilidade","Sem outliers")
p2_2 <- boxp_out(names(price_details)[6],"Bairro","Sem outliers")
p2_3 <- boxp_out(names(price_details)[10],"Star rating","Sem outliers")
p2_4 <- boxp_out(names(price_details)[11],"Superhost","Sem outliers")
p2_5 <- boxp_out(names(price_details)[8],"Número de quartos","Sem outliers")
p2_6 <- boxp_out(names(price_details)[9],"Número de banheiros","Sem outliers")

# Visualmente a variavel que apresentou possiveis diferenças entre os níveis foi bairro (com e sem outliers)
grid.arrange(p1_1,p2_1,ncol=2)
grid.arrange(p1_2,p2_2,ncol=2)
grid.arrange(p1_3,p2_3,ncol=2)
grid.arrange(p1_4,p2_4,ncol=2)
grid.arrange(p1_5,p2_5,ncol=2)
grid.arrange(p1_6,p2_6,ncol=2)

# Função para gerar graficos de dispersao entre o faturamento e variaveis numericas
dispersao <- function(var,var_n,tt){
  num <- which(names(price_details)==var)
  price_details$vari <- price_details[,num]
  
  ggplot(price_details,aes(x=vari,y=faturamento))+
    geom_point(color="#FF585D",alpha=0.3)+
    scale_y_continuous(labels=dollar_format(prefix="R$ "))+
    labs(x = var_n, y = "Faturamento",title = tt)+
    theme_light()+
    theme(panel.grid = element_blank())
}

# Função para gerar graficos de dispersao entre o faturamento e variaveis numericas
dispersao_out <- function(var,var_n,tt){
  num <- which(names(price_details)==var)
  price_details$vari <- price_details[,num]
  
  outliers1 <- boxplot(price_details$faturamento,plot = F)$out
  outliers2 <- boxplot(price_details$vari,plot = F)$out
  
  price_details <- price_details %>% 
    filter(faturamento < min(outliers1) & vari < min(outliers2))
  
  ggplot(price_details,aes(x=vari,y=faturamento))+
    geom_point(color="#FF585D",alpha=0.3)+
    scale_y_continuous(labels=dollar_format(prefix="R$ "))+
    labs(x = var_n, y = "Faturamento",title=tt)+
    theme_light()+
    theme(panel.grid = element_blank())
}

p3_1 <- dispersao(names(price_details)[4],"Preço ofertado","Com outliers")
p3_2 <- dispersao(names(price_details)[12],"Número de reviews","Com outliers")

p4_1 <- dispersao_out(names(price_details)[4],"Preço ofertado","Sem outliers")
p4_2 <- dispersao_out(names(price_details)[12],"Número de reviews","Sem outliers")

# Visualizando os gráficos de dispersão (com e sem outliers)
grid.arrange(p3_1,p4_1,ncol=2)
grid.arrange(p3_2,p4_2,ncol=2)

# Calculando o numero total de anuncios
total_listing <- price_details %>%
  group_by(listing_id) %>%             # Agrupando por listing_id
  count()                              # Contagem por listing_id
names(total_listing)[2] <- "total_reservas"

#Mesclando o conjunto de dados price_details e total_listing com o conectivo listing_id
price_details <- left_join(price_details,total_listing, by = "listing_id")

cor(price_details$faturamento,price_details$total_reservas) # r = 0.68

# Aparentemente existe correlacao positiva entre o total de reservas e o faturamento, o que se espera. 
ggplot(price_details,aes(x=total_reservas,y=faturamento))+
  geom_point(color="#FF585D")+
  scale_y_continuous(labels=dollar_format(prefix="R$ "))+
  labs(x = "Total de reservas", y = "Faturamento")+
  theme_light()+
  theme(panel.grid = element_blank())

#############################################################################
# QUARTA INFORMACAO: QUAL A ANTECENDENCIA MEDIA DAS RESERVAS, ESSE NUMERO E #
# MAIOR OU MENOR NOS FINAIS DE SEMANA                                       # 
#############################################################################  

# Transformando booked_on e date em dados de data
price_details$booked_on <- ifelse(price_details$booked_on=="blank",
                                  NA,price_details$booked_on)
price_details$booked_on <- as.Date(price_details$booked_on)
price_details$date <- as.Date(price_details$date)

# Calculando a diferenca entre a data alugada e quando foi alugado, encontrando a antecedencia da reserva 
price_details$date_diff <- difftime(price_details$date,
                                    price_details$booked_on,units="days")

# Criando um objeto para o vetor de antecedencia
date_diff <- price_details$date_diff 
date_diff <- na.omit(date_diff)     # retirando os NAs

# Encontrando a antecedencia media
mean(date_diff)

# O valor da antecedencia media foi de aproximadamente 32 dias, porem, ao olhar o histograma do vetor de antecedencia notamos que esse valor esta muito alto, devido a alguns valores extremos, como por exemplo 7644 dias de antecedencia, que aumentaram o valor da media (media e sensivel a valores outliers). 

ggplot()+
  geom_histogram(aes(x=date_diff),bins=50,col="#484848",fill = "#FF585D")+
  labs(x="Antecedência (em dias)", y = "Contagem",
       title="Histograma da diferença entre as datas sem nenhuma alteração")+
  theme_light()+
  theme(panel.grid = element_blank(),
        title = element_text(size=7))

# Dessa forma para encontrar a antecedencia media corretamente seria de interesse retirar os valores outliers

# Encontrando os valores outliers e os removendo
outliers_diff <- boxplot(date_diff,plot=F)$out
date_diff_out <- date_diff[-which(date_diff %in% outliers_diff)]

# Apos retirar os valores outliers ficamos com uma antecencia media de aproximadamente 15 dias, que e um valor muito mais realista.
mean(date_diff_out) # média sem outlier

p5 <- ggplot()+
  geom_histogram(aes(x=date_diff),col="#484848",fill = "#FF585D")+
  labs(x="Antecedência (em dias)", y = "Densidade",
       title="Diferença entre as datas sem nenhuma alteração")+
  theme_light()+
  theme(panel.grid = element_blank(),
        title = element_text(size=7))

p6 <- ggplot()+
  geom_histogram(aes(x=date_diff_out),col="#484848",fill = "#FF585D")+
  labs(x="Antecedência (em dias)", y = "Densidade",
       title="Diferença entre as datas sem outliers")+
  theme_light()+
  theme(panel.grid = element_blank(),
        title = element_text(size=7))

grid.arrange(p5,p6,ncol=2)

# Vale ressaltar que a mediana (50% dos dados) foram bastante proximas com e sem os valores outliers (mediana de 6 dias de antecedencia para os dados originais e 4 dias de antecedencia para os dados sem outlier), a medida da mediana e mais confiavel nessa situacao de valores extremos.

# Criando a variavel para os dias da semana com a funcao weekdays
price_details$weekday <- weekdays(price_details$date)

# Transformando weekday em fator e ajeitando os niveis
price_details$weekday <- as.factor(price_details$weekday) 
levels(price_details$weekday) <- c("Sexta-feira","Segunda-feira","Sábado",
                                   "Domingo","Quinta-feira","Terça-feira",
                                   "Quarta-feira")
# Reorganizando os niveis de weekday
price_details$weekday <- factor(price_details$weekday,
                                levels = levels(price_details$weekday)
                                [c(2,6,7,5,1,3,4)])


weekday <- price_details %>%
  group_by(weekday) %>%                   # Agrupando por weekday
  select(date_diff) %>%                   # Selecionando a antecedencia media
  na.omit() %>%                           # Retirando valores NA
  filter(date_diff %notin% outliers_diff) %>%  # Retirando os outliers
  summarise_at(vars("date_diff"),list(media = mean)) # Media de antecedencia

weekday

# Visualizando a diferenca media por dias da semana
ggplot(weekday, aes(x=weekday,y=media))+
  geom_col(fill="#FF585D")+
  labs(x = "Dias da semana", y = "Antecedência média",
       title = "Antecêndencia média por dia da semana")+
  theme_light()+
  theme(panel.grid = element_blank(),
        axis.title = element_text(colour = "#484848"))

# Aparentemente existe um pico na sexta feira, seguido por domingo, sabado e quinta-feira. Porem, ao meu ver esse valor nao e significativo. Os dias mais incomuns para reservar sao segunda-feira, terca-feira e quarta-feira.

# Baixando o arquivo price_details para usar no aplicativo
# write.csv(price_details.csv,"price_details.csv")