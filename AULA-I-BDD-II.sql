CREATE DATABASE IF NOT EXISTS loja_roupas;

USE loja_roupas;

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,          -- Nome do cliente (não pode ser nulo)
    email VARCHAR(100) UNIQUE,           -- Email do cliente (deve ser único)
    telefone VARCHAR(20)                -- Telefone do cliente
);

-- Tabela de Produtos
CREATE TABLE IF NOT EXISTS produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,          -- Nome do produto (não pode ser nulo)
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0), -- Preço do produto (não pode ser nulo e deve ser não negativo)
    estoque INT NOT NULL CHECK (estoque >= 0) -- Quantidade em estoque (não pode ser nulo e deve ser não negativo)
);

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,             -- ID do cliente que fez o pedido (não pode ser nulo)
    data_pedido DATE NOT NULL,           -- Data em que o pedido foi feito (não pode ser nulo)
    FOREIGN KEY (cliente_id) REFERENCES clientes (id) -- Chave estrangeira referenciando a tabela 'clientes'
);

-- Tabela de Itens do Pedido (detalhes de cada produto dentro de um pedido)
CREATE TABLE IF NOT EXISTS itens_pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,              -- ID do pedido (não pode ser nulo)
    produto_id INT NOT NULL,             -- ID do produto (não pode ser nulo)
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade do produto no pedido (não pode ser nulo e deve ser maior que zero)
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id), -- Chave estrangeira referenciando a tabela 'pedidos'
    FOREIGN KEY (produto_id) REFERENCES produtos(id), -- Chave estrangeira referenciando a tabela 'produtos'
    UNIQUE (pedido_id, produto_id)       -- Garante que um produto seja adicionado apenas uma vez por pedido
);

-- Tabela de Pagamentos
CREATE TABLE IF NOT EXISTS pagamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,              -- ID do pedido ao qual o pagamento se refere (não pode ser nulo)
    valor DECIMAL(10,2) NOT NULL CHECK (valor >= 0), -- Valor do pagamento (não pode ser nulo e deve ser não negativo)
    data_pagamento DATE NOT NULL,        -- Data em que o pagamento foi realizado (não pode ser nulo)
    FOREIGN KEY (pedido_id) REFERENCES pedidos (id) -- Chave estrangeira referenciando a tabela 'pedidos'
); 

-- Inserindo dados na tabela 'clientes'
INSERT INTO clientes (nome, email, telefone) VALUES
('Ana Souza', 'ana@gmail.com', '8877773331'),
('Carlos Lima', 'carlos@gmail.com', '222333331');

-- Inserindo dados na tabela 'produtos'
INSERT INTO produtos (nome, preco, estoque) VALUES
('Blusa', 200.00, 8),
('Calça', 350.00, 15);

-- Inserindo dados na tabela 'pedidos'
INSERT INTO pedidos (cliente_id, data_pedido) VALUES
(1, '2025-06-01'), -- Ana Souza fez um pedido em 1 de junho de 2025
(2, '2025-06-02'); -- Carlos Lima fez um pedido em 2 de junho de 2025

-- Inserindo dados na tabela 'itens_pedidos'
-- Estes itens são baseados nos pedidos e produtos inseridos acima
INSERT INTO itens_pedidos (pedido_id, produto_id, quantidade) VALUES
(1, 1, 2), -- Pedido 1 (Ana): 2 Blusas
(1, 2, 1), -- Pedido 1 (Ana): 1 Calça
(2, 2, 1); -- Pedido 2 (Carlos): 1 Calça

-- Inserindo dados na tabela 'pagamentos'
-- Os valores são calculados com base nos itens dos pedidos (2 Blusas * 200 + 1 Calça * 350 = 400 + 350 = 750 para o pedido 1)
INSERT INTO pagamentos (pedido_id, valor, data_pagamento) VALUES
(1, 750.00, '2025-06-01'), -- Pagamento do Pedido 1
(2, 350.00, '2025-06-02'); -- Pagamento do Pedido 2

SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedidos;
SELECT * FROM pagamentos;

DELIMITER // -- Altera o delimitador para permitir o uso de ';' dentro do procedimento

CREATE PROCEDURE criar_pedido(
    IN p_cliente_id INT,        -- Parâmetro para o ID do cliente
    IN p_data_pedido DATE       -- Parâmetro para a data do pedido
)
BEGIN
    -- Insere um novo pedido na tabela 'pedidos'
    INSERT INTO pedidos (cliente_id, data_pedido)
    VALUES (p_cliente_id, p_data_pedido);
END //

DELIMITER ; -- Volta o delimitador para ';'