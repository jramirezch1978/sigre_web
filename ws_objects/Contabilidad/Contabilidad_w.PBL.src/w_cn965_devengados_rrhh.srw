$PBExportHeader$w_cn965_devengados_rrhh.srw
forward
global type w_cn965_devengados_rrhh from w_prc
end type
type cbx_mes from checkbox within w_cn965_devengados_rrhh
end type
type st_7 from statictext within w_cn965_devengados_rrhh
end type
type dw_origen from datawindow within w_cn965_devengados_rrhh
end type
type sle_libro from singlelineedit within w_cn965_devengados_rrhh
end type
type st_5 from statictext within w_cn965_devengados_rrhh
end type
type sle_mes from singlelineedit within w_cn965_devengados_rrhh
end type
type sle_ano from singlelineedit within w_cn965_devengados_rrhh
end type
type cb_cancelar from commandbutton within w_cn965_devengados_rrhh
end type
type cb_generar from commandbutton within w_cn965_devengados_rrhh
end type
type st_4 from statictext within w_cn965_devengados_rrhh
end type
type st_2 from statictext within w_cn965_devengados_rrhh
end type
type st_1 from statictext within w_cn965_devengados_rrhh
end type
type gb_1 from groupbox within w_cn965_devengados_rrhh
end type
end forward

global type w_cn965_devengados_rrhh from w_prc
integer width = 1646
integer height = 1072
string title = "[CN965] Pre asientos de Devengados de PLANILLA"
string menuname = "m_prc"
boolean maxbox = false
boolean resizable = false
boolean center = true
cbx_mes cbx_mes
st_7 st_7
dw_origen dw_origen
sle_libro sle_libro
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_4 st_4
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn965_devengados_rrhh w_cn965_devengados_rrhh

on w_cn965_devengados_rrhh.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.cbx_mes=create cbx_mes
this.st_7=create st_7
this.dw_origen=create dw_origen
this.sle_libro=create sle_libro
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_mes
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.sle_libro
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.cb_cancelar
this.Control[iCurrent+9]=this.cb_generar
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn965_devengados_rrhh.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_mes)
destroy(this.st_7)
destroy(this.dw_origen)
destroy(this.sle_libro)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro



try 
	
	// Proceso CANI
	ls_ano = string(gnvo_app.of_fecha_Actual(), 'yyyy')
	ls_mes = string(gnvo_app.of_fecha_Actual(), 'mm')
	
	sle_ano.text = ls_ano
	sle_mes.text = ls_mes
	sle_libro.text = gnvo_app.of_get_parametro( 'LIBRO_DEVENGADO_RRHH', '34')
	
	dw_origen.SetTransObject(SQLCA)
	dw_origen.Retrieve()
	
	dw_origen.InsertRow(0)
	dw_origen.object.origen[1] = gs_origen
	
catch ( Exception ex )
	MessageBox('Exception en event open()', ex.getMessage())
	
finally
	/*statementBlock*/
end try



end event

type cbx_mes from checkbox within w_cn965_devengados_rrhh
integer x = 457
integer y = 508
integer width = 366
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir Mes"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_mes.enabled = true
else
	sle_mes.enabled = false
end if
end event

type st_7 from statictext within w_cn965_devengados_rrhh
integer x = 398
integer y = 312
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_origen from datawindow within w_cn965_devengados_rrhh
integer x = 841
integer y = 304
integer width = 256
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_origen_ff"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_cn965_devengados_rrhh
event ue_dobleclick pbm_lbuttondblclk
integer x = 841
integer y = 604
integer width = 192
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT trim(to_char(nro_libro)) AS CODIGO, " &
		 + "desc_libro AS DESCRIPCION " &
		 + "FROM cntbl_libro " &
		 + "ORDER BY nro_libro " 

//ls_sql = "SELECT d.tipo_doc AS CODIGO, " &
//		 + "d.desc_tipo_doc AS DESCRIPCION " &
//		 + "FROM doc_tipo d " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data,'1') 

if ls_codigo <> '' then
	this.text   = ls_codigo
// sle_1.text	= ls_data
end if



end event

type st_5 from statictext within w_cn965_devengados_rrhh
integer x = 256
integer y = 112
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "de Devengados de PLANILLA"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn965_devengados_rrhh
integer x = 841
integer y = 504
integer width = 192
integer height = 80
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

type sle_ano from singlelineedit within w_cn965_devengados_rrhh
integer x = 841
integer y = 404
integer width = 192
integer height = 80
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

type cb_cancelar from commandbutton within w_cn965_devengados_rrhh
integer x = 855
integer y = 760
integer width = 302
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn965_devengados_rrhh
integer x = 494
integer y = 760
integer width = 302
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Long		ll_year, ll_mes, ll_nro_libro
string  	ls_msj, ls_tipo_alm, ls_origen
Date		ld_fecha

try 
	cb_generar.enabled = false
	
	ll_year 			= Long(sle_ano.text)

	if cbx_mes.checked then
		ll_mes 			= Long(sle_mes.text)
	else
		ll_mes 			= -1
	end if
	
	ll_nro_libro 	= Long(sle_libro.text)
	ls_origen 		= dw_origen.object.origen[1]
	
	// Generacion de asientos contables de devengado de planilla
	//create or replace procedure USP_RH_DEVENGADO_EXTORNO (
	//       asi_origen       in origen.cod_origen%TYPE,
	//       ani_year         in number,
	//       ani_mes          in number,
	//       ani_nro_libro    in cntbl_libro.nro_libro%TYPE,
	//       asi_usuario      in usuario.cod_usr%TYPE
	//) is
	//
	
	DECLARE USP_RH_DEVENGADO_EXTORNO PROCEDURE FOR 
		USP_RH_DEVENGADO_EXTORNO ( :ls_origen,
											:ll_year, 
											:ll_mes, 
											:ll_nro_libro, 
											:gs_user ) ;
	
	EXECUTE USP_RH_DEVENGADO_EXTORNO  ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error USP_RH_DEVENGADO_EXTORNO', 'Se produjo un error al ejecutar el procedure USP_RH_DEVENGADO_EXTORNO: ' + ls_msj, StopSign! )
		return
	END IF
	
	Close USP_RH_DEVENGADO_EXTORNO;
	
	MessageBox( 'Mensaje', "Proceso terminado" )

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al realizar el proceso de generacion")

finally
	cb_generar.enabled = true
end try

		

end event

type st_4 from statictext within w_cn965_devengados_rrhh
integer x = 398
integer y = 612
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro contable :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn965_devengados_rrhh
integer x = 398
integer y = 412
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn965_devengados_rrhh
integer x = 256
integer y = 16
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generación de pre asientos"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn965_devengados_rrhh
integer x = 187
integer y = 232
integer width = 1248
integer height = 492
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Generales"
end type

