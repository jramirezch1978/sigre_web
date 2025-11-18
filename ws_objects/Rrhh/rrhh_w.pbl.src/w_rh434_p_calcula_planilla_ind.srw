$PBExportHeader$w_rh434_p_calcula_planilla_ind.srw
forward
global type w_rh434_p_calcula_planilla_ind from w_prc
end type
type cbx_1 from checkbox within w_rh434_p_calcula_planilla_ind
end type
type cbx_asig_familiar from checkbox within w_rh434_p_calcula_planilla_ind
end type
type cbx_descuento from checkbox within w_rh434_p_calcula_planilla_ind
end type
type em_desc_tipo_planilla from editmask within w_rh434_p_calcula_planilla_ind
end type
type cb_tipo_planilla from commandbutton within w_rh434_p_calcula_planilla_ind
end type
type em_tipo_planilla from editmask within w_rh434_p_calcula_planilla_ind
end type
type st_2 from statictext within w_rh434_p_calcula_planilla_ind
end type
type cb_2 from commandbutton within w_rh434_p_calcula_planilla_ind
end type
type st_1 from statictext within w_rh434_p_calcula_planilla_ind
end type
type cbx_renta_quinta from checkbox within w_rh434_p_calcula_planilla_ind
end type
type cbx_cierre_mes from checkbox within w_rh434_p_calcula_planilla_ind
end type
type cbx_control from checkbox within w_rh434_p_calcula_planilla_ind
end type
type cb_4 from commandbutton within w_rh434_p_calcula_planilla_ind
end type
type sle_nombres from singlelineedit within w_rh434_p_calcula_planilla_ind
end type
type sle_codigo from singlelineedit within w_rh434_p_calcula_planilla_ind
end type
type st_6 from statictext within w_rh434_p_calcula_planilla_ind
end type
type cb_1 from commandbutton within w_rh434_p_calcula_planilla_ind
end type
type em_fec_proceso from editmask within w_rh434_p_calcula_planilla_ind
end type
type gb_1 from groupbox within w_rh434_p_calcula_planilla_ind
end type
end forward

global type w_rh434_p_calcula_planilla_ind from w_prc
integer width = 2533
integer height = 868
string title = "(RH434) Proceso de Cálculo de la Planilla Individual"
boolean resizable = false
boolean center = true
cbx_1 cbx_1
cbx_asig_familiar cbx_asig_familiar
cbx_descuento cbx_descuento
em_desc_tipo_planilla em_desc_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_tipo_planilla em_tipo_planilla
st_2 st_2
cb_2 cb_2
st_1 st_1
cbx_renta_quinta cbx_renta_quinta
cbx_cierre_mes cbx_cierre_mes
cbx_control cbx_control
cb_4 cb_4
sle_nombres sle_nombres
sle_codigo sle_codigo
st_6 st_6
cb_1 cb_1
em_fec_proceso em_fec_proceso
gb_1 gb_1
end type
global w_rh434_p_calcula_planilla_ind w_rh434_p_calcula_planilla_ind

type variables
string is_tipo_emp, is_salir
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

public function integer of_get_param ();select tipo_trab_empleado
  into :is_tipo_emp
  from rrhhparam
 where reckey = '1';
 
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha indicado parametros en RRHHPARAM')
	return 0
end if

return 1
end function

on w_rh434_p_calcula_planilla_ind.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_asig_familiar=create cbx_asig_familiar
this.cbx_descuento=create cbx_descuento
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_tipo_planilla=create em_tipo_planilla
this.st_2=create st_2
this.cb_2=create cb_2
this.st_1=create st_1
this.cbx_renta_quinta=create cbx_renta_quinta
this.cbx_cierre_mes=create cbx_cierre_mes
this.cbx_control=create cbx_control
this.cb_4=create cb_4
this.sle_nombres=create sle_nombres
this.sle_codigo=create sle_codigo
this.st_6=create st_6
this.cb_1=create cb_1
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_asig_familiar
this.Control[iCurrent+3]=this.cbx_descuento
this.Control[iCurrent+4]=this.em_desc_tipo_planilla
this.Control[iCurrent+5]=this.cb_tipo_planilla
this.Control[iCurrent+6]=this.em_tipo_planilla
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cbx_renta_quinta
this.Control[iCurrent+11]=this.cbx_cierre_mes
this.Control[iCurrent+12]=this.cbx_control
this.Control[iCurrent+13]=this.cb_4
this.Control[iCurrent+14]=this.sle_nombres
this.Control[iCurrent+15]=this.sle_codigo
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.em_fec_proceso
this.Control[iCurrent+19]=this.gb_1
end on

