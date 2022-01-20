# Seazone Code Challenge - Análise dos dados de ocupação e preços de anúncios da Airbnb

O objetivo desse repositório é exibir os códigos e arquivos necessários para reproduzir a minha análise. Todo o *script* foi feito utilizando o *software Rstudio* () e foi programado na linguagem *R*.

A análise foi embasada em gráficos e tabelas bem como alguns conceitos estatísticos, como o de correlação linear heterogênea. Ao final dois produtos foram gerados: 

- **Um relatório em PDF com comentários**
- **Um aplicativo *web* para visualização dos dados disponíveis**

Para reproduzir os *scripts* da análise é necessário que o usuário siga alguns passos, são eles:

- Instale o *R*: https://cran.r-project.org/
- Instale o *RStudio*: https://www.rstudio.com/products/rstudio/download/
- Com o *Rstudio* aberto é necessário instalar os seguintes pacotes :

```
install.packages("ggcorrplot") # Gera uma visualização para a matriz de correlação
install.packages("kableExtra") # Cria tabelas com boa estética no R Markdown
install.packages("gridExtra")  # Permite criar grids de gráficos
install.packages("tidyverse")  # Coleção de diversos pacotes para fins gerais
install.packages("polycor")    # Gera a matriz de correlação heterogênea
install.packages("scales")     # Permite formatar os valores nos eixos dos gráficos
install.packages("knitr")      # Gera o arquivo R Markdown
```

Após a instalação dos pacotes o(a) avaliador(a) pode rodar os códigos encontrado no arquivo *script_desafio_seazone.R* ou se for de interesse é possível gerar o mesmo PDF rodando os códigos presentes no arquivo *relatorio_desafio_seazone.Rmd*. **Para garantir que não haja nenhum problema os scripts e os dados devem estar na mesma página** ou será necessário adicionar a seguinte linha de código antes de rodar:

```
setwd("diretório dos dados")
```

Caso prefira, o(a) avaliador(a) pode acessar a versão *HTML* do relatório final através desse [link](https://htmlpreview.github.io/?https://github.com/wesleyacruzzz/desafio_seazone/blob/main/Arquivos/html_relatorio_desafio_seazone.html)

O aplicativo *web* foi um extra que eu decidi adicionar ao desafio. O *app* funciona como um dashboard online para visualização rápida dos dados, nesse aplicativo é possível encontrar gráficos de variáveis individuais, gráficos de cruzamento de variáveis e gráficos de variáveis ao longo do tempo. 

Caso o usuário tenha alguma dificuldade ou não saber como interagir com o aplicativo, basta clicar nos ícones de interrogação localizados no canto superior direito da tela, lá terá um resumo de cada página no dashboard. O aplicativo pode ser encontrado nesse [link](https://wesley-almeida-cruz-wess.shinyapps.io/desafio_seazone/). 

<p align="center">
  <img src="https://github.com/wesleyacruzzz/desafio_seazone/tree/main/Imagens/print_app.png" width="350" title=" ">
</p>
