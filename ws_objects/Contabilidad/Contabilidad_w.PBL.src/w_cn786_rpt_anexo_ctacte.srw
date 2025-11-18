$PBExportHeader$w_cn786_rpt_anexo_ctacte.srw
forward
global type w_cn786_rpt_anexo_ctacte from w_rpt_list
end type
type sle_ano from singlelineedit within w_cn786_rpt_anexo_ctacte
end type
type sle_mes_ini from singlelineedit within w_cn786_rpt_anexo_ctacte
end type
type dw_text from datawindow within w_cn786_rpt_anexo_ctacte
end type
type st_campo from statictext within w_cn786_rpt_anexo_ctacte
end type
type pb_3 from picturebutton within w_cn786_rpt_anexo_ctacte
end type
type st_1 from statictext within w_cn786_rpt_anexo_ctacte
end type
type cbx_pres from checkbox within w_cn786_rpt_anexo_ctacte
end type
type cbx_ape from checkbox within w_cn786_rpt_anexo_ctacte
end type
type rb_res from radiobutton within w_cn786_rpt_anexo_ctacte
end type
type rb_det from radiobutton within w_cn786_rpt_anexo_ctacte
end type
type ddlb_1 from dropdownlistbox within w_cn786_rpt_anexo_ctacte
end type
type sle_mes_fin from singlelineedit within w_cn786_rpt_anexo_ctacte
end type
type sle_titulo from singlelineedit within w_cn786_rpt_anexo_ctacte
end type
type st_2 from statictext within w_cn786_rpt_anexo_ctacte
end type
type sle_subtitulo from singlelineedit within w_cn786_rpt_anexo_ctacte
end type
type st_3 from statictext within w_cn786_rpt_anexo_ctacte
end type
type gb_1 from groupbox within w_cn786_rpt_anexo_ctacte
end type
type gb_2 from groupbox within w_cn786_rpt_anexo_ctacte
end type
type rr_1 from roundrectangle within w_cn786_rpt_anexo_ctacte
end type
end forward

global type w_cn786_rpt_anexo_ctacte from w_rpt_list
integer width = 3154
integer height = 1844
string title = "(CN786) Anexos de cuenta corriente "
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes_ini sle_mes_ini
dw_text dw_text
st_campo st_campo
pb_3 pb_3
st_1 st_1
cbx_pres cbx_pres
cbx_ape cbx_ape
rb_res rb_res
rb_det rb_det
ddlb_1 ddlb_1
sle_mes_fin sle_mes_fin
sle_titulo sle_titulo
st_2 st_2
sle_subtitulo sle_subtitulo
st_3 st_3
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_cn786_rpt_anexo_ctacte w_cn786_rpt_anexo_ctacte

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

on w_cn786_rpt_anexo_ctacte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_ini=create sle_mes_ini
this.dw_text=create dw_text
this.st_campo=create st_campo
this.pb_3=create pb_3
this.st_1=create st_1
this.cbx_pres=create cbx_pres
this.cbx_ape=create cbx_ape
this.rb_res=create rb_res
this.rb_det=create rb_det
this.ddlb_1=create ddlb_1
this.sle_mes_fin=create sle_mes_fin
this.sle_titulo=create sle_titulo
this.st_2=create st_2
this.sle_subtitulo=create sle_subtitulo
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_ini
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cbx_pres
this.Control[iCurrent+8]=this.cbx_ape
this.Control[iCurrent+9]=this.rb_res
this.Control[iCurrent+10]=this.rb_det
this.Control[iCurrent+11]=this.ddlb_1
this.Control[iCurrent+12]=this.sle_mes_fin
this.Control[iCurrent+13]=this.sle_titulo
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.sle_subtitulo
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.rr_1
end on

on w_cn786_rpt_anexo_ctacte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_ini)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.pb_3)
destroy(this.st_1)
destroy(this.cbx_pres)
destroy(this.cbx_ape)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.ddlb_1)
destroy(this.sle_mes_fin)
destroy(this.sle_titulo)
destroy(this.st_2)
destroy(this.sle_subtitulo)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_moneda, ls_tipo_rep, ls_incluye_ape, ls_presentacion, ls_soles, ls_msj
String ls_titulo, ls_subtitulo
Long ll_ano, ll_mes_ini, ll_mes_fin