on w_rh434_p_calcula_planilla_ind.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.cbx_asig_familiar)
destroy(this.cbx_descuento)
destroy(this.em_desc_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_tipo_planilla)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.cbx_renta_quinta)
destroy(this.cbx_cierre_mes)
destroy(this.cbx_control)
destroy(this.cb_4)
destroy(this.sle_nombres)
destroy(this.sle_codigo)
destroy(this.st_6)
destroy(this.cb_1)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
end on

event open;call super::open;em_tipo_planilla.text = 'N'
em_desc_tipo_planilla.text = 'Planilla Normal'
end event

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

type cbx_1 from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 59
integer y = 456
integer width = 846
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No incluir Descuento Fijo ni variable"
end type

type cbx_asig_familiar from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 1285
integer y = 452
integer width = 1129
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No Tomar Dominical para Asignación Familiar"
boolean checked = true
end type

type cbx_descuento from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 59
integer y = 380
integer width = 718
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No incluir Descuento Alguno"
end type

type em_desc_tipo_planilla from editmask within w_rh434_p_calcula_planilla_ind
integer x = 763
integer y = 144
integer width = 1349
integer height = 76
integer taborder = 70
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

type cb_tipo_planilla from commandbutton within w_rh434_p_calcula_planilla_ind
integer x = 677
integer y = 144
integer width = 87
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj, ls_cod_trabajador
Date		ld_fec_proceso

ls_cod_trabajador = trim(sle_codigo.text)

select cod_origen, tipo_trabajador
	into :ls_origen, :ls_tipo_trabaj
from maestro
where cod_trabajador = :ls_cod_trabajador;

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	sle_codigo.SetFocus()
	return
end if

if IsNull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then
	gnvo_app.of_message_error( "Debe especificar tipo de Trabajador. Por favor verifique!")
	sle_codigo.SetFocus()
	return
end if


ls_sql = "select distinct " &
		 + "       r.tipo_planilla as tipo_planilla, " &
		 + "       decode(r.tipo_planilla, 'N', 'Planilla Normal', 'B', 'Bonificaciones Tripulante', 'G', 'Gratificacion Tripulante', 'C', 'CTS Tripulante', 'V', 'Vacaciones Tripulante') as desc_tipo_planilla " &
		 + "from rrhh_param_org r " &
		 + "where r.origen = '" + ls_origen + "'" &
		 + "  and r.tipo_trabajador = '" + ls_tipo_trabaj + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_planilla.text = ls_codigo
	em_desc_tipo_planilla.text = ls_data
	

end if
end event

type em_tipo_planilla from editmask within w_rh434_p_calcula_planilla_ind
integer x = 430
integer y = 144
integer width = 247
integer height = 76
integer taborder = 50
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

event modified;string ls_data, ls_tipo_planilla, ls_origen, ls_cod_trabajador

ls_cod_trabajador = sle_codigo.text

select cod_origen
	into :ls_origen
from maestro
where cod_trabajador = :ls_cod_trabajador;

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	sle_codigo.setFocus()
	return
end if

ls_tipo_planilla = this.text

select usp_sigre_rrhh.of_tipo_planilla(:ls_tipo_planilla)
	into :ls_data
from dual;

em_desc_tipo_planilla.text = ls_data

end event

type st_2 from statictext within w_rh434_p_calcula_planilla_ind
boolean visible = false
integer x = 41
integer y = 152
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Tipo Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh434_p_calcula_planilla_ind
integer x = 2039
integer y = 588
integer width = 430
integer height = 152
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;Close(parent)
end event

