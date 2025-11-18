$PBExportHeader$w_cn736_rpt_saldos_ctacte.srw
forward
global type w_cn736_rpt_saldos_ctacte from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn736_rpt_saldos_ctacte
end type
type sle_mes from singlelineedit within w_cn736_rpt_saldos_ctacte
end type
type em_origen from singlelineedit within w_cn736_rpt_saldos_ctacte
end type
type em_descripcion from editmask within w_cn736_rpt_saldos_ctacte
end type
type st_1 from statictext within w_cn736_rpt_saldos_ctacte
end type
type st_2 from statictext within w_cn736_rpt_saldos_ctacte
end type
type cbx_origen from checkbox within w_cn736_rpt_saldos_ctacte
end type
type cbx_proveedores from checkbox within w_cn736_rpt_saldos_ctacte
end type
type cb_proveedores from commandbutton within w_cn736_rpt_saldos_ctacte
end type
type cbx_cuentas from checkbox within w_cn736_rpt_saldos_ctacte
end type
type cb_cuentas from commandbutton within w_cn736_rpt_saldos_ctacte
end type
type cb_procesar from commandbutton within w_cn736_rpt_saldos_ctacte
end type
type cbx_saldos from checkbox within w_cn736_rpt_saldos_ctacte
end type
type cbx_resumen from checkbox within w_cn736_rpt_saldos_ctacte
end type
type cb_aplicacion from commandbutton within w_cn736_rpt_saldos_ctacte
end type
type gb_2 from groupbox within w_cn736_rpt_saldos_ctacte
end type
end forward

global type w_cn736_rpt_saldos_ctacte from w_report_smpl
integer width = 4690
integer height = 2284
string title = "[CN736] Saldos de Cuenta Corriente x Codigo de Relación"
string menuname = "m_impresion"
sle_ano sle_ano
sle_mes sle_mes
em_origen em_origen
em_descripcion em_descripcion
st_1 st_1
st_2 st_2
cbx_origen cbx_origen
cbx_proveedores cbx_proveedores
cb_proveedores cb_proveedores
cbx_cuentas cbx_cuentas
cb_cuentas cb_cuentas
cb_procesar cb_procesar
cbx_saldos cbx_saldos
cbx_resumen cbx_resumen
cb_aplicacion cb_aplicacion
gb_2 gb_2
end type
global w_cn736_rpt_saldos_ctacte w_cn736_rpt_saldos_ctacte

on w_cn736_rpt_saldos_ctacte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.st_1=create st_1
this.st_2=create st_2
this.cbx_origen=create cbx_origen
this.cbx_proveedores=create cbx_proveedores
this.cb_proveedores=create cb_proveedores
this.cbx_cuentas=create cbx_cuentas
this.cb_cuentas=create cb_cuentas
this.cb_procesar=create cb_procesar
this.cbx_saldos=create cbx_saldos
this.cbx_resumen=create cbx_resumen
this.cb_aplicacion=create cb_aplicacion
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cbx_origen
this.Control[iCurrent+8]=this.cbx_proveedores
this.Control[iCurrent+9]=this.cb_proveedores
this.Control[iCurrent+10]=this.cbx_cuentas
this.Control[iCurrent+11]=this.cb_cuentas
this.Control[iCurrent+12]=this.cb_procesar
this.Control[iCurrent+13]=this.cbx_saldos
this.Control[iCurrent+14]=this.cbx_resumen
this.Control[iCurrent+15]=this.cb_aplicacion
this.Control[iCurrent+16]=this.gb_2
end on

on w_cn736_rpt_saldos_ctacte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cbx_origen)
destroy(this.cbx_proveedores)
destroy(this.cb_proveedores)
destroy(this.cbx_cuentas)
destroy(this.cb_cuentas)
destroy(this.cb_procesar)
destroy(this.cbx_saldos)
destroy(this.cbx_resumen)
destroy(this.cb_aplicacion)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(gnvo_app.of_fecha_actual(), 'yyyy')
sle_mes.text = string(gnvo_app.of_fecha_actual(), 'mm')
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_year, li_mes
string 	ls_origen, ls_nombre_mes, ls_desc_origen

