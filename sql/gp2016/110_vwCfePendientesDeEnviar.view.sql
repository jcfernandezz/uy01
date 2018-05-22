-----------------------------------------------------------------------------------------
IF (OBJECT_ID ('ucfe.vwCfePendientesDeEnviar', 'V') IS NULL)
   exec('create view ucfe.vwCfePendientesDeEnviar as SELECT 1 as t');
go

alter view ucfe.vwCfePendientesDeEnviar as
--Prop�sito. Lista los comprobantes que se deben enviar a UCFE
--Usado por. 
--Requisitos. Posibles estados:
--		Vac�o. Est� listo para enviar a UCFE
--		CFE_LISTO. Est� listo para enviar a UCFE
--27/03/18 jcf Creaci�n cfe Uruguay
--19/04/18 jcf Mostrar s�lo los comprobantes contabilizados
--25/04/18 JCF No muestra las facturas que no est�n validadas
--17/05/18 jcf Agrega comment_1, pymtrmid
--

	select  tv.tipoCfe, tv.codTerminal, tv.codComercio, tv.sopnumbe, tv.SOPTYPE, tv.docid, 
		'CFE_ENESPERA' siguienteStatusCfe,	tv.docXml, ac.jrnentry, tv.comment_1, tv.pymtrmid
	from ucfe.vwComprobantesFiscalesElectronicos tv
		cross apply dbo.fnGlGetPrimerAsientoContableDeTrx(3, tv.soptype, tv.sopnumbe) ac
		outer apply ucfe.fnValidaNCAplicada(tv.soptype, tv.docXml) vnc
	where rtrim(isnull(tv.usrtab01, '')) in ('', 'CFE_LISTO')
	and ac.origen in ('Hist�rico', 'Abrir')
	and	vnc.validacionGP = 'OK'

go

IF (@@Error = 0) PRINT 'Creaci�n exitosa de la vista: vwCfePendientesDeEnviar'
ELSE PRINT 'Error en la creaci�n de la vista: vwCfePendientesDeEnviar'
GO
