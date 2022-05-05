
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


#Iniciar Elaboracao de estrategia
#Cruzamento de sinais
#Ações: Comprar 1 contrato/minicontrato no cruzamento de 12 >72					
#Zerar posicao (vender) no cruzamento de 12 <72					

#Mercado em tendência de alta

# Utilizacao de medias moveis

#Configuracao
symbols = c("DOLAR_2021_QUINZENA01_MES01")
initEq=10^6

currency("USD")
strategy.st <- portfolio.st <- account.st <- "SMA"
rm.strat(strategy.st)
initAcct(account.st, portfolios=portfolio.st, 
         initEq = initEq)
initPortf(portfolio.st, symbols)
initOrders(portfolio.st)
strategy(strategy.st, store=TRUE)


#Adicao de Indicadores
add.indicator(
  strategy.st, name="SMA",
  arguments=list(x=quote(Cl(mktdata)), n=72),
  label="sma72")

add.indicator(
  strategy.st, name="SMA",
  arguments=list(x=quote(Cl(mktdata)), n=12),
  label="sma12")


#Adicao de sinais (compra-venda)
add.signal(
  strategy.st, 
  name="sigCrossover",
  arguments=list(columns=c("sma12","sma72"),
                 relationship="gt"),
  label="buy")

add.signal(
  strategy.st, 
  name="sigCrossover",
  arguments=list(columns=c("sma12","sma72"), 
                 relationship="lt"), 
  label="sell")


#Adicao de regras
add.rule(strategy.st, 
         name='ruleSignal', 
         arguments = list(sigcol="buy", 
                          sigval=TRUE,  
                          orderqty=1, 
                          ordertype='market', 
                          orderside='long', 
                          pricemethod='market', 
                          replace=FALSE), 
         type='enter', 
         path.dep=TRUE)

add.rule(strategy.st, 
         name='ruleSignal', 
         arguments = list(sigcol="sell", 
                          sigval=TRUE,  
                          orderqty='all', 
                          ordertype='market', 
                          orderside='long', 
                          pricemethod='market', 
                          replace=FALSE), 
         type='exit', 
         path.dep=TRUE)


#Avaliacao - visualizacao de negociacoes
out<-try(applyStrategy(strategy.st, 
                       portfolios=portfolio.st))
         
#Atualizacao de Contas
updatePortf(portfolio.st)
updateAcct(portfolio.st)
updateEndEq(account.st)

#Tracar posicoes de mercado
for(symbol in symbols) {
  chart.Posn(Portfolio=portfolio.st,
             Symbol=symbol,log=TRUE)
}

#Estatisticas de negociacao
tstats <- tradeStats(portfolio.st)
t(tstats) #transpose tstats

#Analise de Desempenho
rets <- PortfReturns(Account = account.st)
rownames(rets) <- NULL
tab <- table.Arbitrary(rets,
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
tab

#Visualizacao de desempenho
View(tab)

#Plotagem de desempenho
charts.PerformanceSummary(rets, colorset = bluefocus)

