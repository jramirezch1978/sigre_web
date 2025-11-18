$PBExportHeader$w_al719_consumo_material_anual.srw
forward
global type w_al719_consumo_material_anual from w_report_smpl
end type
type st_2 from statictext within w_al719_consumo_material_anual
end type
type cb_3 from commandbutton within w_al719_consumo_material_anual
end type
type st_1 from statictext within w_al719_consumo_material_anual
end type
type sle_ano from singlelineedit within w_al719_consumo_material_anual
end type
type sle_almacen from singlelineedit within w_al719_consumo_material_anual
end type
type sle_descrip from singlelineedit within w_al719_consumo_material_anual
end type
type gb_1 from groupbox within w_al719_consumo_material_anual
end type
end forward

global type w_al719_consumo_material_anual from w_report_smpl
integer width = 3456
integer height = 1956
string title = "Movimientos por tipo de Operación (AL719)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 12632256
st_2 st_2
cb_3 cb_3
st_1 st_1
sle_ano sle_ano
sle_almacen sle_almacen
sle_descrip sle_descrip
gb_1 gb_1
end type
global w_al719_consumo_material_anual w_al719_consumo_material_anual

type variables
Integer ii_index
end variables

on w_al719_consumo_material_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_2=create st_2
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_ano=create sle_ano
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.sle_almacen
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.gb_1
end on

on w_al719_consumo_material_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_ano, ls_almac

ls_ano = sle_ano.text
ls_almac = sle_almacen.text
//ls_almac = ddlb_almacen.ia_key[ii_index]

dw_report.retrieve(ls_ano, ls_almac)
dw_report.object.t_texto.text = 'Año :' + ls_ano + '  Almacen :' + ls_almac
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL719'
end event

type dw_report from w_report_smpl`dw_report within w_al719_consumo_material_anual
integer x = 41
integer y = 344
integer width = 3342
integer height = 1276
string dataobject = "d_rpt_consumo_anual_tbl"
end type

type st_2 from statictext within w_al719_consumo_material_anual
integer x = 101
integer y = 204
integer width = 320
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Almacen:"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_al719_consumo_material_anual
integer x = 2190
integer y = 108
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type st_1 from statictext within w_al719_consumo_material_anual
integer x = 101
integer y = 72
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Año :"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_al719_consumo_material_anual
integer x = 389
integer y = 68
integer width = 357
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_al719_consumo_material_anual
event dobleclick pbm_lbuttondblclk
integer x = 389
integer y = 192
integer width = 343
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al719_consumo_material_anual
integer x = 745
integer y = 192
integer width = 1198
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_al719_consumo_material_anual
integer x = 23
integer y = 16
integer width = 2080
integer height = 300
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Parametros"
end type