li_year = integer(sle_ano.text)
li_mes  = integer(sle_mes.text)

// Hacer funcion
IF li_mes=0 THEN
	ls_nombre_mes = 'Apertura'
ELSEIF li_mes=1 THEN
	ls_nombre_mes = 'Enero'
ELSEIF li_mes=2 THEN
	ls_nombre_mes = 'Febrero'
ELSEIF li_mes=3 THEN
	ls_nombre_mes = 'Marzo'
ELSEIF li_mes=4 THEN
	ls_nombre_mes = 'Abril'
ELSEIF li_mes=5 THEN
	ls_nombre_mes = 'Mayo'
ELSEIF li_mes=6 THEN
	ls_nombre_mes = 'Junio'
ELSEIF li_mes=7 THEN
	ls_nombre_mes = 'Julio'
ELSEIF li_mes=8 THEN
	ls_nombre_mes = 'Agosto'
ELSEIF li_mes=9 THEN
	ls_nombre_mes = 'Setiembre'
ELSEIF li_mes=10 THEN
	ls_nombre_mes = 'Octubre'
ELSEIF li_mes=11 THEN
	ls_nombre_mes = 'Noviembre'
ELSEIF li_mes=12 THEN
	ls_nombre_mes = 'Diciembre'
ELSEIF li_mes=13 THEN
	ls_nombre_mes = 'Diciembre ajustado'
ELSE
	ls_nombre_mes = 'Defina nombre mes'
END IF 

if cbx_origen.checked then
	ls_origen = '%%'
	ls_desc_origen		=	'Todos los Origenes'
else
	if trim(em_origen.text) = "" then
		f_mensaje("Debe ingresar el origen, por favor verifique!", "")
		em_origen.setFocus()
		return
	else
		ls_origen = trim(em_origen.text) + '%'
		ls_desc_origen	 	=  string(em_descripcion.text)
	end if
end if

//Todos los Codigos de relacion
if cbx_proveedores.checked then
	delete tt_cntbl_cliente;
	if gnvo_app.of_ExistsError(SQLCA) then return
	commit;
	
	insert into tt_cntbl_cliente (codigo)
		select distinct p.proveedor
		 from cntbl_Asiento ca,
				cntbl_Asiento_det cad,
				proveedor         p
		where ca.origen      = cad.origen
		  and ca.ano         = cad.ano
		  and ca.mes         = cad.mes
		  and ca.nro_libro   = cad.nro_libro
		  and ca.nro_asiento = cad.nro_asiento      
		  and cad.cod_relacion = p.proveedor
		  and cad.tipo_docref1 is not null 
		  and cad.nro_docref1  is not null
		  and ca.flag_estado   <> '0'
		  and ca.ano           = :li_year;
	
	if gnvo_app.of_ExistsError(SQLCA) then return
	commit;
end if	 

//Todos los Codigos de relacion
if cbx_cuentas.checked then
	delete tt_cnt_cnta_ctbl;
	if gnvo_app.of_ExistsError(SQLCA) then return
	commit;
	
	insert into tt_cnt_cnta_ctbl (CNTA_CTBL)
		select distinct cad.cnta_ctbl
		 from cntbl_Asiento       ca,
				cntbl_Asiento_det   cad
		where ca.origen      = cad.origen
		  and ca.ano         = cad.ano
		  and ca.mes         = cad.mes
		  and ca.nro_libro   = cad.nro_libro
		  and ca.nro_asiento = cad.nro_asiento      
		  and cad.tipo_docref1 is not null 
		  and cad.nro_docref1  is not null
		  and cad.cod_relacion is not null
		  and ca.flag_estado   <> '0'
		  and cad.ano			  = :li_year;
	
	if gnvo_app.of_ExistsError(SQLCA) then return
	
	commit;
end if	 

if cbx_saldos.checked then
	if cbx_Resumen.checked then
		idw_1.DataObject = 'd_rpt_sdo_ctacte_dato_saldos_res_tbl'
	else
		idw_1.DataObject = 'd_rpt_sdo_ctacte_dato_saldos_tbl'
	end if
else
	idw_1.DataObject = 'd_rpt_sdo_ctacte_dato_x_cod_relacion_tbl'
end if


