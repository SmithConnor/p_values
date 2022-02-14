library(shiny)
library(shinydashboard)
library(forestplot)
library(tidyverse)
library(plotly)

header = dashboardHeader()

sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Confidence Intervals",
                 tabName = 'dashboard',
                 icon = icon("chalkboard")),
        numericInput(inputId = "mean",
                     label = "Mean",
                     value = 0,
                     min = 0,
                     max = 100,
                     step = 1),
        numericInput(inputId = "sd",
                     label = "Standard Deviation",
                     value = 1,
                     min = 1,
                     max = 100,
                     step = 1),
        sliderInput(inputId = "n_obs",
                    label = "Number of Observations",
                    min = 10,
                    max = 100,
                    value = 50),
        sliderInput(inputId = "alpha",
                    label = "Significance Level",
                    min = 0.01,
                    max = 0.1,
                    value = 0.05,
                    step = 0.01),
        menuItem("Question",
                 tabName = 'question',
                 icon = icon("question")),
        menuItem("Solution",
                 tabName = 'solution',
                 icon = icon("chart-line")),
        menuItem("About",
                 tabName = 'about',
                 icon = icon("address-book"))))

body = dashboardBody(
    tabItems(
        tabItem(tabName = 'dashboard',
                h1("Confidence Intervals for Unknown Mean and Unknown Variance"),
                HTML("A <b> Confidence Interval </b> estimates a range of values which are likely to include an <b> unknown population parameter </b>, where this estimated range is calculated from <b> sample data </b>. <br>"),
                "In the majority of applications, both the mean and variance are unknown. As such we may need to construct Confidence Intervals where we estimate both these parameters.",
                HTML("<br>"),
                withMathJax("To simulate data, we sample from \\(X\\) where $$X \\sim \\mathcal{N}(\\mu,\\sigma^{2}).$$"),
                checkboxInput(inputId = "dist_visible",
                              label = "Show simulation settings",
                              value = FALSE),
                uiOutput("dist"),
                verbatimTextOutput("dist_code"),
                withMathJax("Given that we have simulated data from a normal distribution where \\(\\mu\\) and \\(\\sigma\\) are both unknown, a Confidence Interval for the population mean can be estimated by $$\\bar{x} \\pm t(n-1)_{(1-\\alpha)/2}\\frac{s}{\\sqrt{n}},$$ where \\(t(n-1)_{(1-\\alpha)/2}\\) is the upper critical value for the \\(t\\) distribution with \\(n-1\\) degrees of freedom."),
                HTML("<br>"),
                uiOutput("est"),
                verbatimTextOutput("est_code"),
                uiOutput("CI")
                ),
        tabItem(tabName = 'question',
                h1("Student Height Questions"),
                "After a recent study, it has been found that the heights of students on campus follows a normal distribution with the average height being 173cm and the standard deviation being 5cm (These are population values not samples).",
                HTML("<br>"),
                HTML("<b> 1. If I was to go collect data from 110 people and create a 95% Confidence Interval from their heights, would I expect the Confidence Interval to contain the average height of the student population?</b>"),
                HTML("<br>"),
                "As it would be impractical to ask 110 students for their heights, we can simulate this sampling.",
        HTML("<br>"),
        HTML("<b> 2. If I repeated this sampling 40 times, how many Confidence Intervals would I expect to contain the population mean? How does this compare to your simulated values? </b>"),
                helpText("The knowledge of both the mean and standard deviation is to allow for us to simulate data. You cannot use any of this knowledge after simulating your data.")),
        tabItem(tabName = 'solution',
                h1("Student Height Solutions"),
                "Let \\(X\\) be the height of a student at university. We are given that $$X \\sim \\mathcal{N}(173,5^{2}),$$ where \\(X\\) is measured in cm.",
                HTML("<br>"),
                "We are able to simulate from this population using the following code:",
                verbatimTextOutput("height_sim"),
                "Then we can repeat this process 40 times storing each repeat as a row inside a matrix",
                verbatimTextOutput("height_sim_rep"),
                "We then calculate the mean and standard deviation for each row",
                verbatimTextOutput("height_sim_mean"),
                "We then calculate the upper and lower bounds of the Confidence Intervals",
                verbatimTextOutput("height_sim_CI"),
                "Finally we count how many intervals contain 173cm",
                verbatimTextOutput("height_CI_check"),
                uiOutput("result"),
                plotOutput("ci_plot")),
        tabItem(tabName = 'about',
                "This Shiny application was created by Connor Smith on the 11th of February 2022.")
    ))



dashboardPage(header,
              sidebar,
              body,
              skin = "purple")
