$PBExportHeader$w_ope713_oper_program_a_facturar.srw
forward
global type w_ope713_oper_program_a_facturar from w_rpt
end type
type cb_2 from commandbutton within w_ope713_oper_program_a_facturar
end type
type sle_descripcion from singlelineedit within w_ope713_oper_program_a_facturar
end type
type cb_1 from commandbutton within w_ope713_oper_program_a_facturar
end type
type sle_ot from singlelineedit within w_ope713_oper_program_a_facturar
end type
type st_1 from statictext within w_ope713_oper_program_a_facturar
end type
type dw_report from u_dw_rpt within w_ope713_oper_program_a_facturar
end type
end forward

global type w_ope713_oper_program_a_facturar from w_rpt
integer width = 2930
integer height = 1648
string title = "Operaciones programadas a facturar (OPE713)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cb_2 cb_2
sle_descripcion sle_descripcion
cb_1 cb_1
sle_ot sle_ot
st_1 st_1
dw_report dw_report
end type
global w_ope713_oper_program_a_facturar w_ope713_oper_program_a_facturar

on w_ope713_oper_program_a_facturar.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_2=create cb_2
this.sle_descripcion=create sle_descripcion
this.cb_1=create cb_1
this.sle_ot=create sle_ot
this.st_1=create st_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_ot
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_report
end on

on w_ope713_oper_program_a_facturar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.sle_descripcion)
destroy(this.cb_1)
destroy(this.sle_ot)
destroy(this.st_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()


end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve();call super::ue_retrieve;String ls_ot, ls_ejecutor

ls_ot = sle_ot.text

SELECT ejecutor_3ro INTO :ls_ejecutor 
FROM prod_param WHERE reckey='1' ;

if Isnull(ls_ot) or Trim(ls_ot) = '' then
	Messagebox('Aviso','Debe Seleccionar una Administración de Orden de Trabajo')
	Return
end if

idw_1.Retrieve(ls_ot, ls_ejecutor, gs_empresa, gs_user)
idw_1.Object.p_logo.filename = gs_logo
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter();call super::ue_filter;idw_1.GroupCalc()
end event

type cb_2 from commandbutton within w_ope713_oper_program_a_facturar
integer x = 1829
integer y = 120
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_descripcion from singlelineedit within w_ope713_oper_program_a_facturar
integer x = 549
integer y = 128
integer width = 1243
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ope713_oper_program_a_facturar
integer x = 402
integer y = 128
integer width = 123
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO, '&   
										 +'OT_ADMINISTRACION.DESCRIPCION  AS DESCRIPCION  '&   
										 +'FROM  OT_ADMINISTRACION '&
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_ot.text          = lstr_seleccionar.param1[1]
		sle_descripcion.text = lstr_seleccionar.param2[1]
	 END IF	 	
end event

type sle_ot from singlelineedit within w_ope713_oper_program_a_facturar
integer x = 37
integer y = 128
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_ot_adm,ls_desc
Long   ll_count


ls_ot_adm = This.Text

select count(*) into :ll_count
  from ot_administracion 
 where (ot_adm = :ls_ot_adm );

 
if ll_count > 0 then
	
	select descripcion into :ls_desc
	  from ot_administracion 
	 where (ot_adm = :ls_ot_adm );
	
	sle_descripcion.text = ls_desc
else
	
	setnull(ls_desc)
	
	sle_descripcion.text = ls_desc
	
end if



end event

type st_1 from statictext within w_ope713_oper_program_a_facturar
integer x = 37
integer y = 32
integer width = 1280
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Busqueda por Adminitración de Orden de Trabajo :"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_ope713_oper_program_a_facturar
integer y = 256
integer width = 1426
integer height = 704
string dataobject = "d_facturacion_operac_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

