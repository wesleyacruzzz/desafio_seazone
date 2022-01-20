library(DT)
library(shiny)
library(polycor)
library(extrafont)
library(gridExtra)
library(tidyverse)
library(ggcorrplot)
library(data.table)
library(shinyWidgets)
library(shinydashboard)

dados <- fread("price_details.csv",encoding = "Latin-1")
dados <- dados[,-1]

dados$booked_on <- as.Date(dados$booked_on)
dados$date <- as.Date(dados$date)

dados$weekday <- as.factor(dados$weekday)
dados$weekday <- factor(dados$weekday,
                        levels = levels(dados$weekday)
                        [c(5,7,2,3,6,4,1)])

dados$suburb <- as.factor(dados$suburb)
dados$available <- as.factor(dados$available)
dados$star_rating <- as.factor(dados$star_rating)
dados$is_superhost <- as.factor(dados$is_superhost)
dados$number_of_bedrooms <- as.factor(dados$number_of_bedrooms)
dados$number_of_bathrooms <- as.factor(dados$number_of_bathrooms)

set.seed(123456)
amostra <- sample(1:dim(dados)[1],20000)

`%notin%` <- Negate(`%in%`)

variaveis <- names(dados)[c(4:6,8:16)]
variaveis_f <- variaveis[c(2,3,4,5,6,7,11)]
variaveis_t <- variaveis[which(variaveis %notin% variaveis_f)] 