ll_ano = Long(sle_ano.text)
ll_mes_ini = Long(sle_mes_ini.text)
ll_mes_fin = Long(sle_mes_fin.text)
ls_titulo = TRIM(sle_titulo.text)
ls_subtitulo = TRIM(sle_subtitulo.text)

// Moneda
SELECT cod_soles INTO :ls_soles FROM logparam WHERE reckey='1' ;
ls_moneda    = string(upper(ddlb_1.Text))

If trim(ls_moneda)= '' or IsNull(ls_moneda) then
	ls_moneda ='%'
END IF 

// Tipo de reporte
IF (rb_res.checked = TRUE) AND (rb_det.checked = TRUE) THEN
	MessageBox('Aviso', ' Defina correctamente tipo de reporte')
	Return
END IF

IF rb_res.checked = TRUE THEN
	ls_tipo_rep = 'R'
ELSE
	ls_tipo_rep = 'D'
END IF 

IF cbx_ape.checked = TRUE THEN
	ls_incluye_ape = 'S'
ELSE
	ls_incluye_ape = 'N'
END IF 

DECLARE pb_usp_cnt_anexo_cta_cte PROCEDURE FOR usp_cnt_anexo_cta_cte
		  ( :ll_ano, :ll_mes_ini, :ll_mes_fin, :ls_moneda, :ls_tipo_rep, :ls_incluye_ape ) ;
EXECUTE pb_usp_cnt_anexo_cta_cte ;	

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error usp_cnt_anexo_cta_cte', ls_msj, StopSign! )
	return
END IF

// Presentacion vertical
IF cbx_pres.checked = FALSE THEN
	IF (ls_tipo_rep='R' AND ls_moneda = ls_soles) THEN 
		idw_1.DataObject = 'd_rpt_anexo_res_ctacte_sol_tbl'
	ELSEIF (ls_tipo_rep='R' AND ls_moneda <> ls_soles) THEN 
		idw_1.DataObject = 'd_rpt_anexo_res_ctacte_dol_tbl'
	ELSEIF (ls_tipo_rep='D' AND ls_moneda = ls_soles) THEN 	
		idw_1.DataObject = 'd_rpt_anexo_det_ctacte_sol_tbl'
	ELSEIF (ls_tipo_rep='D' AND ls_moneda <> ls_soles) THEN 
		idw_1.DataObject = 'd_rpt_anexo_det_ctacte_dol_tbl'
	END IF
//ELSE
// Presentacion horizontal
//	IF ls_moneda = ls_soles THEN
//	ELSE
//	END IF
END IF

// Recuperando informacion
idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_2.text = ls_titulo
// Asignando subtitulo
IF TRIM(ls_subtitulo)='' OR IsNull(ls_subtitulo) THEN
	idw_1.object.t_texto.text = 'Año: ' + TRIM(sle_ano.text) + ' Rango meses: ' + TRIM(sle_mes_ini.text) + ' - ' + TRIM(sle_mes_fin.text) + ' ,Moneda :' + ls_moneda
ELSE
	idw_1.object.t_texto.text = ls_subtitulo
END IF
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CN786'
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(today(),'yyyy')
sle_mes_ini.text = '00'
end event

type dw_report from w_rpt_list`dw_report within w_cn786_rpt_anexo_ctacte
boolean visible = false
integer x = 14
integer y = 252
integer width = 3067
integer height = 1388
integer taborder = 0
string dataobject = "d_rpt_anexo_res_ctacte_sol_tbl"
integer ii_zoom_actual = 100
end type

type dw_1 from w_rpt_list`dw_1 within w_cn786_rpt_anexo_ctacte
integer x = 165
integer y = 628
integer width = 1280
integer height = 932
integer taborder = 0
string dataobject = "d_cntbl_rpt_cuentas_ctacte_tbl"
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

