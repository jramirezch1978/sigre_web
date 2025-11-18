$PBExportHeader$w_rh901_cierra_planilla_bk.srw
forward
global type w_rh901_cierra_planilla_bk from w_prc
end type
type em_desc_tipo_planilla from editmask within w_rh901_cierra_planilla_bk
end type
type cb_tipo_planilla from commandbutton within w_rh901_cierra_planilla_bk
end type
type em_tipo_planilla from editmask within w_rh901_cierra_planilla_bk
end type
type st_1 from statictext within w_rh901_cierra_planilla_bk
end type
type st_7 from statictext within w_rh901_cierra_planilla_bk
end type
type em_descripcion_ttrab from editmask within w_rh901_cierra_planilla_bk
end type
type cb_origen from commandbutton within w_rh901_cierra_planilla_bk
end type
type em_ttrab from editmask within w_rh901_cierra_planilla_bk
end type
type pb_procesar from picturebutton within w_rh901_cierra_planilla_bk
end type
type st_5 from statictext within w_rh901_cierra_planilla_bk
end type
type st_2 from statictext within w_rh901_cierra_planilla_bk
end type
type cb_ttrab from commandbutton within w_rh901_cierra_planilla_bk
end type
type em_origen from editmask within w_rh901_cierra_planilla_bk
end type
type em_descripcion_origen from editmask within w_rh901_cierra_planilla_bk
end type
type em_fec_proceso from editmask within w_rh901_cierra_planilla_bk
end type
type gb_1 from groupbox within w_rh901_cierra_planilla_bk
end type
end forward

global type w_rh901_cierra_planilla_bk from w_prc
integer width = 2139
integer height = 676
string title = "(RH901) Adiciona Movimiento de Cálculos a los Históricos"
string menuname = "m_only_exit"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean center = true
event ue_tipo_planilla ( )
event ue_fecha_proceso ( )
em_desc_tipo_planilla em_desc_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_tipo_planilla em_tipo_planilla
st_1 st_1
st_7 st_7
em_descripcion_ttrab em_descripcion_ttrab
cb_origen cb_origen
em_ttrab em_ttrab
pb_procesar pb_procesar
st_5 st_5
st_2 st_2
cb_ttrab cb_ttrab
em_origen em_origen
em_descripcion_origen em_descripcion_origen
em_fec_proceso em_fec_proceso
gb_1 gb_1
end type
global w_rh901_cierra_planilla_bk w_rh901_cierra_planilla_bk

event ue_tipo_planilla();String	ls_origen, ls_tipo_trabajador, ls_tipo_planilla, ls_desc_tipo_planilla

ls_origen 				= em_origen.text
ls_tipo_trabajador 	= em_ttrab.text

if IsNull(ls_origen) or trim(ls_origen) = '' then return
if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return

select distinct c.tipo_planilla, 
		 USP_SIGRE_RRHH.of_tipo_planilla(c.tipo_planilla)
	into :ls_tipo_planilla, :ls_desc_tipo_planilla		 
from calculo 	c,
	  maestro	m
where c.cod_trabajador = m.cod_trabajador
  and m.tipo_trabajador = :ls_tipo_trabajador
  and m.cod_origen		= :ls_origen;

em_tipo_planilla.text 		= ls_tipo_planilla
em_desc_tipo_planilla.text = ls_desc_tipo_planilla
end event

event ue_fecha_proceso();string 	ls_origen, ls_tipo_trabajador, ls_tipo_planilla
Date		ld_fecha

ls_origen 				= em_origen.text
ls_tipo_trabajador 	= em_ttrab.text
ls_tipo_planilla		= em_tipo_planilla.text

if IsNull(ls_origen) or trim(ls_origen) = '' then return
if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return
if isNull(ls_tipo_planilla) or trim(ls_tipo_planilla) = '' then return

//ld_fecha = gnvo_app.rrhhparam.of_get_ult_fec_proceso(ls_origen, ls_tipo_trabajador, ls_tipo_planilla)
select distinct fec_proceso
  into :ld_fecha
 from calculo c,
 		maestro m
 where c.cod_trabajador 	= m.cod_trabajador
   and m.cod_origen			= :ls_origen
	and m.tipo_trabajador 	= :ls_tipo_trabajador
	and c.tipo_planilla		= :ls_tipo_planilla;

