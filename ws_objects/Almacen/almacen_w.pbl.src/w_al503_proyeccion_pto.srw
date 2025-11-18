$PBExportHeader$w_al503_proyeccion_pto.srw
$PBExportComments$Consulta que muestra los movimientos de un articulo por almacen.
forward
global type w_al503_proyeccion_pto from w_report_smpl
end type
type st_1 from statictext within w_al503_proyeccion_pto
end type
type cb_3 from commandbutton within w_al503_proyeccion_pto
end type
type ddlb_1 from dropdownlistbox within w_al503_proyeccion_pto
end type
type st_2 from statictext within w_al503_proyeccion_pto
end type
type ddlb_delmes from dropdownlistbox within w_al503_proyeccion_pto
end type
type st_3 from statictext within w_al503_proyeccion_pto
end type
type sle_ano from singlelineedit within w_al503_proyeccion_pto
end type
type st_4 from statictext within w_al503_proyeccion_pto
end type
type ddlb_almes from dropdownlistbox within w_al503_proyeccion_pto
end type
type cbx_sel from checkbox within w_al503_proyeccion_pto
end type
type cbx_des from checkbox within w_al503_proyeccion_pto
end type
type r_1 from rectangle within w_al503_proyeccion_pto
end type
end forward

global type w_al503_proyeccion_pto from w_report_smpl
integer width = 3671
integer height = 1156
string title = "Proyeccion Presupuestal  (AL503)"
string menuname = "m_impresion"
long backcolor = 12632256
st_1 st_1
cb_3 cb_3
ddlb_1 ddlb_1
st_2 st_2
ddlb_delmes ddlb_delmes
st_3 st_3
sle_ano sle_ano
st_4 st_4
ddlb_almes ddlb_almes
cbx_sel cbx_sel
cbx_des cbx_des
r_1 r_1
end type
global w_al503_proyeccion_pto w_al503_proyeccion_pto

type variables
integer ii_tipo, ii_mes_del, ii_mes_al
end variables

on w_al503_proyeccion_pto.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cb_3=create cb_3
this.ddlb_1=create ddlb_1
this.st_2=create st_2
this.ddlb_delmes=create ddlb_delmes
this.st_3=create st_3
this.sle_ano=create sle_ano
this.st_4=create st_4
this.ddlb_almes=create ddlb_almes
this.cbx_sel=create cbx_sel
this.cbx_des=create cbx_des
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.ddlb_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_delmes
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.ddlb_almes
this.Control[iCurrent+10]=this.cbx_sel
this.Control[iCurrent+11]=this.cbx_des
this.Control[iCurrent+12]=this.r_1
end on

on w_al503_proyeccion_pto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.ddlb_1)
destroy(this.st_2)
destroy(this.ddlb_delmes)
destroy(this.st_3)
destroy(this.sle_ano)
destroy(this.st_4)
destroy(this.ddlb_almes)
destroy(this.cbx_sel)
destroy(this.cbx_des)
destroy(this.r_1)
end on

event ue_open_pre();call super::ue_open_pre;sle_ano.text = String( year(today()))
end event

type dw_report from w_report_smpl`dw_report within w_al503_proyeccion_pto
integer x = 14
integer y = 196
integer height = 688
integer taborder = 60
string dataobject = "d_cns_proyeccion_pto"
end type

type st_1 from statictext within w_al503_proyeccion_pto
integer x = 2034
integer y = 12
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Tipo:"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_al503_proyeccion_pto
integer x = 3351
integer y = 12
integer width = 279
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccion"
end type

event clicked;Long ll_ano
String ls_desb

SetPointer( Hourglass!)

ll_ano = LONG( sle_ano.text)
if cbx_sel.checked = false then
	str_parametros sl_param

	sl_param.int1 = ii_tipo
	sl_param.int2 = ii_mes_del
	sl_param.int3 = ii_mes_al
	sl_param.long1 = Long(sle_ano.text)

	OpenWithParm( w_al503_sel_proyeccion_pto, sl_param)
else
	DECLARE proc1 PROCEDURE FOR USP_ALM_PROYECCION_PTO(5, :ii_mes_del, :ii_mes_al, :ll_ano);
	EXECUTE proc1;
	if sqlca.sqlcode = -1 then   // Fallo
		Messagebox( "Error", sqlca.sqlerrtext, stopsign!)
		rollback ;	
		RETURN 
	End If
	close proc1;
end if

if cbx_des.checked = true then
	ls_desb = '1'
else
	ls_desb = '%'
end if

idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
idw_1.Visible = True

idw_1.SetTransObject(Sqlca)
idw_1.Retrieve(ls_desb)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_2.text = 'MES: ' + ddlb_delmes.Text + ' AÑO: ' + sle_ano.text
idw_1.object.t_user.text = gs_user
end event

type ddlb_1 from dropdownlistbox within w_al503_proyeccion_pto
integer x = 2213
integer y = 8
integer width = 599
integer height = 248
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Tipo documento","Centro de Costo"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	ii_tipo = index
end if
end event

type st_2 from statictext within w_al503_proyeccion_pto
integer x = 421
integer y = 12
integer width = 274
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Del Mes:"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ddlb_delmes from dropdownlistbox within w_al503_proyeccion_pto
integer x = 704
integer y = 8
integer width = 512
integer height = 768
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	ii_mes_del = index
end if
end event

type st_3 from statictext within w_al503_proyeccion_pto
integer y = 12
integer width = 146
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año:"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_al503_proyeccion_pto
integer x = 165
integer y = 8
integer width = 233
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_al503_proyeccion_pto
integer x = 1243
integer y = 12
integer width = 247
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Al Mes:"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ddlb_almes from dropdownlistbox within w_al503_proyeccion_pto
integer x = 1499
integer y = 8
integer width = 512
integer height = 768
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;if index > 0 then
	ii_mes_al = index
end if
end event

type cbx_sel from checkbox within w_al503_proyeccion_pto
integer x = 2857
integer y = 24
integer width = 256
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

event clicked;if this.checked = true then
	cb_3.text = 'Reporte'
else
	cb_3.text = 'Seleccion'
end if
end event

type cbx_des from checkbox within w_al503_proyeccion_pto
integer x = 2857
integer y = 96
integer width = 430
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Solo Desbordes"
end type

type r_1 from rectangle within w_al503_proyeccion_pto
integer linethickness = 4
long fillcolor = 12632256
integer x = 2834
integer y = 12
integer width = 489
integer height = 172
end type

