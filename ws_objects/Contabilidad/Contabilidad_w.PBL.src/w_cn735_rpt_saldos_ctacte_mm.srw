$PBExportHeader$w_cn735_rpt_saldos_ctacte_mm.srw
forward
global type w_cn735_rpt_saldos_ctacte_mm from w_rpt_list
end type
type sle_ano from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
end type
type sle_mes from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
end type
type dw_text from datawindow within w_cn735_rpt_saldos_ctacte_mm
end type
type st_campo from statictext within w_cn735_rpt_saldos_ctacte_mm
end type
type pb_3 from picturebutton within w_cn735_rpt_saldos_ctacte_mm
end type
type sle_periodo_ant from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
end type
type st_2 from statictext within w_cn735_rpt_saldos_ctacte_mm
end type
type em_origen from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
end type
type em_descripcion from editmask within w_cn735_rpt_saldos_ctacte_mm
end type
type cbx_origen from checkbox within w_cn735_rpt_saldos_ctacte_mm
end type
type gb_1 from groupbox within w_cn735_rpt_saldos_ctacte_mm
end type
type gb_2 from groupbox within w_cn735_rpt_saldos_ctacte_mm
end type
type gb_3 from groupbox within w_cn735_rpt_saldos_ctacte_mm
end type
type rr_1 from roundrectangle within w_cn735_rpt_saldos_ctacte_mm
end type
end forward

global type w_cn735_rpt_saldos_ctacte_mm from w_rpt_list
integer width = 3154
integer height = 1744
string title = "Reporte de Saldos de Cuenta Corriente (CN735)"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
dw_text dw_text
st_campo st_campo
pb_3 pb_3
sle_periodo_ant sle_periodo_ant
st_2 st_2
em_origen em_origen
em_descripcion em_descripcion
cbx_origen cbx_origen
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
rr_1 rr_1
end type
global w_cn735_rpt_saldos_ctacte_mm w_cn735_rpt_saldos_ctacte_mm

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

on w_cn735_rpt_saldos_ctacte_mm.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.dw_text=create dw_text
this.st_campo=create st_campo
this.pb_3=create pb_3
this.sle_periodo_ant=create sle_periodo_ant
this.st_2=create st_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cbx_origen=create cbx_origen
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.sle_periodo_ant
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.cbx_origen
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.rr_1
end on

on w_cn735_rpt_saldos_ctacte_mm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.pb_3)
destroy(this.sle_periodo_ant)
destroy(this.st_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cbx_origen)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_origen, ls_desc_origen, ls_period_ant, ls_msj, &
		 ls_nombre_mes 
Integer ll_ano, ll_mes

ls_ano = String(sle_ano.text)
ll_ano = INTEGER(String(sle_ano.text))
ls_mes = String(sle_mes.text)
ll_mes = INTEGER(String(sle_mes.text))

// Hacer funcion
IF ll_mes=0 THEN
	ls_nombre_mes = 'Apertura'
ELSEIF ll_mes=1 THEN
	ls_nombre_mes = 'Enero'
ELSEIF ll_mes=2 THEN
	ls_nombre_mes = 'Febrero'
ELSEIF ll_mes=3 THEN
	ls_nombre_mes = 'Marzo'
ELSEIF ll_mes=4 THEN
	ls_nombre_mes = 'Abril'
ELSEIF ll_mes=5 THEN
	ls_nombre_mes = 'Mayo'
ELSEIF ll_mes=6 THEN
	ls_nombre_mes = 'Junio'
ELSEIF ll_mes=7 THEN
	ls_nombre_mes = 'Julio'
ELSEIF ll_mes=8 THEN
	ls_nombre_mes = 'Agosto'
ELSEIF ll_mes=9 THEN
	ls_nombre_mes = 'Setiembre'
ELSEIF ll_mes=10 THEN
	ls_nombre_mes = 'Octubre'
ELSEIF ll_mes=11 THEN
	ls_nombre_mes = 'Noviembre'
ELSEIF ll_mes=12 THEN
	ls_nombre_mes = 'Diciembre'
ELSEIF ll_mes=13 THEN
	ls_nombre_mes = 'Diciembre ajustado'
ELSE
	ls_nombre_mes = 'Defina nombre mes'
END IF 

IF cbx_origen.Checked THEN
	ls_origen			= '%%' 	//Todos los Origenes
	ls_desc_origen		=	'Todos los Origenes'
		
	ELSE
		
	ls_origen 			=  upper(string(em_origen.text))	//Un solo Origen
	ls_desc_origen	 	=  string(em_descripcion.text)
				
	IF len(trim(ls_origen)) = 0 OR IsNull(ls_origen) THEN
			messagebox('Contabilidad', 'Por favor seleccione un Origen')
		 RETURN
	END IF
