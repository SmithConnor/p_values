library(shiny)
library(shinydashboard)
library(forestplot)
library(tidyverse)
library(plotly)

shinyServer(function(input, output) {

        data = reactive({
            set.seed(2022)
            rnorm(n = input$n_obs,
                     mean = input$mean,
                     sd = input$sd)})


    output$dist = renderUI({
        if (!input$dist_visible) return()
        withMathJax(
            helpText("With your current selection on the left, you are sampling ", input$n_obs, " observations from $$X \\sim \\mathcal{N}(", input$mean ,",",input$sd^2,").$$",
                     "The parameters you currently know are: $$n = ", input$n_obs,",$$ $$\\alpha = ",input$alpha,"$$")
        )
    })

    output$dist_code = renderPrint({
        cat("set.seed(2022)",
            paste0("x = rnorm(",input$n_obs,",",input$mean,",", input$sd,")"), sep = "\n")
    })

    output$est = renderUI({
        withMathJax("To compute the Confidence Interval, we use our data to calculate: $$\\bar{x}=",round(mean(data()),3),",$$ $$s=",round(sd(data()),3),",$$ $$t(n-1)_{(1-\\alpha)/2}=",round(qt(p = input$alpha, df = input$n_obs-1, lower.tail = FALSE),3),"$$")
    })

    output$est_code = renderPrint({
        cat(paste0("x_bar = mean(x)"),
            "x_bar",
            paste0("x_sd = sd(x)"),
            "x_sd",
            paste0("t_a = qt(",input$alpha/2,",",input$n_obs-1,", lower.tail = FALSE)"),
            "t_a",
            sep = "\n")
    })

    output$CI = renderUI({
        withMathJax("After computing all the required values we can compute the Confidence Interval for the current simulated data: $$CI = (",round(mean(data()) - qt(p = input$alpha, df = input$n_obs-1, lower.tail = FALSE)*sd(data())/sqrt(input$n_obs), 3),",",round(mean(data()) + qt(p = input$alpha/2, df = input$n_obs-1, lower.tail = FALSE)*sd(data())/sqrt(input$n_obs), 3),").$$")
    })


    output$height_sim = renderPrint({
        cat(paste0("x = rnorm(n = 110,      #we sample 110 students"),
            paste0("          mean = 173,   #we know that our mean is 173cm"),
            paste0("          sd = 5)       #we know that our standard deviation is 5cm"),
            sep = "\n")
    })

    output$height_sim_rep = renderPrint({
        cat("X = matrix(data = NA_real_, nrow = 110, ncol = 50)",
            "for (b in 1:40){",
            paste0("   X[,b] = rnorm(n = 110,"),
            paste0("                 mean = 173,"),
            paste0("                 sd = 5)"),
            "}",
            sep = "\n")
    })

    output$height_sim_mean = renderPrint({
        cat("X_mean = apply(X,",
            "               MARGIN = 2,     #we apply the function to each column",
            "               FUN = mean)     #we want to calculate the mean",
            "X_sd = apply(X,",
            "             MARGIN = 2,",
            "             FUN = sd)         #we want to calculate the standard deviation",
            sep = "\n")
    })

    output$height_sim_CI = renderPrint({
        cat(paste0("CI_upper = X_mean + qt(p = ",input$alpha,", df = ",110-1,", lower.tail = FALSE)*X_sd/sqrt(",110,")"),
                   paste0("CI_lower = X_mean - qt(p = ",input$alpha,", df = ",110-1,", lower.tail = FALSE)*X_sd/sqrt(",110,")"),
            sep = "\n")
    })

    output$height_CI_check = renderPrint({
        cat("sum(CI_upper >= 173 & CI_lower <= 173)  #logical OR operator",
            sep = "\n")
    })


    X = matrix(rnorm(n = 110*40,
                              mean = 173,
                              sd = 5), 110, 40)

    X_mean = apply(X,
                   MARGIN = 2,    #we apply the function to each column
                   FUN = mean)    #we want to calculate the mean
    X_sd = apply(X,
                 MARGIN = 2,
                 FUN = sd)        #we want to calculate the standard deviation

    CI_upper = X_mean + qt(p = 0.05/2, df = 109, lower.tail = FALSE)*X_sd/sqrt(110)
    CI_lower = X_mean - qt(p = 0.05/2, df = 109, lower.tail = FALSE)*X_sd/sqrt(110)

    output$result = renderUI({
        paste0("In our simulations, there were a total of ",sum(CI_upper >= 173 & CI_lower <= 173)," confidence intervals that contained the value 173cm.")})

    base_data = tibble(index = 1:40,
                       mean = X_mean,
                       lower = CI_lower,
                       upper = CI_upper,
                       labeltext = paste("Rep", 1:40),
                       cont = CI_upper >= 173 & CI_lower <= 173)
    output$ci_plot = renderPlot({
        ggplot(data = base_data, aes(y=index, x=mean, xmin=lower, xmax=upper, col = cont)) +
        geom_point() +
        scale_y_continuous(name = "", breaks=1:nrow(base_data), labels=base_data$labeltext)+
        geom_errorbarh(height=.1) +
        labs(title='Student Height', x='Height (cm)') +
        geom_vline(xintercept=173, color='black', linetype='dashed', alpha=.5) +
        theme_minimal() + labs(col = "Contains 173cm")})




})
