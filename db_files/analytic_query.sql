-- Consultas Analíticas propostas
\c operadora;

-- Mostrar as 10 operadoras com maiores despesas no último trimestre em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR "
-- Último trimestre de 2024 (Outubro a Dezembro de 2024)
SELECT op.registro_ans, op.razao_social, SUM(df.vl_saldo_final - df.vl_saldo_inicial ) AS despesas_totais
FROM dados_financeiros df
JOIN operadoras op ON df.reg_ans = op.registro_ans
WHERE df.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
AND df.data >= DATE_TRUNC('quarter', '2024-12-31'::DATE)
GROUP BY op.registro_ans, op.razao_social
ORDER BY despesas_totais DESC
LIMIT 10;

-- Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
-- Último Ano (Janeiro a Dezembro de 2024)
SELECT op.registro_ans, op.razao_social, SUM(df.vl_saldo_final - df.vl_saldo_inicial ) AS despesas_totais
FROM dados_financeiros df
JOIN operadoras op ON df.reg_ans = op.registro_ans
WHERE df.descricao = 'EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR '
AND df.data >= DATE_TRUNC('year', '2024-12-31'::DATE)
GROUP BY op.registro_ans, op.razao_social
ORDER BY despesas_totais DESC
LIMIT 10;