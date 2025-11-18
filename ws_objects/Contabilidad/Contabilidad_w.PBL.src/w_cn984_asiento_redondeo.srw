$PBExportHeader$w_cn984_asiento_redondeo.srw
forward
global type w_cn984_asiento_redondeo from w_rpt
end type
type hpb_1 from hprogressbar within w_cn984_asiento_redondeo
end type
type cb_invertir_select from commandbutton within w_cn984_asiento_redondeo
end type
type cb_select_all from commandbutton within w_cn984_asiento_redondeo
end type
type sle_margen from singlelineedit within w_cn984_asiento_redondeo
end type
type st_4 from statictext within w_cn984_asiento_redondeo
end type
type cb_reporte from commandbutton within w_cn984_asiento_redondeo
end type
type cb_cntas from commandbutton within w_cn984_asiento_redondeo
end type
type st_2 from statictext within w_cn984_asiento_redondeo
end type
type em_mes from editmask within w_cn984_asiento_redondeo
end type
type em_year from editmask within w_cn984_asiento_redondeo
end type
type st_1 from statictext within w_cn984_asiento_redondeo
end type
type st_nro_reg from statictext within w_cn984_asiento_redondeo
end type
type st_3 from statictext within w_cn984_asiento_redondeo
end type
type pb_procesar from picturebutton within w_cn984_asiento_redondeo
end type
type dw_report from u_dw_rpt within w_cn984_asiento_redondeo
end type
end forward

global type w_cn984_asiento_redondeo from w_rpt
integer width = 3621
integer height = 2368
string title = "[CN984] Asiento de Ajustes por Redondeo"
string menuname = "m_export"
event ue_procesar ( )
hpb_1 hpb_1
cb_invertir_select cb_invertir_select
cb_select_all cb_select_all
sle_margen sle_margen
st_4 st_4
cb_reporte cb_reporte
cb_cntas cb_cntas
st_2 st_2
em_mes em_mes
em_year em_year
st_1 st_1
st_nro_reg st_nro_reg
st_3 st_3
pb_procesar pb_procesar
dw_report dw_report
end type
global w_cn984_asiento_redondeo w_cn984_asiento_redondeo

type variables
String is_cnta_cntbl [], is_null []

end variables

