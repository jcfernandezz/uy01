	DECLARE @BD_UCFEPROD varchar(30), @BD_UCFETEST  varchar(30);  
	DECLARE @BD_UCFE varchar(30);

	select @BD_UCFEPROD = param3, @BD_UCFETEST = param4
	from ucfe.fCfdiParametros('BD_GPPROD', 'BD_GPTEST', 'BD_UCFEPROD', 'BD_UCFETEST', 'NA', 'NA', 'UCFE')

	if @BD_UCFEPROD = db_name()
		--print @BD_UCFEPROD
		set @BD_UCFE = @BD_UCFEPROD
	else
		--print 'test?'
		set @BD_UCFE = @BD_UCFETEST

	if OBJECT_ID('ucfe.synonymDatabaseChannelInput') is not null
		DROP SYNONYM ucfe.synonymDatabaseChannelInput;
		
	EXEC ('create synonym ucfe.synonymDatabaseChannelInput for ' + @BD_UCFE + '..DatabaseChannelInput;');

	IF (@@Error = 0) PRINT 'Creación exitosa del synonym: synonymDatabaseChannelInput'
	ELSE PRINT 'Error en la creación del synonym: synonymDatabaseChannelInput'


	if OBJECT_ID('ucfe.synonymDatabaseChannelOutput') is not null
		DROP SYNONYM ucfe.synonymDatabaseChannelOutput;
		
	EXEC ('create synonym ucfe.synonymDatabaseChannelOutput for ' + @BD_UCFE + '..DatabaseChannelOutput;');

	IF (@@Error = 0) PRINT 'Creación exitosa del synonym: synonymDatabaseChannelOutput'
	ELSE PRINT 'Error en la creación del synonym: synonymDatabaseChannelOutput'
	go

----------------------------------------
--test
--create synonym ucfe.synonymDatabaseChannelInput for dynamics..DatabaseChannelInput