
#Instalar pacotes necessários

install.packages("TTR")
install.packages("xts")
install.packages("quantmod")
install.packages("usethis")
install.packages("devtools")
install.packages("FinancialInstrument")
install.packages("PerformanceAnalytics")
devtools :: install_github("braverock/blotter", force = T)
install.packages("foreach")
devtools :: install_github ("braverock/quantstrat", force = T)

#Chamar pacotes necessários
library(TTR)
library(xts)
library(quantmod)
library(usethis)
library(devtools)
library(FinancialInstrument)
library(PerformanceAnalytics)
library(blotter)
library(foreach)
library(quantstrat)


#Chamar dados

# *Chamar WorkSpace Dolar - "Dolar - Workspace 2021" - Arquivo R.Data

#visualizando dados
View(dolar)

# Removendo Linhas Data Frame

#Dados 2020
DOLAR <- dolar [-(1:1634)]
View(DOLAR)

#Dados 2022
DOLAR_2021 <- DOLAR [-(26380:33366)]
View(DOLAR_2021)

#Calculo de Indicadores

#Media Movel Simples
sma108 <-SMA((DOLAR_2021$Close),n=108)
sma72 <-SMA((DOLAR_2021$Close),n=72)
sma12 <-SMA((DOLAR_2021$Close),n=12)
sma26 <-SMA((DOLAR_2021$Close),n=26)
tail(sma108,n=5)
tail(sma72,n=5)
tail(sma12,n=5)
tail(sma26,n=5)

#MACD
macd <- MACD((DOLAR_2021$Close), nFast=12, nSlow=26, nSig=9, maType=SMA)
tail(macd,n=5)

#VWAP
vwap_108 <- VWAP(DOLAR_2021$Close, DOLAR_2021$Volume, n = 108)
vwap_12 <- VWAP(DOLAR_2021$Close, DOLAR_2021$Volume, n = 12)
tail(vwap_108)
tail(vwap_12)

#Plotando Grafico com indicadores de Periodo (1ª Quinzena Janeiro 2021)

#Criar base de Dados:
DOLAR_2021_QUINZENA01_MES01 <- DOLAR_2021 [-(1141:26379)]
quantmod::chartSeries(DOLAR_2021_QUINZENA01_MES01,
                      type="candlesticks",
                      subset='2021-01',
                      TA = "addSMA(12);addSMA (108);addMACD()",
                      theme = "white")


#Iniciar Elaboracao de estrategia (RSI)
#Estratégia:
#Compar 01 contrato/mini-contrato no comparativo RSI <30
#Zerar posicao (vender) no fechamento do dia.


# Configurando e adicionando indicador

day <-12
price <- Cl(DOLAR_2021)
signal <- c()                    #Vetor de Inicializacao
rsi <- RSI(price, candle)     #rsi is the lag of RSI
signal [1:day+1] <- 0          


# Configurando sinal de operacao

for (i in (day+1): length(price)){
  if (rsi[i] < 30){             #buy if rsi < 30
    signal[i] <- 1
  }else {                       #no trade all if rsi > 30
    signal[i] <- 0
  }
}
signal<-reclass(signal,Cl(DOLAR_2021))
trade2 <- Lag(signal)


# Construcao da variavel

ret <- dailyReturn(DOLAR_2021)*trade2
names(ret) <- 'RSI'


# Plotagem do retorno acumulado

retall <- cbind(ret)
charts.PerformanceSummary(retall, 
                          main="RSI")

#Analise de Desempenho

tab <- table.Arbitrary(ret,
                       metrics=c(
                         "Return.cumulative",
                         "Return.annualized",
                         "SharpeRatio.annualized",
                         "CalmarRatio"),
                       metricsNames=c(
                         "Cumulative Return",
                         "Annualized Return",
                         "Annualized Sharpe Ratio",
                         "Calmar Ratio"))


#Visualizacao de desempenho
View(tab)

#Plotagem de desempenho
charts.PerformanceSummary(retorno_diario, colorset = bluefocus)

