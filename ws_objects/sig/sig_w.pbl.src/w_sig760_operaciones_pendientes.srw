$PBExportHeader$w_sig760_operaciones_pendientes.srw
forward
global type w_sig760_operaciones_pendientes from w_report_smpl
end type
type uo_fecha from u_ingreso_fecha within w_sig760_operaciones_pendientes
end type
type cb_1 from commandbutton within w_sig760_operaciones_pendientes
end type
type rb_desprogramadas from radiobutton within w_sig760_operaciones_pendientes
end type
type rb_atrazadas from radiobutton within w_sig760_operaciones_pendientes
end type
type gb_1 from groupbox within w_sig760_operaciones_pendientes
end type
end forward

global type w_sig760_operaciones_pendientes from w_report_smpl
integer width = 2455
integer height = 1644
string title = "Operaciones x Reprogramar (SIG760)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
uo_fecha uo_fecha
cb_1 cb_1
rb_desprogramadas rb_desprogramadas
rb_atrazadas rb_atrazadas
gb_1 gb_1
end type
global w_sig760_operaciones_pendientes w_sig760_operaciones_pendientes

type variables
String	is_dw = 'D'
end variables

on w_sig760_operaciones_pendientes.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.rb_desprogramadas=create rb_desprogramadas
this.rb_atrazadas=create rb_atrazadas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_desprogramadas
this.Control[iCurrent+4]=this.rb_atrazadas
this.Control[iCurrent+5]=this.gb_1
end on

on w_sig760_operaciones_pendientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.rb_desprogramadas)
destroy(this.rb_atrazadas)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date	ld_fecha

ld_fecha = uo_fecha.of_get_fecha()

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Retrieve(ld_fecha)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_fecha.text = String(ld_fecha, 'dd/mm/yyyy')
end event

event ue_open_pre;call super::ue_open_pre;is_dw = 'D'
idw_1.Dataobject = 'd_operaciones_desprogramadas'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")


end event

type dw_report from w_report_smpl`dw_report within w_sig760_operaciones_pendientes
integer x = 0
integer y = 208
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_labor" 
		lstr_1.DataObject = 'd_labor_ff'
		lstr_1.Width = 2500
		lstr_1.Height= 650
		lstr_1.Arg[1] = GetItemString(row,'cod_labor')
		lstr_1.Title = 'Labor'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type uo_fecha from u_ingreso_fecha within w_sig760_operaciones_pendientes
integer x = 18
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Hasta:') 
 of_set_fecha(RelativeDate(Today(),-1))
 of_set_rango_inicio(date('01/01/2000')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_sig760_operaciones_pendientes
integer x = 1975
integer y = 68
integer width = 402
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()

end event

type rb_desprogramadas from radiobutton within w_sig760_operaciones_pendientes
integer x = 718
integer y = 76
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Desprogramadas"
boolean checked = true
end type

event clicked;is_dw = 'D'
idw_1.Dataobject = 'd_operaciones_desprogramadas'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))

end event

type rb_atrazadas from radiobutton within w_sig760_operaciones_pendientes
integer x = 1280
integer y = 80
integer width = 375
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Atrazadas"
end type

event clicked;is_dw = 'A'
idw_1.Dataobject = 'd_operaciones_atrazadas'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))

end event

type gb_1 from groupbox within w_sig760_operaciones_pendientes
integer x = 667
integer y = 12
integer width = 1033
integer height = 164
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Tipo de Operaciones"
end type