type pb_1 from w_rpt_list`pb_1 within w_cn786_rpt_anexo_ctacte
integer x = 1490
integer y = 940
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cn786_rpt_anexo_ctacte
integer x = 1490
integer y = 1060
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn786_rpt_anexo_ctacte
integer x = 1659
integer y = 628
integer width = 1280
integer height = 932
integer taborder = 0
string dataobject = "d_cntbl_rpt_cuentas_ctacte_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cn786_rpt_anexo_ctacte
integer x = 2565
integer y = 48
integer width = 297
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;integer i
string  ls_cuenta, ls_descripcion
string  ls_codigo

idw_1.Visible = True
dw_1.visible = False
dw_2.visible = False
pb_1.visible = False
pb_2.visible = False
gb_2.visible = False
dw_text.visible = false
st_campo.visible = false

delete from tt_cntbl_rpt_cuentas_ctacte ;
	
for i = 1 to dw_2.rowcount()
  	 ls_cuenta      = dw_2.object.cnta_ctbl[i]
 	 ls_descripcion = dw_2.object.desc_cnta[i]
	 
	 insert into tt_cntbl_rpt_cuentas_ctacte (cuenta, descripcion)
	 values (:ls_cuenta, :ls_descripcion) ;
	 
	 if sqlca.sqlcode = -1 then
		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
	end if
next

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn786_rpt_anexo_ctacte
integer x = 489
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

type sle_mes_ini from singlelineedit within w_cn786_rpt_anexo_ctacte
integer x = 736
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

type dw_text from datawindow within w_cn786_rpt_anexo_ctacte
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 169
integer y = 524
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

type st_campo from statictext within w_cn786_rpt_anexo_ctacte
integer x = 1659
integer y = 536
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

type pb_3 from picturebutton within w_cn786_rpt_anexo_ctacte
integer x = 2642
integer y = 140
integer width = 169
integer height = 120
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

type st_1 from statictext within w_cn786_rpt_anexo_ctacte
integer x = 1111
integer y = 124
integer width = 210
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
string text = "Moneda:"
boolean focusrectangle = false
end type

type cbx_pres from checkbox within w_cn786_rpt_anexo_ctacte
integer x = 1664
integer y = 72
integer width = 631
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Presentación horizontal"
end type

type cbx_ape from checkbox within w_cn786_rpt_anexo_ctacte
integer x = 1664
integer y = 148
integer width = 786
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Incluye saldos periodo anterior"
end type

type rb_res from radiobutton within w_cn786_rpt_anexo_ctacte
integer x = 87
integer y = 64
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
long backcolor = 12632256
string text = "Resumen"
boolean checked = true
end type

type rb_det from radiobutton within w_cn786_rpt_anexo_ctacte
integer x = 87
integer y = 156
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
long backcolor = 12632256
string text = "Detalle"
end type

type ddlb_1 from dropdownlistbox within w_cn786_rpt_anexo_ctacte
integer x = 1330
integer y = 112
integer width = 288
integer height = 400
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"S/.","US$"}
borderstyle borderstyle = stylelowered!
end type

type sle_mes_fin from singlelineedit within w_cn786_rpt_anexo_ctacte
integer x = 891
integer y = 128
integer width = 123
integer height = 72
integer taborder = 30
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

type sle_titulo from singlelineedit within w_cn786_rpt_anexo_ctacte
integer x = 562
integer y = 256
integer width = 1874
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "ANEXO DE CUENTA CORRIENTE"
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn786_rpt_anexo_ctacte
integer x = 69
integer y = 260
integer width = 402
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Titulo reporte:"
boolean focusrectangle = false
end type

type sle_subtitulo from singlelineedit within w_cn786_rpt_anexo_ctacte
integer x = 562
integer y = 344
integer width = 1874
integer height = 72
integer taborder = 70
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

type st_3 from statictext within w_cn786_rpt_anexo_ctacte
integer x = 78
integer y = 348
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "SubTitulo reporte:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn786_rpt_anexo_ctacte
integer x = 439
integer y = 60
integer width = 626
integer height = 164
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Año y Rango meses"
end type

type gb_2 from groupbox within w_cn786_rpt_anexo_ctacte
integer x = 101
integer y = 436
integer width = 2912
integer height = 1184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Cuentas Contables "
end type

type rr_1 from roundrectangle within w_cn786_rpt_anexo_ctacte
integer linethickness = 5
long fillcolor = 12632256
integer x = 59
integer y = 48
integer width = 2418
integer height = 384
integer cornerheight = 40
integer cornerwidth = 46
end type

