-- CREATE DATABASE Cookflow;
-- USE Cookflow;

-- 1. Criação das Tabelas

-- Tabela de usuários: Armazena informações de login e perfil.
CREATE TABLE usuarios (
    id_usuario      INT IDENTITY(1,1) PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    senha_hash      VARCHAR(255) NOT NULL,
    data_criacao    DATETIME2 DEFAULT GETDATE()
);

-- Tabela de categorias: Agrupa as receitas por tipo.
CREATE TABLE categorias (
    id_categoria    INT IDENTITY(1,1) PRIMARY KEY,
    nome            VARCHAR(50) UNIQUE NOT NULL
);

-- Tabela de receitas: Contém todos os detalhes de uma receita.
CREATE TABLE receitas (
    id_receita              INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario              INT NOT NULL,
    id_categoria            INT NOT NULL,
    titulo                  VARCHAR(150) NOT NULL,
    descricao               VARCHAR(MAX),
    url_imagem              VARCHAR(255),
    tempo_preparo_minutos   INT NOT NULL,
    dificuldade             VARCHAR(20) NOT NULL CHECK (dificuldade IN ('Fácil', 'Médio', 'Difícil')),
    instrucoes              VARCHAR(MAX) NOT NULL,
    data_criacao            DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE NO ACTION -- Equivalente a ON DELETE RESTRICT
);

-- Tabela de ingredientes: Lista de todos os ingredientes possíveis.
CREATE TABLE ingredientes (
    id_ingrediente  INT IDENTITY(1,1) PRIMARY KEY,
    nome            VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela associativa receitas_ingredientes: Conecta receitas a ingredientes, com quantidade e medida.
CREATE TABLE receitas_ingredientes (
    PRIMARY KEY (id_receita, id_ingrediente),
    id_receita      INT NOT NULL,
    id_ingrediente  INT NOT NULL,
    quantidade      DECIMAL(10, 2) NOT NULL,
    unidade_medida  VARCHAR(50) NOT NULL,

    FOREIGN KEY (id_receita) REFERENCES receitas(id_receita) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente) ON DELETE NO ACTION -- Equivalente a ON DELETE RESTRICT
);

-- Tabela de favoritos: Registra quais usuários favoritaram quais receitas.
CREATE TABLE favoritos (
    PRIMARY KEY (id_usuario, id_receita),
    id_usuario  INT NOT NULL,
    id_receita  INT NOT NULL,
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_receita) REFERENCES receitas(id_receita) ON DELETE NO ACTION
);

-- Tabela de avaliações: Armazena as notas (1 a 5 estrelas) dadas pelos usuários.
CREATE TABLE avaliacoes (
    UNIQUE (id_usuario, id_receita),
    id_avaliacao    INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario      INT NOT NULL,
    id_receita      INT NOT NULL,
    nota            DECIMAL(2, 1) NOT NULL CHECK (nota BETWEEN 1.0 AND 5.0),
    data_criacao    DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_receita) REFERENCES receitas(id_receita) ON DELETE NO ACTION
);

-- Tabela de comentários: Armazena os comentários textuais dos usuários nas receitas.
CREATE TABLE comentarios (
    id_comentario   INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario      INT NOT NULL,
    id_receita      INT NOT NULL,
    conteudo        VARCHAR(MAX) NOT NULL,
    data_criacao    DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_receita) REFERENCES receitas(id_receita) ON DELETE NO ACTION
);

-------------------------------------------------------------------------------------------------------------------
-- 2. Massa de Dados

INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Ana Silva', 'ana.silva@exemplo.com', 'a3b1c5d9e2f4g6h8i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7A8B9C0D1E2F3');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Bruno Mendes', 'bruno.mendes@exemplo.com', 'b4c2d6e0f3g5h7i9j1k0l2m4n6o8p0q9r1s3t5u7v9w1x3y5z7A9B1C3D5E7F9');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Carla Oliveira', 'carla.oliveira@exemplo.com', 'c5d3e7f1g4h6i8j0k9l1m3n5o7p9q1r0s2t4u6v8w0x2y4z6A8B0C2D4E6F8G0');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Daniel Rocha', 'daniel.rocha@exemplo.com', 'd6e4f8g2h5i7j9k0l8m2n4o6p8q0r9s1t3u5v7w9x1y3z5A7B9C1D3E5F7G9H1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Elisa Ferreira', 'elisa.ferreira@exemplo.com', 'e7f5g9h3i6j8k0l1m7n3o5p7q9r0s8t2u4v6w8x0y2z4A6B8C0D2E4F6G8H0I2');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Fábio Lima', 'fabio.lima@exemplo.com', 'f8g6h0i4j7k9l1m2n6o2p4q6r8s0t7u1v3w5x7y9z1A3B5C7D9E1F3G5H7I9J1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Giovana Santos', 'giovana.santos@exemplo.com', 'g9h7i1j5k8l0m2n3o5p1q3r5s7t9u0v6w2x4y6z8A0B2C4D6E8F0G2H4I6J8K0');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Heitor Costa', 'heitor.costa@exemplo.com', 'h0i8j2k6l9m1n3o4p6q2r4s6t8u0v9w5x3y5z7A9B1C3D5E7F9G1H3I5J7K9L1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Igor Almeida', 'igor.almeida@exemplo.com', 'i1j9k3l7m0n2o4p5q7r3s5t7u9v0w8x4y6z8A0B2C4D6E8F0G2H4I6J8K0L2M1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Júlia Pereira', 'julia.pereira@exemplo.com', 'j2k0l4m8n1o3p5q6r8s4t6u8v0w1x7y5z7A9B1C3D5E7F9G1H3I5J7K9L3M3N1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Kauã Souza', 'kaua.souza@exemplo.com', 'k3l1m5n9o2p4q6r7s9t5u7v9w0x2y8z6A8B0C2D4E6F8G0H2I4J6K8L4M4N2O1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Larissa Martins', 'larissa.martins@exemplo.com', 'l4m2n6o0p3q5r7s8t0u6v8w1x3y9z7A9B1C3D5E7F9G1H3I5J7K9L5M5N3O2P1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Marcelo Gomes', 'marcelo.gomes@exemplo.com', 'm5n3o7p1q4r6s8t9u1v7w0x4y0z8A0B2C4D6E8F0G2H4I6J8K0L6M6N4O3P2Q1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Natália Ribeiro', 'natalia.ribeiro@exemplo.com', 'n6o4p8q2r5s7t9u0v2w8x5y1z9A1B3C5D7E9F1G3H5I7J9K1L7M7N5O4P3Q2R1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Otávio Neves', 'otavio.neves@exemplo.com', 'o7p5q9r3s6t8u0v1w3x9y2z0A2B4C6D8E0F2G4H6I8J0K2L8M8N6O5P4Q3R2S1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Patrícia Alves', 'patricia.alves@exemplo.com', 'p8q6r0s4t7u9v1w2x4y0z1A3B5C7D9E1F3G5H7I9J1K3L9M9N7O6P5Q4R3S2T1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Quiteria Dias', 'quiteria.dias@exemplo.com', 'q9r7s1t5u8v0w2x3y5z2A4B6C8D0E2F4G6H8I0J2K4L0M0N8O7P6Q5R4S3T2U1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Rafael Barbosa', 'rafael.barbosa@exemplo.com', 'r0s8t2u6v9w1x3y4z6A5B7C9D1E3F5G7H9I1J3K5L1M1N9O8P7Q6R5S4T3U2V1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Sofia Fernandes', 'sofia.fernandes@exemplo.com', 's1t9u3v7w0x2y4z5A7B9C1D3E5F7G9H1I3J5K6L2M2N0O9P8Q7R6S5T4U3V2W1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Thiago Moreira', 'thiago.moreira@exemplo.com', 't2u0v4w8x1y3z5A6B8C0D2E4F6G8H0I2J4K7L3M3N1P0Q9R8S7T6U5V4W3X1Y1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Úrsula Nunes', 'ursula.nunes@exemplo.com', 'u3v1w5x9y2z4A6B7C9D1E3F5G7H9I1J3K8L4M4N2P1Q0R9S8T7U6V5W4X2Y2Z1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Victor Castro', 'victor.castro@exemplo.com', 'v4w2x6y0z3A5B7C8D0E2F4G6H8I0J2K9L5M5N3P2Q1R0S9T8U7V6W5X3Y3Z2A1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Wendel Correia', 'wendel.correia@exemplo.com', 'w5x3y7z1A4B6C8D9E1F3G5H7I9J1K0L6M6N4P3Q2R1S0T9U8V7W6X4Y4Z3A2B1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Xênia Pires', 'xenia.pires@exemplo.com', 'x6y4z8A2B5C7D9E0F2G4H6I8J0K1L7M7N5P4Q3R2S1T0U9V8W7X5Y5Z4A3B2C1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Yago Ribeiro', 'yago.ribeiro@exemplo.com', 'y7z5A9B3C6D8E0F1G3H5I7J9K2L8M8N6P5Q4R3S2T1U0V9W8X6Y6Z5A4B3C2D1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Zara Silva', 'zara.silva@exemplo.com', 'z8A6B0C4D7E9F1G2H4I6J8K3L9M9N7P6Q5R4S3T2U1V0W9X7Y7Z6A5B4C3D2E1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Alexandre Neto', 'alexandre.neto@exemplo.com', 'A9B7C1D5E8F0G2H3I5J7K4L0M0N8P7Q6R5S4T3U2V1W0X8Y8Z7A6B5C4D3E2F1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Beatriz Souza', 'beatriz.souza@exemplo.com', 'B0C8D2E6F9G1H3I4J6K5L1M1N9P8Q7R6S5T4U3V2W1X9Y9Z8A7B6C5D4E3F2G1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Cássio Lima', 'cassio.lima@exemplo.com', 'C1D9E3F7G0H2I4J5K6L2M2N0P9Q8R7S6T5U4V3W2X0Y0Z9A8B7C6D5E4F3G2H1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Denise Freitas', 'denise.freitas@exemplo.com', 'D2E0F4G8H1I3J5K6L7M3N1P0Q9R8S7T6U5V4W3X1Y1Z0A9B8C7D6E5F4G3H2I1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Eduardo Pinho', 'eduardo.pinho@exemplo.com', 'E3F1G5H9I2J4K6L7M8N2P1Q0R9S8T7U6V5W4X2Y2Z1A0B9C8D7E6F5G4H3I2J1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Fernanda Matos', 'fernanda.matos@exemplo.com', 'F4G2H6I0J3K5L7M8N9P2Q1R0S9T8U7V6W5X3Y3Z2A1B0C9D8E7F6G5H4I3J2K1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Gustavo Abreu', 'gustavo.abreu@exemplo.com', 'G5H3I7J1K4L6M8N9P0Q3R2S1T0U9V8W7X4Y4Z3A2B1C0D9E8F7G6H5I4J3K2L1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Heloísa Dantas', 'heloisa.dantas@exemplo.com', 'H6I4J8K2L5M7N9O0P1Q4R3S2T1U0V9W8X5Y5Z4A3B2C1D0E9F8G7H6I5J4K3L2M1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Ivan Toledo', 'ivan.toledo@exemplo.com', 'I7J5K9L3M6N8O0P1Q2R5S4T3U2V1W0X6Y6Z5A4B3C2D1E0F9G8H7I6J5K4L3M2N1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Jaqueline Viana', 'jaqueline.viana@exemplo.com', 'J8K6L0M4N7O9P1Q2R3S6T5U4V3W2X7Y7Z6A5B4C3D2E1F0G9H8I7J6K5L4M3N2O1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Kleber Mello', 'kleber.mello@exemplo.com', 'K9L7M1N5O8P0Q2R3S4T7U6V5W4X8Y8Z7A6B5C4D3E2F1G0H9I8J7K6L5M4N3O2P1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Lívia Ramos', 'livia.ramos@exemplo.com', 'L0M8N2O6P9Q1R3S4T5U8V7W6X9Y9Z8A7B6C5D4E3F2G1H0I9J8K7L6M5N4O3P2Q1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Mauro Brito', 'mauro.brito@exemplo.com', 'M1N9O3P7Q0R2S4T5U6V9W8X0Y0Z9A8B7C6D5E4F3G2H1I0J9K8L7M6N5O4P3Q2R1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Nicole Prado', 'nicole.prado@exemplo.com', 'N2O0P4Q8R1S3T5U6V7W0X1Y1Z0A9B8C7D6E5F4G3H2I1J0K9L8M7N6O5P4Q3R2S1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Oscar Coelho', 'oscar.coelho@exemplo.com', 'O3P1Q5R9S2T4U6V7W8X2Y2Z1A0B9C8D7E6F5G4H3I2J1K0L9M8N7O6P5Q4R3S2T1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Paula Lima', 'paula.lima@exemplo.com', 'P4Q2R6S0T3U5V7W8X9Y3Z2A1B0C9D8E7F6G5H4I3J2K1L0M9N8O7P6Q5R4S3T2U1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Quirino Rocha', 'quirino.rocha@exemplo.com', 'Q5R3S7T1U4V6W8X9Y0Z3A2B1C0D9E8F7G6H5I4J3K2L1M0N9O8P7Q6R5S4T3U2V1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Renata Sales', 'renata.sales@exemplo.com', 'R6S4T8U2V5W7X9Y0Z1A3B2C1D0E9F8G7H6I5J4K3L2M1N0O9P8Q7R6S5T4U3V2W1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Sérgio Cruz', 'sergio.cruz@exemplo.com', 'S7T5U9V3W6X8Y0Z1A2B4C3D2E1F0G9H8I7J6K5L4M3N2O1P0Q9R8S7T6U5V4W3X1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Tatiane Bueno', 'tatiane.bueno@exemplo.com', 'T8U6V0W4X7Y9Z1A2B3C5D4E3F2G1H0I9J8K7L6M5N4O3P2Q1R0S9T8U7V6W5X2Y1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Ubiratan Góes', 'ubiratan.goes@exemplo.com', 'U9V7W1X5Y8Z0A2B3C4D6E5F4G3H2I1J0K9L8M7N6O5P4Q3R2S1T0U9V8W7X3Y2Z1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Viviane Mota', 'viviane.mota@exemplo.com', 'V0W8X2Y6Z9A1B3C4D5E7F6G5H4I3J2K1L0M9N8O7P6Q5R4S3T2U1V0W9X4Y3Z2A1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Wilson Gomes', 'wilson.gomes@exemplo.com', 'W1X9Y3Z7A0B2C4D5E6F8G7H6I5J4K3L2M1N0O9P8Q7R6S5T4U3V2W1X5Y4Z3A2B1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Yasmin Lira', 'yasmin.lira@exemplo.com', 'Y3Z1A5B9C2D4E6F7G8H0I9J8K7L6M5N4O3P2Q1R0S9T8U7V6W5X7Y6Z5A4B3C2D1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Ziraldo Paiva', 'ziraldo.paiva@exemplo.com', 'Z4A2B6C0D3E5F7G8H9I1J0K9L8M7N6O5P4Q3R2S1T0U9V8W7X8Y7Z6A5B4C3D2E1');
INSERT INTO usuarios (nome, email, senha_hash) VALUES ('Amanda Rosa', 'amanda.rosa@exemplo.com', 'A5B3C7D1E4F6G8H9I0J2K1L0M9N8O7P6Q5R4S3T2U1V0W9X9Y8Z7A6B5C4D3E2F1');

