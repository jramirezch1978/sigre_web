$PBExportHeader$w_ve741_precio_promedio_x_art.srw
forward
global type w_ve741_precio_promedio_x_art from w_rpt
end type
type st_3 from statictext within w_ve741_precio_promedio_x_art
end type
type pb_1 from picturebutton within w_ve741_precio_promedio_x_art
end type
type sle_desc_art from singlelineedit within w_ve741_precio_promedio_x_art
end type
type st_2 from statictext within w_ve741_precio_promedio_x_art
end type
type st_1 from statictext within w_ve741_precio_promedio_x_art
end type
type em_ano from editmask within w_ve741_precio_promedio_x_art
end type
type sle_cod_art from singlelineedit within w_ve741_precio_promedio_x_art
end type
type cb_2 from commandbutton within w_ve741_precio_promedio_x_art
end type
type cb_1 from commandbutton within w_ve741_precio_promedio_x_art
end type
type dw_grafico from u_dw_grf within w_ve741_precio_promedio_x_art
end type
type dw_report from u_dw_rpt within w_ve741_precio_promedio_x_art
end type
type gb_1 from groupbox within w_ve741_precio_promedio_x_art
end type
end forward

global type w_ve741_precio_promedio_x_art from w_rpt
integer width = 4119
integer height = 2180
string title = "Precio Promedio Articulo Facturado (VE741)"
string menuname = "m_reporte"
long backcolor = 12632256
st_3 st_3
pb_1 pb_1
sle_desc_art sle_desc_art
st_2 st_2
st_1 st_1
em_ano em_ano
sle_cod_art sle_cod_art
cb_2 cb_2
cb_1 cb_1
dw_grafico dw_grafico
dw_report dw_report
gb_1 gb_1
end type
global w_ve741_precio_promedio_x_art w_ve741_precio_promedio_x_art

type variables
String is_doc_ov
end variables

on w_ve741_precio_promedio_x_art.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_3=create st_3
this.pb_1=create pb_1
this.sle_desc_art=create sle_desc_art
this.st_2=create st_2
this.st_1=create st_1
this.em_ano=create em_ano
this.sle_cod_art=create sle_cod_art
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_grafico=create dw_grafico
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.sle_desc_art
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.sle_cod_art
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_grafico
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_ve741_precio_promedio_x_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.sle_desc_art)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.sle_cod_art)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_grafico)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
dw_grafico.SetTransObject(sqlca)

//ib_preview= FALSE
//This.Event ue_preview()

dw_report.sharedata(dw_grafico)


SELECT L.DOC_OV into :is_doc_ov FROM LOGPARAM L WHERE L.RECKEY = '1' ;        

end event

event ue_retrieve;call super::ue_retrieve;String ls_cod_art 
Long 	 ll_ano

ls_cod_art = sle_cod_art.Text
ll_ano	  = Long(em_ano.text)	

dw_report.Retrieve(ls_cod_art,ll_ano)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text	= gs_empresa
dw_report.object.t_user.text 		= gs_user
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x

dw_grafico.width   = newwidth  - dw_report.x
dw_grafico.height = newheight - dw_grafico.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

type st_3 from statictext within w_ve741_precio_promedio_x_art
integer x = 3397
integer y = 244
integer width = 631
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217752
string text = "Imprimir Grafico"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ve741_precio_promedio_x_art
integer x = 3557
integer y = 16
integer width = 311
integer height = 220
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Jpg\print.jpg"
alignment htextalign = left!
end type

event clicked;dw_grafico.Print()
end event

type sle_desc_art from singlelineedit within w_ve741_precio_promedio_x_art
integer x = 983
integer y = 100
integer width = 1413
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217752
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve741_precio_promedio_x_art
integer x = 55
integer y = 104
integer width = 279
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve741_precio_promedio_x_art
integer x = 155
integer y = 212
integer width = 178
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_ve741_precio_promedio_x_art
integer x = 370
integer y = 200
integer width = 174
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type sle_cod_art from singlelineedit within w_ve741_precio_promedio_x_art
integer x = 370
integer y = 100
integer width = 466
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ve741_precio_promedio_x_art
integer x = 2455
integer y = 196
integer width = 466
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.TriggerEvent('ue_retrieve')
end event

type cb_1 from commandbutton within w_ve741_precio_promedio_x_art
integer x = 859
integer y = 100
integer width = 101
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'

lstr_seleccionar.s_sql =  'SELECT ART.COD_ART AS CODIGO, '&
   							        +'ART.NOM_ARTICULO AS DESCRIPCION '&
										  +'FROM ARTICULO ART '
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cod_art.text  = lstr_seleccionar.param1[1]
	sle_desc_art.text = lstr_seleccionar.param2[1]
ELSE
	sle_cod_art.text  = ''
	sle_desc_art.text = '' 
END IF

end event

type dw_grafico from u_dw_grf within w_ve741_precio_promedio_x_art
integer x = 27
integer y = 1160
integer width = 4018
integer height = 820
integer taborder = 20
string dataobject = "d_abc_pprom_x_salida_grf"
end type

type dw_report from u_dw_rpt within w_ve741_precio_promedio_x_art
integer x = 27
integer y = 320
integer width = 4018
integer height = 820
string dataobject = "d_abc_pprom_x_salida_tbl"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ve741_precio_promedio_x_art
integer x = 32
integer y = 24
integer width = 2391
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

