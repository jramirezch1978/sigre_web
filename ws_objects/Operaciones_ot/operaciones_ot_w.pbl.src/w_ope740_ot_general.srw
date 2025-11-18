$PBExportHeader$w_ope740_ot_general.srw
forward
global type w_ope740_ot_general from w_report_smpl
end type
type cb_lectura from commandbutton within w_ope740_ot_general
end type
type rb_origen from radiobutton within w_ope740_ot_general
end type
type rb_cencos from radiobutton within w_ope740_ot_general
end type
type rb_ot_adm from radiobutton within w_ope740_ot_general
end type
type rb_ot_tipo from radiobutton within w_ope740_ot_general
end type
type rb_ot_todos from radiobutton within w_ope740_ot_general
end type
type ddlb_origen from u_ddlb within w_ope740_ot_general
end type
type ddlb_cencos from u_ddlb within w_ope740_ot_general
end type
type ddlb_ot_adm from u_ddlb within w_ope740_ot_general
end type
type ddlb_ot_tipo from u_ddlb within w_ope740_ot_general
end type
type rb_estado from radiobutton within w_ope740_ot_general
end type
type rb_estado_todos from radiobutton within w_ope740_ot_general
end type
type ddlb_estado from dropdownlistbox within w_ope740_ot_general
end type
type uo_fechas from u_ingreso_rango_fechas within w_ope740_ot_general
end type
type gb_1 from groupbox within w_ope740_ot_general
end type
type gb_3 from groupbox within w_ope740_ot_general
end type
type gb_2 from groupbox within w_ope740_ot_general
end type
end forward

global type w_ope740_ot_general from w_report_smpl
integer width = 3323
integer height = 1596
string title = "OT General (OPE740)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_lectura cb_lectura
rb_origen rb_origen
rb_cencos rb_cencos
rb_ot_adm rb_ot_adm
rb_ot_tipo rb_ot_tipo
rb_ot_todos rb_ot_todos
ddlb_origen ddlb_origen
ddlb_cencos ddlb_cencos
ddlb_ot_adm ddlb_ot_adm
ddlb_ot_tipo ddlb_ot_tipo
rb_estado rb_estado
rb_estado_todos rb_estado_todos
ddlb_estado ddlb_estado
uo_fechas uo_fechas
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_ope740_ot_general w_ope740_ot_general

type variables
Integer	ii_estado_index
end variables

on w_ope740_ot_general.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_lectura=create cb_lectura
this.rb_origen=create rb_origen
this.rb_cencos=create rb_cencos
this.rb_ot_adm=create rb_ot_adm
this.rb_ot_tipo=create rb_ot_tipo
this.rb_ot_todos=create rb_ot_todos
this.ddlb_origen=create ddlb_origen
this.ddlb_cencos=create ddlb_cencos
this.ddlb_ot_adm=create ddlb_ot_adm
this.ddlb_ot_tipo=create ddlb_ot_tipo
this.rb_estado=create rb_estado
this.rb_estado_todos=create rb_estado_todos
this.ddlb_estado=create ddlb_estado
this.uo_fechas=create uo_fechas
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.rb_origen
this.Control[iCurrent+3]=this.rb_cencos
this.Control[iCurrent+4]=this.rb_ot_adm
this.Control[iCurrent+5]=this.rb_ot_tipo
this.Control[iCurrent+6]=this.rb_ot_todos
this.Control[iCurrent+7]=this.ddlb_origen
this.Control[iCurrent+8]=this.ddlb_cencos
this.Control[iCurrent+9]=this.ddlb_ot_adm
this.Control[iCurrent+10]=this.ddlb_ot_tipo
this.Control[iCurrent+11]=this.rb_estado
this.Control[iCurrent+12]=this.rb_estado_todos
this.Control[iCurrent+13]=this.ddlb_estado
this.Control[iCurrent+14]=this.uo_fechas
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_2
end on