em_fec_proceso.text = string(ld_fecha, 'dd/mm/yyyy')
end event

on w_rh901_cierra_planilla_bk.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_tipo_planilla=create em_tipo_planilla
this.st_1=create st_1
this.st_7=create st_7
this.em_descripcion_ttrab=create em_descripcion_ttrab
this.cb_origen=create cb_origen
this.em_ttrab=create em_ttrab
this.pb_procesar=create pb_procesar
this.st_5=create st_5
this.st_2=create st_2
this.cb_ttrab=create cb_ttrab
this.em_origen=create em_origen
this.em_descripcion_origen=create em_descripcion_origen
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_desc_tipo_planilla
this.Control[iCurrent+2]=this.cb_tipo_planilla
this.Control[iCurrent+3]=this.em_tipo_planilla
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.em_descripcion_ttrab
this.Control[iCurrent+7]=this.cb_origen
this.Control[iCurrent+8]=this.em_ttrab
this.Control[iCurrent+9]=this.pb_procesar
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.cb_ttrab
this.Control[iCurrent+13]=this.em_origen
this.Control[iCurrent+14]=this.em_descripcion_origen
this.Control[iCurrent+15]=this.em_fec_proceso
this.Control[iCurrent+16]=this.gb_1
end on

on w_rh901_cierra_planilla_bk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_desc_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_tipo_planilla)
destroy(this.st_1)
destroy(this.st_7)
destroy(this.em_descripcion_ttrab)
destroy(this.cb_origen)
destroy(this.em_ttrab)
destroy(this.pb_procesar)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.cb_ttrab)
destroy(this.em_origen)
destroy(this.em_descripcion_origen)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//inicializa datos
try 
	em_fec_proceso.text = String(Date(gnvo_app.of_fecha_actual()), 'dd/mm/yyyy')
	
	if gnvo_app.of_get_parametro("RRHH_PROCESSING_TIPO_PLANILLA", "0") = "1" OR gs_empresa = "CANTABRIA" then
	
		
		st_1.visible = true
		em_tipo_planilla.visible = true
		cb_tipo_planilla.visible = true
		em_desc_tipo_planilla.visible = true
		
		st_1.enabled = true
		em_tipo_planilla.enabled = true
		cb_tipo_planilla.enabled = true
		em_desc_tipo_planilla.enabled = true
		
	else
	
		st_1.visible = false
		em_tipo_planilla.visible = false
		cb_tipo_planilla.visible = false
		em_desc_tipo_planilla.visible = false
		
		st_1.enabled = false
		em_tipo_planilla.enabled = false
		cb_tipo_planilla.enabled = false
		em_desc_tipo_planilla.enabled = false
	
	end if

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "")
end try

end event

type em_desc_tipo_planilla from editmask within w_rh901_cierra_planilla_bk
boolean visible = false
integer x = 727
integer y = 276
integer width = 983
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_tipo_planilla from commandbutton within w_rh901_cierra_planilla_bk
boolean visible = false
integer x = 640
integer y = 276
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
boolean enabled = false
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj
Date		ld_fec_proceso

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	em_origen.SetFocus()
	return
end if

ls_tipo_trabaj = em_ttrab.text

if IsNull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then
	gnvo_app.of_message_error( "Debe especificar tipo de Trabajador. Por favor verifique!")
	em_ttrab.SetFocus()
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
	
	parent.event ue_fecha_proceso()
	
end if
end event

type em_tipo_planilla from editmask within w_rh901_cierra_planilla_bk
boolean visible = false
integer x = 453
integer y = 276
integer width = 183
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_tipo_trabaj, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_trabaj = this.text

select desc_tipo_tra
	into :ls_data
from tipo_trabajador tt,
	  maestro			m
where m.tipo_trabajador  = tt.tipo_trabajador
  and tt.tipo_trabajador = :ls_tipo_trabaj
  and m.cod_origen		 = :ls_origen
  and tt.flag_estado 	 = '1';

