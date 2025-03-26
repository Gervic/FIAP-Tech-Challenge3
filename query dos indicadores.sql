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



    ---- QUERY PADRÃO DE CONSULTA, PODEMOS ALTERAR PELOS RESULTADOS (CONSULTA MÉDIA E PERCENTUAL MÉDIA DE CADA CATEGORIA DE ACORDO COM A ANÁLISE DE ABERTURA GRUPO DE IDADE)

WITH VARIAVEL_STRING AS (
    SELECT 'Pessoas com alguma comorbidade e que testaram positivo em algum dos testes (mil pessoas)' AS NOME_INDI,
           'Grupos de Idade 2' as VAR_ABER1
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
SELECT  
    categoria_de_abertura_1,
    SUM(setembro) AS "SOMA_SETEMBRO",
    SUM(outubro) AS "SOMA_OUTUBRO",
    SUM(novembro) AS "SOMA_NOVEMBRO",
    -- Calcular a média por linha (usando SUM para cada coluna antes de dividir)
    (SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0 AS "MÉDIA",
    -- Calcular o percentual da média
    ROUND(((SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0) * 100.0 / (SELECT soma_total_media FROM total_med)) AS percentual_media
FROM 
    worspace.tb_pnad_covid_tech
WHERE 
    indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM VARIAVEL_STRING)
    AND categoria_de_abertura_1 NOT LIKE '%Tot%'
GROUP BY 
    categoria_de_abertura_1;




--------- QUERY PADRÃO DE CONSULTA, PODEMOS ALTERAR PELOS RESULTADOS (CONSULTA MÉDIA E PERCENTUAL MÉDIA DE CADA CATEGORIA DE ACORDO COM A ANÁLISE DE ABERTURA COR E RAÇA)-------------

WITH VARIAVEL_STRING AS (
    SELECT 'Pessoas com alguma comorbidade e que testaram positivo em algum dos testes (mil pessoas)' AS NOME_INDI,
           'Cor ou Raça' as VAR_ABER1
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
SELECT  
    categoria_de_abertura_1,
    SUM(setembro) AS "SOMA_SETEMBRO",
    SUM(outubro) AS "SOMA_OUTUBRO",
    SUM(novembro) AS "SOMA_NOVEMBRO",
    -- Calcular a média por linha (usando SUM para cada coluna antes de dividir)
    (SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0 AS "MÉDIA",
    -- Calcular o percentual da média
    ROUND(((SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0) * 100.0 / (SELECT soma_total_media FROM total_med)) AS percentual_media
FROM 
    worspace.tb_pnad_covid_tech
WHERE 
    indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM VARIAVEL_STRING)
    AND categoria_de_abertura_1 NOT LIKE '%Tot%'
GROUP BY 
    categoria_de_abertura_1;





-------- QUERY PADRÃO DE CONSULTA, PODEMOS ALTERAR PELOS RESULTADOS (CONSULTA MÉDIA E PERCENTUAL MÉDIA DE CADA CATEGORIA DE ACORDO COM A ANÁLISE DE ABERTURA NIVEL DE INSTRUÇÃO)-------------------

WITH VARIAVEL_STRING AS (
    SELECT 'Pessoas com alguma comorbidade e que testaram positivo em algum dos testes (mil pessoas)' AS NOME_INDI,
           'Nível de instrução' as VAR_ABER1
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
SELECT  
    categoria_de_abertura_1,
    SUM(setembro) AS "SOMA_SETEMBRO",
    SUM(outubro) AS "SOMA_OUTUBRO",
    SUM(novembro) AS "SOMA_NOVEMBRO",
    -- Calcular a média por linha (usando SUM para cada coluna antes de dividir)
    (SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0 AS "MÉDIA",
    -- Calcular o percentual da média
    ROUND(((SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0) * 100.0 / (SELECT soma_total_media FROM total_med)) AS percentual_media
FROM 
    worspace.tb_pnad_covid_tech
WHERE 
    indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM VARIAVEL_STRING)
    AND categoria_de_abertura_1 NOT LIKE '%Tot%'
GROUP BY 
    categoria_de_abertura_1;



---- QUERY PADRÃO DE CONSULTA, PODEMOS ALTERAR PELOS RESULTADOS (CONSULTA MÉDIA E PERCENTUAL MÉDIA DE CADA CATEGORIA DE ACORDO COM A ANÁLISE DE ABERTURA SEXO)

WITH VARIAVEL_STRING AS (
    SELECT 'Pessoas com alguma comorbidade e que testaram positivo em algum dos testes (mil pessoas)' AS NOME_INDI,
           'Sexo' as VAR_ABER1
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
SELECT  
    categoria_de_abertura_1,
    SUM(setembro) AS "SOMA_SETEMBRO",
    SUM(outubro) AS "SOMA_OUTUBRO",
    SUM(novembro) AS "SOMA_NOVEMBRO",
    -- Calcular a média por linha (usando SUM para cada coluna antes de dividir)
    (SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0 AS "MÉDIA",
    -- Calcular o percentual da média
    ROUND(((SUM(setembro) + SUM(outubro) + SUM(novembro)) / 3.0) * 100.0 / (SELECT soma_total_media FROM total_med)) AS percentual_media
FROM 
    worspace.tb_pnad_covid_tech
WHERE 
    indicador = (SELECT NOME_INDI FROM VARIAVEL_STRING)
    AND variavel_de_abertura_1 = (SELECT VAR_ABER1 FROM VARIAVEL_STRING)
    AND categoria_de_abertura_1 NOT LIKE '%Tot%'
GROUP BY 
    categoria_de_abertura_1;