END IF
	
	ls_period_ant = upper(trim(sle_periodo_ant.text))
		
	if ls_period_ant = 'S' or ls_period_ant = 'N' then
	
		DECLARE usp_cnt_rpt_sdo_ctacte_dato PROCEDURE FOR 
			usp_cnt_rpt_sdo_ctacte_dato (:ll_ano, 
												  :ll_mes, 
												  :ls_origen, 
												  :ls_period_ant) ;
		EXECUTE usp_cnt_rpt_sdo_ctacte_dato ;	
		
		IF sqlca.sqlcode = -1 THEN
			ls_msj = sqlca.sqlerrtext
			ROLLBACK ;
			MessageBox( 'Error en usp_cnt_rpt_sdo_ctacte_dato', ls_msj, StopSign! )
			RETURN
		end if
		
		close usp_cnt_rpt_sdo_ctacte_dato;
		
	ELSE
		messagebox('Aviso','Acumulador de periodo debe de ser S o N')
		RETURN
	END IF
	
//ELSE
//	
//	ls_origen 			=  upper(string(em_origen.text))	//Un solo Origen
//	ls_desc_origen	 	=  string(em_descripcion.text)
//				
//	IF len(trim(ls_origen)) = 0 OR IsNull(ls_origen) THEN
//			messagebox('Contabilidad', 'Por favor seleccione un Origen')
//		 RETURN
//	else
//		DECLARE pb_usp_cnt_rpt_sldo_ctacte_x_orig PROCEDURE FOR usp_cnt_rpt_sldo_ctacte_x_orig
//			  ( :ls_ano, :ls_mes,:ls_origen) ;
//	Execute pb_usp_cnt_rpt_sldo_ctacte_x_orig ;		
//end if

dw_report.retrieve()

dw_report.object.p_logo.filename = 	gs_logo
dw_report.object.t_empresa.text 	= 	gs_empresa
dw_report.object.t_user.text 		= 	gs_user
dw_report.object.t_texto.text 	= 	'A ' + ls_nombre_mes + ' del ' + ls_ano + ', '+ ls_desc_origen

//END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_cn735_rpt_saldos_ctacte_mm
boolean visible = false
integer x = 14
integer y = 280
integer width = 3067
integer height = 1360
integer taborder = 0
string dataobject = "d_rpt_sdo_ctacte_dato_tbl"
integer ii_zoom_actual = 100
end type

type dw_1 from w_rpt_list`dw_1 within w_cn735_rpt_saldos_ctacte_mm
integer x = 165
integer y = 472
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

type pb_1 from w_rpt_list`pb_1 within w_cn735_rpt_saldos_ctacte_mm
integer x = 1490
integer y = 784
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cn735_rpt_saldos_ctacte_mm
integer x = 1490
integer y = 904
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn735_rpt_saldos_ctacte_mm
integer x = 1659
integer y = 472
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

type cb_report from w_rpt_list`cb_report within w_cn735_rpt_saldos_ctacte_mm
integer x = 2761
integer y = 116
integer width = 261
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;integer i
string  ls_cuenta, ls_descripcion
string  ls_codigo
Long ll_count

idw_1.Visible 		= 	True
dw_1.visible 		= 	False
dw_2.visible 		= 	False
pb_1.visible 		= 	False
pb_2.visible 		= 	False
gb_2.visible 		= 	False
dw_text.visible 	= 	false
st_campo.visible 	= 	false

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

select count(*) into :ll_count from tt_cntbl_rpt_cuentas_ctacte ;

IF ll_count=0 THEN
	MessageBox('Aviso','Seleccione cuentas contables a reportar')
	return
END IF

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
integer x = 197
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

type sle_mes from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
integer x = 443
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

type dw_text from datawindow within w_cn735_rpt_saldos_ctacte_mm
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

type st_campo from statictext within w_cn735_rpt_saldos_ctacte_mm
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

type pb_3 from picturebutton within w_cn735_rpt_saldos_ctacte_mm
integer x = 2533
integer y = 100
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

type sle_periodo_ant from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
integer x = 2363
integer y = 112
integer width = 73
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "N"
integer limit = 1
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn735_rpt_saldos_ctacte_mm
integer x = 1559
integer y = 128
integer width = 795
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Acumula periodo anterior: [S/N]"
boolean focusrectangle = false
end type

type em_origen from singlelineedit within w_cn735_rpt_saldos_ctacte_mm
event dobleclick pbm_lbuttondblclk
integer x = 672
integer y = 124
integer width = 128
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_cn735_rpt_saldos_ctacte_mm
integer x = 814
integer y = 124
integer width = 663
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_origen from checkbox within w_cn735_rpt_saldos_ctacte_mm
integer x = 667
integer y = 52
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Origen     /     Todos"
boolean checked = true
boolean lefttext = true
end type

event clicked;IF THIS.CHECKED THEN
	em_origen.Enabled 	= False
	em_origen.Text 		= ''
	em_descripcion.text	= ''
ELSE
	em_origen.Enabled = True
END IF
end event

type gb_1 from groupbox within w_cn735_rpt_saldos_ctacte_mm
integer x = 146
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

type gb_2 from groupbox within w_cn735_rpt_saldos_ctacte_mm
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
string text = " Seleccione Cuentas Contables "
end type

type gb_3 from groupbox within w_cn735_rpt_saldos_ctacte_mm
integer x = 631
integer y = 60
integer width = 891
integer height = 164
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type rr_1 from roundrectangle within w_cn735_rpt_saldos_ctacte_mm
integer linethickness = 5
long fillcolor = 12632256
integer x = 110
integer y = 48
integer width = 2624
integer height = 212
integer cornerheight = 40
integer cornerwidth = 46
end type

