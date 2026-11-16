/* SA2 - Implementação e manipulação do banco de embalagens
   Aluno(a): Ryan Matheus Dos Santos Lima
   Antes: execute o embalagens-base-sa2.sql. */
USE embalagens;

-- ETAPA 1: dados de teste (INSERT e UPDATE)
INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo)
VALUES
('2026-11-03', 5000, 4800, 200, 60, 1, 1),
('2026-11-03', 5000, 4950, 50, 25, 1, 2),
('2026-11-03', 8000, 7650, 350, 160, 2, 3),
('2026-11-03', 3000, 2880, 120, 18, 3, 2),
('2026-11-03', 4000, 3900, 100, 48, 1, 1);

INSERT INTO expedicao (data_saida, unidade_codigo, cliente_cnpj)
VALUES
('2026-11-06', 1 , '11.111.111/0001-11'),
('2026-11-06', 2 , '22.222.222/0001-22');

INSERT INTO item_expedicao (expedicao_numero, produto_codigo, quantidade, preco_cobrado)
VALUES
(p_expedicao, p_produto, p_quantidade, v_preco);

UPDATE produto SET preco_tabela = 0.48
WHERE codigo = 1;

-- ETAPA 2: consultas 1 a 5
-- consulta 1
SELECT * FROM ordem_producao
WHERE qtd_refugo > 100
ORDER BY qtd_refugo DESC;

-- consulta 2
SELECT produto_codigo, SUM(qtd_refugo) AS total_refugo
FROM ordem_producao
GROUP BY produto_codigo
ORDER BY total_refugo DESC;
 
 -- consulta 3
 SELECT unidade_codigo, SUM(qtd_boa) AS total_boas
 FROM ordem_producao
 GROUP BY unidade_codigo
 HAVING SUM(qtd_boa) > 5000;
 
 -- consulta 4
 SELECT cliente.razao_social, expedicao.unidade_codigo, item_expedicao.produto_codigo, item_expedicao.quantidade, item_expedicao.quantidade * item_expedicao.preco_cobrado AS valor 
 FROM expedicao
 JOIN cliente ON expedicao.cliente_cnpj = cliente.cnpj
 JOIN item_expedicao ON expedicao.numero = item_expedicao.expedicao_numero;
 
 -- consulta 5
 SELECT * FROM cliente
 WHERE cnpj NOT IN (
 SELECT cliente_cnpj
 FROM expedicao
 );
-- ETAPA 3: view, procedure e trigger
CREATE VIEW vw_refugo_produto AS
SELECT produto_codigo, SUM(qtd_refugo) AS total_refugo
FROM ordem_producao
GROUP BY produto_codigo;

DELIMITER $$

CREATE PROCEDURE sp_registrar_item(
IN p_expedicao INT,
IN p_produto INT,
IN p_quantidade INT
)
BEGIN
DECLARE v_preco DECIMAL(8,2);
SELECT preco_tabela INTO v_preco
FROM produto
WHERE codigo = p_produto;

INSERT INTO item_expedicao
VALUES (p_expedicao, p_produto, p_quantidade, v_preco);

END $$
DELIMITER ;

CALL sp_registrar_item(2, 4, 5000);

SELECT * FROM item_expedicao
WHERE expedicao_numero = 2
AND produto_codigo = 4;

DELIMITER $$

CREATE TRIGGER tg_ordem_baixa_resina
AFTER INSERT ON ordem_producao
FOR EACH ROW
BEGIN
UPDATE estoque_resina
SET quantidade_kg = quantidade_kg - NEW.consumo_kg
WHERE unidade_codigo = NEW.unidade_codigo 
AND resina_codigo = (
SELECT resina_codigo
FROM produto
WHERE codigo = NEW.produto_codigo
);
END $$
DELIMITER ;

INSERT INTO ordem_producao (data_ordem, qtd_planejada, qtd_boa, qtd_refugo, consumo_kg, unidade_codigo, produto_codigo)
VALUES
('2026-11-09', 1000, 950, 50, 20, 2, 3);

SELECT quantidade_kg
FROM estoque_resina
WHERE unidade_codigo = 2
AND resina_codigo = 3;
-- ETAPA 4: privilégios dos perfis e SHOW GRANTS
-- Permissões do operador: ordens de produção
GRANT SELECT, INSERT ON embalagens.ordem_producao TO 'emb_operador'@'localhost';
-- Permissões do operador: leitura de produtos
GRANT SELECT ON embalagens.produto TO 'emb_operador'@'localhost';

-- Permissões do gerente: leitura de todo o banco
GRANT SELECT ON embalagens.* TO 'emb_gerente'@'localhost'
-- Permissão do gerente: alterar produtos 
GRANT UPDATE ON embalagens.produto TO 'emb_gerente'@'localhost';
-- Mostrar permissões do operador:
SHOW GRANTS FOR 'emb_operador'@'localhost';
-- Mostrar permissões do gerente:
SHOW GRANTS FOR 'emb_gerente'@'localhost';
 
-- Contar as linhas da tabela:
SELECT COUNT(*) FROM embalagens.ordem_producao;
SELECT COUNT(*) FROM embalagens.item_expedicao;
SELECT COUNT(*) FROM embalagens.produto;

DROP DATABASE embalagens;
CREATE DATABASE embalagens;

SELECT COUNT(*) FROM embalagens.ordem_producao;
SELECT COUNT(*) FROM embalagens.item_expedicao;


SELECT * FROM embalagens.vw_refugo_produto;