type st_1 from statictext within w_rh434_p_calcula_planilla_ind
integer x = 41
integer y = 76
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Trabajador: "
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_renta_quinta from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 1285
integer y = 380
integer width = 718
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Procesar Renta Quinta"
boolean checked = true
end type

type cbx_cierre_mes from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 59
integer y = 532
integer width = 718
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cierre de Mes"
end type

type cbx_control from checkbox within w_rh434_p_calcula_planilla_ind
integer x = 59
integer y = 304
integer width = 718
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No Incluir Ganancias Fijas"
end type

type cb_4 from commandbutton within w_rh434_p_calcula_planilla_ind
integer x = 677
integer y = 68
integer width = 87
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros lstr_param

lstr_param.dw1 = "d_rpt_select_codigo_tbl"
lstr_param.titulo = "Seleccionar Búsqueda"
lstr_param.field_ret_i[1] 	= 1
lstr_param.field_ret_i[2] 	= 2
lstr_param.param_def 		= 2
lstr_param.tipo				= '1S'
lstr_param.string1			= gs_origen

OpenWithParm( w_search, lstr_param)		
lstr_param = MESSAGE.POWEROBJECTPARM
IF lstr_param.titulo <> 'n' THEN
	sle_codigo.text  = lstr_param.field_ret[1]
	sle_nombres.text = lstr_param.field_ret[2]
END IF

end event

type sle_nombres from singlelineedit within w_rh434_p_calcula_planilla_ind
integer x = 763
integer y = 72
integer width = 1349
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_rh434_p_calcula_planilla_ind
integer x = 430
integer y = 72
integer width = 247
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_rh434_p_calcula_planilla_ind
integer x = 974
integer y = 316
integer width = 521
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh434_p_calcula_planilla_ind
integer x = 1600
integer y = 588
integer width = 430
integer height = 152
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
boolean default = true
end type

event clicked;String  	ls_codtra          , ls_mensaje     	  	, ls_flag_control		, &
			ls_flag_cierre_mes , ls_flag_renta_quinta	, ls_origen				, &
			ls_tipo_trabaj		 , ls_tipo_planilla		, ls_flag_descuento	, &
			ls_flag_dso_af
			
Date    	ld_fec_proceso		,ld_fec_calculo	,ld_fecha1				, ld_fecha2
Long    	ln_reg_act			,ln_reg_tot			,ll_count				, ll_dias_mes, &
			ll_dias_mes_empleado, ll_dias_mes_obrero

u_ds_base	lds_base

Parent.SetMicroHelp('Procesando Cálculo de Planilla')

ls_codtra 		 = sle_codigo.text
ls_tipo_planilla = trim(em_tipo_planilla.text)
em_fec_proceso.getData(ld_fec_proceso)

if ls_codtra = '' then
	gnvo_app.of_message_error("Debe especificar un Código de Trabajador, por favor verifique!")
	sle_codigo.SetFocus()
	return
end if

if IsNull(ld_fec_proceso) or string(ld_fec_proceso, 'dd/mm/yyyy') = '01/01/1900' then
	gnvo_app.of_message_error("Debe especificar una Fecha de proceso, por favor verifique!")
	em_fec_proceso.SetFocus()
	return
end if

//verificar control de ganacias fijas
if cbx_control.checked then //no tomar en cuenta ganancias fijas
	ls_flag_control = '2'
else
	ls_flag_control = '1'
end if	

//Validar si tienen o no descuento
if cbx_descuento.checked then
	ls_flag_descuento = '0'
else
	ls_flag_descuento = '1'
end if

//Verificar si el proceso es de cierre de mes
if cbx_cierre_mes.checked then 	
	//Esto es necesario para los impuestos patronales que dependen de los topes mínimos
	ls_flag_cierre_mes = '1'
else
	ls_flag_cierre_mes = '0'
end if	

//ACtivo o no la generación de la renta de quinta
if cbx_renta_quinta.checked then 	
	ls_flag_renta_quinta = '1'
