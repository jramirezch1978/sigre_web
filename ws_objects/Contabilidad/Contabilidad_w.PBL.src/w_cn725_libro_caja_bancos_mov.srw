$PBExportHeader$w_cn725_libro_caja_bancos_mov.srw
forward
global type w_cn725_libro_caja_bancos_mov from w_report_smpl
end type
type cb_generar from commandbutton within w_cn725_libro_caja_bancos_mov
end type
type sle_ano from singlelineedit within w_cn725_libro_caja_bancos_mov
end type
type sle_mes from singlelineedit within w_cn725_libro_caja_bancos_mov
end type
type st_10 from statictext within w_cn725_libro_caja_bancos_mov
end type
type st_11 from statictext within w_cn725_libro_caja_bancos_mov
end type
type rb_asiento from radiobutton within w_cn725_libro_caja_bancos_mov
end type
type rb_cuenta from radiobutton within w_cn725_libro_caja_bancos_mov
end type
type rb_resumen from radiobutton within w_cn725_libro_caja_bancos_mov
end type
type gb_1 from groupbox within w_cn725_libro_caja_bancos_mov
end type
end forward

global type w_cn725_libro_caja_bancos_mov from w_report_smpl
integer width = 3529
integer height = 2044
string title = "Detalle de libro caja (CN725)"
string menuname = "m_abc_report_smpl"
cb_generar cb_generar
sle_ano sle_ano
sle_mes sle_mes
st_10 st_10
st_11 st_11
rb_asiento rb_asiento
rb_cuenta rb_cuenta
rb_resumen rb_resumen
gb_1 gb_1
end type
global w_cn725_libro_caja_bancos_mov w_cn725_libro_caja_bancos_mov

on w_cn725_libro_caja_bancos_mov.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_generar=create cb_generar
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_10=create st_10
this.st_11=create st_11
this.rb_asiento=create rb_asiento
this.rb_cuenta=create rb_cuenta
this.rb_resumen=create rb_resumen
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.rb_asiento
this.Control[iCurrent+7]=this.rb_cuenta
this.Control[iCurrent+8]=this.rb_resumen
this.Control[iCurrent+9]=this.gb_1
end on

on w_cn725_libro_caja_bancos_mov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.rb_asiento)
destroy(this.rb_cuenta)
destroy(this.rb_resumen)
destroy(this.gb_1)
end on

event ue_retrieve;String 	ls_nombre_mes, ls_nom_empresa, ls_mensaje
Integer 	li_ano, li_mes

try 
	IF rb_asiento.checked = TRUE THEN
		
		IF gs_empresa = 'FISHOLG' then
			idw_1.DataObject='d_rpt_libro_caja_bancos_det_fisholg_tbl'
		else
			idw_1.DataObject='d_rpt_libro_caja_bancos_det_tbl'	
		end if

	ELSEIF rb_cuenta.checked = TRUE THEN
		
		
		IF gs_empresa = 'FISHOLG' then
			idw_1.DataObject='d_rpt_libro_caja_bancos_mov_fisholg_tbl'
		else
			idw_1.DataObject='d_rpt_libro_caja_bancos_mov_tbl'	
		end if
	
	ELSEIF rb_resumen.checked = TRUE THEN
		
		IF gs_empresa = 'FISHOLG' then
			idw_1.DataObject='d_rpt_libro_caja_bancos_res_fisholg_tbl'
		else
			idw_1.DataObject='d_rpt_libro_caja_bancos_res_tbl'
		end if
	
	ELSE
		
		MessageBox('Aviso','Seleccione una de las opciones')
		RETURN
		
	END IF
	
	cb_generar.enabled = false
	SetPointer(hourglass!)
	
	li_ano = Integer(sle_ano.text)
	li_mes = Integer(sle_mes.text)
	
	DECLARE USP_CNT_REP_CAJA_BANCOS_MOV PROCEDURE FOR 
		USP_CNT_REP_CAJA_BANCOS_MOV ( :li_ano, :li_mes ) ;
	
	Execute USP_CNT_REP_CAJA_BANCOS_MOV ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox( 'Error en USP_CNT_REP_CAJA_BANCOS_MOV', ls_mensaje, StopSign! )
		Return
	END IF
	
	//--
	CHOOSE CASE li_mes
				
			CASE 0
				  ls_nombre_mes = 'MES CERO'
			CASE 1
				  ls_nombre_mes = '01 ENERO'
			CASE 2
				  ls_nombre_mes = '02 FEBRERO'
			CASE 3
				  ls_nombre_mes = '03 MARZO'
			CASE 4
				  ls_nombre_mes = '04 ABRIL'
			CASE 5
				  ls_nombre_mes = '05 MAYO'
			CASE 6
				  ls_nombre_mes = '06 JUNIO'
			CASE 7
				  ls_nombre_mes = '07 JULIO'
			CASE 8
				  ls_nombre_mes = '08 AGOSTO'
			CASE 9
				  ls_nombre_mes = '09 SEPTIEMBRE'
			CASE 10
				  ls_nombre_mes = '10 OCTUBRE'
			CASE 11
				  ls_nombre_mes = '11 NOVIEMBRE'
			CASE 12
				  ls_nombre_mes = '12 DICIEMBRE'
		END CHOOSE
	//--
	
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
	idw_1.Visible = True
	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_texto.text = 'Año: ' + string(li_ano, '0000') + '  Mes: ' + ls_nombre_mes
	
	IF gs_empresa = 'FISHOLG' then
		dw_report.object.t_empresa2.text  = gnvo_app.empresa.is_nom_empresa
	end if
	
	idw_1.object.t_ruc.text = gs_ruc
	
	
	CLOSE USP_CNT_REP_CAJA_BANCOS_MOV;

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
	
finally
	cb_generar.enabled = true
	SetPointer(Arrow!)
end try


end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = String(today(), 'yyyy')
sle_mes.text = String(today(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn725_libro_caja_bancos_mov
integer x = 0
integer y = 356
integer width = 3406
integer height = 1408
integer taborder = 90
string dataobject = "d_rpt_libro_caja_bancos_det_tbl"
end type

type cb_generar from commandbutton within w_cn725_libro_caja_bancos_mov
integer x = 1710
integer y = 156
integer width = 297
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn725_libro_caja_bancos_mov
integer x = 914
integer y = 176
integer width = 192
integer height = 76
integer taborder = 50
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

type sle_mes from singlelineedit within w_cn725_libro_caja_bancos_mov
integer x = 1362
integer y = 176
integer width = 105
integer height = 72
integer taborder = 60
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

type st_10 from statictext within w_cn725_libro_caja_bancos_mov
integer x = 1161
integer y = 184
integer width = 201
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn725_libro_caja_bancos_mov
integer x = 745
integer y = 184
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_asiento from radiobutton within w_cn725_libro_caja_bancos_mov
integer x = 105
integer y = 92
integer width = 544
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x asiento contable"
end type

type rb_cuenta from radiobutton within w_cn725_libro_caja_bancos_mov
integer x = 105
integer y = 176
integer width = 544
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x cuenta contable"
end type

type rb_resumen from radiobutton within w_cn725_libro_caja_bancos_mov
integer x = 105
integer y = 260
integer width = 544
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "resumen"
end type

type gb_1 from groupbox within w_cn725_libro_caja_bancos_mov
integer x = 32
integer y = 44
integer width = 1536
integer height = 296
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

