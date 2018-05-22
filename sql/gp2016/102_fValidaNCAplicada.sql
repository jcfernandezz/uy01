IF OBJECT_ID ('ucfe.fnValidaNCAplicada') IS NOT NULL
   drop function ucfe.fnValidaNCAplicada
go

create function ucfe.fnValidaNCAplicada(@soptype smallint, @archivoXml xml)
--Propósito. Obtiene los datos de la factura electrónica
--Usado por. 
--Requisitos. CFE
--25/04/18 jcf Creación
--
returns table
return(
	WITH XMLNAMESPACES(DEFAULT 'http://cfe.dgi.gub.uy')
	select 		
		case when @soptype = 4 
				and isnull(doc.IndGlobal, '_no_existe') = '_no_existe' 
				and isnull(doc.NroCFERef, '_no_existe') = '_no_existe'  then
				'NC no está aplicada o no indica una referencia.'
			when @soptype = 4 
				and isnull(doc.IndGlobal, '_no_existe') = '1' 
				and isnull(doc.NroCFERef, '_no_existe') = '_no_existe'  then
				'OK'
			when @soptype = 4 
				and isnull(doc.IndGlobal, '_no_existe') = '_noexiste' 
				and isnull(doc.NroCFERef, '_no_existe') != '_no_existe'  then
				'OK'
			when @soptype = 4 
				and isnull(doc.IndGlobal, '_no_existe') = '1' 
				and isnull(doc.NroCFERef, '_no_existe') != '_no_existe'  then
				'NC referencia una factura física pero aplica a un CFE.'
			else 'OK'
			end validacionGP
	from
		(select 
			@archivoXml.value('(//eTck/Referencia/Referencia/IndGlobal)[1]', 'varchar(5)') IndGlobal,
			@archivoXml.value('(//eTck/Referencia/Referencia/NroCFERef)[1]', 'varchar(20)') NroCFERef
		) doc
	)
	go

IF (@@Error = 0) PRINT 'Creación exitosa de: fnValidaNCAplicada()'
ELSE PRINT 'Error en la creación de: fnValidaNCAplicada()'
GO

--------------------------------------------------------------------------------------

--PRUEBAS--

--select lf.*, dx.*
--from vwSopTransaccionesVenta tv
--	cross join dbo.fCfdEmisor() emi
--	outer apply dbo.fCfdCertificadoVigente(tv.fechahora) fv
--	outer apply dbo.fCfdCertificadoPAC(tv.fechahora) pa
--	left join cfdlogfacturaxml lf
--		on lf.soptype = tv.SOPTYPE
--		and lf.sopnumbe = tv.sopnumbe
--		and lf.estado = 'emitido'
--	outer apply ucfe.fnValidaNCAplicada(lf.archivoXML) dx