else
	ls_flag_renta_quinta = '0'
end if	

//Verifico si anexo los descuentos para el calculo de la planilla
if cbx_descuento.checked then 	
	ls_flag_renta_quinta = '0'
else
	ls_flag_renta_quinta = '1'
end if	

if cbx_asig_familiar.checked then
	ls_flag_dso_af = '1'
else
	ls_flag_dso_af = '0'
end if

/***********************************************/
/*************VALIDACIONES**********************/
/***********************************************/
select dias_mes_empleado , dias_mes_obrero 		 
  into :ll_dias_mes_empleado , :ll_dias_mes_obrero  
  from rrhhparam 
 where (reckey = '1' ) ;
 
select cod_origen, tipo_trabajador
	into :ls_origen, :ls_tipo_trabaj
from maestro
where cod_trabajador = :ls_codtra;

//Valido el origen si esta activo
select count(*) 
	into :ll_count
  from origen 
 where (cod_origen  = :ls_origen ) and
 		 (flag_estado = '1'			) ;
		  
if ll_count = 0 then
	Messagebox('Aviso','Origen No Existe o no está activo, por favor verifique!')
	Return
end if

//Valido si el tipo de trabajador esta activo o no
select count(*) 
	into :ll_count 
  from tipo_trabajador
 where (tipo_trabajador = :ls_tipo_trabaj ) and
 		 (flag_estado	   = '1'					) ;

if ll_count = 0 then
	Messagebox('Aviso','Tipo de Trabajador no existe o no está activo, por favor verifique!')
	Return
end if

//VAlido la cantidad de días trabajados
if (ls_tipo_trabaj = 'EMP' or ls_tipo_trabaj = 'FUN' or ls_tipo_trabaj = 'FGE') then
	ll_dias_mes = ll_dias_mes_empleado 
else
	ll_dias_mes = ll_dias_mes_obrero 
end if ;

select count(*) 
	into :ll_count 
	from inasistencia i
  where i.cod_trabajador  = :ls_codtra and
		  i.concep          in (select g.concepto_gen from grupo_calculo g 
										 where g.grupo_calculo in (select c.gan_fij_calc_vacac 
																			  from rrhhparam_cconcep c 
																			 where c.reckey = '1' ))  ;

if ll_dias_mes = 0 and ll_count = 0 then
	gnvo_app.of_message_error("El Trabajador " + ls_codtra &
		+ " con tipo de trabajador: " + ls_tipo_trabaj &
		+ ", no tiene días trabajados, por favor confirme")
	return
end if


//Obtengo las fecha de inicio y de fin según la fecha de proceso
select fec_inicio, fec_final
	into :ld_fecha1, :ld_fecha2
from rrhh_param_org
where fec_proceso 	 = :ld_fec_proceso
  and origen 			 = :ls_origen
  and tipo_trabajador = :ls_tipo_trabaj
  and tipo_planilla	 = :ls_tipo_planilla;

if SQLCA.SQLCode = 100 then
	gnvo_app.of_message_error("No existe fecha de proceso para los parametros ingresados..~r~n" &
			  + "Origen: " + ls_origen + "~r~n" &
			  + "Fecha Proceso: " + string(ld_fec_proceso, 'dd/mm/yyyy') + "~r~n" &
			  + "Tipo Trabajador: " + ls_tipo_trabaj + "~r~n" &
			  + "Tipo Planilla: " + ls_tipo_planilla )
	return 
end if

//  Verifica que exista el tipo de cambio a la fecha de proceso
select Count(*) 
	into :ll_count
	from calendario
 where trunc(fecha) = :ld_fec_proceso ;
  
if ll_count = 0 then
	gnvo_app.of_message_error('No existe tipo de cambio a la fecha de proceso. Solicitarlo a Contabilidad')
	return
end if




//  Si la planilla existe en el histórico, no debe generar cálculo
select count(*) 
	into :ll_count
	from historico_calculo hc, 
		  maestro m
 where hc.cod_trabajador = m.cod_trabajador 
   and m.cod_origen 		 = :ls_origen 
	and m.tipo_trabajador = :ls_tipo_trabaj 
	and hc.fec_calc_plan  = :ld_fec_proceso 
	and hc.tipo_planilla	 = :ls_tipo_planilla;
		 
		 