idw_1.SetTransObject(SQLCA)
ib_preview = false
event ue_preview()

idw_1.Retrieve(ls_origen, li_year, li_mes)

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_user.text 		= gs_user

dw_report.object.t_texto.text = 'A ' + ls_nombre_mes + ' del ' + string(li_year, '0000') + ', '+ ls_desc_origen

if cbx_saldos.checked then
	if cbx_Resumen.checked then
		if idw_1.RowCount() > 0 then
			cb_aplicacion.enabled = true
		else
			cb_aplicacion.enabled = false
		end if
	else
		cb_aplicacion.enabled = false
	end if
else
	cb_aplicacion.enabled = false
end if
end event

type dw_report from w_report_smpl`dw_report within w_cn736_rpt_saldos_ctacte
integer x = 0
integer y = 280
integer width = 2798
integer height = 1484
string dataobject = "d_rpt_sdo_ctacte_dato_x_cod_relacion_tbl"
end type

type sle_ano from singlelineedit within w_cn736_rpt_saldos_ctacte
integer x = 224
integer y = 72
integer width = 219
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn736_rpt_saldos_ctacte
integer x = 654
integer y = 72
integer width = 123
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type em_origen from singlelineedit within w_cn736_rpt_saldos_ctacte
event dobleclick pbm_lbuttondblclk
integer x = 558
integer y = 164
integer width = 128
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_cn736_rpt_saldos_ctacte
integer x = 695
integer y = 164
integer width = 663
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_cn736_rpt_saldos_ctacte
integer x = 41
integer y = 72
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn736_rpt_saldos_ctacte
integer x = 453
integer y = 72
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_origen from checkbox within w_cn736_rpt_saldos_ctacte
integer x = 37
integer y = 168
integer width = 517
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los origenes"
boolean checked = true
end type

event clicked;if this.checked then
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type cbx_proveedores from checkbox within w_cn736_rpt_saldos_ctacte
integer x = 1367
integer y = 64
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los proveedores"
boolean checked = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	cb_proveedores.enabled = false
else
	cb_proveedores.enabled = true
end if
end event

type cb_proveedores from commandbutton within w_cn736_rpt_saldos_ctacte
integer x = 1961
integer y = 52
integer width = 549
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Proveedores"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete tt_cntbl_cliente ;
commit;

sl_param.dw1		= 'd_lista_cntbl_codrel_tbl'
sl_param.titulo	= 'Listado de Relaciones'
sl_param.opcion   = 1
sl_param.long1    = Long(sle_ano.text)
sl_param.tipo		= '1L'


OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cbx_cuentas from checkbox within w_cn736_rpt_saldos_ctacte
integer x = 1371
integer y = 168
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos las cuentas"
boolean checked = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	cb_cuentas.enabled = false
else
	cb_cuentas.enabled = true
end if
end event

type cb_cuentas from commandbutton within w_cn736_rpt_saldos_ctacte
integer x = 1961
integer y = 156
integer width = 549
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Cuentas"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete tt_cnt_cnta_ctbl ;
commit;

sl_param.dw1		= 'd_lista_cntbl_cntas_tbl'
sl_param.titulo	= 'Listado de Relaciones'
sl_param.opcion   = 2
sl_param.long1    = Long(sle_ano.text)
sl_param.tipo		= '1L'

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cb_procesar from commandbutton within w_cn736_rpt_saldos_ctacte
integer x = 3255
integer y = 56
integer width = 430
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type cbx_saldos from checkbox within w_cn736_rpt_saldos_ctacte
integer x = 2514
integer y = 56
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo documentos con saldos"
end type

event clicked;cbx_resumen.enabled = this.checked
end event

type cbx_resumen from checkbox within w_cn736_rpt_saldos_ctacte
integer x = 2510
integer y = 148
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Mostrar Resumen"
end type

type cb_aplicacion from commandbutton within w_cn736_rpt_saldos_ctacte
integer x = 3694
integer y = 60
integer width = 443
integer height = 180
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aplicacion masiva"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type gb_2 from groupbox within w_cn736_rpt_saldos_ctacte
integer x = 5
integer width = 4270
integer height = 264
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos para Proceso"
end type

