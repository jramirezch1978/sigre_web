$PBExportHeader$w_al906_mod_fec_mov_alm.srw
forward
global type w_al906_mod_fec_mov_alm from w_abc
end type
type uo_fecha_hora from u_ingreso_fecha_hora within w_al906_mod_fec_mov_alm
end type
type st_3 from statictext within w_al906_mod_fec_mov_alm
end type
type sle_nro_vale from singlelineedit within w_al906_mod_fec_mov_alm
end type
type st_1 from statictext within w_al906_mod_fec_mov_alm
end type
type pb_2 from picturebutton within w_al906_mod_fec_mov_alm
end type
type pb_1 from picturebutton within w_al906_mod_fec_mov_alm
end type
end forward

global type w_al906_mod_fec_mov_alm from w_abc
integer width = 1870
integer height = 552
string title = "Modificacion Fecha Mov Almacen (AL906)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
event ue_salir ( )
uo_fecha_hora uo_fecha_hora
st_3 st_3
sle_nro_vale sle_nro_vale
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_al906_mod_fec_mov_alm w_al906_mod_fec_mov_alm

type variables
str_parametros  istr_param

end variables

forward prototypes
public function boolean of_proceso (string as_nro_vale, datetime adt_fecha)
end prototypes

event ue_aceptar;Datetime ldt_Fecha
string	ls_nro_Vale
SetPointer (HourGlass!)

/*
	istr_param.string1 -> Codigo Origen
	istr_param.string2 -> Nro Vale
	istr_param.DateTime1 -> Fecha y hora
*/

ldt_fecha = uo_fecha_hora.of_get_fecha()

ls_nro_Vale = sle_nro_vale.text

If ls_nro_vale = '' or IsNull(ls_nro_vale) then
	MessageBox('Aviso', 'Debe indicar un Numero de Movimiento de Almacen')
	return
end if

this.of_proceso(ls_nro_vale, ldt_fecha)

SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public function boolean of_proceso (string as_nro_vale, datetime adt_fecha);string ls_mensaje
//create or replace procedure usp_alm_fec_mov_alm(
//       asi_nro_vale     in vale_mov.nro_vale%TYPE,
//       asi_origen_vale  in vale_mov.cod_origen%TYPE,
//       adi_fecha        in date,
//       asi_usuario      in usuario.cod_usr%TYPE
//) is

//DECLARE usp_alm_fec_mov_alm PROCEDURE FOR
//	usp_alm_fec_mov_alm( :as_nro_vale, 
//								:as_origen_vale,
//								:adt_fecha,
//								:gs_user);
//
//EXECUTE usp_alm_fec_mov_alm;
//
//IF SQLCA.sqlcode = -1 THEN
//	ls_mensaje = "PROCEDURE usp_alm_fec_mov_alm:" &
//			  + SQLCA.SQLErrText
//	Rollback;
//	MessageBox('Aviso', ls_mensaje)
//	Return false
//END IF

update vale_mov vm
   set vm.fec_registro = :adt_fecha	
where vm.nro_vale = :as_nro_vale;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "Error al modificar la fecha en VALE_MOV. Mensaje:" + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

commit;

MessageBox('Aviso', 'Cambio de fecha ejecutado satisfactoriamente')

return true
end function

on w_al906_mod_fec_mov_alm.create
int iCurrent
call super::create
this.uo_fecha_hora=create uo_fecha_hora
this.st_3=create st_3
this.sle_nro_vale=create sle_nro_vale
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha_hora
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.sle_nro_vale
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.pb_1
end on

on w_al906_mod_fec_mov_alm.destroy
call super::destroy
destroy(this.uo_fecha_hora)
destroy(this.st_3)
destroy(this.sle_nro_vale)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event open;// Ancestor Script 

if Not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	if Message.powerobjectparm.ClassName() = 'str_parametros' then
	
		istr_param = Message.PowerObjectParm
		
		/*
		istr_param.string1 -> Codigo Origen
		istr_param.string2 -> Nro Vale
		istr_param.DateTime1 -> Fecha y hora
		*/
		sle_nro_vale.text = istr_param.string2
		uo_fecha_hora.of_set_fecha(istr_param.DateTime1)
	end if
end if	



end event

type uo_fecha_hora from u_ingreso_fecha_hora within w_al906_mod_fec_mov_alm
integer x = 882
integer y = 136
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Fecha:') // para seatear el titulo del boton
of_set_rango_inicio(dateTime('01/01/1900')) // rango inicial
of_set_rango_fin(dateTime('31/12/9999')) // rango final

end event

on uo_fecha_hora.destroy
call u_ingreso_fecha_hora::destroy
end on

type st_3 from statictext within w_al906_mod_fec_mov_alm
integer x = 50
integer y = 140
integer width = 302
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Vale"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_nro_vale from singlelineedit within w_al906_mod_fec_mov_alm
event ue_dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 128
integer width = 439
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT DISTINCT VM.cod_origen as origen_vale, " &
		 + "VM.NRO_VALE AS NUMERO_VALE " &
		 + "FROM VALE_MOV VM, " &
		 + "ARTICULO_MOV AM " &
		 + "WHERE VM.NRO_VALE = AM.NRO_VALE " &
		 + "AND VM.FLAG_ESTADO <> '0' " &
		 + "AND AM.FLAG_ESTADO <> '0' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_data
end if

end event

type st_1 from statictext within w_al906_mod_fec_mov_alm
integer x = 5
integer y = 16
integer width = 1851
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Modificar la fecha del movimiento de almacen"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_al906_mod_fec_mov_alm
integer x = 946
integer y = 240
integer width = 315
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_al906_mod_fec_mov_alm
integer x = 571
integer y = 240
integer width = 315
integer height = 180
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