if ll_count > 0 then
	gnvo_app.of_message_error('Planilla ha sido procesada y esta almacenada en el histórico, imposible volverla a procesar. Verifique fecha de proceso')
	Return
end if

//  Verifica que la planilla haya sido pasada al histórico de cálculo
select max(fec_proceso) 
  into :ld_fec_calculo
  from calculo c, 
       maestro m
 where c.cod_trabajador  = m.cod_trabajador 
   and m.cod_origen 	    = :ls_origen 		
	and m.tipo_trabajador = :ls_tipo_trabaj
	and c.tipo_planilla	 = :ls_tipo_planilla;
	  		  
if ld_fec_calculo <> ld_fec_proceso then
	
	ll_count = 0
	
	select count(*) 
	  into :ll_count 
	  from 	historico_calculo hc, 
	  			maestro 				m
	 where hc.cod_trabajador = m.cod_trabajador
	   and m.cod_origen 	  	 = :ls_origen 	  
		and m.tipo_trabajador = :ls_tipo_trabaj 
		and hc.fec_calc_plan  = :ld_fec_calculo
		and hc.tipo_planilla	 = :ls_tipo_planilla;
			 
	if ll_count = 0 then
			gnvo_app.of_message_error('El cálculo de planilla con fecha '+string(ld_fec_calculo,'dd/mm/yyyy')+ ' no ha sido pasada al histórico, realizar proceso de cierre de planilla')
	      return
	end if
end if


//create or replace procedure USP_RH_HORAS_ASISTENCIA(
//       adi_fecha1 IN DATE,
//       adi_fecha2 IN DATE
//       
//) IS
DECLARE 	USP_RH_JORNAL_CAMPO_COSTO PROCEDURE FOR
			USP_RH_JORNAL_CAMPO_COSTO( :ld_fecha1,
											 	:ld_fecha2);
EXECUTE 	USP_RH_JORNAL_CAMPO_COSTO ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_RH_JORNAL_CAMPO_COSTO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_RH_JORNAL_CAMPO_COSTO;

	
//create or replace procedure usp_rh_del_doc_cal_plla(
//       asi_tipo_trab        in maestro.tipo_trabajador%type,
//       asi_origen           in maestro.cod_origen%type     ,
//       adi_fec_proceso      in date,
//       asi_tipo_planilla    in calculo.tipo_planilla%TYPE                        
//) is

DECLARE usp_rh_del_doc_cal_plla PROCEDURE FOR 
	usp_rh_del_doc_cal_plla( :ls_tipo_trabaj,
									 :ls_origen,
									 :ld_fec_proceso,
									 :ls_tipo_planilla ) ;
									 
EXECUTE usp_rh_del_doc_cal_plla ;

//busco errores
IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLErrText
  	Rollback ;
  	Messagebox('Error usp_rh_del_doc_cal_plla',ls_mensaje)
  	Return
end if

CLOSE usp_rh_del_doc_cal_plla ;


//Borra movimiento calculado de acuerdo al origen y fecha de proceso

//pkg_rrhh.of_borra_mov_calculo(asi_origen => :asi_origen,
//									  adi_fec_proceso => :adi_fec_proceso,
//									  asi_cod_trabajador => :asi_cod_trabajador,
//									  asi_tipo_planilla => :asi_tipo_planilla);

DECLARE USP_RH_CAL_BORRA_MOV_CALCULO PROCEDURE FOR 
	pkg_rrhh.of_borra_mov_calculo( :ls_origen, 
											 :ld_fec_proceso, 
											 :ls_codtra,
											 :ls_tipo_planilla ) ;
EXECUTE USP_RH_CAL_BORRA_MOV_CALCULO ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE pkg_rrhh.of_borra_mov_calculo(): " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_RH_CAL_BORRA_MOV_CALCULO;

