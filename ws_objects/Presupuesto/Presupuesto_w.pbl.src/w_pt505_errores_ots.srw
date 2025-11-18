$PBExportHeader$w_pt505_errores_ots.srw
$PBExportComments$Control presupuestario por cuenta presupuestal
forward
global type w_pt505_errores_ots from w_report_smpl
end type
type cb_2 from commandbutton within w_pt505_errores_ots
end type
type cb_1 from commandbutton within w_pt505_errores_ots
end type
type cb_3 from commandbutton within w_pt505_errores_ots
end type
end forward

global type w_pt505_errores_ots from w_report_smpl
integer width = 3182
integer height = 1644
string title = "Reporte de Erores de Generación de Presupuesto (PT505)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
cb_3 cb_3
end type
global w_pt505_errores_ots w_pt505_errores_ots

type variables
Long il_year
string is_ot_adm
str_parametros istr_param
end variables

on w_pt505_errores_ots.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_3
end on

on w_pt505_errores_ots.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_3)
end on

event ue_retrieve;call super::ue_retrieve;string ls_sel_ots, ls_null

idw_1.Visible = true
idw_1.object.Datawindow.print.Orientation = 1
idw_1.object.Datawindow.print.preview = 'No'
ib_preview=false
idw_1.Retrieve(il_year, is_ot_adm)
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa

end event

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

il_year = lstr_param.long1
is_ot_adm = lstr_param.string1

this.event ue_retrieve()

if dw_report.Rowcount( ) = 0 then
	MessageBox('Aviso', 'No hay ningun error, se prosigue con la operacion')
	lstr_param.titulo = 's'
	CloseWithReturn(this, lstr_param)
end if
end event

event open;//Overriding
THIS.EVENT ue_open_pre()

end event

type dw_report from w_report_smpl`dw_report within w_pt505_errores_ots
integer x = 0
integer y = 160
integer width = 2583
integer height = 1292
integer taborder = 90
string dataobject = "d_cns_errores_ots"
end type

type cb_2 from commandbutton within w_pt505_errores_ots
integer x = 681
integer y = 44
integer width = 517
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Continuar Proceso"
end type

event clicked;istr_param.titulo = 's'
CloseWithReturn(parent, istr_param)
end event

type cb_1 from commandbutton within w_pt505_errores_ots
integer x = 165
integer y = 44
integer width = 517
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Detener Proceso"
end type

event clicked;istr_param.titulo = 'n'
CloseWithReturn(parent, istr_param)
end event

type cb_3 from commandbutton within w_pt505_errores_ots
integer x = 1198
integer y = 44
integer width = 517
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Imprimir"
end type

event clicked;parent.event ue_print( )
end event

