$PBExportHeader$w_rh513_adiciona_pagos.srw
forward
global type w_rh513_adiciona_pagos from w_prc
end type
type sle_year from singlelineedit within w_rh513_adiciona_pagos
end type
type sle_item from singlelineedit within w_rh513_adiciona_pagos
end type
type st_6 from statictext within w_rh513_adiciona_pagos
end type
type em_fec_proceso from editmask within w_rh513_adiciona_pagos
end type
type rb_no_se_pago from radiobutton within w_rh513_adiciona_pagos
end type
type rb_se_pago from radiobutton within w_rh513_adiciona_pagos
end type
type uo_tipo_trabaj from u_ddlb_tipo_trabajador within w_rh513_adiciona_pagos
end type
type st_2 from statictext within w_rh513_adiciona_pagos
end type
type cb_1 from commandbutton within w_rh513_adiciona_pagos
end type
type em_descripcion from editmask within w_rh513_adiciona_pagos
end type
type em_origen from editmask within w_rh513_adiciona_pagos
end type
type cb_2 from commandbutton within w_rh513_adiciona_pagos
end type
type gb_1 from groupbox within w_rh513_adiciona_pagos
end type
type gb_3 from groupbox within w_rh513_adiciona_pagos
end type
type gb_2 from groupbox within w_rh513_adiciona_pagos
end type
end forward

global type w_rh513_adiciona_pagos from w_prc
integer width = 3109
integer height = 564
string title = "(RH513) Adiciona Adelantos a Cuenta de Utilidades a la Planilla"
boolean center = true
event ue_procesar ( )
sle_year sle_year
sle_item sle_item
st_6 st_6
em_fec_proceso em_fec_proceso
rb_no_se_pago rb_no_se_pago
rb_se_pago rb_se_pago
uo_tipo_trabaj uo_tipo_trabaj
st_2 st_2
cb_1 cb_1
em_descripcion em_descripcion
em_origen em_origen
cb_2 cb_2
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_rh513_adiciona_pagos w_rh513_adiciona_pagos

type variables
n_cst_wait	invo_wait
end variables

event ue_procesar();integer li_periodo, li_count, li_item
string  ls_origen, ls_tipo_trabaj, ls_mensaje, ls_pago
date    ld_fec_proceso

try 
	invo_wait.of_mensaje('Adiciona pago de utilidades a la planilla')

	li_periodo     = integer(sle_year.text)
	li_item			= Integer(sle_item.text)
	ls_origen      = string(em_origen.text)
	ld_fec_proceso = date(em_fec_proceso.text)
	
	if isnull(li_periodo) or li_periodo = 0 then
		MessageBox ('Aviso','Debe seleccionar periodo de proceso', StopSign!)
		return
	end if
	
	if isnull(li_item) or li_item = 0 then
		MessageBox ('Aviso','Debe seleccionar Item de proceso', StopSign!)
		return
	end if
	
	if isnull(ls_origen) or ls_origen = "" then
		MessageBox ('Aviso','Debe seleccionar el Origen', StopSign!)
		return
	end if
	
	if rb_se_pago.checked = true then
		ls_pago = '1'
	elseif rb_no_se_pago.checked = true then
		ls_pago = '2'
	end if
	
	ls_tipo_trabaj = uo_tipo_trabaj.of_get_Value()
	
	if isnull(ld_fec_proceso) or ld_fec_proceso = date(string('01/01/1900','dd/mm/yyyy')) then
		MessageBox('Aviso','Debe ingresar fecha de proceso', StopSign!)
		return
	end if
	
	//create or replace procedure usp_rh_utl_adiciona_pago (
	//  ani_periodo       in utl_distribucion.periodo%TYPE,
	//  ani_item          in utl_distribucion.item%TYPE,
	//  adi_fec_proceso   in date, 
	//  asi_pago          in char,
	//  asi_origen        in origen.cod_origen%TYPE, 
	//  asi_tipo_trabaj   in tipo_trabajador.tipo_trabajador%TYPE, 
	//  asi_usuario       in usuario.cod_usr%TYPE 
	//) is
	
	
	DECLARE USP_RH_UTL_ADICIONA_PAGO PROCEDURE FOR 
		USP_RH_UTL_ADICIONA_PAGO( :li_periodo,
										  :li_item,
										  :ld_fec_proceso, 
										  :ls_pago, 
										  :ls_origen, 
										  :ls_tipo_trabaj, 
										  :gs_user ) ;
	EXECUTE USP_RH_UTL_ADICIONA_PAGO ;
	
	IF SQLCA.SQLCode = -1 THEN 
	  ls_mensaje = SQLCA.SQLErrText
	  rollback ;
	  MessageBox("Error", "Error al ejecutar procedure USP_RH_UTL_ADICIONA_PAGO. Mensaje: " + ls_mensaje, StopSign!)
	  return
	end if
	
	close USP_RH_UTL_ADICIONA_PAGO;
	
	invo_wait.of_close( )
	MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)



catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "Exception")
	
finally
	invo_wait.of_close()
end try

end event

on w_rh513_adiciona_pagos.create
int iCurrent
call super::create
this.sle_year=create sle_year
this.sle_item=create sle_item
this.st_6=create st_6
this.em_fec_proceso=create em_fec_proceso
this.rb_no_se_pago=create rb_no_se_pago
this.rb_se_pago=create rb_se_pago
this.uo_tipo_trabaj=create uo_tipo_trabaj
this.st_2=create st_2
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_2=create cb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_year
this.Control[iCurrent+2]=this.sle_item
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.em_fec_proceso
this.Control[iCurrent+5]=this.rb_no_se_pago
this.Control[iCurrent+6]=this.rb_se_pago
this.Control[iCurrent+7]=this.uo_tipo_trabaj
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.em_descripcion
this.Control[iCurrent+11]=this.em_origen
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_2
end on

on w_rh513_adiciona_pagos.destroy
call super::destroy
destroy(this.sle_year)
destroy(this.sle_item)
destroy(this.st_6)
destroy(this.em_fec_proceso)
destroy(this.rb_no_se_pago)
destroy(this.rb_se_pago)
destroy(this.uo_tipo_trabaj)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event open;call super::open;Integer li_periodo, li_item

select distinct periodo, item
	into :li_periodo, :li_item
from utl_movim_general
order by periodo desc, item desc;

sle_year.text 	= String(li_periodo,'0000')
sle_item.text	= String(li_item, '00')

invo_wait = create n_cst_wait
end event

event close;call super::close;destroy invo_wait
end event

type sle_year from singlelineedit within w_rh513_adiciona_pagos
integer x = 283
integer y = 60
integer width = 210
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_item from singlelineedit within w_rh513_adiciona_pagos
integer x = 503
integer y = 60
integer width = 123
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_rh513_adiciona_pagos
integer x = 2117
integer y = 240
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de Proceso:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fec_proceso from editmask within w_rh513_adiciona_pagos
integer x = 2117
integer y = 304
integer width = 448
integer height = 84
integer taborder = 40
boolean bringtotop = true
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
boolean dropdowncalendar = true
boolean dropdownright = true
end type

type rb_no_se_pago from radiobutton within w_rh513_adiciona_pagos
integer x = 27
integer y = 228
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "No se Realizó Pago de Adelanto"
end type

type rb_se_pago from radiobutton within w_rh513_adiciona_pagos
integer x = 27
integer y = 148
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Se Realizó Pago de Adelanto"
boolean checked = true
end type

type uo_tipo_trabaj from u_ddlb_tipo_trabajador within w_rh513_adiciona_pagos
integer x = 1175
integer y = 232
boolean bringtotop = true
end type

on uo_tipo_trabaj.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type st_2 from statictext within w_rh513_adiciona_pagos
integer x = 27
integer y = 72
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh513_adiciona_pagos
integer x = 2679
integer y = 36
integer width = 293
integer height = 220
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.event ue_procesar()


end event

type em_descripcion from editmask within w_rh513_adiciona_pagos
integer x = 1541
integer y = 108
integer width = 1006
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh513_adiciona_pagos
integer x = 1221
integer y = 108
integer width = 151
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh513_adiciona_pagos
integer x = 1408
integer y = 108
integer width = 87
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type gb_1 from groupbox within w_rh513_adiciona_pagos
integer x = 1175
integer y = 52
integer width = 1440
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh513_adiciona_pagos
integer x = 1143
integer width = 1504
integer height = 456
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Datos de la planilla"
end type

type gb_2 from groupbox within w_rh513_adiciona_pagos
integer width = 1120
integer height = 456
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Datos de las utilidades"
end type

