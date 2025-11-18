$PBExportHeader$w_cn971_apertura_ejercicio.srw
forward
global type w_cn971_apertura_ejercicio from w_prc
end type
type uo_1 from u_ingreso_fecha within w_cn971_apertura_ejercicio
end type
type cb_cancelar from commandbutton within w_cn971_apertura_ejercicio
end type
type cb_generar from commandbutton within w_cn971_apertura_ejercicio
end type
type st_1 from statictext within w_cn971_apertura_ejercicio
end type
type gb_2 from groupbox within w_cn971_apertura_ejercicio
end type
end forward

global type w_cn971_apertura_ejercicio from w_prc
integer width = 1650
integer height = 768
string title = "(CN971) Apertura del Ejercicio"
boolean resizable = false
boolean center = true
uo_1 uo_1
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_2 gb_2
end type
global w_cn971_apertura_ejercicio w_cn971_apertura_ejercicio

on w_cn971_apertura_ejercicio.create
int iCurrent
call super::create
this.uo_1=create uo_1
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.cb_generar
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_cn971_apertura_ejercicio.destroy
call super::destroy
destroy(this.uo_1)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_1)
destroy(this.gb_2)
end on

type uo_1 from u_ingreso_fecha within w_cn971_apertura_ejercicio
integer x = 498
integer y = 308
integer taborder = 10
end type

event constructor;call super::constructor;date ld_fec_proceso 
of_set_label('Al')
ld_fec_proceso = today()

of_set_fecha(ld_fec_proceso)
of_set_rango_inicio(date('01/01/1900'))
of_set_rango_fin(date('31/12/9999'))

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type cb_cancelar from commandbutton within w_cn971_apertura_ejercicio
integer x = 869
integer y = 480
integer width = 347
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn971_apertura_ejercicio
integer x = 389
integer y = 480
integer width = 347
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;cb_generar.enabled  = false
cb_cancelar.enabled = false

date ld_fec_proceso
string ls_mensaje

try 
	cb_generar.enabled  = false
	cb_cancelar.enabled = false
	
	ld_fec_proceso = uo_1.of_get_fecha()

	DECLARE USP_CNTBL_APERTURA_EJERCICIO PROCEDURE FOR 
		USP_CNTBL_APERTURA_EJERCICIO( :ld_fec_proceso, 
												:gs_origen, 
												:gs_user ) ;
	EXECUTE USP_CNTBL_APERTURA_EJERCICIO ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_mensaje = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( "Store Procedure USP_CNTBL_APERTURA_EJERCICIO Falló", ls_mensaje, StopSign! )
		return
	end if
	
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
	
	CLOSE USP_CNTBL_APERTURA_EJERCICIO ;

catch ( Exception ex )
	gnvo_app.of_message_error("Ha ocurrido una excepcion. Mensaje: " + ex.GetMessage())
	
finally
	cb_generar.enabled  = true
	cb_cancelar.enabled = true
end try


end event

type st_1 from statictext within w_cn971_apertura_ejercicio
integer x = 151
integer y = 20
integer width = 1303
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "APERTURA DEL EJERCICIO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_cn971_apertura_ejercicio
integer x = 411
integer y = 228
integer width = 777
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