if SQLCA.SQLCode = 100 then
	gnvo_app.of_message_error("TIPO DE TRABAJADOR NO EXISTE, NO ESTA ACTIVO O NO TIENE " &
									+ "TRABAJADORES ASIGNADOS A ESE ORIGEN")
	this.text = gnvo_app.is_null
	em_descripcion_ttrab.text = gnvo_app.is_null
	return
end if

em_desc_tipo_planilla.text = ls_data

parent.event ue_fecha_proceso()


end event

type st_1 from statictext within w_rh901_cierra_planilla_bk
boolean visible = false
integer x = 128
integer y = 276
integer width = 320
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "T. Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_rh901_cierra_planilla_bk
integer x = 69
integer y = 192
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_descripcion_ttrab from editmask within w_rh901_cierra_planilla_bk
integer x = 727
integer y = 184
integer width = 983
integer height = 76
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

type cb_origen from commandbutton within w_rh901_cierra_planilla_bk
integer x = 635
integer y = 92
integer width = 87
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//// Abre ventana de ayuda 
//
//str_parametros sl_param
//
//sl_param.dw1 = "d_seleccion_origen_tbl"
//sl_param.titulo = "Seleccionar Búsqueda"
//sl_param.field_ret_i[1] = 1
//sl_param.field_ret_i[2] = 2
//
//OpenWithParm( w_search_origen, sl_param)		
//sl_param = MESSAGE.POWEROBJECTPARM
//IF sl_param.titulo <> 'n' THEN
//	em_origen.text             = sl_param.field_ret[1]
//	em_descripcion_origen.text = sl_param.field_ret[2]
//END IF

boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT distinct o.cod_origen AS CODIGO_origen, " &
		  + "o.nombre AS nombre_origen " &
		  + "FROM origen o," &
		  + "calculo c, " &
		  + "maestro m " &
		  + "WHERE c.cod_trabajador = m.cod_trabajador" &
		  + "  and m.cod_origen		 = o.cod_origen" &
		  + "  and o.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion_origen.text = ls_data
	//parent.event ue_fecha_proceso( )
end if
end event

type em_ttrab from editmask within w_rh901_cierra_planilla_bk
integer x = 453
integer y = 184
integer width = 183
integer height = 76
integer taborder = 40
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

event modified;parent.event ue_tipo_planilla()
parent.event ue_fecha_proceso()
end event

type pb_procesar from picturebutton within w_rh901_cierra_planilla_bk
integer x = 1787
integer y = 12
integer width = 297
integer height = 352
integer taborder = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\Gif\Procesar_rh.GIF"
boolean map3dcolors = true
string powertiptext = "Procesar"
end type

event clicked;Integer li_opcion
Long    ll_count
String  ls_origen,ls_ttrab ,ls_mensaje, ls_tipo_planilla
Date	  ld_fec_proceso

ls_origen 			= em_origen.text
ls_ttrab	 			= em_ttrab.text
ls_tipo_planilla	= em_tipo_planilla.text
em_fec_proceso.getData(ld_fec_proceso)

select count(*) 
  into :ll_count
  from origen 
 where cod_origen  = :ls_origen 
   and flag_estado = '1';
		  
if ll_count = 0 then
	Messagebox('Aviso','Origen No Existe o no esta activo, por favor Verifique!')
	Return
end if

select count(*) 
  into :ll_count 
  from tipo_trabajador
 where tipo_trabajador = :ls_ttrab 
 	and flag_estado	   = '1'	;

if ll_count = 0 then
	Messagebox('Aviso','Tipo de trabajador no existe o no esta activo, por favor Verifique!')
	Return
end if

//se grabo informacion satisfactoriamente
select count(*) 
	into :ll_count 
from 	historico_calculo hc
where trunc(hc.fec_calc_plan) = trunc(:ld_fec_proceso)
  and hc.cod_origen       	   = :ls_origen    		
  and hc.tipo_trabajador  	   = :ls_ttrab
  and hc.tipo_planilla			= :ls_tipo_planilla;

if ll_count > 0 then
	Messagebox('Aviso','Planilla ya fue Enviada a los historicos , por favor Verifique!')
	Return
