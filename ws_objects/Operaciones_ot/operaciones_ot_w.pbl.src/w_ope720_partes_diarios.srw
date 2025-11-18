$PBExportHeader$w_ope720_partes_diarios.srw
forward
global type w_ope720_partes_diarios from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope720_partes_diarios
end type
type rb_ccr from radiobutton within w_ope720_partes_diarios
end type
type rb_eje from radiobutton within w_ope720_partes_diarios
end type
type sle_nombre from singlelineedit within w_ope720_partes_diarios
end type
type uo_1 from u_ingreso_rango_fechas within w_ope720_partes_diarios
end type
type cb_3 from commandbutton within w_ope720_partes_diarios
end type
type pb_1 from picturebutton within w_ope720_partes_diarios
end type
type rb_ord from radiobutton within w_ope720_partes_diarios
end type
type rb_maq from radiobutton within w_ope720_partes_diarios
end type
type rb_ota from radiobutton within w_ope720_partes_diarios
end type
type rb_gen from radiobutton within w_ope720_partes_diarios
end type
type rb_1 from radiobutton within w_ope720_partes_diarios
end type
type gb_1 from groupbox within w_ope720_partes_diarios
end type
end forward

global type w_ope720_partes_diarios from w_report_smpl
integer width = 3424
integer height = 1468
string title = "Operaciones segun estado (ope720)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
sle_codigo sle_codigo
rb_ccr rb_ccr
rb_eje rb_eje
sle_nombre sle_nombre
uo_1 uo_1
cb_3 cb_3
pb_1 pb_1
rb_ord rb_ord
rb_maq rb_maq
rb_ota rb_ota
rb_gen rb_gen
rb_1 rb_1
gb_1 gb_1
end type
global w_ope720_partes_diarios w_ope720_partes_diarios

on w_ope720_partes_diarios.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.rb_ccr=create rb_ccr
this.rb_eje=create rb_eje
this.sle_nombre=create sle_nombre
this.uo_1=create uo_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.rb_ord=create rb_ord
this.rb_maq=create rb_maq
this.rb_ota=create rb_ota
this.rb_gen=create rb_gen
this.rb_1=create rb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.rb_ccr
this.Control[iCurrent+3]=this.rb_eje
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.rb_ord
this.Control[iCurrent+9]=this.rb_maq
this.Control[iCurrent+10]=this.rb_ota
this.Control[iCurrent+11]=this.rb_gen
this.Control[iCurrent+12]=this.rb_1
this.Control[iCurrent+13]=this.gb_1
end on

on w_ope720_partes_diarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.rb_ccr)
destroy(this.rb_eje)
destroy(this.sle_nombre)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.rb_ord)
destroy(this.rb_maq)
destroy(this.rb_ota)
destroy(this.rb_gen)
destroy(this.rb_1)
destroy(this.gb_1)
end on

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

event ue_open_pre;call super::ue_open_pre;sle_codigo.text=''
sle_nombre.text=''
end event

type dw_report from w_report_smpl`dw_report within w_ope720_partes_diarios
integer x = 50
integer y = 432
integer width = 3145
integer height = 832
end type

type sle_codigo from singlelineedit within w_ope720_partes_diarios
integer x = 1093
integer y = 296
integer width = 311
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_ccr from radiobutton within w_ope720_partes_diarios
integer x = 590
integer y = 160
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo Rsp."
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_eje from radiobutton within w_ope720_partes_diarios
integer x = 590
integer y = 228
integer width = 480
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejecutor"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type sle_nombre from singlelineedit within w_ope720_partes_diarios
integer x = 1582
integer y = 296
integer width = 1125
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ope720_partes_diarios
integer x = 1088
integer y = 100
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_3 from commandbutton within w_ope720_partes_diarios
integer x = 2816
integer y = 160
integer width = 320
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_codigo, ls_estado, ls_texto, ls_nombre
Date ld_fec_ini, ld_fec_fin

ls_codigo = TRIM(sle_codigo.text)

IF rb_gen.checked=false AND ls_codigo='' then
	messagebox('Aviso', 'Seleccione codigo a mostrar')
	return
END IF

SetPointer(hourglass!)
ls_codigo = TRIM(sle_codigo.text)
ls_nombre = TRIM(sle_nombre.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

IF rb_gen.checked=true then
	ls_texto = 'General - '
	idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
ELSEIF rb_ota.checked=true then	
	ls_texto = ls_codigo + '-' + ls_nombre+', '
	idw_1.DataObject='d_rpt_parte_diario_ot_adm_tbl'
ELSEIF rb_maq.checked=true then	
	ls_texto = ls_codigo + '-' + ls_nombre+', '
	idw_1.DataObject='d_rpt_parte_diario_maq_tbl'
ELSEIF rb_ord.checked=true then	
	ls_texto = ls_codigo + ', '
	idw_1.DataObject='d_rpt_parte_diario_ord_trab_tbl'	
ELSEIF rb_ccr.checked=true then	
	ls_texto = ls_codigo + '-' + ls_nombre+', '
	idw_1.DataObject='d_rpt_parte_diario_cc_rsp_tbl'
ELSEIF rb_eje.checked=true then
	ls_texto = ls_codigo + '-' + ls_nombre+', '
	idw_1.DataObject='d_rpt_parte_diario_eje_tbl'
END IF

idw_1.SetTransObject(sqlca)
IF rb_gen.checked=true then
	idw_1.retrieve(ld_fec_ini, ld_fec_fin)
ELSE
	idw_1.retrieve(ls_codigo, ld_fec_ini, ld_fec_fin)
END IF
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto + 'del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'OPE 720'
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

//cb_generar.enabled = true

end event

type pb_1 from picturebutton within w_ope720_partes_diarios
integer x = 1426
integer y = 296
integer width = 123
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_inactivo

IF rb_ota.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO,'&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM OT_ADMINISTRACION ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_maq.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
									 +'MAQUINA.DESC_MAQ AS DESCRIPCION '&     	
		   						 +'FROM MAQUINA ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_ord.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
									 +'ORDEN_TRABAJO.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM ORDEN_TRABAJO ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 


IF rb_ccr.checked = true then
	ls_inactivo = '0'
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
									 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
		   						 +'FROM CENTROS_COSTO ' &
									 +'WHERE CENTROS_COSTO.FLAG_ESTADO <> ' + "'"+ls_inactivo+"'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_eje.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT EJECUTOR.COD_EJECUTOR  AS CODIGO,'&
									 +'EJECUTOR.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM EJECUTOR ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 

END IF

end event

type rb_ord from radiobutton within w_ope720_partes_diarios
integer x = 110
integer y = 296
integer width = 480
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Trabajo"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_maq from radiobutton within w_ope720_partes_diarios
integer x = 110
integer y = 228
integer width = 480
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Máquina"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_ota from radiobutton within w_ope720_partes_diarios
integer x = 110
integer y = 160
integer width = 480
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ot Adm"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=true
sle_nombre.enabled=true
end event

type rb_gen from radiobutton within w_ope720_partes_diarios
integer x = 110
integer y = 92
integer width = 443
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
end type

event clicked;sle_codigo.text=''
sle_nombre.text=''
sle_codigo.enabled=false
sle_nombre.enabled=false
end event

type rb_1 from radiobutton within w_ope720_partes_diarios
integer x = 590
integer y = 92
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "C.Costo Slc."
end type

type gb_1 from groupbox within w_ope720_partes_diarios
integer x = 59
integer y = 24
integer width = 2683
integer height = 380
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Parámetros"
end type