//Genera proceso para el cálculo de la planilla
if ls_tipo_planilla = 'G' then
	//  procedure PROCESAR_GRATIF_TRIPULANTE (
	//    asi_codtra             in maestro.cod_trabajador%TYPE,
	//    asi_codusr             in usuario.cod_usr%TYPE,
	//    adi_fec_proceso        in date,
	//    asi_origen             in origen.cod_origen%TYPE
	//  );
	
	DECLARE PKG_CALC_GRATIF_TRIP PROCEDURE FOR 
		USP_SIGRE_RRHH.PROCESAR_GRATIF_TRIPULANTE(:ls_codtra,
																:gs_user,
																:ld_fec_proceso,
																:ls_origen ) ;

	//*verifico pago de vacaciones (cambio autorizado por mmoran) *//
 
	if (ls_tipo_trabaj = 'EMP' or ls_tipo_trabaj = 'FUN' or ls_tipo_trabaj = 'FGE') then
		ll_dias_mes = ll_dias_mes_empleado 
	else
		ll_dias_mes = ll_dias_mes_obrero 
	end if ;


	select count(*) 
		into :ll_count 
		from inasistencia i
	  where i.cod_trabajador  = :ls_codtra and
			  i.concep          in (select g.concepto_gen from grupo_calculo g 
											 where g.grupo_calculo in (select c.gan_fij_calc_vacac 
																				  from rrhhparam_cconcep c 
																				 where c.reckey = '1' ))  ;
																					
 
	//
	if Not(ll_dias_mes = 0 and ll_count = 0) then		
		EXECUTE PKG_CALC_GRATIF_TRIP ;

		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = SQLCA.SQLErrText
			ls_mensaje = 'Código Trabajador: ' + ls_codtra + "~r~n" + ls_mensaje
			Rollback ;
			MessageBox('Error en procedure USP_RH_CAL_CALCULA_PLANILLA', ls_mensaje, StopSign!)	
			Parent.SetMicroHelp('No se realizó el cálculo de la ' &
						+ 'planilla con Exito; trabajador ' + ls_codtra )
			return 
		END IF

	end if ;
	
	CLOSE PKG_CALC_GRATIF_TRIP;	
	
elseif ls_tipo_planilla = 'V' then
	
	//  procedure PROCESAR_VACAC_TRIPULANTE (
	//    asi_codtra             in maestro.cod_trabajador%TYPE,
	//    asi_codusr             in usuario.cod_usr%TYPE,
	//    adi_fec_proceso        in date,
	//    asi_origen             in origen.cod_origen%TYPE
	//  ) IS
	
	DECLARE PKG_CALC_VACAC_TRIP PROCEDURE FOR 
		USP_SIGRE_RRHH.PROCESAR_VACAC_TRIPULANTE(:ls_codtra,
																:gs_user,
																:ld_fec_proceso,
																:ls_origen ) ;

	//*verifico pago de vacaciones (cambio autorizado por mmoran) *//
 
	if (ls_tipo_trabaj = 'EMP' or ls_tipo_trabaj = 'FUN' or ls_tipo_trabaj = 'FGE') then
		ll_dias_mes = ll_dias_mes_empleado 
	else
		ll_dias_mes = ll_dias_mes_obrero 
	end if ;


	select count(*) 
		into :ll_count 
		from inasistencia i
	  where i.cod_trabajador  = :ls_codtra and
			  i.concep          in (select g.concepto_gen from grupo_calculo g 
											 where g.grupo_calculo in (select c.gan_fij_calc_vacac 
																				  from rrhhparam_cconcep c 
																				 where c.reckey = '1' ))  ;
																					
 
	//
	if Not(ll_dias_mes = 0 and ll_count = 0) then		
		EXECUTE PKG_CALC_VACAC_TRIP ;

		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = SQLCA.SQLErrText
			ls_mensaje = 'Código Trabajador: ' + ls_codtra + "~r~n" + ls_mensaje
			Rollback ;
			MessageBox('Error en procedure USP_RH_CAL_CALCULA_PLANILLA', ls_mensaje, StopSign!)	
			Parent.SetMicroHelp('No se realizó el cálculo de la ' &
						+ 'planilla con Exito; trabajador ' + ls_codtra )
			return 
		END IF

	end if ;
	
	CLOSE PKG_CALC_VACAC_TRIP;	