forward prototypes
public function integer of_ruc_empresa ()
public function boolean of_procesar (string as_cnta_cntbl, string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
end prototypes

event ue_procesar();Long 		ll_count, ll_i, ll_Rows
Integer	li_year, li_mes
String	ls_cnta_cntbl, ls_cod_relacion, ls_tipo_doc, ls_nro_doc

idw_1.AcceptText()

if idw_1.RowCount() = 0 then return

li_year 	= Integer(em_year.text)
li_mes	= Integer(em_mes.text)

ll_count = 0

ll_rows = idw_1.RowCount()

hpb_1.Position = 0
hpb_1.visible = true

for ll_i = 1 to ll_rows
	if idw_1.object.checked [ll_i] = '1' then
		ll_count ++
	end if
	yield()
	hpb_1.Position = ll_i / idw_1.RowCount() * 100
next

if ll_count = 0 then
	gnvo_app.of_mensaje_error("No hay registros seleccionados")
	return
end if

//Proceso los registros seleccionados
yield()
hpb_1.Position = 0
for ll_i = 1 to ll_rows
	
	yield()
	if idw_1.object.checked [ll_i] = '1' then
		ls_cnta_cntbl 		= idw_1.object.cnta_ctbl 		[ll_i]
		ls_cod_relacion 	= idw_1.object.cod_relacion 	[ll_i]
		ls_tipo_doc		 	= idw_1.object.tipo_docref1 	[ll_i]
		ls_nro_doc 			= idw_1.object.nro_docref1 	[ll_i]
		
		if not of_procesar(ls_cnta_cntbl, ls_cod_relacion, ls_tipo_doc, ls_nro_doc) then return
	end if
	
	yield()
	
	hpb_1.Position = ll_i / ll_rows * 100
	
next

this.event ue_retrieve()
MessageBox("Aviso", "Proceso de ajuste terminado satisfactoriamente", Information!)
hpb_1.visible = false

end event

public function integer of_ruc_empresa ();//// Obtengo el codig de empresa en genparam
//
//String	ls_cod_emp
//
//	SELECT cod_empresa
//	  Into :ls_cod_emp
//	FROM   genparam
//	WHERE reckey = '1' ;
//	
//IF sqlca.sqlcode = 100 THEN
//	Messagebox( "Error", "No ha definido parametros en GENPARAM")
//	RETURN 0
//END IF
//
//SELECT RUC
//  INTO :is_ruc_emp
//FROM   EMPRESA
//WHERE  COD_EMPRESA = :ls_cod_emp ;
//
//IF sqlca.sqlcode = 100 THEN
//	Messagebox( "Error", "No ha definido RUC EN TABLA EMPRESA")
//	RETURN 0
//END IF

RETURN 1
end function

public function boolean of_procesar (string as_cnta_cntbl, string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Integer 	li_year, li_mes
String 	ls_mensaje

li_year 	= Integer(em_year.text)
li_mes	= Integer(em_mes.text)

//  PROCEDURE USP_SIGRE_CNTBL.sp_asiento_redondeo(
//      asi_origen         origen.cod_origen%TYPE, 
//      ani_year           number, 
//      ani_mes            number,
//      asi_cnta_cntbl     cntbl_cnta.cnta_ctbl%TYPE,
//      asi_cod_relacion   cntbl_asiento_det.cod_relacion%TYPE,
//      asi_tipo_doc       cntbl_asiento_det.tipo_docref1%TYPE,
//      asi_nro_doc        cntbl_asiento_det.nro_docref1%TYPE,
//      asi_cod_usr        usuario.cod_usr%TYPE
//  ) is

DECLARE sp_asiento_redondeo PROCEDURE FOR 
	USP_SIGRE_CNTBL.sp_asiento_redondeo( :gs_origen, 
													 :li_year, 
													 :li_mes,
													 :as_cnta_cntbl,
													 :as_cod_relacion,
													 :as_tipo_doc,
													 :as_nro_doc,
													 :gs_user) ;
	
EXECUTE sp_asiento_redondeo ;
	
if SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error en USP_SIGRE_CNTBL.sp_asiento_redondeo', ls_mensaje)
	return false
end if
	
Commit;
close sp_asiento_redondeo;

return true
end function

on w_cn984_asiento_redondeo.create
int iCurrent
call super::create
if this.MenuName = "m_export" then this.MenuID = create m_export
this.hpb_1=create hpb_1
this.cb_invertir_select=create cb_invertir_select
this.cb_select_all=create cb_select_all
this.sle_margen=create sle_margen
this.st_4=create st_4
this.cb_reporte=create cb_reporte
this.cb_cntas=create cb_cntas
this.st_2=create st_2
this.em_mes=create em_mes
this.em_year=create em_year
this.st_1=create st_1
this.st_nro_reg=create st_nro_reg
this.st_3=create st_3
this.pb_procesar=create pb_procesar
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.cb_invertir_select
this.Control[iCurrent+3]=this.cb_select_all
this.Control[iCurrent+4]=this.sle_margen
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_reporte
this.Control[iCurrent+7]=this.cb_cntas
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_mes
this.Control[iCurrent+10]=this.em_year
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.st_nro_reg
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.pb_procesar
this.Control[iCurrent+15]=this.dw_report
end on

on w_cn984_asiento_redondeo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_1)
destroy(this.cb_invertir_select)
destroy(this.cb_select_all)
destroy(this.sle_margen)
destroy(this.st_4)
destroy(this.cb_reporte)
destroy(this.cb_cntas)
destroy(this.st_2)
destroy(this.em_mes)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.st_nro_reg)
destroy(this.st_3)
destroy(this.pb_procesar)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;Date	ld_hoy
	
try 

	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	em_year.text 	= String(ld_hoy, 'yyyy')
	em_mes.text 	= String(ld_hoy, 'mm')
	
	idw_1 = dw_report
	idw_1.SetTransObject(sqlca)

	sle_margen.text = gnvo_app.of_get_parametro("MARGEN_DOC_CNTA_CRRTE", "0.05")
	
catch ( Exception ex )
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	
end try
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_year, li_mes
Decimal	ldc_margen

try 
	
	if trim(sle_margen.text) = '' then
		gnvo_app.of_mensaje_error("Debe Ingresar un margen adecuado. Por favor verifique!")
		sle_margen.setFocus()
		return
	end if
	
	ldc_margen = Dec(sle_margen.text)

	if ldc_margen < 0 then
		gnvo_app.of_mensaje_error("El margen no puede ser negativo. Por favor verifique!")
		sle_margen.setFocus()
		return
	end if
	

	if em_year.text = '' then
		messagebox('Aviso', 'Debe especificar un año para el reporte')
		em_year.setFocus( )
		RETURN
	end if
	
	if em_mes.text = '' then
		messagebox('Aviso', 'Debe especificar un mes para el reporte')
		em_mes.setFocus( )
		RETURN
	end if
	
	li_year 	= Integer(em_year.text)
	li_mes	= Integer(em_mes.text)
	
	// Recuperar y mostrar datos
	idw_1.Retrieve(li_year, li_mes, is_cnta_cntbl, ldc_margen)
	idw_1.Visible = True

	st_nro_reg.text = string(idw_1.RowCount())
	

