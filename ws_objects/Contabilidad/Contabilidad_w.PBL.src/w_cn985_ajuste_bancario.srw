$PBExportHeader$w_cn985_ajuste_bancario.srw
forward
global type w_cn985_ajuste_bancario from w_prc
end type
type dw_reporte from u_dw_rpt within w_cn985_ajuste_bancario
end type
type cb_reporte from commandbutton within w_cn985_ajuste_bancario
end type
type sle_mes from singlelineedit within w_cn985_ajuste_bancario
end type
type sle_ano from singlelineedit within w_cn985_ajuste_bancario
end type
type cb_cancelar from commandbutton within w_cn985_ajuste_bancario
end type
type cb_generar from commandbutton within w_cn985_ajuste_bancario
end type
type st_3 from statictext within w_cn985_ajuste_bancario
end type
type st_2 from statictext within w_cn985_ajuste_bancario
end type
type st_1 from statictext within w_cn985_ajuste_bancario
end type
type gb_1 from groupbox within w_cn985_ajuste_bancario
end type
end forward

global type w_cn985_ajuste_bancario from w_prc
integer width = 3387
integer height = 1908
string title = "[CN985] Ajuste por diferencia bancaria - SALDOS BANCARIOS"
dw_reporte dw_reporte
cb_reporte cb_reporte
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn985_ajuste_bancario w_cn985_ajuste_bancario

on w_cn985_ajuste_bancario.create
int iCurrent
call super::create
this.dw_reporte=create dw_reporte
this.cb_reporte=create cb_reporte
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reporte
this.Control[iCurrent+2]=this.cb_reporte
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn985_ajuste_bancario.destroy
call super::destroy
destroy(this.dw_reporte)
destroy(this.cb_reporte)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;String ls_ano, ls_mes
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) -1 )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

dw_reporte.SetTransObject(SQLCA)

end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

st_1.width = dw_reporte.width
end event

type dw_reporte from u_dw_rpt within w_cn985_ajuste_bancario
integer y = 332
integer width = 3337
integer height = 1460
integer taborder = 30
string dataobject = "d_rpt_saldos_bancarios_tbl"
end type

type cb_reporte from commandbutton within w_cn985_ajuste_bancario
integer x = 1184
integer y = 176
integer width = 320
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;String 	ls_msj
Integer	li_year, li_mes

try 
	
	li_year 	= Integer(sle_ano.text)
	li_mes 	= Integer(sle_mes.text)
		
	dw_reporte.Retrieve(li_year, li_mes)
	
	if dw_reporte.RowCount() > 0 then
		cb_generar.enabled = true
	end if

	
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
finally
	

	
end try

end event

type sle_mes from singlelineedit within w_cn985_ajuste_bancario
integer x = 562
integer y = 184
integer width = 187
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn985_ajuste_bancario
integer x = 229
integer y = 184
integer width = 187
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn985_ajuste_bancario
integer x = 1824
integer y = 176
integer width = 320
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
boolean cancel = true
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn985_ajuste_bancario
integer x = 1504
integer y = 176
integer width = 320
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Generar"
end type

event clicked;String 	ls_msj
Integer	li_year, li_mes

try 
	
	cb_generar.enabled  = false
	cb_cancelar.enabled = false
	
	sle_ano.enabled     = false
	sle_mes.enabled     = false
	
	li_year 	= Integer(sle_ano.text)
	li_mes 	= Integer(sle_mes.text)
	

	//create or replace procedure usp_cntbl_ajuste_bancario( 
	//       asi_origen  in origen.cod_origen%TYPE,
	//       ani_year    in cntbl_asiento.ano%TYPE, 
	//       ani_mes     in cntbl_asiento.mes%TYPE, 
	//       asi_usuario in usuario.cod_usr%TYPE
	//) is	
	
	DECLARE USP_CNTBL_AJUSTE_BANCARIO PROCEDURE FOR 
		USP_CNTBL_AJUSTE_BANCARIO( :gs_origen, 
											:li_year, 
											:li_mes, 
											:gs_user ) ;
	EXECUTE USP_CNTBL_AJUSTE_BANCARIO ;
	
	IF sqlca.sqlcode < 0 THEN
		ls_msj = sqlca.sqlerrtext
		rollback ;
		MessageBox ('Error',"Error en procedimiento USP_CNTBL_AJUSTE_BANCARIO. Mensaje: "+ ls_msj, StopSign!)
		return
	end if
	
	dw_reporte.Retrieve(li_year, li_mes)
	
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")	
	
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
finally
	
	CLOSE USP_CNTBL_AJUSTE_BANCARIO ;
	
	cb_generar.enabled  = true
	cb_cancelar.enabled = true
	sle_ano.enabled     = true
	sle_mes.enabled     = true
	
end try

end event

type st_3 from statictext within w_cn985_ajuste_bancario
integer x = 421
integer y = 184
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn985_ajuste_bancario
integer x = 69
integer y = 184
integer width = 169
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn985_ajuste_bancario
integer width = 2537
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 16777215
long backcolor = 8388608
string text = "Ajuste por diferencia bancaria - SALDOS BANCARIOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn985_ajuste_bancario
integer y = 104
integer width = 2542
integer height = 220
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