elseif ls_tipo_planilla = 'C' then
	
	//  procedure PROCESAR_CTS_TRIPULANTE (
	//    asi_codtra             in maestro.cod_trabajador%TYPE,
	//    asi_codusr             in usuario.cod_usr%TYPE,
	//    adi_fec_proceso        in date,
	//    asi_origen             in origen.cod_origen%TYPE
	//  );

	
	DECLARE PKG_CALC_CTS_TRIP PROCEDURE FOR 
		USP_SIGRE_RRHH.PROCESAR_CTS_TRIPULANTE(:ls_codtra,
																:gs_user,
																:ld_fec_proceso,
																:ls_origen ) ;

	//*verifico pago de vacaciones (cambio autorizado por mmoran) *//
 
	if (ls_tipo_trabaj = 'EMP' or ls_tipo_trabaj = 'FUN' or ls_tipo_trabaj = 'FGE') then
		ll_dias_mes = ll_dias_mes_empleado 
	else
		ll_dias_mes = ll_dias_mes_obrero 
	end if ;


	select count(*) 
		into :ll_count 
		from inasistencia i
	  where i.cod_trabajador  = :ls_codtra and
			  i.concep          in (select g.concepto_gen from grupo_calculo g 
											 where g.grupo_calculo in (select c.gan_fij_calc_vacac 
																				  from rrhhparam_cconcep c 
																				 where c.reckey = '1' ))  ;
																					
 
	//
	if Not(ll_dias_mes = 0 and ll_count = 0) then		
		EXECUTE PKG_CALC_CTS_TRIP ;

		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = SQLCA.SQLErrText
			ls_mensaje = 'Código Trabajador: ' + ls_codtra + "~r~n" + ls_mensaje
			Rollback ;
			MessageBox('Error en procedure USP_RH_CAL_CALCULA_PLANILLA', ls_mensaje, StopSign!)	
			Parent.SetMicroHelp('No se realizó el cálculo de la ' &
						+ 'planilla con Exito; trabajador ' + ls_codtra )
			return 
		END IF

	end if ;
	
	CLOSE PKG_CALC_CTS_TRIP;	

else
	
	//create or replace procedure usp_rh_cal_calcula_planilla (
	//  asi_codtra             in maestro.cod_trabajador%TYPE,
	//  asi_codusr             in usuario.cod_usr%TYPE,
	//  adi_fec_proceso        in date,
	//  asi_origen             in origen.cod_origen%TYPE,
	//  asi_flag_control       in char,
	//  asi_flag_renta_quinta  in char,
	//  asi_flag_dso_af        in char,
	//  asi_tipo_planilla      in char,
	//  asi_flag_cierre_mes    in char,
	//  asi_flag_descuento     in char
	//) is
	
	DECLARE USP_RH_CAL_CALCULA_PLANILLA PROCEDURE FOR 
		USP_RH_CAL_CALCULA_PLANILLA(	:ls_codtra,
												:gs_user,
												:ld_fec_proceso,
												:ls_origen,
												:ls_flag_control,
												:ls_flag_renta_quinta,
												:ls_flag_dso_af,
												:ls_tipo_planilla,
												:ls_flag_cierre_mes,
												:ls_flag_descuento) ;
												
	//*verifico pago de vacaciones (cambio autorizado por mmoran) *//
 
	if (ls_tipo_trabaj = 'EMP' or ls_tipo_trabaj = 'FUN' or ls_tipo_trabaj = 'FGE') then
		ll_dias_mes = ll_dias_mes_empleado 
	else
		ll_dias_mes = ll_dias_mes_obrero 
	end if ;


	select count(*) 
		into :ll_count 
		from inasistencia i
	  where i.cod_trabajador  = :ls_codtra and
			  i.concep          in (select g.concepto_gen from grupo_calculo g 
											 where g.grupo_calculo in (select c.gan_fij_calc_vacac 
																				  from rrhhparam_cconcep c 
																				 where c.reckey = '1' ))  ;
																					
 
	//
	if Not(ll_dias_mes = 0 and ll_count = 0) then		
		EXECUTE USP_RH_CAL_CALCULA_PLANILLA ;

		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = SQLCA.SQLErrText
			ls_mensaje = 'Código Trabajador: ' + ls_codtra + "~r~n" + ls_mensaje
			Rollback ;
			MessageBox('Error en procedure USP_RH_CAL_CALCULA_PLANILLA', ls_mensaje, StopSign!)	
			Parent.SetMicroHelp('No se realizó el cálculo de la ' &
						+ 'planilla con Exito; trabajador ' + ls_codtra )
			return 
		END IF

	end if ;
	
	CLOSE USP_RH_CAL_CALCULA_PLANILLA;	