tab1 <- function(var){
  num <- which(names(dados)==var)
  dados$vari <- dados[,..num]
  dd <- dados
  
  if (is.numeric(dd$vari)==T) {
    ggplot(dd,aes(x=vari))+
      geom_histogram(fill="#FF585D",color="white")+
      labs(y = "Contagem", x = var)+
      theme_light()+
      theme(panel.grid = element_blank(),
            axis.title = element_text(colour = "#484848"))
  } else {
    dd1 <- table(dd$vari) %>% as.data.frame()
    names(dd1) <- c("vari","n")
    
    ggplot(dd1,aes(x=reorder(vari,n),y=n))+
      geom_col(fill="#FF585D")+
      geom_text(aes(label=paste(n,"(",round(100*n/sum(n),1),"%)")),
                vjust=-0.5,size=3, color="#484848",) +
      labs(y = "Contagem", x = var)+
      theme_light()+
      theme(panel.grid = element_blank(),
            axis.title = element_text(colour = "#484848"))
  }
}
tab2 <- function(var1,var2){
  
  num1 <- which(names(dados) == var1)
  num2 <- which(names(dados) == var2)
  
  dados$var11 <- dados[,..num1]
  dados$var22 <- dados[,..num2]
  
  dd <- dados[amostra,]
  
  if (is.numeric(dados$var11) & is.numeric(dados$var22) == T) {
    
    ggplot(dd,aes(x=var11,y=var22))+
      geom_point(color="#FF585D")+
      labs(y = var2, x = var1)+
      theme_light()+
      theme(panel.grid = element_blank(),
            axis.title = element_text(colour = "#484848"))
    
  } else if (is.factor(dados$var11) & is.factor(dados$var22) == T) {
    
    ggplot(dd, aes(x=var11,fill=var22))+
      geom_bar(position = "fill",color = "white")+
      scale_y_continuous(labels=scales::percent)+
      labs(x = var1, y = "Porcentagem", fill = var2)+
      theme_light()+
      theme(panel.grid = element_blank(),
            axis.title = element_text(colour = "#484848"))
    
  } else {
    
    ggplot(dd, aes(y=var11,x=var22))+
      geom_col(fill="#FF585D",color = "#FF585D")+
      labs(x = var2, y = var1)+
      theme_light()+
      theme(panel.grid = element_blank(),
            axis.title = element_text(colour = "#484848"))
    
  }
}
tab3 <- function(var1,var2,var3){
  
  num1 <- which(names(dados) == var1)
  num2 <- which(names(dados) == var2)
  num3 <- which(names(dados) == var3)
  
  dados$var11 <- dados[,..num1]
  dados$var22 <- dados[,..num2]
  dados$var33 <- dados[,..num3]
  
  dd <- dados[amostra,]
  dd$var33 <- as.factor(dd$var33)
  dd <- dd %>% select(var11,var22,var33)
  correlacao <- hetcor(dd)
  corr <- correlacao$correlations
  colnames(corr) <- c(var1,var2,var3)
  rownames(corr) <- c(var1,var2,var3)
  
  p1 <- ggplot(dd,aes(x=var11,y=var22,color=var33))+
    geom_point()+
    facet_wrap(~var33)+
    labs(y = var2, x = var1, color = var3)+
    theme_light()+
    theme(legend.position = "bottom",
          panel.grid = element_blank(),
          axis.title = element_text(colour = "#484848"))
  
  p2 <- ggcorrplot(corr,
                   method = "square",type = "upper", lab=T)+
    theme(legend.position = "bottom",
          panel.grid = element_blank())
  
  return(list(p1,p2))
}
ggboxplot <- function(var){
  num <- which(names(dados)==var)
  dados$vari <- dados[,..num]
  dd <- dados
  
  outliers <- boxplot(dd$vari,plot=F)$out
  dd_out <- dd %>% select(vari) %>% filter(vari %notin% outliers)
  
  p2 <- paste0((dim(dd)[1]-dim(dd_out)[1]), " (",
               round((dim(dd)[1]-dim(dd_out)[1])/dim(dd)[1],3)," %)")
  
  if (is.numeric(dd$vari) == T) {
    p1 <- ggplot(dd, aes(y=vari))+
      geom_boxplot(fill="#FF585D",outlier.shape = NA)+
      scale_y_continuous(limits = quantile(dd$vari, c(0.1, 0.9),na.rm = T))+
      labs(y = var)+
      theme_light()+
      theme(panel.grid = element_blank())
  } else {
    p1 <- NULL
  }
  
  return(list(p1,p2))
}
tabela <- function(var){
  num <- which(names(dados)==var)
  dados$vari <- dados[,..num]
  dd <- dados
  sumario <- summary(dd$vari)
  
  if (is.numeric(dd$vari) == T) {
    sumario <- sumario %>% as.matrix() %>% t() %>% as.data.frame()
    rownames(sumario) <- NULL
    sumario[,4] <- round(sumario[,4],2)
  } else {
    sumario <- sumario %>% t() %>% as.data.frame()
    rownames(sumario) <- NULL
  }
  
  return(sumario)
}
tempo1 <- function(var){
  num <- which(names(dados)==var)
  dados$vari <- dados[,..num]
  dd <- dados

  var_tempo <- dd %>% group_by(date) %>% na.omit() %>% 
    summarise_at(vars("vari"),mean)
  names(var_tempo) <- c("date","vari")
  
  ggplot(var_tempo,aes(x=date,y = vari,
                       ymin=min(vari)-sd(vari),
                       ymax=vari))+
    geom_line()+
    geom_ribbon(fill="#FF585D")+
    theme_light()+
    labs(y=var, x = "Data")+
    theme(panel.grid = element_blank())
}
tempo2 <- function(var1,var2){
  num1 <- which(names(dados) == var1)
  num2 <- which(names(dados) == var2)
  
  dados$var11 <- dados[,..num1]
  dados$var22 <- dados[,..num2]
  
  dd <- dados
  
  var_tempo <- dados %>% group_by(date,var22) %>% na.omit() %>% 
    summarise_at(vars("var11"),mean)
  names(var_tempo) <- c("date","var22","var11")
  
  ggplot(var_tempo,aes(x=date,y = var11,color=var22))+
    geom_line(size = 1.2)+
    labs(y=var1,color=var2, x = "Data")+
    theme_light()+
    theme(panel.grid = element_blank())
}
