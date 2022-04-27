##  Automatização de Negociação -  Contratos Futuros - USD/BRL

O Sistema de Negociação apresentado nesta apostila foi desenvolvido com o objetivo de avaliar o desempenho de regras “estratégias” de análise técnica (TA) aplicadas ao contrato futuro derivativo da taxa de câmbio de reais por dólar comercial.

O dólar, atualmente é a moeda mais negociada na B3, antiga BOVESPA e também segundo Hernandez et al. (2017), a moeda mais negociada mundialmente, nas principais bolsas de valores internacionais como Nova York (E.U.A), Frankfurt (Alemanha), Paris (França), Xangai (China), Tóquio (Japão), dentre outras, de acordo com o relatório diário de volume cambial negociado elaborado pela B3. Segundo a B3, A negociação do contrato futuro de taxa de câmbio de reais por dólar comercial é utilizada mundialmente para proteção de ativos e do câmbio em si, tornando-se uma forma de garantir compromissos de compra e venda em vários contratos realizados entre as diversas instituições financeiras e de câmbio, participantes do mercado.

Ainda segundo a B3, o Contrato Futuro de Dólar dos Estados Unidos da América pode servir também para proteção ou especulação sobre o preço da moeda em data futura, assim como para investidores que, por exemplo, tenham recebíveis em dólares dos Estados Unidos da América, ou exposição para pagamentos de passivos na moeda em datas futuras ou até mesmo negociar sobre a tendência da moeda no futuro e assim auferir lucro. De acordo com o último relatório divulgado pela B3 em dezembro de 2021, 49% dos investidores nesse mercado no país, são estrangeiros, acompanhados das instituições financeiras e de investidores institucionais, sendo 27% e 18% respectivamente, os investidores pessoa física correspondem a 4% da participação no mercado.

Segundo a CVM (Comissão de Valores Imobiliários), no memorando 25/2020, o crescimento do número de investidores pessoa física no mercado de contrato futuro de taxa de câmbio de reais por dólar comercial, vem acompanhado o crescimento como um todo, segundo o memorando, em janeiro de 2018, registrava-se o número de 22 mil investidores, esse número cresceu para 45 mil em julho de 2019 e para 91 mil em março de 2020.

Após estudos bibliográficos, definição das “regras” estratégias de análise técnica a serem utilizadas como objeto de estudo e elaboração da metodologia a ser aplicada, foram desenvolvidos estudos e “scripts” no Software de programação “R”, de modo a importar os dados de negociação, criar e automatizar o sistema de negociação e por fim avaliar e mensurar risco-retorno e rendimento das “regras” estratégias criadas, estabelecendo-se como período de avaliação o ano de 2021. 

Abaixo estão listados os pacotes do Software "R", necessários para desenvolvimento e correto funcionamento do sistema de negociação desenvolvido:

('quantmod')
('timeSeries')
('fPortfolio')
('tidyverse')
('Hmisc')
('corrplot')
('magrittr')
("TTR")
("xts")
("FinancialInstrument")
("braverock/blotter")
("PerformanceAnalytics")
("braverock/quantstrat")

### Desenvolvimento do Script de Importação dos dados USD/BRL

O sistema de negociação como dito foi desenvolvido em um ambiente de programação “R” e foi baseado em “regras” e estratégias de negociação utilizando-se do cruzamento de médias móveis aplicadas ao contrato futuro de taxa de câmbio de reais por dólar comercial.

Realizou-se a adaptação do pacote “R”, depositado no site Github.com denominado “mt5.R”. O pacote em questão fornece uma estrutura aos usuários do Metatrader5 na obtenção de dados para análise e desenvolvimento de sistemas automatizados de negociação, além de ferramentas direcionadas ao desenvolvimento de Machine Learning através de integração com conexão de “soquete”. A utilização de tal pacote possibilitou a comunicação entre “R”, B3 e a plataforma de negociação (Metatrader5).

Para utilização da ferramenta faz-se ainda necessário que o usuário tenha uma conta em uma corretora e que seja disponibilizada pela mesma, acesso a referida plataforma de negociação Metatrader5. A instalação do pacote é feita em dois passos sendo um no “R” e outro no Metatrader5, conforme passo a passo presente no site conforme link abaixo:

https://kinzel.github.io/mt5R/index.html

Após instalação e parametrização do pacote desenvolveu-se o “Script” abaix, que permitiu a importação, tratamento dos dados históricos de negociação do contrato futuro de taxa de câmbio de reais por dólar comercial referente ao ano de 2021, bem como o cálculo e desenvolvimento dos indicadores a serem utilizados nas regras “estratégias” elaboradas para desenvolvimento do estudo:

```markdown
# Importação de dados

# Instalando e chamando Pacote devtools
install.packages("devtools")
library (devtools)


# Instalando e Chamando pacote mt5R

devtools :: install_github ("Kinzel/mt5R", force = T)
library (mt5R)
library(quantmod)

# Definindo quantidade de pregoes para 05 minutos - Aprox. 16 meses

dolar = MT5.GetSymbol("DOL$", iTF = 5, iRows = 35000, xts = T)

dolar <- timeSeries::as.timeSeries(na.omit(dolar))

# Chamando todos os dados
quantmod::chartSeries(dolar, theme = "black", name = "DOL$")

# Tratamento dos dados – Instalação de pacotes para elaboração das regras “estratégias”

#Instalar pacotes necessários
install.packages("quantmod")
install.packages("TTR")
install.packages("devtools")
install.packages("xts")
install.packages("FinancialInstrument")
install_github("braverock/blotter")
install.packages("PerformanceAnalytics")
devtools :: install_github ("braverock/quantstrat", force = T)

#Chamar pacotes necessários
library(quantmod)
library(TTR)
library(devtools)
library(xts)
library(blotter)
library(FinancialInstrument)
library(PerformanceAnalytics)
library(quantstrat)

#Chamar dados

# *Chamar WorkSpace Dolar - "Whorkspace com dados baixados 35000 candles - Série XTS"

#visualizando dados
View(dolar)

# Removendo Linhas Data Frame

#Dados 2020
DOLAR <- -dolar [-(1:1634)]
View(DOLAR)

#Dados 2022
DOLAR_2021 <- -DOLAR [-(26380:33366)]
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
DOLAR_2021_QUINZENA01_MES01 <- -DOLAR_2021 [-(1141:26379)]
quantmod::chartSeries(DOLAR_2021_QUINZENA01_MES01,
                      type="candlesticks",
                      subset='2021-01',
                      TA = "addSMA(12);addSMA (108);addMACD()",
                      theme = "white")

```

A tabela abaixo apresenta as 10 primeiras linhas de um total de 26.380 linhas do histórico de negociação no timeframe de 05 minutos, para o ano de 2021 referentes ao contrato futuro de taxa de câmbio de reais por dólar comercial:

![image](https://user-images.githubusercontent.com/104097497/165585552-67ffe9f4-d472-491a-bf0a-4ff68b32ac51.png)


### Desenvolvimento das Regras "Estratégias" de Negociação

As regras...

### Regra "Estratégia" - Média Móvel

A Regra...

### Regra "Estratégia" - Preço de Fechamento

A Regra...
