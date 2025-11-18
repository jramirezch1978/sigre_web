$PBExportHeader$w_ope726_mat_ot_x_cotizar.srw
forward
global type w_ope726_mat_ot_x_cotizar from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope726_mat_ot_x_cotizar
end type
type uo_1 from u_ingreso_rango_fechas within w_ope726_mat_ot_x_cotizar
end type
type cb_3 from commandbutton within w_ope726_mat_ot_x_cotizar
end type
type pb_1 from picturebutton within w_ope726_mat_ot_x_cotizar
end type
type st_1 from statictext within w_ope726_mat_ot_x_cotizar
end type
type gb_1 from groupbox within w_ope726_mat_ot_x_cotizar
end type
end forward

global type w_ope726_mat_ot_x_cotizar from w_report_smpl
integer width = 3424
integer height = 1656
string title = "Materiales de orden de trabajo  a cotizar (ope726)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
uo_1 uo_1
cb_3 cb_3
pb_1 pb_1
st_1 st_1
gb_1 gb_1
end type
global w_ope726_mat_ot_x_cotizar w_ope726_mat_ot_x_cotizar

on w_ope726_mat_ot_x_cotizar.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.uo_1=create uo_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_ope726_mat_ot_x_cotizar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

event ue_open_pre;call super::ue_open_pre;sle_codigo.text=''

end event

type dw_report from w_report_smpl`dw_report within w_ope726_mat_ot_x_cotizar
integer x = 50
integer y = 432
integer width = 3282
integer height = 980
string dataobject = "d_rpt_material_x_ot_cotizar_tbl"
end type

type sle_codigo from singlelineedit within w_ope726_mat_ot_x_cotizar
integer x = 626
integer y = 120
integer width = 338
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

type uo_1 from u_ingreso_rango_fechas within w_ope726_mat_ot_x_cotizar
integer x = 105
integer y = 248
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

type cb_3 from commandbutton within w_ope726_mat_ot_x_cotizar
integer x = 1527
integer y = 156
integer width = 357
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_codigo, ls_estado, ls_texto, ls_tipo, ls_msj_err, ls_nombre_empresa, ls_ruc
Date ld_fec_ini, ld_fec_fin
DateTime ldt_fec_ini, ldt_fec_fin

ls_codigo = TRIM(sle_codigo.text)

SetPointer(hourglass!)
ls_codigo = TRIM(sle_codigo.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

ldt_fec_ini = DATETIME( ld_fec_ini )
ldt_fec_fin = DATETIME( ld_fec_fin, TIME('23:59:59'))

select nom_proveedor, ruc 
  into :ls_nombre_empresa, :ls_ruc
  from proveedor p
 where p.proveedor=(select cod_empresa from genparam where reckey='1') ;

//idw_1.SetTransObject(sqlca)
idw_1.retrieve(ls_codigo, ldt_fec_ini, ldt_fec_fin)

idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.t_texto.text = 'Del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_nombre_empresa.text = ls_nombre_empresa
idw_1.Object.t_ruc.text = ls_ruc

SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

end event

type pb_1 from picturebutton within w_ope726_mat_ot_x_cotizar
integer x = 1010
integer y = 116
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

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
								 +'ORDEN_TRABAJO.DESCRIPCION AS DESCRIPCION '&     	
								 +'FROM ORDEN_TRABAJO ' 

OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_codigo.text = lstr_seleccionar.param1[1]
END IF												 

end event

type st_1 from statictext within w_ope726_mat_ot_x_cotizar
integer x = 91
integer y = 128
integer width = 526
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de trabajo:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ope726_mat_ot_x_cotizar
integer x = 59
integer y = 28
integer width = 1417
integer height = 352
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