end if

//create or replace procedure usp_rh_cierre_planilla(
//       asi_origen         in origen.cod_origen%Type               ,
//       asi_tipo_trab      in tipo_trabajador.tipo_trabajador%Type ,
//       adi_fec_proceso    in date,
//       asi_tipo_planilla  in calculo.tipo_planilla%TYPE
//) is


//ejecuto procesos de CIERRE DE PLANILLA
DECLARE usp_rh_cierre_planilla PROCEDURE FOR 
	usp_rh_cierre_planilla(	:ls_origen ,
									:ls_ttrab ,
									:ld_fec_proceso,
									:ls_tipo_planilla);

EXECUTE usp_rh_cierre_planilla ;
  
//busco errores
if sqlca.sqlcode = -1 then
   ls_mensaje = sqlca.sqlerrtext
   Rollback ;
   Messagebox('SQL Error usp_rh_cierre_planilla', 'Error al procesar el cierre de planilla. ' + ls_mensaje)
   Return
end if	   	  
  
CLOSE usp_rh_cierre_planilla ;
  

//se grabo informacion satisfactoriamente
select count(*) 
	into :ll_count 
from 	historico_calculo hc
where trunc(hc.fec_calc_plan) = :ld_Fec_proceso 
  and hc.cod_origen       	   = :ls_origen    		
  and hc.tipo_trabajador  	   = :ls_ttrab
  and hc.tipo_planilla			= :ls_tipo_planilla;
		 
if ll_count > 0 then		 
	Commit ;	  
	Messagebox('Aviso','Proceso ha concluído Satisfactoriamente')
	Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
else
	Rollback ;
	Messagebox('Aviso','Proceso No ha concluído Satisfactoriamente')
	Parent.SetMicroHelp('Proceso No ha concluído Satisfactoriamente')
end if	


end event

type st_5 from statictext within w_rh901_cierra_planilla_bk
integer x = 69
integer y = 100
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh901_cierra_planilla_bk
integer x = 55
integer y = 376
integer width = 837
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de Proceso Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ttrab from commandbutton within w_rh901_cierra_planilla_bk
integer x = 635
integer y = 184
integer width = 87
integer height = 76
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

event clicked;//// Abre ventana de ayuda 
//
//str_parametros sl_param
//
//sl_param.dw1 = "d_seleccion_tiptra_tbl"
//sl_param.titulo = "Seleccionar Búsqueda"
//sl_param.field_ret_i[1] = 1
//sl_param.field_ret_i[2] = 2
//
//OpenWithParm( w_search_origen, sl_param)		
//sl_param = MESSAGE.POWEROBJECTPARM
//IF sl_param.titulo <> 'n' THEN
//	em_ttrab.text             = sl_param.field_ret[1]
//	em_descripcion_ttrab.text = sl_param.field_ret[2]
//END IF
//

boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	em_origen.SetFocus()
	return
end if

ls_sql = "SELECT distinct " &
		  + "tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt," &
		  + "     maestro			  m, " &
		  + "		 calculo			  c  " &
		  + "WHERE c.cod_trabajador  = m.cod_trabajador " &
		  + "  and m.tipo_Trabajador = tt.tipo_trabajador " &
		  + "  and m.cod_origen = '" + ls_origen + "'" &
		  + "  and m.flag_estado = '1'" &
		  + "  and tt.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_ttrab.text = ls_codigo
	em_descripcion_ttrab.text = ls_data
	
	parent.event ue_tipo_planilla()
	
	parent.event ue_fecha_proceso()
end if
end event

type em_origen from editmask within w_rh901_cierra_planilla_bk
integer x = 453
integer y = 92
integer width = 183
integer height = 76
integer taborder = 20
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

type em_descripcion_origen from editmask within w_rh901_cierra_planilla_bk
integer x = 727
integer y = 92
integer width = 983
integer height = 76
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

type em_fec_proceso from editmask within w_rh901_cierra_planilla_bk
integer x = 914
integer y = 376
integer width = 375
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type gb_1 from groupbox within w_rh901_cierra_planilla_bk
integer width = 1765
integer height = 512
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Datos Generales"
end type