INSERT INTO categorias (nome) VALUES ('Sobremesas');
INSERT INTO categorias (nome) VALUES ('Pratos Principais');
INSERT INTO categorias (nome) VALUES ('Aperitivos');
INSERT INTO categorias (nome) VALUES ('Saladas');
INSERT INTO categorias (nome) VALUES ('Sopas e Caldos');
INSERT INTO categorias (nome) VALUES ('Massas');
INSERT INTO categorias (nome) VALUES ('Carnes');
INSERT INTO categorias (nome) VALUES ('Aves');
INSERT INTO categorias (nome) VALUES ('Peixes e Frutos do Mar');
INSERT INTO categorias (nome) VALUES ('Vegetarianas');
INSERT INTO categorias (nome) VALUES ('Veganas');
INSERT INTO categorias (nome) VALUES ('Pães e Fermentados');
INSERT INTO categorias (nome) VALUES ('Bolos e Tortas');
INSERT INTO categorias (nome) VALUES ('Bebidas e Coquetéis');
INSERT INTO categorias (nome) VALUES ('Lanches Rápidos');
INSERT INTO categorias (nome) VALUES ('Café da Manhã');
INSERT INTO categorias (nome) VALUES ('Molhos e Temperos');
INSERT INTO categorias (nome) VALUES ('Comida Italiana');
INSERT INTO categorias (nome) VALUES ('Comida Japonesa');
INSERT INTO categorias (nome) VALUES ('Comida Mexicana');
INSERT INTO categorias (nome) VALUES ('Comida Brasileira');
INSERT INTO categorias (nome) VALUES ('Comida Tailandesa');
INSERT INTO categorias (nome) VALUES ('Comida Chinesa');
INSERT INTO categorias (nome) VALUES ('Comida Indiana');
INSERT INTO categorias (nome) VALUES ('Gourmet');
INSERT INTO categorias (nome) VALUES ('Low Carb');
INSERT INTO categorias (nome) VALUES ('Sem Glúten');
INSERT INTO categorias (nome) VALUES ('Sem Lactose');
INSERT INTO categorias (nome) VALUES ('Fitness');
INSERT INTO categorias (nome) VALUES ('Culinária Saudável');
INSERT INTO categorias (nome) VALUES ('Micro-ondas');
INSERT INTO categorias (nome) VALUES ('Air Fryer');
INSERT INTO categorias (nome) VALUES ('Churrasco');
INSERT INTO categorias (nome) VALUES ('Culinária Natalina');
INSERT INTO categorias (nome) VALUES ('Festas Juninas');
INSERT INTO categorias (nome) VALUES ('Receitas de Páscoa');
INSERT INTO categorias (nome) VALUES ('Comida Congelada (Preparação)');
INSERT INTO categorias (nome) VALUES ('Acompanhamentos');
INSERT INTO categorias (nome) VALUES ('Risotos');
INSERT INTO categorias (nome) VALUES ('Pizzas e Calzones');
INSERT INTO categorias (nome) VALUES ('Refeição em 30 Minutos');
INSERT INTO categorias (nome) VALUES ('Para Crianças');
INSERT INTO categorias (nome) VALUES ('Comida Alemã');
INSERT INTO categorias (nome) VALUES ('Comida Mediterrânea');
INSERT INTO categorias (nome) VALUES ('Cozinha Clássica');
INSERT INTO categorias (nome) VALUES ('Drinks Sem Álcool');
INSERT INTO categorias (nome) VALUES ('Geografia Culinária');
INSERT INTO categorias (nome) VALUES ('Marmitas');
INSERT INTO categorias (nome) VALUES ('Conservas e Geleias');
INSERT INTO categorias (nome) VALUES ('Receitas de Inverno');

INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (1, 12, 'Pão Caseiro Rústico', 'Um pão artesanal com casca crocante e miolo macio.', 'url_pao_rustico.jpg', 180, 'Médio', 'Misture os ingredientes, sove por 10 minutos, deixe crescer por 2 horas, asse em forno pré-aquecido.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (2, 6, 'Lasanha à Bolonhesa Clássica', 'Camadas de massa, molho de carne e muito queijo.', 'url_lasanha_bolonhesa.jpg', 90, 'Médio', 'Prepare o molho bolonhesa. Monte as camadas. Leve ao forno por 40 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (3, 1, 'Mousse de Maracujá Cremoso', 'Uma sobremesa leve e azedinha, perfeita para o verão.', 'url_mousse_maracuja.jpg', 15, 'Fácil', 'Bata o leite condensado, creme de leite e suco de maracujá no liquidificador. Leve à geladeira por 3 horas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (4, 4, 'Salada Caesar com Frango Grelhado', 'Clássica salada com molho caseiro e crôutons.', 'url_salada_caesar.jpg', 25, 'Fácil', 'Prepare o molho. Grelhe o frango. Misture a alface, frango e crôutons com o molho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (5, 5, 'Sopa de Legumes da Vovó', 'Rica em nutrientes e perfeita para dias frios.', 'url_sopa_legumes.jpg', 50, 'Fácil', 'Cozinhe os legumes picados em caldo de galinha. Tempere a gosto e sirva quente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (6, 7, 'Bife Wellington Tradicional', 'Filé mignon envolto em massa folhada e cogumelos.', 'url_bife_wellington.jpg', 120, 'Difícil', 'Selle o filé. Cubra com duxelles de cogumelos e massa folhada. Asse até dourar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (7, 8, 'Frango Xadrez Chinês', 'Um clássico agridoce com pimentões e amendoim.', 'url_frango_xadrez.jpg', 40, 'Médio', 'Corte e frite o frango. Refogue os vegetais. Adicione o molho e o amendoim.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (8, 9, 'Salmão Grelhado com Molho de Maracujá', 'Prato sofisticado e leve, com toque tropical.', 'url_salmao_maracuja.jpg', 30, 'Médio', 'Grelhe o salmão. Prepare o molho. Sirva o peixe regado com o molho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (9, 10, 'Feijoada Vegana Completa', 'Substituição da carne por legumes defumados e cogumelos.', 'url_feijoada_vegana.jpg', 150, 'Difícil', 'Cozinhe os feijões e os substitutos da carne. Tempere e cozinhe lentamente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (10, 11, 'Hambúrguer de Grão de Bico', 'Opção de hambúrguer sem carne, muito saborosa.', 'url_hamburguer_grao_bico.jpg', 45, 'Fácil', 'Amasse o grão de bico com temperos. Modele os hambúrgueres. Frite ou asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (11, 13, 'Bolo de Cenoura com Cobertura de Chocolate', 'Um clássico irresistível e fofinho.', 'url_bolo_cenoura.jpg', 70, 'Médio', 'Bata a massa. Asse o bolo. Prepare a cobertura e despeje sobre o bolo quente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (12, 14, 'Mojito Refrescante', 'Drink cubano clássico com rum, hortelã e limão.', 'url_mojito.jpg', 10, 'Fácil', 'Macerar o hortelã e o limão. Adicionar rum, açúcar e água com gás. Sirva com gelo.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (13, 15, 'Wrap de Frango com Cream Cheese', 'Lanche rápido e prático para o dia a dia.', 'url_wrap_frango.jpg', 20, 'Fácil', 'Cozinhe e desfie o frango. Misture com cream cheese. Enrole na tortilha com alface.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (14, 16, 'Omelete de Legumes Coloridos', 'Opção nutritiva para começar o dia.', 'url_omelete_legumes.jpg', 15, 'Fácil', 'Bata os ovos. Refogue os legumes. Misture e frite em uma frigideira.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (15, 17, 'Molho Pesto Genovês Caseiro', 'Molho aromático feito com manjericão fresco e pinoli.', 'url_molho_pesto.jpg', 10, 'Fácil', 'Bata no processador manjericão, azeite, alho, pinoli e queijo parmesão.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (16, 18, 'Spaghetti Aglio e Olio', 'Clássico italiano rápido com alho e azeite.', 'url_aglio_e_olio.jpg', 20, 'Fácil', 'Cozinhe o spaghetti. Refogue o alho e pimenta no azeite. Misture a massa.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (17, 19, 'Sushi Nigiri de Salmão', 'Peça simples de sushi com arroz e salmão.', 'url_nigiri_salmao.jpg', 45, 'Difícil', 'Prepare o arroz de sushi. Fatie o salmão. Modele e monte o nigiri.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (18, 20, 'Guacamole Autêntico', 'Dip mexicano feito de abacate, tomate e pimenta.', 'url_guacamole.jpg', 10, 'Fácil', 'Amasse o abacate. Misture com limão, coentro, cebola e tomate picados. Tempere.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (19, 21, 'Moqueca Baiana de Camarão', 'Prato brasileiro com azeite de dendê e leite de coco.', 'url_moqueca_camarao.jpg', 60, 'Médio', 'Refogue os temperos, adicione camarão, leite de coco e dendê. Cozinhe lentamente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (20, 22, 'Pad Thai Clássico', 'Macarrão de arroz tailandês com camarões, tofu e amendoim.', 'url_pad_thai.jpg', 35, 'Médio', 'Prepare o macarrão. Frite os ingredientes. Misture com o molho Pad Thai.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (21, 23, 'Rolinho Primavera Chinês', 'Entrada crocante recheada com legumes e carne.', 'url_rolinho_primavera.jpg', 40, 'Difícil', 'Prepare o recheio. Enrole na massa. Frite em óleo quente até dourar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (22, 24, 'Curry de Frango Indiano', 'Curry cremoso e aromático, servido com arroz basmati.', 'url_curry_frango.jpg', 55, 'Médio', 'Refogue cebola e especiarias. Adicione o frango e leite de coco. Cozinhe.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (23, 25, 'Tiramisu Desconstruído', 'Sobremesa gourmet com todos os sabores do clássico.', 'url_tiramisu_desconstruido.jpg', 30, 'Médio', 'Prepare o creme de mascarpone. Molhe o biscoito. Monte em camadas ou taças.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (24, 26, 'Sopa de Abóbora Low Carb', 'Creme de abóbora com gengibre, sem adição de açúcar.', 'url_sopa_lowcarb.jpg', 40, 'Fácil', 'Cozinhe a abóbora. Bata com caldo de legumes e gengibre. Sirva com sementes.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (25, 27, 'Bolo de Chocolate Sem Glúten', 'Bolo fofo feito com farinha de arroz e amido de milho.', 'url_bolo_sem_gluten.jpg', 60, 'Médio', 'Misture os ingredientes secos e molhados separadamente. Asse em forno médio.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (26, 28, 'Panqueca de Banana Sem Lactose', 'Panquecas leves feitas com farinha integral e leite vegetal.', 'url_panqueca_sem_lactose.jpg', 20, 'Fácil', 'Bata os ingredientes. Despeje a massa em uma frigideira. Doure os dois lados.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (27, 29, 'Omelete de Claras Fitness', 'Omelete proteico com espinafre e queijo cottage.', 'url_omelete_fitness.jpg', 15, 'Fácil', 'Bata as claras. Misture o espinafre e cottage. Frite em azeite até firmar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (28, 30, 'Bowl de Açaí com Granola Caseira', 'Opção super saudável e refrescante para o verão.', 'url_acai_bowl.jpg', 10, 'Fácil', 'Bata o açaí congelado com banana. Sirva em uma tigela com granola e frutas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (29, 31, 'Caneca de Brownie no Micro-ondas', 'Sobremesa rápida feita em 5 minutos.', 'url_brownie_micro.jpg', 5, 'Fácil', 'Misture os ingredientes na caneca. Leve ao micro-ondas por 1 a 2 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (30, 32, 'Batata Rústica na Air Fryer', 'Batatas crocantes e sequinhas, sem óleo em excesso.', 'url_batata_airfryer.jpg', 30, 'Fácil', 'Corte as batatas. Tempere. Leve à Air Fryer a 200°C por 20 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (31, 33, 'Picanha na Grelha com Sal Grosso', 'O corte clássico do churrasco brasileiro.', 'url_picanha_churrasco.jpg', 50, 'Médio', 'Tempere a picanha com sal grosso. Leve à brasa, virando a cada 10 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (32, 34, 'Peru Recheado para o Natal', 'Receita festiva tradicional para a ceia.', 'url_peru_natal.jpg', 300, 'Difícil', 'Prepare o recheio. Recheie o peru. Asse por 5 horas, regando a cada hora.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (33, 35, 'Cuscuz Paulista de Camarão', 'Prato salgado típico das festas juninas.', 'url_cuscuz_junino.jpg', 90, 'Médio', 'Refogue o camarão. Misture a farinha de milho. Cozinhe no vapor na forma de cuscuz.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (34, 36, 'Bacalhau à Brás', 'Clássico português de Páscoa com bacalhau desfiado.', 'url_bacalhau_pascoa.jpg', 45, 'Médio', 'Dessalgue o bacalhau. Refogue com cebola e batata palha. Misture ovos mexidos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (35, 37, 'Bolo de Banana para Congelar', 'Receita perfeita para ter lanches prontos.', 'url_bolo_congelar.jpg', 60, 'Fácil', 'Prepare o bolo. Asse. Deixe esfriar e corte em fatias antes de congelar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (36, 38, 'Arroz Cremoso de Brócolis', 'Acompanhamento rico e saboroso para qualquer prato.', 'url_arroz_brocolis.jpg', 35, 'Fácil', 'Cozinhe o arroz. Refogue o brócolis. Misture o arroz e creme de leite.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (37, 39, 'Risoto de Limão Siciliano', 'Um risoto cítrico e cremoso, fácil de fazer.', 'url_risoto_limao.jpg', 40, 'Médio', 'Refogue a cebola. Adicione o arroz arbóreo e caldo quente aos poucos. Finalize com raspas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (38, 40, 'Pizza Margherita Caseira', 'Clássica pizza italiana com massa fina e ingredientes frescos.', 'url_pizza_margherita.jpg', 120, 'Médio', 'Prepare a massa. Deixe crescer. Monte com molho, mussarela e manjericão. Asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (39, 41, 'Frango com Ervas em 20 Minutos', 'Refeição completa e rápida para um dia corrido.', 'url_frango_20min.jpg', 20, 'Fácil', 'Corte o frango em cubos. Frite rapidamente em azeite com ervas finas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (40, 42, 'Mini-hambúrgueres Divertidos', 'Receita para crianças, colorida e nutritiva.', 'url_hamburguer_infantil.jpg', 40, 'Fácil', 'Prepare a carne e os pães pequenos. Use cortadores de biscoito para formas divertidas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (41, 43, 'Kartoffelsalat (Salada de Batata Alemã)', 'Salada de batata servida quente com bacon e vinagre.', 'url_kartoffelsalat.jpg', 45, 'Médio', 'Cozinhe as batatas. Prepare o molho quente com bacon e cebola. Misture tudo.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (42, 44, 'Homus (Pasta de Grão de Bico)', 'Prato clássico da culinária mediterrânea.', 'url_homus.jpg', 25, 'Fácil', 'Bata no processador grão de bico, tahine, alho, limão e azeite.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (43, 45, 'Boeuf Bourguignon (Carne de Vaca Borgonhesa)', 'Clássico francês cozido lentamente em vinho tinto.', 'url_boeuf_bourguignon.jpg', 180, 'Difícil', 'Cozinhe a carne no vinho tinto com legumes por 3 horas. Sirva com purê.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (44, 46, 'Limonada Suíça Cremosa', 'Bebida refrescante e saborosa, sem álcool.', 'url_limonada_suica.jpg', 10, 'Fácil', 'Bata os limões (com casca) com açúcar e água. Coe. Bata novamente com leite condensado e gelo.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (45, 47, 'Taco de Peixe com Molho Chipotle', 'Inspirado na culinária mexicana e do sudoeste americano.', 'url_taco_peixe.jpg', 40, 'Médio', 'Tempere e grelhe o peixe. Prepare o molho. Monte os tacos com repolho e molho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (46, 48, 'Marmita de Frango e Batata Doce', 'Opção balanceada e prática para o almoço.', 'url_marmita_fitness.jpg', 60, 'Fácil', 'Asse ou cozinhe o frango e a batata-doce. Distribua em porções individuais.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (47, 49, 'Geleia de Morango com Pimenta', 'Combinação agridoce e picante para torradas ou carnes.', 'url_geleia_pimenta.jpg', 50, 'Médio', 'Cozinhe o morango com açúcar. Adicione pimenta dedo-de-moça. Engarrafe em potes esterilizados.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (48, 50, 'Chocolate Quente Europeu Denso', 'Receita ideal para o frio, muito encorpada.', 'url_chocolate_quente.jpg', 20, 'Fácil', 'Misture cacau, açúcar e amido de milho. Adicione leite e leve ao fogo, mexendo até engrossar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (49, 1, 'Brownie de Chocolate com Nozes', 'Clássico americano com interior macio e casquinha crocante.', 'url_brownie_nozes.jpg', 50, 'Médio', 'Derreta o chocolate e a manteiga. Misture ovos, açúcar e farinha. Asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (50, 2, 'Filé Mignon ao Molho Madeira', 'Prato requintado e rápido para um jantar especial.', 'url_file_molho_madeira.jpg', 35, 'Médio', 'Selle os filés. Prepare o molho com vinho madeira e cogumelos. Sirva com o filé.');

INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (1, 12, 'Bagel Caseiro com Gergelim', 'Pão em formato de anel, perfeito para café da manhã.', 'url_bagel_caseiro.jpg', 150, 'Médio', 'Prepare a massa, cozinhe brevemente em água e depois asse até dourar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (3, 1, 'Torta Holandesa Sem Assar', 'Clássica torta cremosa com base de biscoito e cobertura de chocolate.', 'url_torta_holandesa.jpg', 30, 'Fácil', 'Prepare a base de biscoito. Misture o creme e leve à geladeira. Decore com a ganache.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (5, 5, 'Vichyssoise (Sopa Fria de Batata e Alho-Poró)', 'Sopa francesa elegante, servida gelada.', 'url_vichyssoise.jpg', 60, 'Médio', 'Refogue o alho-poró e a batata. Cozinhe em caldo. Bata no liquidificador e leve à geladeira.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (10, 11, 'Torta Salgada de Legumes Vegana', 'Massa e recheio sem nenhum produto de origem animal.', 'url_torta_vegana.jpg', 75, 'Médio', 'Prepare a massa. Refogue os legumes (brócolis, cenoura, milho) com leite vegetal e asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (15, 17, 'Maionese de Alho Caseira', 'Molho versátil e saboroso para lanches e petiscos.', 'url_maionese_alho.jpg', 10, 'Fácil', 'Bata o ovo e o alho no liquidificador. Adicione o óleo em fio até emulsionar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (20, 22, 'Curry Verde Tailandês de Camarão', 'Prato picante e aromático com leite de coco.', 'url_curry_verde.jpg', 40, 'Médio', 'Refogue a pasta de curry. Adicione camarão e vegetais. Cozinhe no leite de coco.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (25, 27, 'Cheesecake Low Carb de Frutas Vermelhas', 'Sobremesa sem açúcar e com pouca farinha.', 'url_cheesecake_lowcarb.jpg', 120, 'Médio', 'Faça a base com farinha de amêndoas. Misture o cream cheese e ovos. Asse e cubra com frutas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (30, 32, 'Pão de Queijo na Air Fryer', 'Receita rápida e prática, fica crocante por fora e macio por dentro.', 'url_pao_queijo_airfryer.jpg', 15, 'Fácil', 'Use massa pronta ou prepare a sua. Leve à Air Fryer a 180°C por 12-15 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (35, 37, 'Barra de Cereal Caseira', 'Opção saudável para lanches e pré-treino.', 'url_barra_cereal.jpg', 40, 'Fácil', 'Misture cereais, mel e sementes. Pressione em forma e leve ao forno.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (40, 42, 'Hot Dog Colorido (Receita Infantil)', 'O clássico lanche montado de forma divertida para as crianças.', 'url_hot_dog_infantil.jpg', 25, 'Fácil', 'Cozinhe as salsichas. Monte o lanche usando vegetais coloridos para decorar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (45, 47, 'Burrito de Carne Asada', 'Versão rápida e saborosa com carne marinada e arroz mexicano.', 'url_burrito_carne.jpg', 50, 'Médio', 'Prepare a carne e o arroz. Aqueça as tortilhas. Enrole o recheio firmemente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (50, 2, 'Medalhão de Filé Mignon ao Vinho', 'Cortes de carne com molho rico e denso.', 'url_medalhao_vinho.jpg', 30, 'Médio', 'Selle os medalhões. Deglaceie a panela com vinho tinto. Cozinhe o molho até reduzir.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (2, 6, 'Ravioli de Queijo ao Molho Manteiga e Sálvia', 'Massa fresca recheada com um molho simples e aromático.', 'url_ravioli_manteiga.jpg', 20, 'Fácil', 'Cozinhe o ravioli. Derreta a manteiga com sálvia. Misture o ravioli e sirva.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (4, 4, 'Salada Grega Clássica', 'Combinação de pepino, tomate, azeitonas e queijo feta.', 'url_salada_grega.jpg', 15, 'Fácil', 'Pique os vegetais. Misture com azeitonas e feta. Tempere com azeite, limão e orégano.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (6, 7, 'Costela Suína Assada com Barbecue', 'Costelinha macia, banhada em molho agridoce.', 'url_costela_bbq.jpg', 240, 'Difícil', 'Tempere a costela e asse coberta por 3 horas. Pincele o molho barbecue e asse por mais 30 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (8, 9, 'Ceviche Clássico Peruano', 'Peixe branco marinado no suco de limão e temperos.', 'url_ceviche_peruano.jpg', 20, 'Fácil', 'Corte o peixe. Marine no limão e pimenta. Adicione cebola roxa e coentro.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (12, 14, 'Caipirinha de Morango e Manjericão', 'Variação da caipirinha com toque herbal e frutado.', 'url_caipirinha_morango.jpg', 10, 'Fácil', 'Macerar morangos e manjericão. Adicionar açúcar, gelo e cachaça.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (14, 16, 'Waffles de Aveia e Mel', 'Opção de café da manhã nutritiva e com poucas calorias.', 'url_waffles_aveia.jpg', 25, 'Fácil', 'Misture a aveia, ovos e mel. Cozinhe na máquina de waffle até dourar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (16, 18, 'Macarrão com Queijo (Mac and Cheese) Cremoso', 'Receita americana de conforto com muito queijo.', 'url_mac_and_cheese.jpg', 35, 'Médio', 'Cozinhe o macarrão. Prepare um roux. Adicione leite e queijo ralado. Misture ao macarrão.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (18, 20, 'Tacos de Carnitas (Carne de Porco Mexicana)', 'Carne de porco desfiada e cozida lentamente.', 'url_tacos_carnitas.jpg', 180, 'Difícil', 'Cozinhe a carne de porco por 3 horas. Desfie e doure. Sirva em tortilhas de milho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (22, 24, 'Chutney de Manga Agridoce', 'Acompanhamento indiano para carnes ou queijos.', 'url_chutney_manga.jpg', 50, 'Médio', 'Cozinhe a manga com vinagre, açúcar e especiarias até engrossar.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (24, 26, 'Panqueca Americana Low Carb', 'Panquecas feitas com farinha de amêndoas.', 'url_panqueca_lowcarb.jpg', 20, 'Fácil', 'Misture farinha de amêndoas, ovos, fermento e leite. Frite em frigideira pequena.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (26, 28, 'Bolo de Fubá com Erva Doce Sem Lactose', 'Bolo clássico brasileiro com leite de coco.', 'url_bolo_fuba_sl.jpg', 60, 'Fácil', 'Bata os ingredientes, substituindo o leite por leite de coco. Asse em forno médio.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (28, 30, 'Salada no Pote (Pint Glass Salad)', 'Salada montada em camadas para a semana inteira.', 'url_salada_pote.jpg', 45, 'Fácil', 'Coloque o molho no fundo do pote. Monte camadas de legumes duros, folhas e proteínas.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (32, 34, 'Rabanada Clássica de Vó', 'Sobremesa de Natal feita com pão amanhecido.', 'url_rabanada_natal.jpg', 30, 'Médio', 'Passe as fatias de pão no leite e ovo. Frite e polvilhe açúcar e canela.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (34, 36, 'Ovo de Páscoa de Colher Caseiro', 'Chocolate recheado para ser comido de colher.', 'url_ovo_colher.jpg', 90, 'Médio', 'Derreta e tempere o chocolate. Faça a casca. Preencha com brigadeiro ou trufa.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (36, 38, 'Purê de Batata Cremoso com Alho', 'Acompanhamento suave e saboroso.', 'url_pure_alho.jpg', 30, 'Fácil', 'Cozinhe as batatas. Amasse. Adicione manteiga e leite (ou creme de leite) e alho assado.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (38, 40, 'Calzone Napolitano Recheado', 'Pizza dobrada recheada com queijo e presunto.', 'url_calzone_napolitano.jpg', 90, 'Médio', 'Abra a massa de pizza, recheie, feche e asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (42, 44, 'Baba Ghanoush (Pasta de Berinjela)', 'Pasta defumada do Oriente Médio.', 'url_baba_ghanoush.jpg', 45, 'Fácil', 'Asse a berinjela até murchar. Retire a polpa e misture com tahine, limão e alho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (44, 46, 'Smoothie Detox Verde', 'Bebida com couve, maçã e gengibre.', 'url_smoothie_detox.jpg', 5, 'Fácil', 'Bata todos os ingredientes (couve, maçã, gengibre, água) no liquidificador com gelo.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (46, 48, 'Marmita Vegana de Quinoa e Abobrinha', 'Prato completo e balanceado, sem carne.', 'url_marmita_quinoa.jpg', 40, 'Fácil', 'Cozinhe a quinoa. Refogue a abobrinha. Misture e tempere a gosto.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (48, 50, 'Grog de Natal (Receita de Inverno)', 'Bebida quente com rum, água e especiarias.', 'url_grog_natal.jpg', 15, 'Fácil', 'Aqueça o rum e a água. Adicione cravo, canela e rodelas de laranja. Sirva quente.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (1, 3, 'Pavê de Limão com Chocolate Branco', 'Combinação clássica em camadas.', 'url_pave_limao.jpg', 45, 'Médio', 'Prepare o creme de limão e o creme de chocolate. Monte as camadas com biscoito e leve à geladeira.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (3, 6, 'Nhoque de Batata Doce com Ragu', 'Nhoque leve e molho de carne desfiada.', 'url_nhoque_batata_doce.jpg', 90, 'Médio', 'Prepare o ragu lentamente. Faça o nhoque com batata doce e farinha. Cozinhe e sirva com o molho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (5, 8, 'Frango com Catupiry na Air Fryer', 'Frango recheado e crocante sem fritura.', 'url_frango_catupiry_airfryer.jpg', 30, 'Fácil', 'Recheie o filé de frango com catupiry. Empane e leve à Air Fryer.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (7, 10, 'Lasanha de Abobrinha (Vegetariana)', 'Massa substituída por fatias finas de abobrinha.', 'url_lasanha_abobrinha.jpg', 60, 'Médio', 'Fatie a abobrinha. Monte as camadas com ricota temperada e molho de tomate. Asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (9, 13, 'Cupcake Red Velvet', 'Bolinho americano com massa vermelha e cobertura de cream cheese.', 'url_cupcake_red_velvet.jpg', 60, 'Médio', 'Prepare a massa e asse. Prepare a cobertura de cream cheese e decore.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (11, 15, 'Misto Quente na Chapa com Manteiga de Ervas', 'Lanche simples elevado com manteiga temperada.', 'url_misto_quente_ervas.jpg', 10, 'Fácil', 'Prepare a manteiga de ervas. Monte o misto e grelhe na chapa com a manteiga.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (13, 17, 'Pasta de Alho para Pão (Churrasco)', 'Creme de alho temperado para passar no pão antes de assar.', 'url_pasta_alho_churrasco.jpg', 15, 'Fácil', 'Misture creme de leite, maionese, alho e queijo ralado. Guarde na geladeira.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (15, 19, 'Temaki de Salmão com Cream Cheese', 'Cone de alga recheado com salmão e arroz.', 'url_temaki_salmao.jpg', 30, 'Médio', 'Prepare o arroz. Pique o salmão. Enrole na alga com o arroz e o cream cheese.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (17, 21, 'Yakisoba de Frango e Legumes', 'Macarrão oriental com molho shoyu e vegetais.', 'url_yakisoba_frango.jpg', 40, 'Médio', 'Cozinhe o macarrão. Frite o frango e os vegetais. Adicione o molho e misture.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (19, 23, 'Profiteroles com Recheio de Sorvete', 'Carolinas recheadas com sorvete e calda de chocolate.', 'url_profiteroles.jpg', 90, 'Difícil', 'Prepare a massa choux e asse as carolinas. Recheie e cubra com calda.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (21, 25, 'Bolo Red Velvet Vegano', 'Versão vegana do bolo veludo vermelho.', 'url_red_velvet_vegano.jpg', 75, 'Médio', 'Use substitutos para ovos e laticínios na massa e no glacê.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (23, 27, 'Bolo de Milho Sem Glúten e Sem Lactose', 'Bolo úmido feito com fubá e leite de coco.', 'url_bolo_milho_sl.jpg', 60, 'Fácil', 'Bata todos os ingredientes no liquidificador. Asse em forma untada.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (25, 29, 'Salada de Quinoa com Atum e Manga', 'Opção de almoço fitness e refrescante.', 'url_quinoa_atum_manga.jpg', 25, 'Fácil', 'Cozinhe a quinoa. Misture com atum, manga, pepino e temperos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (27, 31, 'Chips de Batata Doce no Micro-ondas', 'Snack saudável e crocante, pronto em minutos.', 'url_chips_batata_micro.jpg', 10, 'Fácil', 'Corte a batata doce bem fina. Tempere. Leve ao micro-ondas em potência alta por 5-7 minutos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (29, 33, 'Cupim Assado no Papel Alumínio', 'Carne macia e suculenta, cozida lentamente.', 'url_cupim_aluminio.jpg', 360, 'Difícil', 'Tempere o cupim, embrulhe firmemente no alumínio e asse por 6 horas em fogo baixo.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (31, 35, 'Biscoito de Polvilho Caseiro (Festas Juninas)', 'Biscoito crocante e aerado.', 'url_biscoito_polvilho.jpg', 40, 'Médio', 'Escalde o polvilho com água quente. Amasse com ovos e queijo. Modele e asse.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (33, 37, 'Marmita de Carne Moída e Brócolis', 'Opção prática de refeição completa para congelar.', 'url_marmita_carne.jpg', 45, 'Fácil', 'Prepare a carne moída. Cozinhe o brócolis no vapor. Monte as porções.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (35, 39, 'Risoto de Funghi Secchi', 'Risoto cremoso com cogumelos secos.', 'url_risoto_funghi.jpg', 45, 'Médio', 'Hidrate o funghi. Refogue a cebola. Adicione o arroz e o caldo de legumes aos poucos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (37, 41, 'Salmão Rápido ao Molho de Mostarda', 'Preparo em menos de 20 minutos.', 'url_salmao_mostarda.jpg', 15, 'Fácil', 'Grelhe o salmão. Prepare o molho rápido com mostarda e mel. Sirva o salmão com o molho.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (39, 43, 'Goulash Húngaro (Ensopado de Carne)', 'Clássico ensopado com páprica e carne macia.', 'url_goulash_hungaro.jpg', 150, 'Difícil', 'Cozinhe a carne com muita páprica, cebola e caldo. Sirva com massa ou pão.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (41, 45, 'Kebab de Frango com Molho de Iogurte', 'Prato mediterrâneo com especiarias.', 'url_kebab_frango.jpg', 60, 'Médio', 'Marine o frango em especiarias e iogurte. Grelhe e sirva no pão pita com molho de iogurte.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (43, 47, 'Kimchi Caseiro (Repolho Fermentado Coreano)', 'Preparo complexo de fermentação.', 'url_kimchi_caseiro.jpg', 7200, 'Difícil', 'Salgar e lavar o repolho. Preparar a pasta de tempero. Misturar e deixar fermentar por dias.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (45, 49, 'Geleia de Laranja com Casca', 'Geleia cítrica e amarga para café da manhã.', 'url_geleia_laranja.jpg', 90, 'Médio', 'Cozinhe as cascas. Cozinhe a polpa com açúcar até atingir o ponto de geleia.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (47, 1, 'Mini Churros com Doce de Leite', 'Sobremesa espanhola crocante.', 'url_mini_churros.jpg', 40, 'Médio', 'Faça a massa de churros (massa choux). Frite e passe no açúcar e canela. Sirva com doce de leite.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (49, 4, 'Salada de Batata e Ovo com Maionese', 'Clássico acompanhamento frio.', 'url_salada_batata_ovo.jpg', 45, 'Fácil', 'Cozinhe batata e ovos. Pique e misture com maionese, mostarda e temperos.');
INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (50, 7, 'Pernil de Porco Assado Lento', 'Carne macia e desmanchando, perfeita para sanduíches.', 'url_pernil_assado.jpg', 480, 'Difícil', 'Marine o pernil por 24h. Asse por 8 horas em baixa temperatura.');

INSERT INTO ingredientes (nome) VALUES ('Farinha de Trigo');
INSERT INTO ingredientes (nome) VALUES ('Açúcar Refinado');
INSERT INTO ingredientes (nome) VALUES ('Ovos');
INSERT INTO ingredientes (nome) VALUES ('Manteiga sem Sal');
INSERT INTO ingredientes (nome) VALUES ('Leite Integral');
INSERT INTO ingredientes (nome) VALUES ('Sal');
INSERT INTO ingredientes (nome) VALUES ('Pimenta do Reino');
INSERT INTO ingredientes (nome) VALUES ('Azeite de Oliva Extra Virgem');
INSERT INTO ingredientes (nome) VALUES ('Cebola');
INSERT INTO ingredientes (nome) VALUES ('Alho');
INSERT INTO ingredientes (nome) VALUES ('Tomate');
INSERT INTO ingredientes (nome) VALUES ('Carne Bovina (Patrimônio)');
INSERT INTO ingredientes (nome) VALUES ('Filé de Frango');
INSERT INTO ingredientes (nome) VALUES ('Salmão');
INSERT INTO ingredientes (nome) VALUES ('Camarão');
INSERT INTO ingredientes (nome) VALUES ('Manjericão Fresco');
INSERT INTO ingredientes (nome) VALUES ('Queijo Muçarela');
INSERT INTO ingredientes (nome) VALUES ('Queijo Parmesão Ralado');
INSERT INTO ingredientes (nome) VALUES ('Leite Condensado');
INSERT INTO ingredientes (nome) VALUES ('Creme de Leite');
INSERT INTO ingredientes (nome) VALUES ('Chocolate em Pó');
INSERT INTO ingredientes (nome) VALUES ('Fermento Biológico Seco');
INSERT INTO ingredientes (nome) VALUES ('Batata');
INSERT INTO ingredientes (nome) VALUES ('Cenoura');
INSERT INTO ingredientes (nome) VALUES ('Brócolis');
INSERT INTO ingredientes (nome) VALUES ('Arroz Arbóreo');
INSERT INTO ingredientes (nome) VALUES ('Vinho Tinto Seco');
INSERT INTO ingredientes (nome) VALUES ('Vinagre de Maçã');
INSERT INTO ingredientes (nome) VALUES ('Limão Siciliano');
INSERT INTO ingredientes (nome) VALUES ('Pimenta Dedo de Moça');
INSERT INTO ingredientes (nome) VALUES ('Gengibre');
INSERT INTO ingredientes (nome) VALUES ('Óleo de Coco');
INSERT INTO ingredientes (nome) VALUES ('Mel');
INSERT INTO ingredientes (nome) VALUES ('Canela em Pó');
INSERT INTO ingredientes (nome) VALUES ('Baunilha (Extrato)');
INSERT INTO ingredientes (nome) VALUES ('Nozes');
INSERT INTO ingredientes (nome) VALUES ('Amendoim');
INSERT INTO ingredientes (nome) VALUES ('Leite de Coco');
INSERT INTO ingredientes (nome) VALUES ('Azeite de Dendê');
INSERT INTO ingredientes (nome) VALUES ('Grão de Bico');
INSERT INTO ingredientes (nome) VALUES ('Lentilha');
INSERT INTO ingredientes (nome) VALUES ('Cominho');
INSERT INTO ingredientes (nome) VALUES ('Curry em Pó');
INSERT INTO ingredientes (nome) VALUES ('Cilantro/Coentro');
INSERT INTO ingredientes (nome) VALUES ('Molho Shoyu');
INSERT INTO ingredientes (nome) VALUES ('Óleo de Gergelim');
INSERT INTO ingredientes (nome) VALUES ('Pão Forma');
INSERT INTO ingredientes (nome) VALUES ('Tomilho Fresco');
INSERT INTO ingredientes (nome) VALUES ('Páprica Defumada');
INSERT INTO ingredientes (nome) VALUES ('Água');

INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (1, 1, 500.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (1, 22, 10.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (1, 6, 5.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (1, 50, 350.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (2, 7, 1.00, 'colher chá');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (2, 11, 500.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (2, 12, 400.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (2, 17, 300.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (3, 19, 395.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (3, 20, 400.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (3, 29, 1.00, 'unidade');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (4, 13, 200.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (4, 8, 50.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (5, 23, 3.00, 'unidades');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (5, 24, 2.00, 'unidades');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (5, 9, 1.00, 'unidade');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (6, 7, 2.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (6, 12, 800.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (7, 2, 30.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (7, 13, 300.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (7, 37, 50.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (8, 14, 400.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (8, 29, 10.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (9, 40, 300.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (9, 41, 100.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (10, 40, 250.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (10, 9, 0.50, 'unidade');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (11, 1, 200.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (11, 24, 3.00, 'unidades');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (11, 21, 50.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (12, 50, 100.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (12, 2, 2.00, 'colheres sopa');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (13, 13, 150.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (13, 20, 50.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (14, 3, 3.00, 'unidades');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (14, 25, 50.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (15, 16, 1.00, 'maço');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (15, 18, 50.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (16, 10, 4.00, 'dentes');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (17, 14, 100.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (18, 11, 1.00, 'unidade');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (18, 44, 1.00, 'maço');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (19, 15, 500.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (19, 39, 50.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (20, 45, 20.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (21, 1, 100.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (22, 43, 10.00, 'g');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (23, 5, 200.00, 'ml');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (24, 9, 0.50, 'unidade');
INSERT INTO receitas_ingredientes (id_receita, id_ingrediente, quantidade, unidade_medida) VALUES (25, 3, 4.00, 'unidades');

INSERT INTO favoritos (id_usuario, id_receita) VALUES (1, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (5, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (10, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (15, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (20, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (25, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (30, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (35, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (40, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (45, 3);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (2, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (7, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (12, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (17, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (22, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (27, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (32, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (37, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (42, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (47, 10);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (3, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (8, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (13, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (18, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (23, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (28, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (33, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (38, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (43, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (48, 20);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (4, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (9, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (14, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (19, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (24, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (29, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (34, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (39, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (44, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (49, 30);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (6, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (11, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (16, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (21, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (26, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (31, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (36, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (41, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (46, 40);
INSERT INTO favoritos (id_usuario, id_receita) VALUES (50, 40);

INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (1, 1, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (2, 2, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (3, 3, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (4, 4, 3.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (5, 5, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (6, 6, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (7, 7, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (8, 8, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (9, 9, 3.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (10, 10, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (11, 11, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (12, 12, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (13, 13, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (14, 14, 3.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (15, 15, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (16, 16, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (17, 17, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (18, 18, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (19, 19, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (20, 20, 3.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (21, 21, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (22, 22, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (23, 23, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (24, 24, 3.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (25, 25, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (26, 26, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (27, 27, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (28, 28, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (29, 29, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (30, 30, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (31, 31, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (32, 32, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (33, 33, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (34, 34, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (35, 35, 3.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (36, 36, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (37, 37, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (38, 38, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (39, 39, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (40, 40, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (41, 41, 3.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (42, 42, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (43, 43, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (44, 44, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (45, 45, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (46, 46, 3.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (47, 47, 4.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (48, 48, 5.0);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (49, 49, 4.5);
INSERT INTO avaliacoes (id_usuario, id_receita, nota) VALUES (50, 50, 5.0);

INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (1, 3, 'O melhor Mousse de Maracujá que já fiz! A textura ficou perfeita e não ficou enjoativo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (2, 12, 'A receita do Mojito é simples e o resultado é incrivelmente refrescante. Adorei!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (3, 20, 'O Guacamole autêntico fez sucesso no meu churrasco. Dica: use coentro fresco!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (4, 30, 'A batata na Air Fryer ficou super crocante! Reduzi o tempo para 25 minutos e deu certo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (5, 40, 'Minha família amou a pizza. A massa ficou alta e fofa. Receita nota 10!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (6, 50, 'Filé ao Molho Madeira requintado. Usei um vinho Cabernet Sauvignon e ficou divino.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (7, 1, 'Pão rústico maravilhoso, mas demorou mais tempo para crescer devido ao frio.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (8, 10, 'O hambúrguer vegano surpreendeu! Substituí o grão de bico por feijão preto e funcionou.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (9, 19, 'A Moqueca é deliciosa, mas achei o dendê muito forte. Da próxima vez, vou usar menos.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (10, 29, 'O brownie de caneca me salvou! Rápido e mata a vontade de doce na hora.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (11, 39, 'Melhor risoto de limão que já preparei. Dica: use um bom vinho branco seco.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (12, 49, 'Bolo de chocolate com nozes impecável! A casquinha do brownie ficou perfeita.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (13, 2, 'Lasanha perfeita para o almoço de domingo. Segui a receita do molho à risca!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (14, 13, 'Wrap de frango super prático e saudável. Ótimo para levar para o trabalho.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (15, 23, 'Tiramisu desconstruído é uma ideia genial! Menos trabalho e o mesmo sabor.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (16, 33, 'Churrasco com picanha de cinema! A dica do sal grosso fez toda a diferença.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (17, 43, 'Boeuf Bourguignon de dar água na boca. O tempo de cozimento lento é essencial.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (18, 4, 'A Salada Caesar ficou boa, mas o molho caseiro é bem intenso.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (19, 14, 'Omelete de legumes nutritiva e leve. Perfeita para o café da manhã.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (20, 24, 'Sopa de abóbora low carb ficou super cremosa e saborosa. Substituí o gengibre por noz-moscada.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (21, 34, 'Peru de Natal maravilhoso! A família elogiou a suculência.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (22, 44, 'Homus autêntico, delicioso e fácil. Servi com pão pita.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (23, 5, 'Sopa da vovó! Conforto em forma de comida.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (24, 15, 'O molho pesto caseiro é incomparável. Usei castanha de caju no lugar do pinoli.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (25, 25, 'Bolo sem glúten muito fofo! Não parece que é sem farinha de trigo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (26, 35, 'Cuscuz paulista tradicional e saboroso. Usei sardinha em lata, ficou ótimo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (27, 45, 'Receita francesa que vale cada minuto de preparo. Perfeita para impressionar.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (28, 6, 'O Bife Wellington é desafiador, mas valeu o esforço! Receita muito detalhada.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (29, 16, 'Spaghetti Aglio e Olio rápido e com aquele toque picante que eu adoro.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (30, 26, 'Panqueca sem lactose super leve! Adicionei um pouco de linhaça moída à massa.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (31, 36, 'O bacalhau à Brás é o meu prato preferido da Páscoa. Perfeito!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (32, 46, 'Limonada suíça muito cremosa e refrescante. A receita ideal para o verão.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (33, 7, 'Frango Xadrez com o tempero no ponto. Não usei amendoim por causa de alergias, mas ficou bom mesmo assim.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (34, 17, 'Sushi Nigiri requer prática, mas a receita do arroz estava ótima.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (35, 27, 'Omelete fitness: rápida e muito proteica. Uso bastante para o pós-treino.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (36, 37, 'Bolo de banana para congelar é uma mão na roda. Fica ótimo depois de descongelado.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (37, 47, 'Geleia de morango com pimenta é viciante! Fica excelente com queijos.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (38, 8, 'O salmão ficou saboroso. Achei o molho de maracujá um pouco ralo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (39, 18, 'Guacamole perfeito! Segui a dica do limão e não oxidou.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (40, 28, 'Açaí bowl incrível! A granola caseira deu um toque especial.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (41, 38, 'Arroz de brócolis cremoso. Combina com tudo!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (42, 48, 'Chocolate quente denso, receita de inverno nota mil!');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (43, 9, 'A feijoada vegana é complexa, mas o sabor vale o esforço. Ficou muito rica.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (44, 19, 'A moqueca é uma explosão de sabores. Receita de família! Usei pimentões de todas as cores.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (45, 29, 'O brownie de caneca me salvou de novo! Uso cacau 70% e fica ótimo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (46, 39, 'Risoto de limão siciliano: refrescante e fácil de harmonizar com peixes.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (47, 49, 'Brownie de nozes super úmido. Minha batedeira quebrou, mas misturei à mão e deu certo.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (48, 2, 'Melhor lasanha que já comi! Dica: use queijo parmesão fresco ralado.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (49, 13, 'O wrap ficou ótimo! Usei cream cheese light para reduzir as calorias.');
INSERT INTO comentarios (id_usuario, id_receita, conteudo) VALUES (50, 23, 'Tiramisu muito elegante. Servi em taças individuais.');


-- Tabelas criadas
SELECT * FROM usuarios;
SELECT * FROM categorias;
SELECT * FROM ingredientes;
SELECT * FROM receitas;
SELECT * FROM receitas_ingredientes;
SELECT * FROM favoritos;
SELECT * FROM comentarios;
SELECT * FROM avaliacoes;
