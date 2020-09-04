CREATE TABLE Cliente
(
    Codigo INT NOT NULL IDENTITY(1,1),
    Nome VARCHAR (150) NOT NULL,
    DataNascimento DateTime NOT NULL
);
GO
--Dica: Bulk  https://medium.com/@leandrobianch/dicas-entity-framework-efcore-bulkextensions-melhoria-de-performance-7594ae4d7fe0
INSERT INTO Cliente 
VALUES 
('JIMI HENDRIX', '1968-11-21'), 
('BBKING', '1934-05-08'), 
('BILL GATES', '1958-07-19'), 
('STEVE JOBS', '1960-12-05'),
('EDDIE VEDDER', '1960-10-10'), 
('DAVID GILMOUR','1956-02-28'),
('LEANDRO BIANCH DO FUTURO', GETDATE())


INSERT INTO Cliente (Nome, DataNascimento) VALUES ('JIMI HENDRIX', '1968-11-21')
INSERT INTO Cliente (Nome, DataNascimento) VALUES ('BBKING', '1934-05-08')