$PBExportHeader$w_ve718_tiempo_permanencia.srw
forward
global type w_ve718_tiempo_permanencia from w_report_smpl
end type
type cb_aceptar from commandbutton within w_ve718_tiempo_permanencia
end type
type uo_1 from u_ingreso_rango_fechas_horas within w_ve718_tiempo_permanencia
end type
type rb_todo from radiobutton within w_ve718_tiempo_permanencia
end type
type rb_guia from radiobutton within w_ve718_tiempo_permanencia
end type
type sle_cliente from singlelineedit within w_ve718_tiempo_permanencia
end type
type cb_1 from commandbutton within w_ve718_tiempo_permanencia
end type
type sle_desc_cliente from singlelineedit within w_ve718_tiempo_permanencia
end type
type gb_1 from groupbox within w_ve718_tiempo_permanencia
end type
type gb_2 from groupbox within w_ve718_tiempo_permanencia
end type
type gb_3 from groupbox within w_ve718_tiempo_permanencia
end type
end forward

global type w_ve718_tiempo_permanencia from w_report_smpl
integer width = 3109
integer height = 1264
string title = "[VE718] Tiempos de Permanencia"
string menuname = "m_reporte"
long backcolor = 67108864
cb_aceptar cb_aceptar
uo_1 uo_1
rb_todo rb_todo
rb_guia rb_guia
sle_cliente sle_cliente
cb_1 cb_1
sle_desc_cliente sle_desc_cliente
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_ve718_tiempo_permanencia w_ve718_tiempo_permanencia

type variables

end variables

on w_ve718_tiempo_permanencia.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_aceptar=create cb_aceptar
this.uo_1=create uo_1
this.rb_todo=create rb_todo
this.rb_guia=create rb_guia
this.sle_cliente=create sle_cliente
this.cb_1=create cb_1
this.sle_desc_cliente=create sle_desc_cliente
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.rb_todo
this.Control[iCurrent+4]=this.rb_guia
this.Control[iCurrent+5]=this.sle_cliente
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.sle_desc_cliente
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_ve718_tiempo_permanencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.uo_1)
destroy(this.rb_todo)
destroy(this.rb_guia)
destroy(this.sle_cliente)
destroy(this.cb_1)
destroy(this.sle_desc_cliente)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;datetime ldt_fec_ini, ldt_fec_fin
string ls_cliente

ldt_fec_ini = uo_1.of_get_fecha1( )
ldt_fec_fin = uo_1.of_get_fecha2( )

if rb_todo.checked = true then
	dw_report.dataobject = 'd_rpt_tiempo_permanencia_total'
else
	dw_report.dataobject = 'd_rpt_tiempo_permanencia_guias'
end if

ls_cliente = sle_cliente.text

if ls_cliente = '' or isnull(ls_cliente) then
	ls_cliente = '%'
end if

dw_report.settransobject( sqlca )
dw_report.retrieve( ldt_fec_ini, ldt_fec_fin, ls_cliente, gs_empresa, gs_user )
dw_report.object.p_logo.filename = gs_logo


ib_preview = false
this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_ve718_tiempo_permanencia
integer x = 37
integer y = 480
integer width = 2967
integer height = 516
string dataobject = "d_rpt_tiempo_permanencia_guias"
integer ii_zoom_actual = 100
end type

type cb_aceptar from commandbutton within w_ve718_tiempo_permanencia
integer x = 1829
integer y = 352
integer width = 334
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_1 from u_ingreso_rango_fechas_horas within w_ve718_tiempo_permanencia
integer x = 82
integer y = 104
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;

of_set_fecha(DateTime( date('01/'+string(today(),'mm')+'/'+string(today(),'yyyy')) , time('06:00:00') ), DateTime(today(),now())) 
end event

on uo_1.destroy
call u_ingreso_rango_fechas_horas::destroy
end on

type rb_todo from radiobutton within w_ve718_tiempo_permanencia
integer x = 2569
integer y = 112
integer width = 407
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Mostrar Todo"
end type

type rb_guia from radiobutton within w_ve718_tiempo_permanencia
integer x = 1870
integer y = 112
integer width = 677
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar &Tickets con Guias"
boolean checked = true
end type

type sle_cliente from singlelineedit within w_ve718_tiempo_permanencia
integer x = 73
integer y = 328
integer width = 347
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event losefocus;string ls_cliente, ls_desc_cliente

ls_cliente = this.text

if ls_cliente = '' or isnull(ls_cliente) then
	sle_desc_cliente.text = ''
	return
end if

select nom_proveedor
  into :ls_desc_cliente
  from proveedor
 where proveedor = :ls_cliente;

if sqlca.sqlcode <> 0 then
	messagebox('Aviso','Proveedor No Existe')
	this.text = ''
else
	sle_desc_cliente.text = ls_desc_cliente
end if
end event

type cb_1 from commandbutton within w_ve718_tiempo_permanencia
integer x = 439
integer y = 328
integer width = 110
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT P.PROVEEDOR AS CODIGO, P.NOM_PROVEEDOR AS NOMBRE '&
								 +'FROM PROVEEDOR P '&
								 +"WHERE P.FLAG_ESTADO = '1'"

OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cliente.text = string(lstr_seleccionar.param1[1])
	sle_desc_cliente.text = string(lstr_seleccionar.param2[1])
END IF
end event

type sle_desc_cliente from singlelineedit within w_ve718_tiempo_permanencia
integer x = 567
integer y = 328
integer width = 1184
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_ve718_tiempo_permanencia
integer x = 37
integer y = 32
integer width = 1760
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_ve718_tiempo_permanencia
integer x = 37
integer y = 256
integer width = 1760
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente"
end type

type gb_3 from groupbox within w_ve718_tiempo_permanencia
integer x = 1829
integer y = 32
integer width = 1175
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

