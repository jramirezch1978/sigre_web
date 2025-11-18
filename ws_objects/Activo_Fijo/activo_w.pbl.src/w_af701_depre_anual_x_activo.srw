$PBExportHeader$w_af701_depre_anual_x_activo.srw
forward
global type w_af701_depre_anual_x_activo from w_rpt
end type
type sle_activo from singlelineedit within w_af701_depre_anual_x_activo
end type
type st_descripcion from statictext within w_af701_depre_anual_x_activo
end type
type pb_aceptar from picturebutton within w_af701_depre_anual_x_activo
end type
type dw_report from u_dw_rpt within w_af701_depre_anual_x_activo
end type
type gb_2 from groupbox within w_af701_depre_anual_x_activo
end type
end forward

global type w_af701_depre_anual_x_activo from w_rpt
integer width = 3360
integer height = 2096
string title = "[AF701]Depreciación Anual x Activo"
string menuname = "m_reporte"
long backcolor = 67108864
sle_activo sle_activo
st_descripcion st_descripcion
pb_aceptar pb_aceptar
dw_report dw_report
gb_2 gb_2
end type
global w_af701_depre_anual_x_activo w_af701_depre_anual_x_activo

type variables

end variables

on w_af701_depre_anual_x_activo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_activo=create sle_activo
this.st_descripcion=create st_descripcion
this.pb_aceptar=create pb_aceptar
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_activo
this.Control[iCurrent+2]=this.st_descripcion
this.Control[iCurrent+3]=this.pb_aceptar
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_2
end on

on w_af701_depre_anual_x_activo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_activo)
destroy(this.st_descripcion)
destroy(this.pb_aceptar)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)




end event

event ue_retrieve;call super::ue_retrieve;String ls_activo

ls_activo = sle_activo.text

idw_1.Retrieve(ls_activo)

idw_1.Visible = True
THIS.Event ue_preview()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_usuario.text = gs_user
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type sle_activo from singlelineedit within w_af701_depre_anual_x_activo
event dobleclick pbm_lbuttondblclk
integer x = 87
integer y = 100
integer width = 361
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_ACTIVO AS CODIGO_ACTIVO, " &
		  + "DESCRIPCION AS DESCRIPCION " &
		  + "FROM AF_MAESTRO " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	This.text 				= ls_codigo
	st_descripcion.text  = ls_data
END IF

end event

event modified;String 	ls_cod_activo, ls_desc, ls_null

SetNull(ls_null)

ls_cod_activo = sle_activo.text

IF ls_cod_activo = '' OR IsNull(ls_cod_activo) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Activo')
	RETURN
END IF

SELECT DESCRIPCION
	INTO :ls_desc
FROM AF_MAESTRO
WHERE COD_ACTIVO = :ls_cod_activo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ACTIVO no existe')
	st_descripcion.text = ls_null
	This.text			  = ls_null
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type st_descripcion from statictext within w_af701_depre_anual_x_activo
integer x = 471
integer y = 100
integer width = 1221
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_aceptar from picturebutton within w_af701_depre_anual_x_activo
integer x = 2478
integer y = 72
integer width = 306
integer height = 148
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;String  ls_activo

ls_activo = sle_activo.text

IF IsNull(ls_activo) OR LEN(ls_activo) = 0 THEN
	messagebox('Aviso', 'Por favor ingrese un codigo de ACTIVO FIJO')
	RETURN 1
END IF

Parent.Event ue_retrieve()




end event

type dw_report from u_dw_rpt within w_af701_depre_anual_x_activo
integer x = 5
integer y = 268
integer width = 3273
integer height = 1632
integer taborder = 30
string dataobject = "dw_rpt_detalle_depre_x_activo_tbl"
end type

type gb_2 from groupbox within w_af701_depre_anual_x_activo
integer x = 64
integer y = 32
integer width = 1650
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217750
string text = "Activo Fijo"
end type

