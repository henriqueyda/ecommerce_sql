use ecommerce

CREATE TABLE tblAuxLocalizacao
(
	geolocation_zip_code_prefix NVARCHAR (MAX),
	geolocation_lat NVARCHAR(max),
	geolocation_lng NVARCHAR(max),
	geolocation_city NVARCHAR(max),
	geolocation_state NVARCHAR(max)
)

BULK INSERT tblAuxLocalizacao
FROM "C:\55151_195341_bundle_archive\olist_geolocation_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
)

CREATE TABLE tblEstado
(
	Id_Estado INT NOT NULL IDENTITY PRIMARY KEY,
	Abrev_Estado NVARCHAR(2) NOT NULL
)

CREATE TABLE tblCidade
(
	Id_Cidade INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome_Cidade NVARCHAR(100) NOT NULL,
	Id_Estado INT NOT NULL,
	CONSTRAINT [FK_tblCidade_tblEstado] FOREIGN KEY ([Id_Estado]) REFERENCES [tblEstado]([Id_Estado])
)

CREATE TABLE tblLocalizacao
(
	Id_Localizacao INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Zip_Code_Localizacao NVARCHAR(8) NOT NULL,
	Longitude FLOAT NOT NULL,
	Latitude FLOAT NOT NULL,
	Id_Cidade INT NOT NULL,
		CONSTRAINT [FK_tblLocalizacao_tblCidade] FOREIGN KEY ([Id_Cidade]) REFERENCES [tblCidade]([Id_Cidade])
)

-- Inserting tblEstado
INSERT INTO tblEstado(Abrev_Estado)(
	SELECT DISTINCT LTRIM(RTRIM([geolocation_state])) from tblAuxLocalizacao
	)

-- Inserting tblCidade
INSERT INTO tblCidade(Nome_Cidade, Id_Estado)
(
	select DISTINCT LTRIM(RTRIM([geolocation_city])),
		(select TOP 1 Id_Estado from tblEstado E where E.Abrev_Estado = LTRIM(RTRIM(G.[geolocation_state])))
	from tblAuxLocalizacao G
)

-- Inserting tblLocalizacao
INSERT INTO tblLocalizacao(Zip_Code_Localizacao, Longitude, Latitude, Id_Cidade)
(
	select DISTINCT 
	G.[geolocation_zip_code_prefix],
	CONVERT(FLOAT,G.[geolocation_lng]),
	CONVERT(FLOAT,G.[geolocation_lat]),
	(select TOP 1 Id_Cidade from tblCidade C where C.Nome_Cidade = LTRIM(RTRIM(G.[geolocation_city])))
	from tblAuxLocalizacao G
)