$PBExportHeader$w_pr701_mediciones_grf.srw
forward
global type w_pr701_mediciones_grf from w_report_smpl
end type
type pb_1 from picturebutton within w_pr701_mediciones_grf
end type
type pb_3 from picturebutton within w_pr701_mediciones_grf
end type
type pb_2 from picturebutton within w_pr701_mediciones_grf
end type
type pb_4 from picturebutton within w_pr701_mediciones_grf
end type
type pb_5 from picturebutton within w_pr701_mediciones_grf
end type
type pb_6 from picturebutton within w_pr701_mediciones_grf
end type
end forward

global type w_pr701_mediciones_grf from w_report_smpl
integer width = 3470
integer height = 1900
string title = "Comportamiento de las mediciones por parte de piso(PR701)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 67108864
boolean clientedge = true
boolean center = true
event ue_mousemove pbm_mousemove
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
pb_4 pb_4
pb_5 pb_5
pb_6 pb_6
end type
global w_pr701_mediciones_grf w_pr701_mediciones_grf

type variables
string is_nro_parte, is_formato, is_cod_maquina, is_atributo
end variables

on w_pr701_mediciones_grf.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_4=create pb_4
this.pb_5=create pb_5
this.pb_6=create pb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_3
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.pb_5
this.Control[iCurrent+6]=this.pb_6
end on

on w_pr701_mediciones_grf.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.pb_6)
end on

event ue_retrieve;string ls_fecha
long ll_cuenta

ll_cuenta = 0
dw_report.visible = false
dw_report.reset()
declare usp_pr_valgrf procedure for 
	usp_pr_parte_piso_valgrf(:is_nro_parte, :is_cod_maquina, :is_atributo);
	
execute usp_pr_valgrf;

fetch usp_pr_valgrf into :ll_cuenta, :ls_fecha;

if ll_cuenta >= 1 then
	dw_report.retrieve()
	idw_1.Object.p_logo.filename = gs_logo
	idw_1.object.t_empresa.text = gs_empresa
	idw_1.object.t_user.text = 'Impreso por: ' + trim(gs_user)
	idw_1.object.t_date.text = 'Fecha de impresión: ' + trim(ls_fecha)
	dw_report.visible = true
	close usp_pr_valgrf;
else
	messagebox(this.title,'No hay datos para mostrar',StopSign!)
	close(this)
	close usp_pr_valgrf;
	return
end if

end event

event open;call super::open;string ls_cadena
ls_cadena = Message.StringParm

is_nro_parte = trim(mid(ls_cadena,1,10))
is_formato = trim(mid(ls_cadena,11,8))
is_cod_maquina = trim(mid(ls_cadena,19,8))
is_atributo = trim(mid(ls_cadena,27,4))

this.event ue_retrieve()

end event

type dw_report from w_report_smpl`dw_report within w_pr701_mediciones_grf
event ue_mousemove pbm_mousemove
integer x = 0
integer y = 92
integer width = 3461
integer height = 1432
string dataobject = "d_pr_parte_diario_lec_cst"
end type

event dw_report::ue_mousemove;//int		li_Rtn, li_Series, li_Category
//string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
//long ll_row
//grObjectType	MouseMoveObject
//	
//MouseMoveObject = this.object.dw_2.ObjectAtPointer('gr_1', li_Series, li_category)
//
//if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then
//	
//	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
//	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
//	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
//
//	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
//
//	st_etiqueta.BringToTop = TRUE
////	st_etiqueta.x = xpos
////	st_etiqueta.y = ypos
//	st_etiqueta.text = ls_mensaje
//	st_etiqueta.width = len(ls_mensaje) * 30
//	st_etiqueta.visible = true
//else
//	st_etiqueta.visible = false
//end if
end event

type pb_1 from picturebutton within w_pr701_mediciones_grf
event ue_copygraph ( )
integer width = 101
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Print!"
alignment htextalign = left!
end type

event ue_copygraph();idw_1.Clipboard("gr_1")
end event

event clicked;idw_1.event ue_print()
end event

type pb_3 from picturebutton within w_pr701_mediciones_grf
integer x = 146
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Retrieve!"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()
end event

type pb_2 from picturebutton within w_pr701_mediciones_grf
integer x = 293
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "EditDataGrid!"
alignment htextalign = left!
end type

event clicked;Parent.Post Dynamic Event ue_zoom(0)
end event

type pb_4 from picturebutton within w_pr701_mediciones_grf
integer x = 389
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Custom033!"
alignment htextalign = left!
end type

event clicked;Parent.Post Dynamic Event ue_zoom(1)
end event

type pb_5 from picturebutton within w_pr701_mediciones_grf
integer x = 485
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Custom034!"
alignment htextalign = left!
end type

event clicked;Parent.Post Dynamic Event ue_zoom(-1)
end event

type pb_6 from picturebutton within w_pr701_mediciones_grf
integer x = 640
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Window!"
alignment htextalign = left!
end type

event clicked;close (parent)
end event

