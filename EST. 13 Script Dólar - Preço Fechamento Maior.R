
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


#Iniciar Elaboracao de estrategia (Preço Fechamento)
#Estratégia:
#Comprar 01 contrato/mini-contrato quando o preço de abertura for maior que o fechamento do dia anterior.
#Zerar posicao (vender) no fechamento do dia.

# Selecao do preco de fechamento apenas:

preco_fechamento <- quantmod::Cl(DOLAR_2021)


# Computo das variacoes diarias dos precos de fechamento:

variacao_preco <- preco_fechamento/lag(preco_fechamento)


# Definicao do parametro de compra:

beta <- 1


# Resultados dos sinais a partir das variacoes e do parametro de compra:

sinal <- c(0)

for (i in 2:length(preco_fechamento)){
  
  if (variacao_preco[i] > beta){
    
    sinal[i] <- 1
    
  } else
    
    sinal[i] <- 0
}


# Adequando as datas dos sinais:

sinal <- xts::reclass(sinal, preco_fechamento)


# Impressao no console das primeiras 5 linhas:

head(sinal, n = 5)


# Gerando o grafico para intervalo de tempo (Visualização para Quinzena de Janeiro):

quantmod::chartSeries(DOLAR_2021,
                      subset= '2021-01-01::2021-01-15',
                      theme = quantmod::chartTheme('black',
                                                   up.col='#70c9e7',
                                                   dn.col='#af636c'))

# Adicionando os sinais de compra:

quantmod::addTA(sinal, col = 'green')

# Deve-se comprar com base no sinal anterior:

ordem <- lag(sinal,1) 


# Alterando o nome da coluna:

names(ordem) <- 'filtro'


# Impressao no console das primeiras 5 linhas:

head(ordem, n = 5)

# Calculo do retorno diario obtido nos dias em que a ordem deveria ser
# executada de acordo com a estrategia tratada:

retorno_diario <- quantmod::dailyReturn(DOLAR_2021) * ordem


# Impressao no console das primeiras 5 linhas:

head(retorno_diario, n = 5)

# Avaliando o resutaldo no periodo tratado (retorno acumulado):

PerformanceAnalytics::charts.PerformanceSummary(retorno_diario)

#Analise de Desempenho

tab <- table.Arbitrary(retorno_diario,
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

