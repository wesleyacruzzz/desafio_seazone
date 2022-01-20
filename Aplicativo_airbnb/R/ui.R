title <- "Wesley A. Cruz"

ui <- fluidPage(
    dashboardPage(
        # Header ####
        dashboardHeader(title = title, titleWidth = 200),
        # Side Bar ####
        dashboardSidebar(width = 350, disable =  TRUE),
        # Body ####
        dashboardBody(
            tags$head(
              tags$style(
              type = 'text/css', 
              '.bg-aqua {background-color: #FF585D!important; }'
            ),
                tags$style(HTML(
                    '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
                    }
      .tabbable > .nav > li[class=active] > a {background-color: #FF585D; color:white}
    ')),
                
                tags$link(rel = "stylesheet", type = "text/css", href = "style1.css")),
            tags$script(HTML('
        $(document).ready(function() {
        $("header").find("nav").append(\'<span class="myClass"> Análise exploratória (Airbnb) - Desafio Seazone </span>\');
        })
        
        ')),
            tabsetPanel(type = "pills",
                tabPanel("Análise por variável",
                         column(12,
                                br(),
                                dropdown(
                                  helpText("• O objetivo desse painel é analisar de forma gráfica as variáveis dos conjuntos de dados do desafio"),
                                  helpText("• Escolha uma variável clicando no seletor que aparece na tela"),
                                  helpText("• A caixa vermelha informa quantos outliers foram retirados dos dados (se a variável for numérica)"),
                                  helpText("• A tabela mostra as estatísticas sumárias da variável escolhida"),
                                  helpText(HTML("• <b> Quando a variável é numérica </b> será mostrado um gráfico de histograma e um boxplot sem outliers")),
                                  helpText(HTML("• <b> Quando a variável é categórica </b> será mostrado um gráfico de barras")),
                                         style = "fill",
                                         status = "primary",
                                         icon = icon("question"),
                                         animate = T),
                                splitLayout(
                                    selectInput("var", "Selecione uma variável",
                                                choices = variaveis, 
                                                selected = variaveis[1],
                                                multiple = FALSE,
                                                selectize=FALSE),
                                    infoBoxOutput("ibox",width = 12),
                                    DTOutput("tabela1"),
                                    cellWidths = c("15%","40%","45%"))),
                         column(12,plotOutput("plot1"))),
                tabPanel("Análise comparativa",
                         column(12,
                                br(),
                                dropdown(
                                  helpText("• O objetivo desse painel é analisar de forma gráfica os possíveis cruzamentos entre duas ou três variáveis dos conjuntos de dados do desafio"),
                                  helpText("• Escolha duas variáveis clicando nos dois primeiros seletores que aparece na tela, é dado uma opção de selecionar uma terceira variável"),
                                  helpText(HTML("• <b> Quando ambas as variáveis são numéricas </b> será mostrado um gráfico de dispersão e é possível selecionar uma terceira variável para categorizar os pontos, nesse caso é mostrado uma grid de gráficos de dispersão e uma matriz de correlação")),
                                  helpText(HTML("• <b> Quando ambas as variáveis são categóricas </b> será mostrado um gráfico de barras empilhado")),
                                  helpText(HTML("• <b> Caso uma variável é numérica e a outra é categórica </b> será mostrado um gráfico de barras comum")),
                                  style = "fill",
                                  status = "primary",
                                  icon = icon("question"),
                                  animate = T),
                                splitLayout(
                                    selectInput("var1",
                                                "Selecione a 1° variável",
                                                choices = variaveis, 
                                                selected = variaveis[1],
                                                multiple = FALSE,
                                                selectize=FALSE),
                                    selectInput("var2",
                                                "Selecione a 2° variável",
                                                choices = variaveis, 
                                                selected = variaveis[9],
                                                multiple = FALSE,
                                                selectize=FALSE),
                                    selectInput("var3", "Selecione uma variável categórica (opcional)",
                                                choices = c("Nenhuma",variaveis_f), 
                                                selected = "Nenhuma",
                                                multiple = FALSE,
                                                selectize=FALSE),
                                    cellWidths = c("33%","33%","33%")),
                                plotOutput("plot2"))),
                tabPanel("Análise no tempo",
                         column(3,
                                br(),
                                dropdown(
                                  helpText("• O objetivo desse painel é analisar as variáveis numéricas e sua relação com as outras variáveis categóricas ao longo do tempo de forma gráfica"),
                                  helpText("• Escolha uma variável clicando no seletor que aparece na tela, também é possível escolher uma variável categórica opcional"),
                                  helpText(HTML("• <b> Se somente a variável numérica for selecionada </b> será mostrado um gráfico de densidade no tempo")),
                                  helpText(HTML("• <b> Se selecionar a variável categórica </b> será mostrado um gráfico de linhas com as categorias da variável")),
                                  style = "fill",
                                  status = "primary",
                                  icon = icon("question"),
                                  animate = T),
                                selectInput("var4",
                                            "Selecione uma variável",
                                            choices = variaveis_t, 
                                            selected = variaveis_t[1],
                                            multiple = FALSE,
                                            selectize=FALSE),
                                selectInput("var5",
                                            "Selecione uma variável (opcional)",
                                            choices = c("Nenhuma",
                                                        variaveis_f), 
                                            selected = "Nenhuma",
                                            multiple = FALSE,
                                            selectize=FALSE)),
                         column(9,plotOutput("plot3")))
            )
    )
))