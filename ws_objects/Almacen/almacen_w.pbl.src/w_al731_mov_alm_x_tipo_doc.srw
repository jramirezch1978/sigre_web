$PBExportHeader$w_al731_mov_alm_x_tipo_doc.srw
forward
global type w_al731_mov_alm_x_tipo_doc from w_report_smpl
end type
type st_2 from statictext within w_al731_mov_alm_x_tipo_doc
end type
type sle_1 from singlelineedit within w_al731_mov_alm_x_tipo_doc
end type
type sle_2 from singlelineedit within w_al731_mov_alm_x_tipo_doc
end type
type cb_1 from commandbutton within w_al731_mov_alm_x_tipo_doc
end type
end forward

global type w_al731_mov_alm_x_tipo_doc from w_report_smpl
integer width = 3506
integer height = 1740
string title = "Movimientos de Almacen x Tipo Doc (AL731)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
st_2 st_2
sle_1 sle_1
sle_2 sle_2
cb_1 cb_1
end type
global w_al731_mov_alm_x_tipo_doc w_al731_mov_alm_x_tipo_doc

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al731_mov_alm_x_tipo_doc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_2=create st_2
this.sle_1=create sle_1
this.sle_2=create sle_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.sle_2
this.Control[iCurrent+4]=this.cb_1
end on

on w_al731_mov_alm_x_tipo_doc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.cb_1)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.visible = true
ib_preview=false
this.event ue_preview()
dw_report.SetTransObject( sqlca)
dw_report.retrieve(sle_1.text, sle_2.text)	
dw_report.object.t_fechas.text = 'TIPO DOCUMENTO: ' + sle_1.text + ' - ' &
	+ sle_2.text
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL731'
end event

type dw_report from w_report_smpl`dw_report within w_al731_mov_alm_x_tipo_doc
integer x = 14
integer y = 144
integer width = 3429
integer height = 1288
string dataobject = "d_rpt_mov_alm_x_tipo_doc"
end type

type st_2 from statictext within w_al731_mov_alm_x_tipo_doc
integer x = 91
integer y = 52
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_al731_mov_alm_x_tipo_doc
event ue_dobleclick pbm_lbuttondblclk
integer x = 466
integer y = 40
integer width = 169
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.tipo_doc AS codigo_tipo_doc, " &
		  + "a.DESC_tipo_doc AS DESCRIPCION_tipo_doc " &
		  + "FROM doc_tipo a, " &
		  + "articulo_mov_proy amp " &
		  + "where amp.tipo_doc = a.tipo_doc " &
		  + "and NVL(amp.cant_procesada,0) > 0 " &
		  + "and amp.flag_estado <> '0' "
		  
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type sle_2 from singlelineedit within w_al731_mov_alm_x_tipo_doc
event ue_dobleclick pbm_lbuttondblclk
integer x = 658
integer y = 40
integer width = 480
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_1.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Ingrese primero un tipo de documento')
	return
end if

ls_sql = "SELECT distinct cod_origen AS origen, " &
		 +	"NRO_DOC AS NUMERO_DOC " &
		 + "FROM ARTICULO_MOV_PROY AMP " &
		 + "WHERE NVL(amp.cant_procesada,0) > 0 " &
		 + "AND TIPO_DOC = '" +ls_tipo_doc + "' " &
		 + "AND FLAG_ESTADO <> '0'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_data
end if

end event

type cb_1 from commandbutton within w_al731_mov_alm_x_tipo_doc
integer x = 1179
integer y = 44
integer width = 329
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

