$PBExportHeader$w_rh414_recalcula_boleta.srw
forward
global type w_rh414_recalcula_boleta from w_prc
end type
type em_descripcion from editmask within w_rh414_recalcula_boleta
end type
type cb_origen from commandbutton within w_rh414_recalcula_boleta
end type
type em_origen from editmask within w_rh414_recalcula_boleta
end type
type st_2 from statictext within w_rh414_recalcula_boleta
end type
type st_4 from statictext within w_rh414_recalcula_boleta
end type
type em_ttrab from editmask within w_rh414_recalcula_boleta
end type
type cb_ttrab from commandbutton within w_rh414_recalcula_boleta
end type
type em_desc_ttrab from editmask within w_rh414_recalcula_boleta
end type
type cb_1 from commandbutton within w_rh414_recalcula_boleta
end type
type st_1 from statictext within w_rh414_recalcula_boleta
end type
type em_fec_proceso from editmask within w_rh414_recalcula_boleta
end type
type gb_1 from groupbox within w_rh414_recalcula_boleta
end type
end forward

global type w_rh414_recalcula_boleta from w_prc
integer width = 2501
integer height = 480
string title = "(RH414) Recálculo de boleta"
boolean center = true
em_descripcion em_descripcion
cb_origen cb_origen
em_origen em_origen
st_2 st_2
st_4 st_4
em_ttrab em_ttrab
cb_ttrab cb_ttrab
em_desc_ttrab em_desc_ttrab
cb_1 cb_1
st_1 st_1
em_fec_proceso em_fec_proceso
gb_1 gb_1
end type
global w_rh414_recalcula_boleta w_rh414_recalcula_boleta

on w_rh414_recalcula_boleta.create
int iCurrent
call super::create
this.em_descripcion=create em_descripcion
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.st_2=create st_2
this.st_4=create st_4
this.em_ttrab=create em_ttrab
this.cb_ttrab=create cb_ttrab
this.em_desc_ttrab=create em_desc_ttrab
this.cb_1=create cb_1
this.st_1=create st_1
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.cb_origen
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.em_ttrab
this.Control[iCurrent+7]=this.cb_ttrab
this.Control[iCurrent+8]=this.em_desc_ttrab
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_fec_proceso
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh414_recalcula_boleta.destroy
call super::destroy
destroy(this.em_descripcion)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.em_ttrab)
destroy(this.cb_ttrab)
destroy(this.em_desc_ttrab)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
end on

type em_descripcion from editmask within w_rh414_recalcula_boleta
integer x = 663
integer y = 108
integer width = 983
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_rh414_recalcula_boleta
integer x = 576
integer y = 108
integer width = 87
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

type em_origen from editmask within w_rh414_recalcula_boleta
integer x = 389
integer y = 108
integer width = 183
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_descripcion.text = ls_null
end if

em_descripcion.text = ls_data


end event

type st_2 from statictext within w_rh414_recalcula_boleta
integer x = 64
integer y = 120
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh414_recalcula_boleta
integer x = 64
integer y = 220
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_rh414_recalcula_boleta
integer x = 389
integer y = 212
integer width = 183
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select desc_tipo_tra
	into :ls_data
from tipo_trabajador
where tipo_trabajador = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "TIPO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_desc_ttrab.text = ls_null
end if

em_desc_ttrab.text = ls_data

end event

type cb_ttrab from commandbutton within w_rh414_recalcula_boleta
integer x = 576
integer y = 212
integer width = 87
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_ttrab.text = ls_codigo
	em_desc_ttrab.text = ls_data
	
end if
end event

type em_desc_ttrab from editmask within w_rh414_recalcula_boleta
integer x = 663
integer y = 212
integer width = 983
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh414_recalcula_boleta
integer x = 2030
integer y = 208
integer width = 370
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Procesando Adelanto de Quincena')

String 	ls_origen, ls_codtra, ls_tipo_trabaj, ls_mensaje
date   	ld_fec_proceso

ls_origen      = string(em_origen.text)
em_fec_proceso.getData( ld_fec_proceso)

ls_tipo_trabaj = trim(em_ttrab.text)
	
// Elimino El documento de Pago de quincena
//create or replace procedure USP_RH_CALC_TOTALES(
//       asi_tipo_Trabajador IN tipo_trabajador.tipo_trabajador%TYPE,
//       asi_origen          IN origen.cod_origen%TYPE,
//       adi_Fec_proceso     IN DATE
//) IS

DECLARE USP_RH_CALC_TOTALES PROCEDURE FOR 
	USP_RH_CALC_TOTALES(	:ls_tipo_trabaj,
								:ls_origen,
								:ld_fec_proceso) ;
EXECUTE USP_RH_CALC_TOTALES ;

//busco errores
if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
  
  	Rollback ;
 	Messagebox('Error USP_RH_CALC_TOTALES',ls_mensaje)
  	Return
end if

CLOSE USP_RH_CALC_TOTALES ;
commit;

//create or replace procedure USP_RH_ACT_DOC_PAGO_AFP(
//       asi_tipo_trab    in maestro.tipo_trabajador%type ,
//       asi_origen       in origen.cod_origen%Type       ,
//       adi_fec_proceso  in date                         ,
//       asi_cod_usr      in usuario.cod_usr%type          
//) is
DECLARE USP_RH_ACT_DOC_PAGO_AFP PROCEDURE FOR 
	USP_RH_ACT_DOC_PAGO_AFP(:ls_tipo_trabaj,
									:ls_origen,
									:ld_fec_proceso,
									:gs_user) ;
EXECUTE USP_RH_ACT_DOC_PAGO_AFP ;

//busco errores
if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
  
  	Rollback ;
 	Messagebox('Error USP_RH_ACT_DOC_PAGO_AFP',ls_mensaje)
  	Return
end if

CLOSE USP_RH_ACT_DOC_PAGO_AFP ;

//create or replace procedure USP_RH_ACT_GEN_PAGO_PLLA(
//       asi_tipo_trab    in maestro.tipo_trabajador%type ,
//       asi_origen       in origen.cod_origen%Type       ,
//       adi_fec_proceso  in date                         ,
//       asi_cod_usr      in usuario.cod_usr%type
//) is
DECLARE USP_RH_ACT_GEN_PAGO_PLLA PROCEDURE FOR 
	USP_RH_ACT_GEN_PAGO_PLLA(:ls_tipo_trabaj,
									:ls_origen,
									:ld_fec_proceso,
									:gs_user) ;
EXECUTE USP_RH_ACT_GEN_PAGO_PLLA ;

//busco errores
if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
  
  	Rollback ;
 	Messagebox('Error USP_RH_ACT_GEN_PAGO_PLLA',ls_mensaje)
  	Return
end if

CLOSE USP_RH_ACT_GEN_PAGO_PLLA ;

commit ;
Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
MessageBox('RRHH', 'Proceso de Recálculo de Boleta se ha realizado satisfactoriamente')


end event

type st_1 from statictext within w_rh414_recalcula_boleta
integer x = 1682
integer y = 116
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Proceso"
boolean focusrectangle = false
end type

type em_fec_proceso from editmask within w_rh414_recalcula_boleta
integer x = 2039
integer y = 108
integer width = 334
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type gb_1 from groupbox within w_rh414_recalcula_boleta
integer width = 2450
integer height = 364
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

