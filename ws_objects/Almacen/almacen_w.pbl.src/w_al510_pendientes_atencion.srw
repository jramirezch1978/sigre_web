$PBExportHeader$w_al510_pendientes_atencion.srw
forward
global type w_al510_pendientes_atencion from w_report_smpl
end type
type cb_recuperar from commandbutton within w_al510_pendientes_atencion
end type
type cbx_todos from checkbox within w_al510_pendientes_atencion
end type
type ddlb_clase from u_ddlb within w_al510_pendientes_atencion
end type
type rb_detalle from radiobutton within w_al510_pendientes_atencion
end type
type rb_resumen from radiobutton within w_al510_pendientes_atencion
end type
type gb_2 from groupbox within w_al510_pendientes_atencion
end type
type gb_1 from groupbox within w_al510_pendientes_atencion
end type
end forward

global type w_al510_pendientes_atencion from w_report_smpl
integer width = 2299
integer height = 1032
string title = "Requerimiento de Articulos Pendiente (AL510)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_recuperar cb_recuperar
cbx_todos cbx_todos
ddlb_clase ddlb_clase
rb_detalle rb_detalle
rb_resumen rb_resumen
gb_2 gb_2
gb_1 gb_1
end type
global w_al510_pendientes_atencion w_al510_pendientes_atencion

type variables
Integer ii_clase
end variables

on w_al510_pendientes_atencion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_recuperar=create cb_recuperar
this.cbx_todos=create cbx_todos
this.ddlb_clase=create ddlb_clase
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_recuperar
this.Control[iCurrent+2]=this.cbx_todos
this.Control[iCurrent+3]=this.ddlb_clase
this.Control[iCurrent+4]=this.rb_detalle
this.Control[iCurrent+5]=this.rb_resumen
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_al510_pendientes_atencion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_recuperar)
destroy(this.cbx_todos)
destroy(this.ddlb_clase)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_clase, ls_tipo

if ii_clase = 0 and cbx_todos.checked = false then
	Messagebox( "Aviso", "Indique Clase")
	return
end if

if rb_detalle.checked = false and rb_resumen.checked = false then
	Messagebox( "Aviso", "Indique tipo")
	return
end if

if rb_detalle.checked = true then
	ls_tipo = 'D'
else
	ls_tipo = 'R'
end if

if cbx_todos.checked = true then
	ls_clase = '%'
else
	ls_clase = ddlb_clase.ia_key[ii_clase]
end if

DECLARE proc PROCEDURE FOR USP_CMP_REQ_PENDIENTES(:ls_clase, :ls_tipo);
EXECUTE proc;

If sqlca.sqlcode = -1 then
	messagebox("Error en el Store Procedure",sqlca.sqlerrtext)
	Close proc;
	return
end if

ib_preview = false
trigger event ue_preview()

idw_1.SetTransobject(sqlca)
idw_1.Retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = 'AL510'
idw_1.object.t_titulo.text = 'AL ' + string( today())
end event

type dw_report from w_report_smpl`dw_report within w_al510_pendientes_atencion
integer y = 172
integer height = 556
string dataobject = "d_cns_req_pendientes_res"
end type

type cb_recuperar from commandbutton within w_al510_pendientes_atencion
integer x = 1902
integer y = 60
integer width = 297
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type cbx_todos from checkbox within w_al510_pendientes_atencion
integer x = 46
integer y = 72
integer width = 402
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
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_clase.enabled = false
	ddlb_clase.text = ''
else	
	ddlb_clase.enabled = true
end if
end event

type ddlb_clase from u_ddlb within w_al510_pendientes_atencion
integer x = 315
integer y = 52
integer width = 722
integer height = 436
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
end type

event selectionchanged;call super::selectionchanged;if index > 0 then
   ii_clase = index	
end if
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_dddw_clases'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 6                     // Longitud del campo 1
ii_lc2 = 45							// Longitud del campo 2
end event

type rb_detalle from radiobutton within w_al510_pendientes_atencion
integer x = 1170
integer y = 64
integer width = 306
integer height = 80
boolean bringtotop = true
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

event clicked;dw_report.dataobject = 'd_cns_req_pendientes'
end event

type rb_resumen from radiobutton within w_al510_pendientes_atencion
integer x = 1435
integer y = 64
integer width = 302
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

event clicked;dw_report.dataobject = 'd_cns_req_pendientes_res'
end event

type gb_2 from groupbox within w_al510_pendientes_atencion
integer x = 5
integer y = 8
integer width = 1070
integer height = 156
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clases"
end type

type gb_1 from groupbox within w_al510_pendientes_atencion
integer x = 1134
integer y = 8
integer width = 649
integer height = 156
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo"
end type

