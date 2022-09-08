# Prova de Banco de Dados
# Bruno Salli Nogueira     
# Gustavo Prado de Freitas 

# Exercicio 1
CREATE DATABASE empresa;

USE empresa;

CREATE TABLE departamento (
     idDepto SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
     nomeDep VARCHAR(50) NOT NULL,
     andar SMALLINT,
     CONSTRAINT pk_depto PRIMARY KEY (idDepto)
);

CREATE TABLE funcionario (
    idFunc SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nomeF VARCHAR(50) NOT NULL,
    emailF VARCHAR(50),
    sexo ENUM('M', 'F'),
    dataAd DATE,
    salario FLOAT,
    idDepto SMALLINT UNSIGNED NOT NULL,
    idSuper SMALLINT,
    CONSTRAINT pk_func PRIMARY KEY (idFunc),
    CONSTRAINT fk_func_depto FOREIGN KEY (idDepto)
        REFERENCES departamento (idDepto) ON DELETE CASCADE
);


CREATE TABLE projeto (
    idProj SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    descrP VARCHAR(50) NOT NULL,
    CONSTRAINT pk_idProj PRIMARY KEY (idProj)
);

CREATE TABLE projFunc (
    idProj SMALLINT UNSIGNED NOT NULL,
    idFunc SMALLINT UNSIGNED NOT NULL,
    dataI DATE,
    CONSTRAINT fk_projF_proj FOREIGN KEY (idProj)
        REFERENCES projeto (idProj) ON DELETE CASCADE,
    CONSTRAINT fk_projF_func FOREIGN KEY (idFunc)
        REFERENCES funcionario (idFunc) ON DELETE CASCADE
);

CREATE TABLE evento (
    idEvento SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    descrEvt VARCHAR(50),
    CONSTRAINT pk_evento PRIMARY KEY (idEvento)
);

CREATE TABLE ocorrencia (
    instante TIMESTAMP NOT NULL,
    idEvento SMALLINT UNSIGNED NOT NULL,
    idFunc SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT fk_ocor_event FOREIGN KEY (idEvento)
        REFERENCES evento (idEvento) ON DELETE CASCADE,
    CONSTRAINT fk_ocor_func FOREIGN KEY (idFunc)
        REFERENCES funcionario (idFunc) ON DELETE CASCADE
);

# Exercicio 2
INSERT INTO departamento VALUES
    (NULL, 'Engenharia', 1),
    (NULL, 'Administrativo', 2),
    (NULL, 'RH', 3),
    (NULL, 'Logistica', 4),
    (NULL, 'Diretoria', 5);

INSERT INTO funcionario VALUES
    (NULL, 'Adamastor Quaresma', 'ada@acme.org', 'M', '2010-01-01', 15000, 5, NULL),
    (NULL, 'Querencia Nunes', 'que@acme.org', 'F', '2010-02-01', 5000, 3, 1),
    (NULL, 'Sergio Patricio', 'ser@acme.org', 'M', '2010-02-10', 3500, 2, 1),
    (NULL, 'Foster Felster', 'fos@acme.org', 'M', '2010-02-10', 2250, 4, 1),
    (NULL, 'Terence Wallace', 'seila@ts.com.br',  'M', '2010-03-10', 4000, 3, 1),
    (NULL, 'Deosdedite Paixao', 'deo@acme.org', 'F', '2010-04-01', 2100, 3, 5),
    (NULL, 'Ricardo Neves', 'ric@acme.org', 'M', '2010-04-01', 2100, 3, 5),
    (NULL, 'Feliciano Ramos', 'fel@acme.org', 'M', '2010-04-01', 2100, 3, 5),
    (NULL, 'Nilsonclecio Fereira', 'nil@acme.org', 'F', '2010-04-01', 2100, 3, 5);

INSERT INTO projeto VALUES
    (NULL, 'Folha de Pagamento'),
    (NULL, 'Trading System'),
    (NULL, 'New Devices for Education'),
    (NULL, 'Ideas for Life');

INSERT INTO projFunc VALUES
    (1, 5, '2010-03-10'),
    (1, 6, '2010-04-10'),
    (1, 7, '2010-04-10'),
    (2, 5, '2010-04-10'),
    (2, 8, '2010-04-10'),
    (3, 9, '2010-04-10'),
    (4, 6, '2010-04-10'),
    (4, 7, '2010-04-10');

INSERT INTO evento VALUES
    (NULL, 'Entrada'),
    (NULL, 'Saida'),
    (NULL, 'Saida-Almoco'),
    (NULL, 'Retorno-Almoco'),
    (NULL, 'Entrada-ServicoExterno'),
    (NULL, 'Saida-ServicoExterno');

INSERT INTO ocorrencia VALUES
    ('2010-05-01 08:00:00', 1, 6),
    ('2010-05-01 08:00:00', 1, 7),
    ('2010-05-01 08:00:00', 1, 8),
    ('2010-05-02 00:00:00', 1, 5),
    ('2010-05-01 17:00:00', 2, 6),
    ('2010-05-01 17:00:00', 2, 7),
    ('2010-05-01 17:00:00', 2, 8),
    ('2010-05-02 00:00:00', 2, 5),
    ('2010-05-01 12:00:00', 3, 6),
    ('2010-05-01 12:00:00', 3, 7),
    ('2010-05-01 12:00:00', 3, 8),
    ('2010-05-02 00:00:00', 3, 5),
    ('2010-05-01 13:00:00', 4, 6),
    ('2010-05-01 13:00:00', 4, 7),
    ('2010-05-01 13:00:00', 4, 8),
    ('2010-05-02 00:00:00', 4, 5),
    ('2010-05-01 08:00:00', 5, 9),
    ('2010-05-01 13:00:00', 5, 9),
    ('2010-05-01 12:00:00', 6, 9),
    ('2010-05-01 17:00:00', 6, 9);

# Exercicio 3.1
SELECT * FROM funcionario ORDER BY nomeF ASC;

# Exercicio 3.2
SELECT * FROM funcionario ORDER BY dataAd ASC LIMIT 1;

# Exercicio 3.3
SELECT DISTINCT nomeDep AS 'Departamentos com funcionarios alocados'
    FROM departamento AS d INNER JOIN funcionario AS f ON f.idDepto = d.idDepto;

# Exercicio 3.4
SELECT DISTINCT descrP AS 'Projetos de Ricardo Neves'
    FROM projFunc AS p INNER JOIN funcionario AS f on f.idFunc = p.idFunc
    INNER JOIN projeto AS proj ON proj.idProj = p.idProj
    WHERE f.nomeF LIKE 'Ricardo Neves';

# Exercicio 3.5
SELECT nomeF AS 'Funcionarios com projeto', NULL AS 'Funcionarios sem projeto'
  FROM funcionario WHERE (idFunc IN (SELECT DISTINCT idFunc FROM projFunc))
	UNION SELECT NULL, nomeF FROM funcionario
	WHERE (idFunc NOT IN (SELECT DISTINCT idFunc FROM projFunc));