end if


//create or replace procedure usp_rh_gen_doc_pago_plla(
//       asi_tipo_trab       in maestro.tipo_trabajador%type ,
//       asi_origen          in origen.cod_origen%Type       ,
//       adi_fec_proceso     in date                         ,
//       asi_tipo_planilla   in calculo.tipo_planilla%TYPE   ,
//       asi_cod_usr         in usuario.cod_usr%type
//) is

DECLARE USP_RH_GEN_DOC_PAGO_PLLA PROCEDURE FOR 
	USP_RH_GEN_DOC_PAGO_PLLA(	:ls_tipo_trabaj,
										:ls_origen,
										:ld_fec_proceso,
										:ls_tipo_planilla,
										:gs_user) ;
										
EXECUTE USP_RH_GEN_DOC_PAGO_PLLA ;

//busco errores
IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLErrText
  	Rollback ;
  	Messagebox('SQL Error USP_RH_GEN_DOC_PAGO_PLLA',ls_mensaje)
  	Return
end if

CLOSE USP_RH_GEN_DOC_PAGO_PLLA ;


//ejecuto procesos de generacion de documentos de pago AFP

//create or replace procedure usp_rh_gen_doc_pago_afp(
//       asi_ttrab            in maestro.tipo_trabajador%type ,
//       asi_origen           in origen.cod_origen%Type       ,
//       adi_fec_proceso      in date                         ,
//       asi_tipo_planilla    in calculo.tipo_planilla%TYPE   ,
//       asi_cod_usr          in usuario.cod_usr%type          
//) is
//
DECLARE USP_RH_GEN_DOC_PAGO_AFP PROCEDURE FOR 
	USP_RH_GEN_DOC_PAGO_AFP(	:ls_tipo_trabaj,
										:ls_origen,
										:ld_fec_proceso,
										:ls_tipo_planilla,
										:gs_user) ;

EXECUTE USP_RH_GEN_DOC_PAGO_AFP ;

//busco errores
IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLErrText
  	Rollback ;
  	Messagebox('SQL Error USP_RH_GEN_DOC_PAGO_AFP',ls_mensaje)
  	Return
end if	   	  

CLOSE USP_RH_GEN_DOC_PAGO_AFP ;

Commit ;	  

//Si hay datos calculados entonces activo el boton reporte
select count(*)
  into :ll_count
  from calculo c
 where c.cod_trabajador  = :ls_codtra
	and c.tipo_planilla	 = :ls_tipo_planilla;

if ll_count = 0 then
	gnvo_app.of_message_error("No hay registros calculados, por favor verifique antes de revisar algun reporte")
else
	f_mensaje("Proceso concluido satisfactoriamente, se han generado " + string(ll_count) + " registros en planilla. Puede usar los reportes para validarlos", "")
end if



end event

type em_fec_proceso from editmask within w_rh434_p_calcula_planilla_ind
integer x = 1513
integer y = 304
integer width = 416
integer height = 76
integer taborder = 40
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
end type

type gb_1 from groupbox within w_rh434_p_calcula_planilla_ind
integer width = 2501
integer height = 764
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

