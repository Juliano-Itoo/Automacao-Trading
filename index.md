##  1. Automatização de Estratégias de Negociação - Contratos Futuros - USD/BRL

O Sistema de Negociação apresentado nesta apostila foi desenvolvido com o objetivo de avaliar o desempenho de estratégias elaboradas a paritr de regras de análise técnica (TA), com base em indicadores, aplicadas ao contrato futuro de taxa de câmbio de reais por dólar comercial, utilizando-se dos Softwares de programação "R" e "RStudio".

"R" é uma linguagem de computador de alto nível projetada para estatísticas e gráficos. Uma característica principal é a linguagem de programa vetorial como o Matlab. Foi inicialmente criado por Ross Ihaka e Robert Gentleman (Departamento de Estatística da Universidade de Auckland, Nova Zelândia, e daí o nome). Atualmente, é um software de código aberto gratuito mantido por vários contribuidores.

Comparado com alternativas, SAS, Matlab ou Stata, R é totalmente gratuito. Outra vantagem é que é open source. Isso significa que não há caixa preta para tudo que você usa. Você sabe o que está fazendo. Também é livremente dispensável para que você possa fazer o que quiser. RStudio é um editor de desenvolvimento integrado (IDE) para R. É mais fácil escrever código usando o editor.

Em consonância, o dólar, atualmente é a moeda mais negociada na B3, antiga BOVESPA e também segundo Hernandez et al. (2017), a moeda mais negociada mundialmente, nas principais bolsas de valores internacionais como Nova York (E.U.A), Frankfurt (Alemanha), Paris (França), Xangai (China), Tóquio (Japão), dentre outras, de acordo com o relatório diário de volume cambial negociado elaborado pela B3. Segundo a B3, A negociação do contrato futuro de taxa de câmbio de reais por dólar comercial é utilizada mundialmente para proteção de ativos e do câmbio em si, tornando-se uma forma de garantir compromissos de compra e venda em vários contratos realizados entre as diversas instituições financeiras e de câmbio, participantes do mercado.

Ainda segundo a B3, o Contrato Futuro de Dólar dos Estados Unidos da América pode servir também para proteção ou especulação sobre o preço da moeda em data futura, assim como para investidores que, por exemplo, tenham recebíveis em dólares dos Estados Unidos da América, ou exposição para pagamentos de passivos na moeda em datas futuras ou até mesmo negociar sobre a tendência da moeda no futuro e assim auferir lucro. De acordo com o último relatório divulgado pela B3 em dezembro de 2021, 49% dos investidores nesse mercado no país, são estrangeiros, acompanhados das instituições financeiras e de investidores institucionais, sendo 27% e 18% respectivamente, os investidores pessoa física correspondem a 4% da participação no mercado.

Segundo a CVM (Comissão de Valores Imobiliários), no memorando 25/2020, o crescimento do número de investidores pessoa física no mercado de contrato futuro de taxa de câmbio de reais por dólar comercial, vem acompanhado o crescimento como um todo, segundo o memorando, em janeiro de 2018, registrava-se o número de 22 mil investidores, esse número cresceu para 45 mil em julho de 2019 e para 91 mil em março de 2020.

Após estudos bibliográficos, definição das regras de análise técnica, baseadas em indicadores a serem utilizadas como objeto de estudo e elaboração da metodologia a ser aplicada, foram desenvolvidos estudos e “scripts” no Software de programação “R”, de modo a importar os dados de negociação, criar e automatizar o sistema de negociação e por fim avaliar e mensurar risco-retorno e rendimento das estratégias criadas, estabelecendo-se como período de avaliação o ano de 2021. 

Abaixo estão listados os pacotes do Software "R", necessários para desenvolvimento e correto funcionamento do sistema de negociação desenvolvido:

('quantmod')

('Kinzel/mt5R')

('timeSeries')

('fPortfolio')

('tidyverse')

('usethis')

('Hmisc')

('corrplot')

('magrittr')

('TTR')

('xts')

('FinancialInstrument')

('braverock/blotter')

('PerformanceAnalytics')

('braverock/quantstrat')

('foreach')

### 2. Desenvolvimento do Script de Importação dos dados USD/BRL

O sistema de negociação como dito foi desenvolvido em um ambiente de programação “R” e foi baseado em regras de negociação utilizando-se dos indicadores, média móvel, preço de fechamento e RSI, aplicadas ao contrato futuro de taxa de câmbio de reais por dólar comercial.

