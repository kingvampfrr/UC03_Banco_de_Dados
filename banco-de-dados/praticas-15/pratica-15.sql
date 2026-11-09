/* Prática 15 – Lanchonete – juntando as tabelas
   Salve este arquivo como pratica-15.sql antes de começar. */
USE lanchonete;

-- pergunta 1:
SELECT
    p.numero,
    c.nome
	FROM pedido p
	INNER JOIN cliente c
    ON c.codigo = p.cliente_codigo
	ORDER BY p.numero ASC;
-- pergunta 2:
SELECT
    p.numero,
    u.nome
	FROM pedido p
	INNER JOIN unidade u
    ON u.codigo = p.unidade_codigo
	WHERE u.nome = 'Ponta Verde'
	ORDER BY p.numero ASC;

-- pergunta 3:
SELECT
    p.data_hora,
    pr.nome,
    ip.quantidade
	FROM item_pedido ip
	INNER JOIN produto pr
    ON pr.codigo = ip.produto_codigo
	INNER JOIN pedido p
    ON p.numero = ip.pedido_numero
	WHERE p.numero = 4;

-- pergunta 4:
SELECT
    pr.nome,
    SUM(ip.quantidade) AS unidades_vendidas
	FROM item_pedido ip
	INNER JOIN produto pr
    ON pr.codigo = ip.produto_codigo
	GROUP BY pr.codigo, pr.nome
	ORDER BY unidades_vendidas DESC;

-- pergunta 5:
SELECT
    pr.nome
	FROM produto pr
	LEFT JOIN item_pedido ip
    ON ip.produto_codigo = pr.codigo
	WHERE ip.produto_codigo IS NULL;
-- pergunta 6:
SELECT
    c.nome
	FROM cliente c
	LEFT JOIN pedido p
    ON p.cliente_codigo = c.codigo
	WHERE p.cliente_codigo IS NULL;

-- pergunta 7:
SELECT
    nome,
    preco_tabela
	FROM produto
	WHERE preco_tabela > (
    SELECT AVG(preco_tabela)
    FROM produto
);

-- pergunta 8:

-- Primeira Consulta
SELECT
    u.codigo,
    u.nome,
    COUNT(p.numero) AS total_pedidos
	FROM unidade u
	LEFT JOIN pedido p
    ON p.unidade_codigo = u.codigo
	GROUP BY u.codigo, u.nome;
    
-- Segunda Consulta

SELECT
    AVG(t.total_pedidos) AS media_pedidos_por_unidade
FROM (
    SELECT
        u.codigo,
        u.nome,
        COUNT(p.numero) AS total_pedidos
    FROM unidade u
    LEFT JOIN pedido p
        ON p.unidade_codigo = u.codigo
    GROUP BY u.codigo, u.nome
) AS t;