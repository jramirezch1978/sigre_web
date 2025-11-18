$PBExportHeader$w_abc_relacionar_ot.srw
forward
global type w_abc_relacionar_ot from w_abc
end type
type sle_nro_orden from u_sle_codigo within w_abc_relacionar_ot
end type
type st_1 from statictext within w_abc_relacionar_ot
end type
type pb_exit from picturebutton within w_abc_relacionar_ot
end type
type pb_grabar from picturebutton within w_abc_relacionar_ot
end type
type pb_eliminar from picturebutton within w_abc_relacionar_ot
end type
type pb_nuevo from picturebutton within w_abc_relacionar_ot
end type
end forward

global type w_abc_relacionar_ot from w_abc
integer width = 1111
integer height = 524
string title = "ASOCIAR A OT"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_get_nro_ot ( )
sle_nro_orden sle_nro_orden
st_1 st_1
pb_exit pb_exit
pb_grabar pb_grabar
pb_eliminar pb_eliminar
pb_nuevo pb_nuevo
end type
global w_abc_relacionar_ot w_abc_relacionar_ot

type variables
integer  ii_grabar = 0
string 	is_cod_relacion, is_tipo_doc, is_nro_doc


end variables

event ue_get_nro_ot();// Para ubicar el nro de OT, cuando ya exista
// una relación con este documento.

string ls_nro_ot


SELECT NRO_ORDEN
  INTO :ls_nro_ot
FROM   ot_otros_gastos
WHERE  cod_relacion = :is_cod_relacion
   AND tipo_doc	  = :is_tipo_doc
	AND nro_doc		  = :is_nro_doc;
	

IF LEN(ls_nro_ot) > 0  THEN
	sle_nro_orden.text 		= ls_nro_ot
	sle_nro_orden.enabled 	= False
	pb_nuevo.enabled			= False
	pb_eliminar.enabled 		= True
END IF
end event

on w_abc_relacionar_ot.create
int iCurrent
call super::create
this.sle_nro_orden=create sle_nro_orden
this.st_1=create st_1
this.pb_exit=create pb_exit
this.pb_grabar=create pb_grabar
this.pb_eliminar=create pb_eliminar
this.pb_nuevo=create pb_nuevo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro_orden
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_exit
this.Control[iCurrent+4]=this.pb_grabar
this.Control[iCurrent+5]=this.pb_eliminar
this.Control[iCurrent+6]=this.pb_nuevo
end on

