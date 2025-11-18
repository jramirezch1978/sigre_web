$PBExportHeader$w_sig779_consistencia_partidas.srw
forward
global type w_sig779_consistencia_partidas from w_report_smpl
end type
type sle_ano from singlelineedit within w_sig779_consistencia_partidas
end type
type st_1 from statictext within w_sig779_consistencia_partidas
end type
type cb_1 from commandbutton within w_sig779_consistencia_partidas
end type
type sle_dato from singlelineedit within w_sig779_consistencia_partidas
end type
type st_label from statictext within w_sig779_consistencia_partidas
end type
type rb_cencos from radiobutton within w_sig779_consistencia_partidas
end type
type rb_total from radiobutton within w_sig779_consistencia_partidas
end type
type rb_cuenta from radiobutton within w_sig779_consistencia_partidas
end type
type rb_egreso from radiobutton within w_sig779_consistencia_partidas
end type
type rb_ingreso from radiobutton within w_sig779_consistencia_partidas
end type
type gb_1 from groupbox within w_sig779_consistencia_partidas
end type
type gb_2 from groupbox within w_sig779_consistencia_partidas
end type
end forward

global type w_sig779_consistencia_partidas from w_report_smpl
integer width = 3337
integer height = 1760
string title = "Presupuesto Ejecutado (SIG779)"
string menuname = "m_rpt_simple"
long backcolor = 67108864
sle_ano sle_ano
st_1 st_1
cb_1 cb_1
sle_dato sle_dato
st_label st_label
rb_cencos rb_cencos
rb_total rb_total
rb_cuenta rb_cuenta
rb_egreso rb_egreso
rb_ingreso rb_ingreso
gb_1 gb_1
gb_2 gb_2
end type
global w_sig779_consistencia_partidas w_sig779_consistencia_partidas

type variables
String	is_dw_obj, is_tipo_cuenta
end variables

on w_sig779_consistencia_partidas.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.sle_ano=create sle_ano
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_dato=create sle_dato
this.st_label=create st_label
this.rb_cencos=create rb_cencos
this.rb_total=create rb_total
this.rb_cuenta=create rb_cuenta
this.rb_egreso=create rb_egreso
this.rb_ingreso=create rb_ingreso
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_dato
this.Control[iCurrent+5]=this.st_label
this.Control[iCurrent+6]=this.rb_cencos
this.Control[iCurrent+7]=this.rb_total
this.Control[iCurrent+8]=this.rb_cuenta
this.Control[iCurrent+9]=this.rb_egreso
this.Control[iCurrent+10]=this.rb_ingreso
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_sig779_consistencia_partidas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_dato)
destroy(this.st_label)
destroy(this.rb_cencos)
destroy(this.rb_total)
destroy(this.rb_cuenta)
destroy(this.rb_egreso)
destroy(this.rb_ingreso)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;sle_ano.text = String(Today(), 'yyyy')

dw_report.Object.Datawindow.Print.Orientation = 1

is_dw_obj = 'd_presup_saldos_ejec_tbl'

is_tipo_cuenta = 'E'
end event

