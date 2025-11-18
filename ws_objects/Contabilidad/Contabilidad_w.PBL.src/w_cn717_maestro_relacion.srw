$PBExportHeader$w_cn717_maestro_relacion.srw
forward
global type w_cn717_maestro_relacion from w_report_smpl
end type
type cb_1 from commandbutton within w_cn717_maestro_relacion
end type
type rb_1 from radiobutton within w_cn717_maestro_relacion
end type
type rb_2 from radiobutton within w_cn717_maestro_relacion
end type
type st_1 from statictext within w_cn717_maestro_relacion
end type
type rb_3 from radiobutton within w_cn717_maestro_relacion
end type
end forward

global type w_cn717_maestro_relacion from w_report_smpl
integer width = 3081
integer height = 1804
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
st_1 st_1
rb_3 rb_3
end type
global w_cn717_maestro_relacion w_cn717_maestro_relacion

type variables
String is_opcion
end variables

on w_cn717_maestro_relacion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rb_3
end on

on w_cn717_maestro_relacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rb_3)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Visible = true

// ii_help = 101           // help topic

//dw_report.Object.Datawindow.Print.Orientation = 1    // 0=defa
end event

event ue_retrieve;call super::ue_retrieve;//idw_1.Retrieve(gs_empresa)
//idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_cn717_maestro_relacion
integer x = 27
integer y = 324
integer width = 3003
integer height = 1272
string dataobject = "d_rpt_proveedor_tbl"
end type

type cb_1 from commandbutton within w_cn717_maestro_relacion
integer x = 2642
integer y = 100
integer width = 297
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera"
end type

event clicked;dw_report.SetTransObject(SQLCA)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text   = gs_empresa
dw_report.object.t_usuario.text     = gs_user
dw_report.Retrieve()
if is_opcion='N' then
	dw_report.SetSort("proveedor A, nom_proveedor A")
	dw_report.Sort()
end if
parent.event ue_preview()
end event

type rb_1 from radiobutton within w_cn717_maestro_relacion
integer x = 73
integer y = 72
integer width = 343
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
boolean enabled = false
string text = "Por código"
end type

event clicked;is_opcion='C'			// Codigo
dw_report.object.t_subtitulo.text   = 'Por código'
//dw_report.SetSort("proveedor A, proveedor A")
//dw_report.Sort()
end event

type rb_2 from radiobutton within w_cn717_maestro_relacion
integer x = 73
integer y = 132
integer width = 667
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
boolean enabled = false
string text = "Por nombre / razón social"
end type

event clicked;is_opcion='N'		//Nombre o Razon social
dw_report.object.t_subtitulo.text   = 'Por razon social'

end event

type st_1 from statictext within w_cn717_maestro_relacion
integer x = 992
integer y = 100
integer width = 1207
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte de maestro de relaciones"
boolean focusrectangle = false
end type

type rb_3 from radiobutton within w_cn717_maestro_relacion
integer x = 73
integer y = 196
integer width = 343
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
boolean enabled = false
string text = "RUC"
end type

event clicked;is_opcion='R'		//RUC
dw_report.object.t_subtitulo.text   = 'Por RUC'
dw_report.SetSort("proveedor A, ruc A")
dw_report.Sort()
end event