Realizou-se a adaptação do pacote “R”, depositado no site Github.com denominado “mt5.R”. O pacote em questão fornece uma estrutura aos usuários do Metatrader5 na obtenção de dados para análise e desenvolvimento de sistemas automatizados de negociação, além de ferramentas direcionadas ao desenvolvimento de Machine Learning através de integração com conexão de “soquete”. A utilização de tal pacote possibilitou a comunicação entre “R”, B3 e a plataforma de negociação (Metatrader5).

Para utilização da ferramenta faz-se ainda necessário que o usuário tenha uma conta em uma corretora e que seja disponibilizada pela mesma, acesso a referida plataforma de negociação Metatrader5. A instalação do pacote é feita em dois passos sendo um no “R” e outro no Metatrader5, conforme passo a passo presente no site conforme link abaixo:

https://kinzel.github.io/mt5R/index.html

Após instalação e parametrização do pacote desenvolveu-se o “Script” abaixo, que permitiu a importação, tratamento dos dados históricos de negociação do contrato futuro de taxa de câmbio de reais por dólar comercial referente ao ano de 2021, bem como o cálculo e desenvolvimento das regras com base nos indicadores a serem utilizados nas estratégias elaboradas para desenvolvimento do estudo:

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

# Tratamento dos dados – Instalação de pacotes para elaboração das estratégias

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

```

A tabela, apresenta as 10 primeiras linhas de um total de 26.380 linhas do histórico de negociação no timeframe de 05 minutos, para o ano de 2021 referentes ao contrato futuro de taxa de câmbio de reais por dólar comercial:

![image](https://user-images.githubusercontent.com/104097497/165585552-67ffe9f4-d472-491a-bf0a-4ff68b32ac51.png)

A figura, representa o histórico de negociações do dólar, referente a primeira quinzena de janeiro de 2021, com a plotagem dos indicadores MACD e as médias móveis de 12 e 108 períodos, respectivamente:

![image](https://user-images.githubusercontent.com/104097497/165602285-b99402b2-9f35-42de-89ca-9c37f4fb3b67.png)


### 3. Desenvolvimento das Estratégias de Negociação

As Estratégias foram desenvolvidas utilizando-se de ferramentas específicas dos pacotes ('quantmod') e ("braverock/quantstrat"), os outros pacotes são necessários para auxílio e suporte na elaboração dos resultados e plotagem dos dados de risco/retorno.

A Palavara "Quantmod" significa "quadro de modelagem financeira quantitativa" e este pacote do "R" possui três funções principais:  baixar dados, gerar e plotar gráficos e  Calcular indicadores técnicos.

O "Quanstrat" ainda está em desenvolvimento, ele ainda não estão disponível no CRAN. Nesse contexto faz-se necessário instalar o pacote do github. Instala-se o pacote devtools primeiro. Em seguida, usa-se a função install_github para baixar o pacote e depois o carregar no sistema.

### 3.1 Estratégia - Média Móvel

É uma média dos preços de um determinado ativo em um determinado período de tempo. Ellis e Parbery (2005) destacou o uso de médias móveis para a geração de sinais de compra e venda como um mecanismo para identificar tendências de preços. Enquanto a média móvel de curto prazo é mais sensível às mudanças de preço, as médias móveis de longo prazo capturam tendências de médio e longo prazo. Os investidores nas bolsas de valores utilizam amplamente a análise técnica, e as médias móveis são os indicadores comumente usados porque são simples de entender e relativamente fáceis de usar.

O cálculo da média móvel pode ser representado pela expressão a seguir, onde “V” são os valores dos preços de fechamento e “n” é o intervalo de tempo selecionado:

MA: V1 + V2 + V3.... + Vn/n

A Estratégia baseada na Média Móvel, utilizou-se do pacote "Quanstrat", e consiste em comprar 1 contrato/minicontrato no cruzamento de 12 >26 e zerar posicão (vender) no cruzamento de 12 <26. A elaboração do "Script" passa pelas etapas discriminadas abaixo:

Etapa 1 - Configuração Inicial

É necessário instalar e carregar os pacotes padrão e pacotes personalizados.

```markdown

# Instalando e carregando Pacotes Necessários

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

```
Após Configurar os pacotes e necessário carregar os dados históricos de negociação:

```markdown

Chamar WorkSpace Dolar - "Dolar - Workspace 2021" - Arquivo R.Data

