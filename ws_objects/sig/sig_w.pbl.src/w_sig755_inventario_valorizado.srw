$PBExportHeader$w_sig755_inventario_valorizado.srw
forward
global type w_sig755_inventario_valorizado from w_report_smpl
end type
type sle_ano_inicial from singlelineedit within w_sig755_inventario_valorizado
end type
type st_1 from statictext within w_sig755_inventario_valorizado
end type
type sle_mes_inicial from singlelineedit within w_sig755_inventario_valorizado
end type
type st_2 from statictext within w_sig755_inventario_valorizado
end type
type st_3 from statictext within w_sig755_inventario_valorizado
end type
type sle_ano_final from singlelineedit within w_sig755_inventario_valorizado
end type
type st_4 from statictext within w_sig755_inventario_valorizado
end type
type sle_mes_final from singlelineedit within w_sig755_inventario_valorizado
end type
type st_5 from statictext within w_sig755_inventario_valorizado
end type
type cb_lectura from commandbutton within w_sig755_inventario_valorizado
end type
end forward

global type w_sig755_inventario_valorizado from w_report_smpl
integer width = 3063
integer height = 1852
string title = "Inventario Valorizado (SIG755)"
string menuname = "m_rpt_simple"
long backcolor = 134217739
sle_ano_inicial sle_ano_inicial
st_1 st_1
sle_mes_inicial sle_mes_inicial
st_2 st_2
st_3 st_3
sle_ano_final sle_ano_final
st_4 st_4
sle_mes_final sle_mes_final
st_5 st_5
cb_lectura cb_lectura
end type
global w_sig755_inventario_valorizado w_sig755_inventario_valorizado

type variables
String	is_clase, is_sub_prod
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_sub_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase, ref string as_sub_prod);Long		ll_rc = 0


SELECT CLASE_PROD_TERM, CLASE_SUB_PROD
  INTO :as_clase, :as_sub_prod
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_sig755_inventario_valorizado.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.sle_ano_inicial=create sle_ano_inicial
this.st_1=create st_1
this.sle_mes_inicial=create sle_mes_inicial
this.st_2=create st_2
this.st_3=create st_3
this.sle_ano_final=create sle_ano_final
this.st_4=create st_4
this.sle_mes_final=create sle_mes_final
this.st_5=create st_5
this.cb_lectura=create cb_lectura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano_inicial
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_mes_inicial
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_ano_final
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_mes_final
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.cb_lectura
end on

on w_sig755_inventario_valorizado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano_inicial)
destroy(this.st_1)
destroy(this.sle_mes_inicial)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_ano_final)
destroy(this.st_4)
destroy(this.sle_mes_final)
destroy(this.st_5)
destroy(this.cb_lectura)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_rc

ll_rc = of_get_parametros(is_clase, is_sub_prod)


sle_ano_inicial.Text = String(Year(Today()))
sle_mes_inicial.Text = '1'
sle_ano_final.Text = String(Year(Today()))
sle_mes_final.Text = String(Month(Today()))
end event

event resize;call super::resize;//dw_grafico.width = newwidth - dw_report.x - 25

end event

event ue_saveas;call super::ue_saveas;//Long	ll_rc = 0
//STR_CNS_POP lstr_1
//
//
//lstr_1.DataObject = 'd_articulo_saldos_men_valorizado_grf'
//lstr_1.Width = 3500
//lstr_1.Height= 2000
//lstr_1.Arg[1] = sle_ano_inicial.Text
//lstr_1.Arg[2] = sle_mes_inicial.Text
//lstr_1.Arg[3] = sle_ano_final.Text
//lstr_1.Arg[4] = sle_mes_final.Text
//lstr_1.Arg[5] = is_clase
//lstr_1.Arg[6] = is_sub_prod
//lstr_1.Title = 'Inventario Valorizado'
//lstr_1.grf_val_index = 1
//lstr_1.Tipo_Cascada = 'G'
//of_new_sheet(lstr_1)

end event

type dw_report from w_report_smpl`dw_report within w_sig755_inventario_valorizado
integer x = 14
integer y = 120
string dataobject = "d_articulo_saldos_men_valorizado"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "stock_valor" 
		lstr_1.DataObject = 'd_articulo_saldos_men_valorizado_det'
		lstr_1.Width = 3200
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_clase')
		lstr_1.Arg[2] = String(GetItemNumber(row,'ano'))
		lstr_1.Arg[3] = String(GetItemNumber(row,'mes'))
		lstr_1.Title = 'Saldos por Almacen por Subcategoria'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type sle_ano_inicial from singlelineedit within w_sig755_inventario_valorizado
integer x = 165
integer y = 36
integer width = 233
integer height = 68
integer taborder = 10
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

type st_1 from statictext within w_sig755_inventario_valorizado
integer x = 27
integer y = 32
integer width = 142
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Año:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_mes_inicial from singlelineedit within w_sig755_inventario_valorizado
integer x = 558
integer y = 36
integer width = 133
integer height = 68
integer taborder = 20
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

type st_2 from statictext within w_sig755_inventario_valorizado
integer x = 411
integer y = 32
integer width = 146
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Mes:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sig755_inventario_valorizado
integer x = 750
integer y = 32
integer width = 105
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Al"
boolean focusrectangle = false
end type

type sle_ano_final from singlelineedit within w_sig755_inventario_valorizado
integer x = 1051
integer y = 36
integer width = 233
integer height = 68
integer taborder = 20
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

type st_4 from statictext within w_sig755_inventario_valorizado
integer x = 914
integer y = 32
integer width = 137
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Año:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_mes_final from singlelineedit within w_sig755_inventario_valorizado
integer x = 1449
integer y = 36
integer width = 133
integer height = 68
integer taborder = 30
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

type st_5 from statictext within w_sig755_inventario_valorizado
integer x = 1312
integer y = 32
integer width = 137
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217739
string text = "Mes:"
boolean focusrectangle = false
end type

type cb_lectura from commandbutton within w_sig755_inventario_valorizado
integer x = 1682
integer y = 28
integer width = 297
integer height = 84
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

event clicked;Long	ll_ano_inicial, ll_mes_inicial, ll_ano_final, ll_mes_final
Long	ll_rc = 0

ll_ano_inicial = Integer(sle_ano_inicial.Text)
ll_mes_inicial = Integer(sle_mes_inicial.Text)
ll_ano_final   = Integer(sle_ano_final.Text)
ll_mes_final   = Integer(sle_mes_final.Text)


IF ll_ano_inicial < 2002 THEN
	MessageBox('Error', 'Año Inicial Errado')
	ll_rc = -1
END IF

IF ll_ano_final < ll_ano_inicial THEN
	MessageBox('Error', 'Año final Errado')
	ll_rc = -2
END IF

IF ll_mes_inicial < 1 OR  ll_mes_inicial > 12 THEN
	MessageBox('Error', 'Mes Inicial Errado')
	ll_rc = -3
END IF

IF ll_mes_final < 1 OR  ll_mes_final > 12 THEN
	MessageBox('Error', 'Mes Final Errado')
	ll_rc = -4
END IF

IF UPPER(gs_lpp) = 'S' THEN PARENT.EVENT ue_set_retrieve_as_needed('S')

IF ll_rc =0 THEN
	idw_1.Retrieve(ll_ano_inicial, ll_mes_inicial, ll_ano_final, ll_mes_final, is_clase, is_sub_prod)
	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_nombre.text = gs_empresa
	idw_1.object.t_user.text = gs_user
	idw_1.Visible = True
END IF

end event