on w_abc_relacionar_ot.destroy
call super::destroy
destroy(this.sle_nro_orden)
destroy(this.st_1)
destroy(this.pb_exit)
destroy(this.pb_grabar)
destroy(this.pb_eliminar)
destroy(this.pb_nuevo)
end on

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (this.ii_grabar = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		this.ii_grabar = 0
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lb_grabar = TRUE
STRING  ls_nro_orden, ls_nro_ot, ls_msj_err

ls_nro_ot = trim(sle_nro_orden.text)

// Grabar relacion en tabla Ot_otros_gastos

INSERT INTO OT_OTROS_GASTOS
		(NRO_ORDEN,	COD_RELACION, TIPO_DOC, NRO_DOC)
VALUES
		(:ls_nro_ot, :is_cod_relacion, :is_tipo_doc, :is_nro_doc);


IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err =  SQLCA.SQLErrText
	lb_grabar = FALSE
	GOTO SALIDA_ERR		
END IF
	

IF lb_grabar THEN
	Commit ;
	Messagebox('Aviso','Operación Satisfactoria !')
	ii_grabar 				 = 0
	sle_nro_orden.enabled = False
	pb_nuevo.Enabled 		 = False
	pb_eliminar.Enabled	 = True
ELSE
	SALIDA_ERR:
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
	Messagebox('Aviso','Se ha procedido al Rollback')
END IF



end event

event open;// Override
THIS.EVENT ue_open_pre()

end event

event ue_open_pre;// Override


str_parametros  ls_param

ls_param = message.PowerObjectParm

is_cod_relacion = ls_param.string1
is_tipo_doc		 = ls_param.string2
is_nro_doc		 = ls_param.string3

THIS.EVENT ue_get_nro_ot()
end event

type sle_nro_orden from u_sle_codigo within w_abc_relacionar_ot
event dobleclick pbm_lbuttondblclk
integer x = 503
integer y = 84
integer taborder = 10
string pointer = "C:\source\CUR\taladro.cur"
boolean enabled = false
end type

event dobleclick;boolean lb_ret
string  ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_ORIGEN AS ORIGEN, " 	&
	  	+  "NRO_ORDEN AS NRO_ORDEN,  " 		&
		+	"FEC_INICIO AS FECHA_INICIO, " 	&
		+	"TITULO AS TITULO  " 				&
		+  "FROM ORDEN_TRABAJO " 				&
		+  "WHERE FLAG_ESTADO <> 0 "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
					
IF ls_codigo <> '' THEN
	sle_nro_orden.text = ls_data
ELSE

END IF
		
parent.ii_grabar = 1
end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_1 from statictext within w_abc_relacionar_ot
integer x = 82
integer y = 120
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro de Orden"
boolean focusrectangle = false
end type

type pb_exit from picturebutton within w_abc_relacionar_ot
integer x = 864
integer y = 244
integer width = 137
integer height = 124
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

type pb_grabar from picturebutton within w_abc_relacionar_ot
integer x = 654
integer y = 244
integer width = 137
integer height = 124
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\BMP\diskette.bmp"
alignment htextalign = left!
string powertiptext = "Grabar"
end type

event clicked;
String 	ls_nro_orden, ls_titulo, ls_nro_ot
integer  li_cuenta

IF sle_nro_orden.enabled = False  THEN return

ls_nro_orden = sle_nro_orden.text
if ls_nro_orden = '' or IsNull(ls_nro_orden) then
	MessageBox('Aviso', 'Debe Ingresar un Nro de Orden de trabajo')
	return
end if

SELECT titulo
	INTO :ls_titulo
FROM Orden_Trabajo
WHERE nro_orden = :ls_nro_orden
  AND flag_estado <> 0;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Orden de Trabajo no existe o no esta activa')
	sle_nro_orden.text = ''
	RETURN
END IF

// verifica que no exista una asociacion anterior con esta ot
SELECT count(nro_orden)
  INTO :li_cuenta
FROM   ot_otros_gastos
WHERE  nro_orden	  = :ls_nro_orden
	AND cod_relacion = :is_cod_relacion
   AND tipo_doc	  = :is_tipo_doc
	AND nro_doc		  = :is_nro_doc;
	

IF li_cuenta <> 0  THEN
	messagebox('AVISO', "Ya existe una relación con esta OT")
	RETURN
END IF

//Verifica que el documento no este asociado a una OT

SELECT NRO_ORDEN
  INTO :ls_nro_ot
FROM   ot_otros_gastos
WHERE  cod_relacion = :is_cod_relacion
   AND tipo_doc	  = :is_tipo_doc
	AND nro_doc		  = :is_nro_doc;
	

IF LEN(ls_nro_ot) > 0  THEN
	messagebox('AVISO', "Este documento esta relacionado a la " + &
								"OT Nro: " + ls_nro_ot)
	RETURN
END IF

parent.ii_grabar = 1


parent.event ue_update()
end event

type pb_eliminar from picturebutton within w_abc_relacionar_ot
integer x = 466
integer y = 244
integer width = 114
integer height = 124
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "h:\source\BMP\eliminar.bmp"
string disabledname = "h:\source\BMP\eliminar_d.bmp"
alignment htextalign = left!
string powertiptext = "Eliminar Relacion"
end type

event clicked;STRING  ls_nro_orden, ls_msj_err
boolean lb_grabar = True

ls_nro_orden = Trim(sle_nro_orden.Text)


IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

IF MessageBox("Eliminacion de registro", " La eliminación sera definitiva " &
					+ '~n~r' +"Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

DELETE FROM OT_OTROS_GASTOS
WHERE  Nro_orden 		= :ls_nro_orden
	AND cod_relacion	= :is_cod_relacion
	AND tipo_doc		= :is_tipo_doc
	AND nro_doc			= :is_nro_doc;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err =  SQLCA.SQLErrText
	lb_grabar = FALSE
	GOTO SALIDA_ERR		
END IF

IF lb_grabar THEN
	Commit ;
	Messagebox('Aviso','Operación Satisfactoria !')
	ii_grabar = 0
	sle_nro_orden.Text 	 = ''
	pb_nuevo.enabled		 = True
	pb_eliminar.enabled	 = False
ELSE
	SALIDA_ERR:
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
	Messagebox('Aviso', 'Se ha procedido al Rollback')
END IF


end event

type pb_nuevo from picturebutton within w_abc_relacionar_ot
integer x = 279
integer y = 244
integer width = 114
integer height = 124
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\BMP\nuevo.bmp"
string disabledname = "h:\source\BMP\nuevo_d.bmp"
alignment htextalign = left!
string powertiptext = "Agregar Relación"
end type

event clicked;String 	ls_sql, ls_codigo, ls_data
boolean  lb_ret

sle_nro_orden.enabled = True

sle_nro_orden.setfocus()


end event

