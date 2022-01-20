shinyServer(function(input, output, session) {
    
    # Primeira tab ####
    
    output$plot1 <- renderPlot({
        num <- which(names(dados) == input$var)
        str <- dados[,..num] %>% as.matrix() %>% as.vector()
        
        if (is.numeric(str)) {
            p1 <- tab1(input$var)
            p2 <- ggboxplot(input$var)
            gridExtra::grid.arrange(p1,p2[[1]],ncol=2)
        } else {
            tab1(input$var)
        }
    })
    
    output$ibox <-  renderValueBox({
        num <- which(names(dados) == input$var)
        str <- dados[,..num] %>% as.matrix() %>% as.vector()
        
        info <- ggboxplot(input$var)
        
        if (is.numeric(str)) {
            infoBox(
                "Valores outliers retirados da amostra",
                width = NULL,
                fill = T,
                info[[2]],
                color = "aqua",
                icon = icon("minus-circle")
            )
        } else {
            infoBox(
                "Valores outliers retirados da amostra (Não se aplica)",
                width = 0,
                fill = T,
                value="",
                color = "aqua",
                icon = icon("minus-circle")
            )
        }
    })
    
    output$tabela1 <- renderDT({
        num <- which(names(dados) == input$var)
        str <- dados[,..num] %>% as.matrix() %>% as.vector()
        
        if (is.numeric(str)) {
            datatable(tabela(input$var), options = list(dom = 't'))
        } else {

        }
    })
    
    # Segunda tab ####
    
    output$plot2 <- renderPlot({
        num1 <- which(names(dados) == input$var1)
        num2 <- which(names(dados) == input$var2)
        
        str1 <- dados[,..num1] %>% as.matrix() %>% as.vector()
        str2 <- dados[,..num2] %>% as.matrix() %>% as.vector()
        
        if (input$var3 != "Nenhuma") {
            if (is.numeric(str1) & is.numeric(str2) == T) {
                p <- tab3(input$var1,input$var2,input$var3)
                grid.arrange(arrangeGrob(p[[1]], ncol=1),
                             arrangeGrob(p[[2]], ncol=1),
                             widths = c(3,1)) 
            } else {
                tab2(input$var1,input$var2)
            }
        } else {
            tab2(input$var1,input$var2)
        }
        
    })
    
    # Terceira tab ####
    
    output$plot3 <- renderPlot({
        num1 <- which(names(dados) == input$var1)
        num2 <- which(names(dados) == input$var2)
        
        str1 <- dados[,..num1] %>% as.matrix() %>% as.vector()
        str2 <- dados[,..num2] %>% as.matrix() %>% as.vector()
        
        if (input$var5 != "Nenhuma") {
            tempo2(input$var4,input$var5)
        } else {
            tempo1(input$var4)
        }
        
    })
})