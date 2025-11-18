$PBExportHeader$w_al761_res_movimiento_ov.srw
forward
global type w_al761_res_movimiento_ov from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al761_res_movimiento_ov
end type
type cb_3 from commandbutton within w_al761_res_movimiento_ov
end type
type cbx_1 from checkbox within w_al761_res_movimiento_ov
end type
type sle_nro_ov from singlelineedit within w_al761_res_movimiento_ov
end type
type st_2 from statictext within w_al761_res_movimiento_ov
end type
type gb_1 from groupbox within w_al761_res_movimiento_ov
end type
type gb_2 from groupbox within w_al761_res_movimiento_ov
end type
end forward

global type w_al761_res_movimiento_ov from w_report_smpl
integer width = 3831
integer height = 1980
string title = "[AL761] Despacho resumido por OV"
string menuname = "m_impresion"
uo_fechas uo_fechas
cb_3 cb_3
cbx_1 cbx_1
sle_nro_ov sle_nro_ov
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_al761_res_movimiento_ov w_al761_res_movimiento_ov

type variables
Integer ii_index
end variables

on w_al761_res_movimiento_ov.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.sle_nro_ov=create sle_nro_ov
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_nro_ov
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_al761_res_movimiento_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.sle_nro_ov)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
String 	ls_nro_ov

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

SetPointer( Hourglass!)

if cbx_1.checked then
	ls_nro_ov = '%%'
else
	ls_nro_ov = trim(sle_nro_ov.text) + '%'
end if

dw_report.visible = true
ib_preview=false
this.event ue_preview()
//dw_report.SetTransObject( sqlca)

dw_report.retrieve(ld_desde, ld_hasta, ls_nro_ov )	
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(LD_DESDE, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(LD_HASTA, "DD/MM/YYYY")		

dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
	

end event

type dw_report from w_report_smpl`dw_report within w_al761_res_movimiento_ov
integer x = 0
integer y = 312
integer width = 3259
integer height = 1036
string dataobject = "d_rpt_despacho_resumido_ov_tbl"
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al761_res_movimiento_ov
event destroy ( )
integer x = 59
integer y = 64
integer height = 212
integer taborder = 50
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type cb_3 from commandbutton within w_al761_res_movimiento_ov
integer x = 2537
integer y = 36
integer width = 393
integer height = 164
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type cbx_1 from checkbox within w_al761_res_movimiento_ov
integer x = 800
integer y = 180
integer width = 814
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos las Ordenes de Venta"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nro_ov.enabled = false
else
	sle_nro_ov.enabled = true
end if
end event

type sle_nro_ov from singlelineedit within w_al761_res_movimiento_ov
event dobleclick pbm_lbuttondblclk
integer x = 1271
integer y = 68
integer width = 763
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event modified;String 	ls_nro_ov, ls_desc

ls_nro_ov = this.text
if ls_nro_ov = '' or IsNull(ls_nro_ov) then
	MessageBox('Aviso', 'Debe Ingresar un numero de Orden de Venta ')
	return
end if

select ov.obs
	into :ls_desc
from orden_venta ov
where ov.nro_ov = :ls_nro_ov;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Nro de OV ' + ls_nro_ov + ' no existe, por favor verifique!', StopSign!)
	this.text = ''
	return
end if


end event

type st_2 from statictext within w_al761_res_movimiento_ov
integer x = 786
integer y = 80
integer width = 471
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Orden Venta :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_al761_res_movimiento_ov
integer y = 8
integer width = 745
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type gb_2 from groupbox within w_al761_res_movimiento_ov
integer x = 763
integer width = 1746
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