```
A moeda é USD para derivativos USD/BRL e o multiplicador é sempre 1 para ações:

```markdown

currency("USD")
stock(symbols, currency="USD", multiplier=1)

```

Define-se a estratégia portfólio e nome da conta:

```markdown

strategy.st <- "filter"
portfolio.st <- "filter"
account.st <- "filter"

```

Remove-se quaisquer variáveis antigas:

```markdown

strategy.st <- "filter"
portfolio.st <- "filter"
account.st <- "filter"

```

Faz-se a inicialização de estratégia, portfólio e conta:

```markdown

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

```

Etapa 2 - Definição de Indicador

O indicador é apenas uma função baseada no preço. Agora se adiciona dois indicadores: SMA12 e SMA72. Para a função SMA, precisamos informar o vetor de preços e o número de períodos:

```markdown

add.indicator(
  strategy.st, name="SMA",
  arguments=list(x=quote(Cl(mktdata)), n=72),
  label="sma72")

add.indicator(
  strategy.st, name="SMA",
  arguments=list(x=quote(Cl(mktdata)), n=12),
  label="sma12")

```

Etapa 3 - Adição de Sinais

Os sinais de negociação são gerados a partir dos indicadores de negociação. Por exemplo, uma regra de negociação simples determina que há um sinal de compra quando o filtro excede determinado limite.
No quantstrat, existem três maneiras de usar um sinal. É referido como nome :

sigThreshold: mais ou menos que um valor fixo

sigCrossover: quando dois sinais se cruzam

sigComparsion: compara dois sinais

A coluna refere-se aos dados para cálculo do sinal. Existem cinco relações possíveis :

gt = maior que

gte = maior ou igual a

lt = menor que

lte = menor ou igual a

eq = igual a

O sinal de compra aparece quando SMA12 é maior que SMA72. Os sinais de venda aparecem quando SMA12 é menor que SMA72.

Aqui, vamos fazer o cruzamento de sinais para que definamos o nome como sigCrossover. Vamos cruzar dois sinais: sma12 e sma72. Então a relação é maior do que para comprar e menor do que para menos. Chamamos o primeiro de sinal de compra e o último de sinal de venda:

```markdown

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

```

Etapa 4 - Adição de regras

Enquanto os sinais de negociação nos dizem comprar ou vender, mas não especifica os detalhes da execução.

As regras de negociação especificarão os sete elementos a seguir:

SigCol: Nome do Sinal

SigVal: implementa quando há sinal (ou reverso)

Tipo de pedido: mercado, limite de parada

Lado do pedido: longo, curto

Método de preço: mercado

Substituir: Deve-se substituir outros

Tipo: entrar ou sair do pedido

A regra de compra especifica que, quando um sinal de compra aparecer, coloque uma ordem de mercado de compra com o tamanho da quantidade.

```markdown

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

```

A regra de venda especifica que, quando um sinal de venda aparecer, coloque uma ordem de mercado de venda com o tamanho da quantidade.

```markdown

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

```

Etapa 5 - Resultados e Avaliação

Aplica-se a estratégia de negociação e posteriormente a atualização da carteira, conta e patrimônio.

```markdown

#Avaliacao - visualizacao de negociacoes
out<-try(applyStrategy(strategy.st, 
                       portfolios=portfolio.st))
                       
```                       
   
```markdown

[1] "2021-01-06 13:20:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5265"
[1] "2021-01-06 18:10:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5281.5"
[1] "2021-01-06 21:10:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5310"
[1] "2021-01-08 12:20:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5373.5"
[1] "2021-01-08 15:30:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5406.5"
[1] "2021-01-11 17:30:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5488.5"
[1] "2021-01-11 20:10:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5504.5"
[1] "2021-01-12 12:25:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5472.5"
[1] "2021-01-13 15:15:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5302"
[1] "2021-01-13 15:40:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5332"
[1] "2021-01-13 20:45:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5311.5"
[1] "2021-01-14 12:10:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5279.5"
[1] "2021-01-15 12:20:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5242"
[1] "2021-01-15 17:05:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5262.5"
[1] "2021-01-15 17:45:00 DOLAR_2021_QUINZENA01_MES01 1 @ 5268"
[1] "2021-01-15 21:25:00 DOLAR_2021_QUINZENA01_MES01 -1 @ 5293,5"

``` 

```markdown
         
#Atualizacao de Contas
updatePortf(portfolio.st)
updateAcct(portfolio.st)
updateEndEq(account.st)

