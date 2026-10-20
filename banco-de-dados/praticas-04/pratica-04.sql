-- Prática 04 - Verificando o ambiente do MySQL

-- 1. Criar o banco de dados
CREATE DATABASE IF NOT EXISTS aula04_ambiente
CHARACTER SET utf8mb4;

-- 2. Mostrar o banco da atividade
SHOW DATABASES LIKE 'aula04_ambiente';

-- 3. Selecionar e confirmar o banco ativo
USE aula04_ambiente;
SELECT DATABASE();

-- 4. Verificar a versão e a porta do servidor
SELECT VERSION();
SELECT @@port;

-- 5. Contagens das tabelas da Sakila
-- film: 1000
-- customer: 599
-- rental: 16044

SELECT COUNT(*) AS total_film FROM sakila.film;
SELECT COUNT(*) AS total_customer FROM sakila.customer;
SELECT COUNT(*) AS total_rental FROM sakila.rental;