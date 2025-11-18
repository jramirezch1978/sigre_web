$PBExportHeader$w_pr904_act_unds_producidas.srw
forward
global type w_pr904_act_unds_producidas from w_abc
end type
type cbx_1 from checkbox within w_pr904_act_unds_producidas
end type
type pb_exit from picturebutton within w_pr904_act_unds_producidas
end type
type cb_actualizar from commandbutton within w_pr904_act_unds_producidas
end type
type uo_rango from u_ingreso_rango_fechas_v within w_pr904_act_unds_producidas
end type
type st_1 from statictext within w_pr904_act_unds_producidas
end type
type st_2 from statictext within w_pr904_act_unds_producidas
end type
type gb_1 from groupbox within w_pr904_act_unds_producidas
end type
end forward

global type w_pr904_act_unds_producidas from w_abc
integer width = 1856
integer height = 904
string title = "Actualizar Unidades Producidas(PR904)"
string menuname = "m_impresion_1"
event ue_generar_os ( )
cbx_1 cbx_1
pb_exit pb_exit
cb_actualizar cb_actualizar
uo_rango uo_rango
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_pr904_act_unds_producidas w_pr904_act_unds_producidas

on w_pr904_act_unds_producidas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cbx_1=create cbx_1
this.pb_exit=create pb_exit
this.cb_actualizar=create cb_actualizar
this.uo_rango=create uo_rango
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.pb_exit
this.Control[iCurrent+3]=this.cb_actualizar
this.Control[iCurrent+4]=this.uo_rango
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_pr904_act_unds_producidas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.pb_exit)
destroy(this.cb_actualizar)
destroy(this.uo_rango)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

type cbx_1 from checkbox within w_pr904_act_unds_producidas
integer x = 933
integer y = 248
integer width = 617
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Borrar Datos Actuales"
boolean checked = true
end type

type pb_exit from picturebutton within w_pr904_act_unds_producidas
integer x = 1454
integer y = 440
integer width = 137
integer height = 104
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Exit!"
alignment htextalign = left!
string powertiptext = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_actualizar from commandbutton within w_pr904_act_unds_producidas
integer x = 1029
integer y = 444
integer width = 402
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualizar"
end type

event clicked;date	ld_fecha_1, ld_fecha_2
string ls_err, ls_borrar

ld_fecha_1 = date(uo_rango.of_get_fecha1( ))
ld_fecha_2 = date(uo_rango.of_get_fecha2( ))

if cbx_1.checked then
	ls_borrar = '1'
else
	ls_borrar = '0'
end if

if MessageBox('Modulo de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
	return
End if

//CREATE OR REPLACE PROCEDURE USP_PROD_ACT_UNIDADES_P(
//       asi_borra     IN VARCHAR2,
//       ADI_FECHA1    IN PROD_COSTOS_DIARIOS.FECHA%TYPE,
//       ADI_FECHA2    IN PROD_COSTOS_DIARIOS.FECHA%TYPE
//) IS

DECLARE USP_PROD_ACT_UNIDADES_P PROCEDURE FOR 
		  USP_PROD_ACT_UNIDADES_P(	:ls_borrar,
		  									:ld_fecha_1,
		  								  	:ld_fecha_2);

EXECUTE USP_PROD_ACT_UNIDADES_P;

IF sqlca.sqlcode = - 1 THEN
	ls_err = SQLCA.SQLErrText
	ROLLBACK;
	messagebox( "Modulo de Producción", ls_err)
	return
END IF

CLOSE USP_PROD_ACT_UNIDADES_P;

messagebox( "Modulo de Producción", 'El proceso se ha realizado de manera satisfactoria')



end event

type uo_rango from u_ingreso_rango_fechas_v within w_pr904_act_unds_producidas
event destroy ( )
integer x = 279
integer y = 344
integer taborder = 40
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_rango.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

of_set_label('Desde:','Hasta:')
 
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final


end event

type st_1 from statictext within w_pr904_act_unds_producidas
integer x = 215
integer y = 48
integer width = 1330
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Actualizar Unidades Producidas"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pr904_act_unds_producidas
integer x = 197
integer y = 228
integer width = 622
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217729
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr904_act_unds_producidas
integer x = 142
integer y = 172
integer width = 1536
integer height = 432
integer taborder = 70
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

