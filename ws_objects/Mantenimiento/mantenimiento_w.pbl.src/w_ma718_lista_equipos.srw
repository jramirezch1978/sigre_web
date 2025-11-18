$PBExportHeader$w_ma718_lista_equipos.srw
forward
global type w_ma718_lista_equipos from w_report_smpl
end type
type cb_reporte from commandbutton within w_ma718_lista_equipos
end type
type rb_maq from radiobutton within w_ma718_lista_equipos
end type
type rb_equ from radiobutton within w_ma718_lista_equipos
end type
type gb_1 from groupbox within w_ma718_lista_equipos
end type
end forward

global type w_ma718_lista_equipos from w_report_smpl
integer width = 2272
integer height = 1916
string title = "Lista de equipos y/ máquinas (MA717)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_reporte cb_reporte
rb_maq rb_maq
rb_equ rb_equ
gb_1 gb_1
end type
global w_ma718_lista_equipos w_ma718_lista_equipos

on w_ma718_lista_equipos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_reporte=create cb_reporte
this.rb_maq=create rb_maq
this.rb_equ=create rb_equ
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.rb_maq
this.Control[iCurrent+3]=this.rb_equ
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma718_lista_equipos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.rb_maq)
destroy(this.rb_equ)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_flag_maq_equipo

IF rb_maq.checked = true THEN
    ls_flag_maq_equipo='M'
ELSE
   ls_flag_maq_equipo='E'
END IF
    
idw_1.Visible = True
idw_1.Retrieve(ls_flag_maq_equipo)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_codigo.text	= 'Código : FMO-R-002'
idw_1.object.t_revision.text	= 'Revisión : 00'
IF rb_maq.checked = true THEN
    idw_1.object.t_texto.text	= 'LISTA DE MAQUINAS'
ELSE
   idw_1.object.t_texto.text	= 'LISTA DE EQUIPOS'
END IF




end event

type dw_report from w_report_smpl`dw_report within w_ma718_lista_equipos
integer x = 0
integer y = 240
integer width = 2199
integer height = 1528
string dataobject = "d_rpt_lista_maquinas_tbl"
end type

type cb_reporte from commandbutton within w_ma718_lista_equipos
integer x = 882
integer y = 68
integer width = 366
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type rb_maq from radiobutton within w_ma718_lista_equipos
integer x = 78
integer y = 76
integer width = 334
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
string text = "Máquina"
end type

type rb_equ from radiobutton within w_ma718_lista_equipos
integer x = 471
integer y = 76
integer width = 334
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
string text = "Equipo"
end type

type gb_1 from groupbox within w_ma718_lista_equipos
integer x = 46
integer y = 28
integer width = 791
integer height = 148
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

