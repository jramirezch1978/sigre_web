$PBExportHeader$w_cn784_grp_cc_costo_prod.srw
forward
global type w_cn784_grp_cc_costo_prod from w_rpt_list
end type
type sle_ano from singlelineedit within w_cn784_grp_cc_costo_prod
end type
type sle_mes from singlelineedit within w_cn784_grp_cc_costo_prod
end type
type dw_text from datawindow within w_cn784_grp_cc_costo_prod
end type
type st_campo from statictext within w_cn784_grp_cc_costo_prod
end type
type pb_3 from picturebutton within w_cn784_grp_cc_costo_prod
end type
type gb_1 from groupbox within w_cn784_grp_cc_costo_prod
end type
type gb_2 from groupbox within w_cn784_grp_cc_costo_prod
end type
type rr_1 from roundrectangle within w_cn784_grp_cc_costo_prod
end type
end forward

global type w_cn784_grp_cc_costo_prod from w_rpt_list
integer width = 3154
integer height = 1844
string title = "CN784 - Costo de produccion por grupo de centros costos "
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
dw_text dw_text
st_campo st_campo
pb_3 pb_3
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_cn784_grp_cc_costo_prod w_cn784_grp_cc_costo_prod

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

on w_cn784_grp_cc_costo_prod.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.dw_text=create dw_text
this.st_campo=create st_campo
this.pb_3=create pb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.rr_1
end on

on w_cn784_grp_cc_costo_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.pb_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_ano, ll_mes

ll_ano = LONG(sle_ano.text)
ll_mes = LONG(sle_mes.text)

//ls_origen = dw_origen.object.origen[1]
//If len(trim(ls_origen))= 0 or IsNull(ls_origen) then
//	ls_origen ='%'
//	ls_orig = 'Todos los Origenes'
//	DECLARE pb_usp_cntbl_rpt_saldos_ctacte PROCEDURE FOR USP_CNTBL_RPT_SALDOS_CTACTE
//			  ( :ls_ano, :ls_mes,:ls_origen) ;
//	Execute pb_usp_cntbl_rpt_saldos_ctacte ;	
//else
//	ls_orig = ls_origen
//	ls_origen = trim(ls_origen)
//	DECLARE pb_usp_cnt_rpt_sldo_ctacte_x_orig PROCEDURE FOR usp_cnt_rpt_sldo_ctacte_x_orig
//			  ( :ls_ano, :ls_mes,:ls_origen) ;
//	Execute pb_usp_cnt_rpt_sldo_ctacte_x_orig ;		
//end if
//
//create or replace procedure usp_cnt_rpt_gastos_cc_produc(
//  an_ano          in cntbl_asiento.ano%type, 
//  an_mes          in cntbl_asiento.mes%type, 
//  as_plant_prod   in cnt_plant_grp_cc_prod.cod_plant%type, 
//  an_nivel        in number, 
//  an_digito       in number ) is
//
//
//dw_report.retrieve()
//
//dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text = gs_empresa
//dw_report.object.t_user.text = gs_user
//dw_report.object.t_origen.text = ls_orig
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_cn784_grp_cc_costo_prod
boolean visible = false
integer x = 14
integer y = 280
integer width = 3067
integer height = 1360
integer taborder = 0
string dataobject = "d_cntbl_rpt_saldos_ctacte_tbl"
integer ii_zoom_actual = 100
end type

type dw_1 from w_rpt_list`dw_1 within w_cn784_grp_cc_costo_prod
integer x = 165
integer y = 472
integer width = 1280
integer height = 932
integer taborder = 0
string dataobject = "d_abc_plant_grp_cc_prod_tbl"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_report
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Orden : " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type pb_1 from w_rpt_list`pb_1 within w_cn784_grp_cc_costo_prod
integer x = 1490
integer y = 784
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cn784_grp_cc_costo_prod
integer x = 1490
integer y = 904
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn784_grp_cc_costo_prod
integer x = 1659
integer y = 472
integer width = 1280
integer height = 932
integer taborder = 0
string dataobject = "d_abc_plant_grp_cc_prod_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cn784_grp_cc_costo_prod
integer x = 1495
integer y = 156
integer width = 297
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;//integer i
//string  ls_cuenta, ls_descripcion
//string  ls_codigo
//
//idw_1.Visible = True
//dw_1.visible = False
//dw_2.visible = False
//pb_1.visible = False
//pb_2.visible = False
//gb_2.visible = False
//dw_text.visible = false
//st_campo.visible = false
//
//delete from tt_cntbl_rpt_cuentas_ctacte ;
//	
//for i = 1 to dw_2.rowcount()
//  	 ls_cuenta      = dw_2.object.cnta_ctbl[i]
// 	 ls_descripcion = dw_2.object.desc_cnta[i]
//	 
//	 insert into tt_cntbl_rpt_cuentas_ctacte (cuenta, descripcion)
//	 values (:ls_cuenta, :ls_descripcion) ;
//	 
//	 if sqlca.sqlcode = -1 then
//		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
//	end if
//next
//
//parent.event ue_preview()
//dw_report.SetTransObject(sqlca)
//dw_report.visible=true

parent.event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn784_grp_cc_costo_prod
integer x = 224
integer y = 128
integer width = 219
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn784_grp_cc_costo_prod
integer x = 471
integer y = 128
integer width = 123
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type dw_text from datawindow within w_cn784_grp_cc_costo_prod
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 169
integer y = 368
integer width = 1280
integer height = 80
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event dw_enter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type st_campo from statictext within w_cn784_grp_cc_costo_prod
integer x = 1659
integer y = 380
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "*"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_cn784_grp_cc_costo_prod
integer x = 1257
integer y = 104
integer width = 169
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\retroceder.bmp"
alignment htextalign = left!
end type

event clicked;idw_1.Visible = False
gb_2.visible = true
pb_1.visible = true
pb_2.visible = true
dw_1.visible = true
dw_2.visible = true
dw_text.visible = true
st_campo.visible = true

end event

type gb_1 from groupbox within w_cn784_grp_cc_costo_prod
integer x = 174
integer y = 60
integer width = 475
integer height = 164
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Año y Mes "
end type

type gb_2 from groupbox within w_cn784_grp_cc_costo_prod
integer x = 101
integer y = 280
integer width = 2912
integer height = 1184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione 01 plantilla de cencos de costos de producción "
end type

type rr_1 from roundrectangle within w_cn784_grp_cc_costo_prod
integer linethickness = 5
long fillcolor = 12632256
integer x = 123
integer y = 48
integer width = 1349
integer height = 212
integer cornerheight = 40
integer cornerwidth = 46
end type

