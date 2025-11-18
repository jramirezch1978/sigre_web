$PBExportHeader$w_cm723_cmpsug_criticas_alm.srw
forward
global type w_cm723_cmpsug_criticas_alm from w_rpt
end type
type rb_2 from radiobutton within w_cm723_cmpsug_criticas_alm
end type
type rb_1 from radiobutton within w_cm723_cmpsug_criticas_alm
end type
type rb_det from radiobutton within w_cm723_cmpsug_criticas_alm
end type
type rb_res from radiobutton within w_cm723_cmpsug_criticas_alm
end type
type sle_almacen from singlelineedit within w_cm723_cmpsug_criticas_alm
end type
type st_almacen from statictext within w_cm723_cmpsug_criticas_alm
end type
type st_2 from statictext within w_cm723_cmpsug_criticas_alm
end type
type st_1 from statictext within w_cm723_cmpsug_criticas_alm
end type
type sle_ult_oc from singlelineedit within w_cm723_cmpsug_criticas_alm
end type
type dw_report from u_dw_rpt within w_cm723_cmpsug_criticas_alm
end type
type cb_1 from commandbutton within w_cm723_cmpsug_criticas_alm
end type
type uo_fecha from u_ingreso_fecha within w_cm723_cmpsug_criticas_alm
end type
end forward

global type w_cm723_cmpsug_criticas_alm from w_rpt
integer x = 283
integer y = 248
integer width = 3113
integer height = 1440
string title = "Compras Artículos Críticos [CM723]"
string menuname = "m_impresion"
long backcolor = 79741120
rb_2 rb_2
rb_1 rb_1
rb_det rb_det
rb_res rb_res
sle_almacen sle_almacen
st_almacen st_almacen
st_2 st_2
st_1 st_1
sle_ult_oc sle_ult_oc
dw_report dw_report
cb_1 cb_1
uo_fecha uo_fecha
end type
global w_cm723_cmpsug_criticas_alm w_cm723_cmpsug_criticas_alm

on w_cm723_cmpsug_criticas_alm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_det=create rb_det
this.rb_res=create rb_res
this.sle_almacen=create sle_almacen
this.st_almacen=create st_almacen
this.st_2=create st_2
this.st_1=create st_1
this.sle_ult_oc=create sle_ult_oc
this.dw_report=create dw_report
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_det
this.Control[iCurrent+4]=this.rb_res
this.Control[iCurrent+5]=this.sle_almacen
this.Control[iCurrent+6]=this.st_almacen
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_ult_oc
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.uo_fecha
end on

on w_cm723_cmpsug_criticas_alm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_det)
destroy(this.rb_res)
destroy(this.sle_almacen)
destroy(this.st_almacen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_ult_oc)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.uo_fecha)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic

idw_1.SetTransObject( SQLCA )

end event

event ue_retrieve();call super::ue_retrieve;dw_report.Retrieve()
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type rb_2 from radiobutton within w_cm723_cmpsug_criticas_alm
integer x = 1243
integer y = 40
integer width = 375
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Muestra OC"
boolean checked = true
end type

event clicked;dw_report.dataObject = "d_rpt_compras_sug_rep_stk"
dw_report.SetTransObject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

sle_ult_oc.enabled = false


end event

type rb_1 from radiobutton within w_cm723_cmpsug_criticas_alm
integer x = 1614
integer y = 40
integer width = 425
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No mostrar OC"
end type

event clicked;dw_report.dataObject = "d_rpt_comp_sug_rep_stk_soc"
dw_report.SetTransObject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

sle_ult_oc.enabled = false
end event

type rb_det from radiobutton within w_cm723_cmpsug_criticas_alm
integer x = 46
integer y = 44
integer width = 293
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

event clicked;dw_report.dataObject = "d_rpt_compras_sugeridas_det_403"
dw_report.SetTransObject(sqlca)

//dw_report.Object.DataWindow.Print.Preview = 'Yes'
//ib_preview = true

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject



end event

type rb_res from radiobutton within w_cm723_cmpsug_criticas_alm
integer x = 384
integer y = 44
integer width = 352
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

event clicked;dw_report.dataObject = "d_rpt_compras_sugeridas_res"
dw_report.SetTransObject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

type sle_almacen from singlelineedit within w_cm723_cmpsug_criticas_alm
event dobleclick pbm_lbuttondblclk
integer x = 315
integer y = 152
integer width = 315
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
		  + "DESC_almacen AS DESCRIPCION_almacen " &
		  + "FROM almacen "  &
		  + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		 = ls_codigo
	st_almacen.text = ls_data
end if

end event

type st_almacen from statictext within w_cm723_cmpsug_criticas_alm
integer x = 645
integer y = 164
integer width = 1417
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm723_cmpsug_criticas_alm
integer x = 32
integer y = 164
integer width = 274
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacén"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm723_cmpsug_criticas_alm
integer x = 745
integer y = 60
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "# de ult. O.C."
boolean focusrectangle = false
end type

type sle_ult_oc from singlelineedit within w_cm723_cmpsug_criticas_alm
integer x = 1065
integer y = 40
integer width = 151
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "3"
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_report from u_dw_rpt within w_cm723_cmpsug_criticas_alm
integer y = 248
integer width = 2999
integer height = 904
boolean bringtotop = true
string dataobject = "d_rpt_compras_sug_rep_stk"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_cm723_cmpsug_criticas_alm
integer x = 2679
integer y = 32
integer width = 302
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Date 		ld_fecha
string 	ls_msg, ls_almacen
integer	li_ult_oc

ls_almacen = sle_almacen.text

if IsNull(ls_almacen) or ls_almacen = '' then
	MessageBox('Error', 'Debe especificar algun almacen')
	return
end if

SetPointer( hourglass!)
ld_fecha = uo_fecha.of_get_fecha()
li_ult_oc = Integer(sle_ult_oc.text)

//create or replace procedure USP_CMP_CRITICO_X_ALM(
//       adi_fecha    in date,
//       asi_origen   in origen.cod_origen%TYPE,
//       ani_nro_oc   in number,                  -- # de Ordenes de Compra a mostrar
//       asi_almacen  in almacen.almacen%TYPE
//) is
	
DECLARE USP_CMP_CRITICO_X_ALM PROCEDURE FOR 
		USP_CMP_CRITICO_X_ALM( :ld_fecha, 
									  :gs_origen, 
									  :li_ult_oc,
									  :ls_almacen );
EXECUTE USP_CMP_CRITICO_X_ALM;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_CRITICO_X_ALM", ls_msg)
	Return
END IF

CLOSE USP_CMP_CRITICO_X_ALM;
	
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
ib_preview = true

Parent.event ue_retrieve()

dw_report.object.t_fecha.text   = STRING(ld_fecha, "DD/MM/YYYY")
dw_report.object.t_almacen.text = ls_almacen + ' - ' + st_almacen.text
SetPointer(Arrow!)


end event

type uo_fecha from u_ingreso_fecha within w_cm723_cmpsug_criticas_alm
event destroy ( )
integer x = 32
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;string ls_inicio 
date ld_fec_ini, ld_Fec_fin
integer li_dia

of_set_label('Hasta:') //para setear la fecha inicial
of_set_fecha(today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1()  para leer las fechas

end event