on w_ope740_ot_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.rb_origen)
destroy(this.rb_cencos)
destroy(this.rb_ot_adm)
destroy(this.rb_ot_tipo)
destroy(this.rb_ot_todos)
destroy(this.ddlb_origen)
destroy(this.ddlb_cencos)
destroy(this.ddlb_ot_adm)
destroy(this.ddlb_ot_tipo)
destroy(this.rb_estado)
destroy(this.rb_estado_todos)
destroy(this.ddlb_estado)
destroy(this.uo_fechas)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True
end event

event ue_retrieve;call super::ue_retrieve;Date	ld_inicio, ld_fin

ld_inicio = uo_fechas.of_get_fecha1()
ld_fin = uo_fechas.of_get_fecha2()























//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text = gs_empresa
//idw_1.object.t_user.text = gs_user


end event

type dw_report from w_report_smpl`dw_report within w_ope740_ot_general
integer x = 18
integer y = 508
integer width = 3227
integer height = 840
string dataobject = "d_ot_general_tbl"
end type

type cb_lectura from commandbutton within w_ope740_ot_general
integer x = 2939
integer y = 72
integer width = 297
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
boolean default = true
end type

event clicked;PARENT.EVENT ue_retrieve()

end event

type rb_origen from radiobutton within w_ope740_ot_general
integer x = 41
integer y = 64
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
end type

type rb_cencos from radiobutton within w_ope740_ot_general
integer x = 41
integer y = 168
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo"
end type

type rb_ot_adm from radiobutton within w_ope740_ot_general
integer x = 41
integer y = 280
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Adm"
end type

type rb_ot_tipo from radiobutton within w_ope740_ot_general
integer x = 41
integer y = 388
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Tipo"
end type

type rb_ot_todos from radiobutton within w_ope740_ot_general
integer x = 1509
integer y = 56
integer width = 270
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas"
end type

type ddlb_origen from u_ddlb within w_ope740_ot_general
integer x = 526
integer y = 56
integer width = 937
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;//is_dataobject = 'd_adm_tbl'

//ii_cn1 = 1                     // Nro del campo 1
//ii_cn2 = 2                     // Nro del campo 2
//ii_ck  = 1                     // Nro del campo key
//ii_lc1 = 1                     // Longitud del campo 1
//ii_lc2 = 1							// Longitud del campo 2
end event

type ddlb_cencos from u_ddlb within w_ope740_ot_general
integer x = 526
integer y = 160
integer width = 937
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

type ddlb_ot_adm from u_ddlb within w_ope740_ot_general
integer x = 526
integer y = 268
integer width = 937
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
end type

type ddlb_ot_tipo from u_ddlb within w_ope740_ot_general
integer x = 526
integer y = 372
integer width = 937
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
end type

type rb_estado from radiobutton within w_ope740_ot_general
integer x = 1888
integer y = 80
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado"
end type

type rb_estado_todos from radiobutton within w_ope740_ot_general
integer x = 1888
integer y = 172
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type ddlb_estado from dropdownlistbox within w_ope740_ot_general
integer x = 2171
integer y = 72
integer width = 581
integer height = 352
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Anulado","Abierto","Terminado","Planeado"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;ii_estado_index = index - 1
end event

type uo_fechas from u_ingreso_rango_fechas within w_ope740_ot_general
integer x = 1906
integer y = 364
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(RelativeDate(today(),-30), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_1 from groupbox within w_ope740_ot_general
integer x = 1838
integer y = 292
integer width = 1399
integer height = 188
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione Fecha de Registro:"
end type

type gb_3 from groupbox within w_ope740_ot_general
integer x = 18
integer y = 8
integer width = 1797
integer height = 476
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione OT :"
end type

type gb_2 from groupbox within w_ope740_ot_general
integer x = 1842
integer y = 4
integer width = 928
integer height = 256
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione :"
end type