```
Apos aplicação das estratégias de negociação é possível "plotar" os resultados obtidos:

```markdown

#Tracar posicoes de mercado
for(symbol in symbols) {
  chart.Posn(Portfolio=portfolio.st,
             Symbol=symbol,log=TRUE)
}

```

![image](https://user-images.githubusercontent.com/104097497/165992597-55b6bceb-ad86-4d1a-8981-c8f8504bdfcf.png)

```markdown

#Estatisticas de negociacao
tstats <- tradeStats(portfolio.st)
t(tstats) #transpose tstats

```

```markdown
                  DOLAR_2021_QUINZENA01_MES01  
Portfolio          "SMA"                        
Symbol             "DOLAR_2021_QUINZENA01_MES01"
Num.Txns           "15"                         
Num.Trades         "7"                          
Net.Trading.PL     "174"                        
Avg.Trade.PL       "21.21429"                   
Med.Trade.PL       "20.5"                       
Largest.Winner     "82"                         
Largest.Loser      "-32"                        
Gross.Profits      "212.5"                      
Gross.Losses       "-64"                        
Std.Dev.Trade.PL   "43.2944"                    
Std.Err.Trade.PL   "16.36374"                   
Percent.Positive   "71.42857"                   
Percent.Negative   "28.57143"                   
Profit.Factor      "3.320312"                   
Avg.Win.Trade      "42.5"                       
Med.Win.Trade      "30"                         
Avg.Losing.Trade   "-32"                        
Med.Losing.Trade   "-32"                        
Avg.Daily.PL       "21.21429"                   
Med.Daily.PL       "20.5"                       
Std.Dev.Daily.PL   "43.2944"                    
Std.Err.Daily.PL   "16.36374"                   
Ann.Sharpe         "7.77852"                    
Max.Drawdown       "-79"                        
Profit.To.Max.Draw "2.202532"                   
Avg.WinLoss.Ratio  "1.328125"                   
Med.WinLoss.Ratio  "0.9375"                     
Max.Equity         "189"                        
Min.Equity         "-2"                         
End.Equity         "174"

```

```markdown

#Analise de Desempenho - Risco Retorno
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

```

```markdown

                        DOLAR_2021_QUINZENA01_MES01.DailyEqPL
Cumulative Return                                1.740071
Annualized Return                                4.394223
Annualized Sharpe Ratio                          7.250135
Calmar Ratio                                     1.830926

```

```markdown

#Plotagem de desempenho
charts.PerformanceSummary(rets, colorset = bluefocus)  

```

![image](https://user-images.githubusercontent.com/104097497/165993734-3bed5f16-7c66-4e84-bf80-8d5b783eebde.png)

### 3.2 Estratégia - Preço de Fechamento

Nesta estratégia, a regra “filtro simples” será pautada na comparação dos preços de fechamento em cada dia. A estratégia de filtro simples sugere comprar quando o preço aumenta muito em relação ao preço, por exemplo. Nessa estratégia o sinal é dado pela fórmula abaixo:

Comprar:Pt/Pt−1>1+β

Em que Pt corresponde ao preço de fechamento no período t, Pt−1 corresponde ao preço de fechamento no período t−1, isto é, imediatamente anterior e β corresponde ao sinal, ou seja, um escalar positivo β>0 e arbitrariamente definiremos na regra de negociação.

Nesse contexto a estratégia, neste exemplo consiste em comprar 01 contrato/mini-contrato quando o preço de abertura for maior que o fechamento do dia anterior e  zerar a posição (vender) no fechamento do dia.

 Etapa 1: Configuração Inicial
 
 Primeiramente faz-se necessário, instalar e "chamar" os pacotes necessários:

```markdown

# Instalando e carregando Pacotes Necessários

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

```
Após Configurar os pacotes e necessário carregar os dados históricos de negociação:

```markdown

Chamar WorkSpace Dolar - "Dolar - Workspace 2021" - Arquivo R.Data

```

Etapa 2: Definição de Indicador e Adição de Sinais

Calcula-se a variação percentual do preço dividindo o preço de fechamento atual por seu próprio atraso e, em seguida, menos 1. Posteriormente gera-se o sinal de compra com base na regra do filtro:

```markdown

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

