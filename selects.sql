-- Relatório 1: Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31 
SELECT 
    e.nome AS Nome_Empregado,
    e.cpf AS CPF_Empregado,
    e.dataAdm AS Data_Admissao,
    e.salario AS Salario,
    d.nome AS Departamento,
    t.numero AS Numero_Telefone
FROM 
    Empregado e
JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
LEFT JOIN 
    Telefone t ON e.cpf = t.Empregado_cpf
WHERE 
    e.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
ORDER BY 
    e.dataAdm DESC;

-- Relatório 2: Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop
SELECT 
    e.nome AS Nome_Empregado,
    e.cpf AS CPF_Empregado,
    e.dataAdm AS Data_Admissao,
    e.salario AS Salario,
    d.nome AS Departamento,
    t.numero AS Numero_Telefone
FROM 
    Empregado e
JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
LEFT JOIN 
    Telefone t ON e.cpf = t.Empregado_cpf
WHERE 
    e.salario < (SELECT AVG(salario) FROM Empregado)
ORDER BY 
    e.nome;
    
-- Relatório 3: Lista dos departamentos com a quantidade de empregados total por cada departamento, 
-- média salarial e média de comissão
    
    SELECT 
    d.nome AS Departamento,
    COUNT(e.cpf) AS Quantidade_Empregados,
    AVG(e.salario) AS Media_Salarial,
    AVG(e.comissao) AS Media_Comissao
FROM 
    Departamento d
LEFT JOIN 
    Empregado e ON d.idDepartamento = e.Departamento_idDepartamento
GROUP BY 
    d.nome
ORDER BY 
    d.nome;
    
-- Relatório 4: Lista dos empregados com a quantidade total de vendas, valor total vendido e 
-- comissão das vendas
SELECT 
    e.nome AS Nome_Empregado,
    e.cpf AS CPF_Empregado,
    e.sexo AS Sexo,
    e.salario AS Salario,
    COUNT(v.idVenda) AS Quantidade_Vendas,
    SUM(v.valor) AS Total_Valor_Vendido,
    SUM(v.valor * e.comissao / 100) AS Total_Comissao_Vendas
FROM 
    Empregado e
LEFT JOIN 
    Venda v ON e.cpf = v.Empregado_cpf
GROUP BY 
    e.nome, e.cpf, e.sexo, e.salario
ORDER BY 
    Quantidade_Vendas DESC;
    
-- Relatório 5: Lista dos empregados que prestaram serviço nas vendas com total de 
-- vendas com serviço e comissão
SELECT 
    e.nome AS Nome_Empregado,
    e.cpf AS CPF_Empregado,
    e.sexo AS Sexo,
    e.salario AS Salario,
    COUNT(iserv.Venda_idVenda) AS Quantidade_Vendas_com_Servico,
    SUM(iserv.valor) AS Total_Valor_Vendido_com_Servico,
    SUM(iserv.valor * e.comissao / 100) AS Total_Comissao_Vendas_com_Servico
FROM 
    Empregado e
JOIN 
    ItensServico iserv ON e.cpf = iserv.Empregado_cpf
GROUP BY 
    e.nome, e.cpf, e.sexo, e.salario
ORDER BY 
    Quantidade_Vendas_com_Servico DESC;
    
-- Relatório 6: Lista dos serviços já realizados para um pet, com dados detalhados do serviço.
SELECT 
    p.nome AS Nome_Pet,
    v.data AS Data_Servico,
    s.nome AS Nome_Servico,
    iserv.quantidade AS Quantidade,
    iserv.valor AS Valor,
    e.nome AS Empregado_Que_Realizou
FROM 
    PET p
JOIN 
    ItensServico iserv ON p.idPET = iserv.PET_idPET
JOIN 
    Servico s ON iserv.Servico_idServico = s.idServico
JOIN 
    Empregado e ON iserv.Empregado_cpf = e.cpf
JOIN 
    Venda v ON iserv.Venda_idVenda = v.idVenda
ORDER BY 
    v.data DESC;
    
-- Relatório 7: Lista das vendas realizadas para um cliente, com detalhes da venda.
SELECT 
    c.nome AS Nome_Cliente,
    v.data AS Data_Venda,
    v.valor AS Valor,
    v.desconto AS Desconto,
    (v.valor - v.desconto) AS Valor_Final,
    e.nome AS Empregado_Que_Realizou
FROM 
    Venda v
JOIN 
    Cliente c ON v.Cliente_cpf = c.cpf
JOIN 
    Empregado e ON v.Empregado_cpf = e.cpf
ORDER BY 
    v.data DESC;
    
-- Relatório 8:  Lista dos 10 serviços mais vendidos, com quantidade de vendas e valor total.
SELECT 
    s.nome AS Nome_Servico,
    COUNT(iserv.Venda_idVenda) AS Quantidade_Vendas,
    SUM(iserv.valor) AS Total_Valor_Vendido
FROM 
    Servico s
JOIN 
    ItensServico iserv ON s.idServico = iserv.Servico_idServico
GROUP BY 
    s.nome
ORDER BY 
    Quantidade_Vendas DESC
LIMIT 10;

-- Relatório 9:  Lista das formas de pagamento mais utilizadas nas vendas, com a quantidade 
-- de vendas e valor total.
SELECT 
    fpg.tipo AS Tipo_Forma_Pagamento,
    COUNT(v.idVenda) AS Quantidade_Vendas,
    SUM(v.valor) AS Total_Valor_Vendido
FROM 
    FormaPgVenda fpg
JOIN 
    Venda v ON fpg.idFormaPgVenda = v.FormaPgVenda_idFormaPgVenda
GROUP BY 
    fpg.tipo
ORDER BY 
    Quantidade_Vendas DESC;
    
-- Relatório 10: alanço das vendas, com soma dos valores vendidos por dia.
SELECT 
    v.data AS Data_Venda,
    COUNT(v.idVenda) AS Quantidade_Vendas,
    SUM(v.valor) AS Valor_Total_Venda
FROM 
    Venda v
GROUP BY 
    v.data
ORDER BY 
    v.data DESC;

-- Relatório 11: Lista dos produtos e seus fornecedores, com informações detalhadas do fornecedor.
SELECT 
    p.nome AS Nome_Produto,
    p.precoCusto AS Valor_Produto,
    p.categoria AS Categoria_Produto,
    f.nome AS Nome_Fornecedor,
    f.email AS Email_Fornecedor,
    t.numero AS Telefone_Fornecedor
FROM 
    Produtos p
JOIN 
    Fornecedor f ON p.Fornecedor_cpf_cnpj = f.cpf_cnpj
LEFT JOIN 
    Telefone t ON f.cpf_cnpj = t.Fornecedor_cpf_cnpj
ORDER BY 
    p.nome;
    
-- Relatório 12: Lista dos produtos mais vendidos, com quantidade total de vendas e valor total recebido.
SELECT 
    p.nome AS Nome_Produto,
    COUNT(ivp.Venda_idVenda) AS Quantidade_Total_Vendas,
    SUM(ivp.valor) AS Valor_Total_Recebido
FROM 
    Produtos p
JOIN 
    ItensVendaProd ivp ON p.idProduto = ivp.Produto_idProduto
GROUP BY 
    p.nome
ORDER BY 
    Quantidade_Total_Vendas DESC;


