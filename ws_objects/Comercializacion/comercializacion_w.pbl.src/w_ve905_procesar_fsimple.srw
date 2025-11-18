$PBExportHeader$w_ve905_procesar_fsimple.srw
forward
global type w_ve905_procesar_fsimple from w_abc
end type
type st_3 from statictext within w_ve905_procesar_fsimple
end type
type st_1 from statictext within w_ve905_procesar_fsimple
end type
type st_2 from statictext within w_ve905_procesar_fsimple
end type
type cb_generar from commandbutton within w_ve905_procesar_fsimple
end type
type cb_cancelar from commandbutton within w_ve905_procesar_fsimple
end type
type sle_year from singlelineedit within w_ve905_procesar_fsimple
end type
type sle_mes from singlelineedit within w_ve905_procesar_fsimple
end type
type gb_1 from groupbox within w_ve905_procesar_fsimple
end type
end forward

global type w_ve905_procesar_fsimple from w_abc
integer width = 1349
integer height = 832
string title = "[VE905] Procesamiento de Factura Simplificada"
string menuname = "m_salir"
st_3 st_3
st_1 st_1
st_2 st_2
cb_generar cb_generar
cb_cancelar cb_cancelar
sle_year sle_year
sle_mes sle_mes
gb_1 gb_1
end type
global w_ve905_procesar_fsimple w_ve905_procesar_fsimple

on w_ve905_procesar_fsimple.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_3=create st_3
this.st_1=create st_1
this.st_2=create st_2
this.cb_generar=create cb_generar
this.cb_cancelar=create cb_cancelar
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_generar
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.sle_mes
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve905_procesar_fsimple.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_generar)
destroy(this.cb_cancelar)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date 	ld_fecha

ld_fecha = Date(gnvo_app.of_fecha_Actual())

sle_year.text 	= string(ld_fecha, 'yyyy')
sle_mes.text	= String(ld_fecha, 'mm')
end event

type st_3 from statictext within w_ve905_procesar_fsimple
integer x = 247
integer y = 348
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
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ve905_procesar_fsimple
integer x = 27
integer y = 68
integer width = 1234
integer height = 176
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generación de Facturacion Simplificada para el registro de Ventas"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ve905_procesar_fsimple
integer x = 247
integer y = 252
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
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_generar from commandbutton within w_ve905_procesar_fsimple
integer x = 352
integer y = 548
integer width = 302
integer height = 84
integer taborder = 30
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
	
	if trim(sle_year.text) = '' then
		MessageBox('Error', 'Debe especificar el año', StopSign!)
		sle_year.setFocus( )
		return
	end if

	if trim(sle_mes.text) = '' then
		MessageBox('Error', 'Debe especificar el mes', StopSign!)
		sle_mes.setFocus( )
		return
	end if	
	
	ll_year = Long(sle_year.text)
	ll_mes  = Long(sle_mes.text)
	
	//	begin
	//	  pkg_fact_electronica.sp_procesar_periodo(ani_year => :ani_year,
	//															 ani_mes => :ani_mes);
	//	end;
	
	DECLARE sp_procesar_periodo PROCEDURE FOR 
		pkg_fact_electronica.sp_procesar_periodo(:ll_year,
															  :ll_mes);
	
	EXECUTE sp_procesar_periodo  ;
	
	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error pkg_fact_electronica.sp_procesar_periodo()', 'Se produjo un error al ejecutar el procedure pkg_fact_electronica.sp_procesar_periodo: ' + ls_msj, StopSign! )
		return
	END IF
	
	Close sp_procesar_periodo;
	
	
	f_mensaje("Proceso terminado satifactoriamente", "")

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al realizar el proceso de generacion")

finally
	cb_generar.enabled = true
end try

		

end event

type cb_cancelar from commandbutton within w_ve905_procesar_fsimple
integer x = 713
integer y = 548
integer width = 302
integer height = 80
integer taborder = 30
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

type sle_year from singlelineedit within w_ve905_procesar_fsimple
integer x = 635
integer y = 244
integer width = 242
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

type sle_mes from singlelineedit within w_ve905_procesar_fsimple
integer x = 635
integer y = 344
integer width = 242
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

type gb_1 from groupbox within w_ve905_procesar_fsimple
integer width = 1303
integer height = 524
integer taborder = 10
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