type dw_report from w_report_smpl`dw_report within w_sig779_consistencia_partidas
integer x = 18
integer y = 160
integer width = 3090
integer height = 1336
integer taborder = 30
string dataobject = "d_presup_saldos_ejec_tbl"
boolean livescroll = false
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1
String		ls_mes, ls_cencos

CHOOSE CASE dwo.Name
	CASE "ejec_ene" 
		ls_mes = '01'
	CASE "ejec_feb" 
		ls_mes = '02'
	CASE "ejec_mar" 
		ls_mes = '03'
	CASE "ejec_abr" 
		ls_mes = '04'
	CASE "ejec_may" 
		ls_mes = '05'
	CASE "ejec_jun" 
		ls_mes = '06'
	CASE "ejec_jul" 
		ls_mes = '07'
	CASE "ejec_ago" 
		ls_mes = '08'
	CASE "ejec_set" 
		ls_mes = '09'
	CASE "ejec_oct" 
		ls_mes = '10'
	CASE "ejec_nov" 
		ls_mes = '11'
	CASE "ejec_dic" 
		ls_mes = '12'
END CHOOSE

IF rb_total.checked THEN
	ls_cencos = '%%'
ELSE
	ls_cencos = THIS.GetItemString( row, 'cencos') + '%'
END IF

lstr_1.DataObject = 'd_presupuesto_ejec_mes_tbl'
lstr_1.Width = 4000
lstr_1.Height= 1300
lstr_1.Title = 'Presupuesto Ejecutado'
lstr_1.Arg[1] = Trim(sle_ano.text)
lstr_1.Arg[2] = ls_cencos
lstr_1.Arg[3] = THIS.GetItemString( row, 'cnta_prsp')
lstr_1.Arg[4] = ls_mes
lstr_1.Tipo_Cascada = 'C'
of_new_sheet(lstr_1)	
end event

type sle_ano from singlelineedit within w_sig779_consistencia_partidas
integer x = 178
integer y = 16
integer width = 160
integer height = 64
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

type st_1 from statictext within w_sig779_consistencia_partidas
integer x = 18
integer y = 16
integer width = 142
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
string text = "Año :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sig779_consistencia_partidas
integer x = 2944
integer y = 44
integer width = 306
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;Integer 	li_ano
String	ls_dato, ls_label

// Preparar Datawindow
idw_1.dataobject = is_dw_obj
idw_1.SetTransObject(SQLCA)
idw_1.Visible = true
// Adecuar dato
li_ano = Integer(sle_ano.text)
ls_dato = sle_dato.text
IF ls_dato="" or IsNull(ls_dato) THEN
	ls_dato = '%%'
	ls_label = 'Todos'
ELSE
	ls_label = ls_dato
	ls_dato = ls_dato + '%'
END IF
// Lectura
IF rb_cencos.checked THEN
	idw_1.retrieve(li_ano, is_tipo_cuenta, ls_dato)
	ls_label = ' Centro de Costo: ' + ls_label
ELSEIF rb_cuenta.checked THEN
	idw_1.retrieve(li_ano, is_tipo_cuenta, ls_dato)
	IF ls_label = 'Todos' THEN ls_label = 'Todas'
	ls_label = ' Cuenta Presupuestal: ' + ls_label
ELSEIF rb_total.checked THEN
	idw_1.retrieve(li_ano, is_tipo_cuenta)
	ls_label = ''
END IF


idw_1.object.t_subtitulo.text = 'Año: ' + trim(sle_ano.text) + ls_label
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'SIG779'
idw_1.Object.p_logo.filename = gs_logo
end event

type sle_dato from singlelineedit within w_sig779_consistencia_partidas
integer x = 782
integer y = 16
integer width = 498
integer height = 64
integer taborder = 20
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

type st_label from statictext within w_sig779_consistencia_partidas
integer x = 402
integer y = 16
integer width = 370
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
string text = "Centro Costo :"
boolean focusrectangle = false
end type

type rb_cencos from radiobutton within w_sig779_consistencia_partidas
integer x = 1952
integer y = 60
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo"
boolean checked = true
end type

event clicked;st_label.text = 'Centro Costo:'
st_label.visible = true
sle_dato.enabled = true

is_dw_obj = 'd_presup_saldos_ejec_tbl'
end event

type rb_total from radiobutton within w_sig779_consistencia_partidas
integer x = 2610
integer y = 60
integer width = 201
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Total"
end type

event clicked;st_label.visible = false
sle_dato.enabled = false

is_dw_obj = 'd_presup_total_ejec_tbl'
end event

type rb_cuenta from radiobutton within w_sig779_consistencia_partidas
integer x = 2350
integer y = 60
integer width = 251
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta"
end type

event clicked;st_label.text = 'Cuenta:'
st_label.visible = true
sle_dato.enabled = true

is_dw_obj = 'd_presup_cuenta_ejec_tbl'
end event

type rb_egreso from radiobutton within w_sig779_consistencia_partidas
integer x = 1349
integer y = 56
integer width = 261
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Egreso"
boolean checked = true
end type

event clicked;is_tipo_cuenta = 'E'
end event

type rb_ingreso from radiobutton within w_sig779_consistencia_partidas
integer x = 1618
integer y = 56
integer width = 261
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingreso"
end type

event clicked;is_tipo_cuenta = 'I'
end event

type gb_1 from groupbox within w_sig779_consistencia_partidas
integer x = 1307
integer width = 581
integer height = 140
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Partida"
end type

type gb_2 from groupbox within w_sig779_consistencia_partidas
integer x = 1911
integer width = 960
integer height = 140
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Reporte"
end type

