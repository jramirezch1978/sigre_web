$PBExportHeader$w_abc_relacionar_ot.srw
forward
global type w_abc_relacionar_ot from w_abc
end type
type st_2 from statictext within w_abc_relacionar_ot
end type
type uo_rango from u_ingreso_rango_fechas_v within w_abc_relacionar_ot
end type
type cb_actualizar from commandbutton within w_abc_relacionar_ot
end type
type st_1 from statictext within w_abc_relacionar_ot
end type
type pb_exit from picturebutton within w_abc_relacionar_ot
end type
end forward

global type w_abc_relacionar_ot from w_abc
integer width = 1413
integer height = 648
string title = "Actualiza Costo de Producción"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_get_nro_ot ( )
st_2 st_2
uo_rango uo_rango
cb_actualizar cb_actualizar
st_1 st_1
pb_exit pb_exit
end type
global w_abc_relacionar_ot w_abc_relacionar_ot

type variables
string 	is_cod_origen, is_articulo, is_almace

dec		ildc_costo_articulo

date		id_fecha


end variables

on w_abc_relacionar_ot.create
int iCurrent
call super::create
this.st_2=create st_2
this.uo_rango=create uo_rango
this.cb_actualizar=create cb_actualizar
this.st_1=create st_1
this.pb_exit=create pb_exit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.cb_actualizar
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_exit
end on

on w_abc_relacionar_ot.destroy
call super::destroy
destroy(this.st_2)
destroy(this.uo_rango)
destroy(this.cb_actualizar)
destroy(this.st_1)
destroy(this.pb_exit)
end on

event ue_update;call super::ue_update;//Boolean lb_grabar = TRUE
//STRING  ls_nro_orden, ls_nro_ot, ls_msj_err
//
//ls_nro_ot = trim(sle_nro_orden.text)
//
//// Grabar relacion en tabla Ot_otros_gastos
//
//INSERT INTO OT_OTROS_GASTOS
//		(NRO_ORDEN,	COD_RELACION, TIPO_DOC, NRO_DOC)
//VALUES
//		(:ls_nro_ot, :is_cod_relacion, :is_tipo_doc, :is_nro_doc);
//
//
//IF SQLCA.SQLCode = -1 THEN 
//   ls_msj_err =  SQLCA.SQLErrText
//	lb_grabar = FALSE
//	GOTO SALIDA_ERR		
//END IF
//	
//
//IF lb_grabar THEN
//	Commit ;
//	Messagebox('Aviso','Operación Satisfactoria !')
//	ii_grabar 				 = 0
//	sle_nro_orden.enabled = False
//	pb_nuevo.Enabled 		 = False
//	pb_eliminar.Enabled	 = True
//ELSE
//	SALIDA_ERR:
//	Rollback ;
//	Messagebox('Aviso',ls_msj_err)
//	Messagebox('Aviso','Se ha procedido al Rollback')
//END IF
//


end event

event open;// Override
THIS.EVENT ue_open_pre()

end event

event ue_open_pre;// Override


str_parametros  ls_param

ls_param = message.PowerObjectParm

is_articulo 			= ls_param.string1
is_almace				= ls_param.string2
is_cod_origen			= ls_param.string3
ildc_costo_articulo	= ls_param.decimal_1

end event

type st_2 from statictext within w_abc_relacionar_ot
integer x = 114
integer y = 44
integer width = 1193
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "ACTUALIZAR COSTO DE PRODUCCIÓN"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_rango from u_ingreso_rango_fechas_v within w_abc_relacionar_ot
integer x = 37
integer y = 264
integer taborder = 30
boolean bringtotop = true
long backcolor = 67108864
end type

event constructor;call super::constructor;String ls_desde

of_set_label('Desde:','Hasta:')
 
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final


end event

on uo_rango.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type cb_actualizar from commandbutton within w_abc_relacionar_ot
integer x = 759
integer y = 352
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

ld_fecha_1 = date(uo_rango.of_get_fecha1( ))
ld_fecha_2 = date(uo_rango.of_get_fecha2( ))

if MessageBox('Modulo de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
return
End if

DECLARE USP_PROD_ACT_COSTO PROCEDURE FOR 
		  USP_PROD_ACT_COSTO(:is_articulo,:is_almace,:ld_fecha_1,:ld_fecha_2,:ildc_costo_articulo,:is_cod_origen);

EXECUTE USP_PROD_ACT_COSTO;

IF sqlca.sqlcode = - 1 THEN
		messagebox( "Modulo de Producción", sqlca.sqlerrtext)
else
		messagebox( "Modulo de Producción", 'El proceso se ha realizado de manera satisfactoria')
END IF

CLOSE USP_PROD_ACT_COSTO;


end event

type st_1 from statictext within w_abc_relacionar_ot
integer x = 14
integer y = 196
integer width = 466
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_exit from picturebutton within w_abc_relacionar_ot
integer x = 1184
integer y = 348
integer width = 137
integer height = 104
integer taborder = 70
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