catch ( Exception ex )
	
	gnvo_app.of_mensaje_error("Ha ocurrido una exception: " + ex.getMessage())
	
end try

end event

type hpb_1 from hprogressbar within w_cn984_asiento_redondeo
boolean visible = false
integer x = 933
integer y = 204
integer width = 1522
integer height = 76
unsignedinteger maxposition = 100
unsignedinteger position = 20
integer setstep = 1
end type

type cb_invertir_select from commandbutton within w_cn984_asiento_redondeo
integer x = 457
integer y = 192
integer width = 457
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Invertir Marcado"
end type

event clicked;Long ll_i
if idw_1.RowCount() = 0 then return


hpb_1.Position = 0
hpb_1.visible = true
for ll_i = 1 to idw_1.RowCount()
	if idw_1.Object.checked [ll_i] = '1' then
		idw_1.Object.checked [ll_i] = '0'
	else
		idw_1.Object.checked [ll_i] = '1'
	end if
	
	yield()
	hpb_1.Position = ll_i / idw_1.RowCount() * 100
next

hpb_1.visible = false
end event

type cb_select_all from commandbutton within w_cn984_asiento_redondeo
integer y = 192
integer width = 457
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Marcar Todo"
end type

event clicked;Long ll_i
if idw_1.RowCount() = 0 then return

hpb_1.Position = 0
hpb_1.visible = true
for ll_i = 1 to idw_1.RowCount()
	idw_1.Object.checked [ll_i] = '1'
	yield()
	hpb_1.Position = ll_i / idw_1.RowCount() * 100
next

hpb_1.visible = false

end event

type sle_margen from singlelineedit within w_cn984_asiento_redondeo
integer x = 1253
integer y = 28
integer width = 229
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn984_asiento_redondeo
integer x = 1015
integer y = 36
integer width = 229
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Margen :"
boolean focusrectangle = false
end type

type cb_reporte from commandbutton within w_cn984_asiento_redondeo
integer x = 1499
integer width = 480
integer height = 152
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()
end event

type cb_cntas from commandbutton within w_cn984_asiento_redondeo
integer x = 489
integer width = 480
integer height = 152
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cuentas Contables"
end type

event clicked;str_cnta_cntbl 	lstr_cntas[]
str_parametros		lstr_param
Long					ll_i

lstr_param = gnvo_cntbl.of_get_cnta_cntbl(true)
		
if lstr_param.b_return = true then
	lstr_Cntas = lstr_param.istr_cntas
	
	if UpperBound(lstr_cntas) = 0 then
		return
	end if
	
	is_cnta_cntbl = is_null
	for ll_i = 1 to UpperBound(lstr_cntas) 
		is_cnta_cntbl[ll_i] = lstr_cntas[ll_i].cnta_cntbl
	next
	
	if UpperBound(is_cnta_cntbl) > 0 then
		cb_reporte.enabled = true
	else
		cb_reporte.enabled = false
	end if
	
end if
end event

type st_2 from statictext within w_cn984_asiento_redondeo
integer x = 5
integer y = 104
integer width = 174
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
boolean focusrectangle = false
end type

type em_mes from editmask within w_cn984_asiento_redondeo
integer x = 187
integer y = 96
integer width = 261
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
end type

type em_year from editmask within w_cn984_asiento_redondeo
integer x = 187
integer width = 261
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#,###"
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_cn984_asiento_redondeo
integer y = 8
integer width = 174
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type st_nro_reg from statictext within w_cn984_asiento_redondeo
integer x = 2789
integer y = 44
integer width = 169
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn984_asiento_redondeo
integer x = 2277
integer y = 52
integer width = 466
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro _registros ="
boolean focusrectangle = false
end type

type pb_procesar from picturebutton within w_cn984_asiento_redondeo
integer x = 3031
integer width = 389
integer height = 160
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "C:\SIGRE\resources\BMP\procesar_enb.bmp"
string disabledname = "C:\SIGRE\resources\BMP\procesar_enb.bmp"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;Parent.event ue_procesar()
end event

type dw_report from u_dw_rpt within w_cn984_asiento_redondeo
integer y = 296
integer width = 3493
integer height = 1676
string dataobject = "d_cns_saldos_doc_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

event clicked;call super::clicked;Long ll_count, ll_i

this.AcceptText()
ll_count = 0

for ll_i = 1 to this.RowCount()
	if this.object.checked [ll_i] = '1' then
		ll_count ++
	end if
next

if ll_count = 0 then
	pb_procesar.enabled = false
else
	pb_procesar.enabled = true
end if

if row > 0 then
	gnvo_app.of_select_current_row(this)
end if
end event