```

![image](https://user-images.githubusercontent.com/104097497/166741836-5a7eaf58-8cd4-44aa-83ea-0e03fdabf9a4.png)

É possivel plotar os sinais de compra no gráfico:

![image](https://user-images.githubusercontent.com/104097497/166742663-67323759-0ed3-4ac1-acf4-7a48b49fd5b3.png)

Etapa 3: Aplicação da Estratégia

A estratégia é aplicada utilizando-se dos comandos abaixo:

```markdown

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

```

Abaixo, plotagem das cinco primeiras linhas do cálculo de retorno:

```markdown

                    daily.returns
2021-01-04 21:25:00   0.032019465
2021-01-05 21:25:00  -0.001697473
2021-01-06 21:25:00   0.000000000
2021-01-07 21:25:00   0.017570234
2021-01-08 21:25:00   0.001754386

```

Etapa 4: Resultados e Avaliação

Os resultados da aplicação da estratégia são plotados utilizando-se dos comandos abaixo:

```markdown

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

```

Abaixo, plotagem do retorno acumulado utilizando-se da estratégia:

![image](https://user-images.githubusercontent.com/104097497/166749115-6b56ae7d-2541-4925-879b-00473bda51ec.png)


### 3.3 Estratégia - Indicador RSI

Contreras, et al. (2017), relata que o relative strength index (RSI), ou indicador RSI, ou ainda Índice de força relativa (IFR), está entre os indicadores mais utilizados na análise técnica (TA), sendo um  dos mais populares na busca de rastreabilidade de tendências. 

O indicador RSI foi desenvolvido por J. Welles Wilder Jr. em 1978 e conhecido por meio do livro “Novos conceitos em Sistemas de Negóciação Técnicos” (New Concepts in Technical Trading Systems), tendo como objetivo oferecer uma forma de se medir a força ou ímpeto de um mercado.

Ainda segundo Contreras, et al. (2017), o indicador é baseado no fator de resistência relativa (RS) de um determinado período que compara movimentos individuais para cima ou para baixo de preços de fechamento sucessivos. O indicador RSI possui oscilação entre 0 e 100.

Contreras, et al. (2017), relata em seus estudos a utilização do indicador  sob dois aspectos: Overbought (“Sobrecompra”) / oversold “Sobrevenda” (RSIO): Usa-se a faixa RSI (Geralmente 70 e 30) para identificar os níveis de sobrecompra e sobrevenda. Os valores RSI acima do nível de sobrecompra acionam um sinal de venda e os valores abaixo do nível de sobrevenda um sinal de compra. Quando o valor RSIO cai abaixo do nível de sobrecompra, um sinal de venda é gerado. Da mesma forma, um sinal de compra é gerado quando o indicador sobe acima da linha de sobrevenda. 

Picasso, et al. (2019), utiliza-se do indicador para elaborar seus estudos e apresenta o cálculo do indicador, onde “RS” representa a média de X períodos de alta dividido pela  média de X períodos de baixa:

RSI = 100 – 100/(1 + RS).

A regra "estratégia" com base no RSI, foi considerada com operacional day trading e RSI de 12 dias. A estratégia consiste em Compar 01 contrato/mini-contrato no comparativo RSI<30 e Zerar posição (vender) no fechamento do dia. Não haverá operação de RSI>30.

Etapa 1 - Configuração Inicial

Primeiramente faz-se necessário, instalar e "chamar" os pacotes necessários:

```markdown

# Instalando e carregando Pacotes Necessários

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

```
Após Configurar os pacotes e necessário carregar os dados históricos de negociação:

```markdown

Chamar WorkSpace Dolar - "Dolar - Workspace 2021" - Arquivo R.Data

```

Etapa 2 - Definição de Indicador e adição de sinais

```markdown

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

```

Etapa 3: Aplicação da Estratégia

A estratégia é aplicada utilizando-se dos comandos abaixo:

```markdown

# Construcao da variavel

ret <- dailyReturn(DOLAR_2021)*trade2
names(ret) <- 'RSI'

```

Etapa 4: Resultados e Avaliação

Os resultados da aplicação da estratégia são plotados utilizando-se dos comandos abaixo:

```markdown

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

```
Abaixo, plotagem do retorno acumulado utilizando-se da estratégia:

![image](https://user-images.githubusercontent.com/104097497/166813500-64c56571-e4fa-495e-8358-dde8a7d6208c.png)


### 4 Desenvolvedores

Juliano Eduardo da Silva (Juliano Itoo)

E-mail: jjuliano.essilva@gmail.com

Victor Eduardo de Mello Valério (Victor Valério)

E-mail: victor.dmv@unifei.edu.br
