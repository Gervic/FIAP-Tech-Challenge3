---- QUERY PADRÃO DE CONSULTA, PODEMOS ALTERAR PELOS RESULTADOS (CONSULTA DE INDICADORES PELAS MÉDIA POR UF)

WITH 
Populacao AS (
    SELECT distinct
        Indicador,
        abertura_territorial,
        sum(setembro) "setembro",
        sum(outubro) "outubro",
        sum(novembro) "novembro"
    FROM "worspace"."tb_pnad_covid_tech"
    WHERE indicador = 'População residente (mil pessoas)'
    GROUP BY 1,2
    ORDER BY 2
),

variaveis_de_pesquisa AS (
    SELECT 'Pessoas que fizeram algum teste para saber se estavam infectadas pelo Coronavírus e testaram positivo (mil pessoas) ' AS NOME_INDI,
           'Total' as abertura_territorial,
           'Sexo' as VAR_ABER1,
           'Total' as cat_de_abertura_1
),

VARIAVEL_STRING AS (
    SELECT 'Pessoas que fizeram algum teste para saber se estavam infectadas pelo Coronavírus e testaram positivo (mil pessoas) ' AS NOME_INDI,
           'Cor ou Raça' as VAR_ABER1
),

total_infectados AS (
    -- Calcular a soma total das médias de todas as linhas
    SELECT 
        indicador,
        abertura_territorial,
        sum(setembro) "setembro",
        sum(outubro) "outubro",
        sum(novembro) "novembro"
         
    FROM worspace.tb_pnad_covid_tech
    WHERE indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM variaveis_de_pesquisa)
    AND categoria_de_abertura_1  = (SELECT abertura_territorial FROM variaveis_de_pesquisa)
    GROUP BY indicador,abertura_territorial
    ORDER BY abertura_territorial desc
),

total_med AS (
    -- Calcular a soma total das médias de todas as linhas
    SELECT 
        SUM((setembro + outubro + novembro) / 3.0) AS soma_total_media
    FROM worspace.tb_pnad_covid_tech
    WHERE indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM VARIAVEL_STRING)
    AND categoria_de_abertura_1 NOT LIKE '%Tot%'
)
    -- Calcular a soma total das médias de todas as linhas
    SELECT 
        indicador,
        abertura_territorial,
        round( SUM((setembro + outubro + novembro) / 3.0),0) AS soma_total_media,
        ROUND(((SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0) * 100.0 / (SELECT soma_total_media FROM total_med)) AS percentual_media
        --total_infectados_estado/pop_do_estado as percentual_entre_infectados,
        
         --as percentual_da_pop_estado
         
    FROM worspace.tb_pnad_covid_tech
    WHERE indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM variaveis_de_pesquisa)
    AND categoria_de_abertura_1  = (SELECT abertura_territorial FROM variaveis_de_pesquisa)
    GROUP BY indicador,abertura_territorial
    --ORDER BY abertura_territorial