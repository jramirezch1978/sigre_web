$PBExportHeader$w_rh411_p_calcula_planilla.srw
forward
global type w_rh411_p_calcula_planilla from w_prc
end type
type cbx_descuento from checkbox within w_rh411_p_calcula_planilla
end type
type st_left_time from statictext within w_rh411_p_calcula_planilla
end type
type st_3 from statictext within w_rh411_p_calcula_planilla
end type
type st_1 from statictext within w_rh411_p_calcula_planilla
end type
type em_desc_tipo_planilla from editmask within w_rh411_p_calcula_planilla
end type
type cb_tipo_planilla from commandbutton within w_rh411_p_calcula_planilla
end type
type em_tipo_planilla from editmask within w_rh411_p_calcula_planilla
end type
type cbx_asig_familiar from checkbox within w_rh411_p_calcula_planilla
end type
type cbx_renta_quinta from checkbox within w_rh411_p_calcula_planilla
end type
type cb_reportes from commandbutton within w_rh411_p_calcula_planilla
end type
type cbx_vacaciones from checkbox within w_rh411_p_calcula_planilla
end type
type hpb_progreso from hprogressbar within w_rh411_p_calcula_planilla
end type
type cbx_cierre_mes from checkbox within w_rh411_p_calcula_planilla
end type
type st_6 from statictext within w_rh411_p_calcula_planilla
end type
type cbx_control from checkbox within w_rh411_p_calcula_planilla
end type
type em_desc_ttrab from editmask within w_rh411_p_calcula_planilla
end type
type cb_origen from commandbutton within w_rh411_p_calcula_planilla
end type
type em_ttrab from editmask within w_rh411_p_calcula_planilla
end type
type st_4 from statictext within w_rh411_p_calcula_planilla
end type
type st_2 from statictext within w_rh411_p_calcula_planilla
end type
type dw_1 from datawindow within w_rh411_p_calcula_planilla
end type
type cb_1 from commandbutton within w_rh411_p_calcula_planilla
end type
type cb_ttrab from commandbutton within w_rh411_p_calcula_planilla
end type
type em_origen from editmask within w_rh411_p_calcula_planilla
end type
type em_descripcion from editmask within w_rh411_p_calcula_planilla
end type
type em_fec_proceso from editmask within w_rh411_p_calcula_planilla
end type
type gb_1 from groupbox within w_rh411_p_calcula_planilla
end type
end forward

global type w_rh411_p_calcula_planilla from w_prc
integer width = 2569
integer height = 2292
string title = "(RH411) Proceso de Cálculo de la Planilla"
string menuname = "m_only_exit"
boolean minbox = false
boolean maxbox = false
boolean clientedge = true
boolean center = true
event ue_fecha_proceso ( )
event ue_tipo_planilla ( )
cbx_descuento cbx_descuento
st_left_time st_left_time
st_3 st_3
st_1 st_1
em_desc_tipo_planilla em_desc_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_tipo_planilla em_tipo_planilla
cbx_asig_familiar cbx_asig_familiar
cbx_renta_quinta cbx_renta_quinta
cb_reportes cb_reportes
cbx_vacaciones cbx_vacaciones
hpb_progreso hpb_progreso
cbx_cierre_mes cbx_cierre_mes
st_6 st_6
cbx_control cbx_control
em_desc_ttrab em_desc_ttrab
cb_origen cb_origen
em_ttrab em_ttrab
st_4 st_4
st_2 st_2
dw_1 dw_1
cb_1 cb_1
cb_ttrab cb_ttrab
em_origen em_origen
em_descripcion em_descripcion
em_fec_proceso em_fec_proceso
gb_1 gb_1
end type
global w_rh411_p_calcula_planilla w_rh411_p_calcula_planilla

type variables
string is_salir
m_rpt_planilla   	im_reportes
n_cst_wait			invo_wait
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

event ue_fecha_proceso();string 	ls_origen, ls_tipo_trabajador, ls_tipo_planilla
Date		ld_fecha

ls_origen 				= em_origen.text
ls_tipo_trabajador 	= em_ttrab.text
ls_tipo_planilla		= em_tipo_planilla.text

if IsNull(ls_origen) or trim(ls_origen) = '' then return
if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return
if isNull(ls_tipo_planilla) or trim(ls_tipo_planilla) = '' then return

ld_fecha = gnvo_app.rrhhparam.of_get_ult_fec_proceso(ls_origen, ls_tipo_trabajador, ls_tipo_planilla)

em_fec_proceso.text = string(ld_fecha, 'dd/mm/yyyy')
end event

event ue_tipo_planilla();String	ls_origen, ls_tipo_trabajador, ls_tipo_planilla, ls_desc_tipo_planilla, &
			ls_mensaje

ls_origen 				= em_origen.text
ls_tipo_trabajador 	= em_ttrab.text

if IsNull(ls_origen) or trim(ls_origen) = '' then return
if IsNull(ls_tipo_trabajador) or trim(ls_tipo_trabajador) = '' then return

select tipo_planilla, 
		 USP_SIGRE_RRHH.of_tipo_planilla(tipo_planilla)
	into :ls_tipo_planilla, :ls_desc_tipo_planilla		 
from rrhh_param_org r
where r.origen = :ls_origen
  and r.tipo_trabajador = :ls_tipo_trabajador
  and rownum = 1
order by fec_proceso desc;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MEssageBox('Error', 'Ha ocurrido un error al obtener el tipo de planilla de la fecha ' &
						+ 'de PROCESO. Por favor corrija!' &
						+ '~r~nOrigen: ' + ls_origen &
						+ '~r~nTipo Trabajador: ' + ls_tipo_trabajador &
						+ 'Mensaje de Error: ' + ls_mensaje, StopSign!)
	return
end if

if SQLCA.SQLCode = 100 then
	ROLLBACK;
	MEssageBox('Error', 'No se ha encontrado Fecha de proceso con el tipo de Parametros' &
						+ '~r~nOrigen: ' + ls_origen &
						+ '~r~nTipo Trabajador: ' + ls_tipo_trabajador, StopSign!)
	return
end if

em_tipo_planilla.text 		= ls_tipo_planilla
em_desc_tipo_planilla.text = ls_desc_tipo_planilla
end event

public function integer of_get_param ();return 1
end function

on w_rh411_p_calcula_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cbx_descuento=create cbx_descuento
this.st_left_time=create st_left_time
this.st_3=create st_3
this.st_1=create st_1
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_tipo_planilla=create em_tipo_planilla
this.cbx_asig_familiar=create cbx_asig_familiar
this.cbx_renta_quinta=create cbx_renta_quinta
this.cb_reportes=create cb_reportes
this.cbx_vacaciones=create cbx_vacaciones
this.hpb_progreso=create hpb_progreso
this.cbx_cierre_mes=create cbx_cierre_mes
this.st_6=create st_6
this.cbx_control=create cbx_control
this.em_desc_ttrab=create em_desc_ttrab
this.cb_origen=create cb_origen
this.em_ttrab=create em_ttrab
this.st_4=create st_4
this.st_2=create st_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_ttrab=create cb_ttrab
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_descuento
this.Control[iCurrent+2]=this.st_left_time
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_desc_tipo_planilla
this.Control[iCurrent+6]=this.cb_tipo_planilla
this.Control[iCurrent+7]=this.em_tipo_planilla
this.Control[iCurrent+8]=this.cbx_asig_familiar
this.Control[iCurrent+9]=this.cbx_renta_quinta
this.Control[iCurrent+10]=this.cb_reportes
this.Control[iCurrent+11]=this.cbx_vacaciones
this.Control[iCurrent+12]=this.hpb_progreso
this.Control[iCurrent+13]=this.cbx_cierre_mes
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.cbx_control
this.Control[iCurrent+16]=this.em_desc_ttrab
this.Control[iCurrent+17]=this.cb_origen
this.Control[iCurrent+18]=this.em_ttrab
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.st_2
this.Control[iCurrent+21]=this.dw_1
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.cb_ttrab
this.Control[iCurrent+24]=this.em_origen
this.Control[iCurrent+25]=this.em_descripcion
this.Control[iCurrent+26]=this.em_fec_proceso
this.Control[iCurrent+27]=this.gb_1
end on

on w_rh411_p_calcula_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_descuento)
destroy(this.st_left_time)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.em_desc_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_tipo_planilla)
destroy(this.cbx_asig_familiar)
destroy(this.cbx_renta_quinta)
destroy(this.cb_reportes)
destroy(this.cbx_vacaciones)
destroy(this.hpb_progreso)
destroy(this.cbx_cierre_mes)
destroy(this.st_6)
destroy(this.cbx_control)
destroy(this.em_desc_ttrab)
destroy(this.cb_origen)
destroy(this.em_ttrab)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_ttrab)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
end on

event open;call super::open;im_reportes = create m_rpt_planilla



end event

event ue_open_pre;call super::ue_open_pre;
try 
	invo_wait = create n_cst_wait
	
	dw_1.settransobject(SQLCA)

	if of_get_param() = 0 then 
		is_salir = 'S'
		post event closequery()   
		return
	end if
	
	if gs_empresa = 'CANTABRIA' then
		cbx_asig_familiar.visible = true
		cbx_asig_familiar.enabled = true
	
		
	else
		cbx_asig_familiar.visible = false
		cbx_asig_familiar.enabled = false
	end if
	
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
	
	em_tipo_planilla.text = 'N'
	em_desc_tipo_planilla.Text = 'Normal'


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
	
end try
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10

hpb_progreso.width  = newwidth  - hpb_progreso.x - 10

end event

event close;call super::close;destroy im_reportes
destroy invo_wait
end event

type cbx_descuento from checkbox within w_rh411_p_calcula_planilla
integer x = 73
integer y = 492
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

type st_left_time from statictext within w_rh411_p_calcula_planilla
integer x = 1294
integer y = 736
integer width = 1202
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh411_p_calcula_planilla
integer y = 736
integer width = 1202
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh411_p_calcula_planilla
boolean visible = false
integer x = 69
integer y = 252
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

type em_desc_tipo_planilla from editmask within w_rh411_p_calcula_planilla
boolean visible = false
integer x = 727
integer y = 244
integer width = 983
integer height = 76
integer taborder = 50
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

type cb_tipo_planilla from commandbutton within w_rh411_p_calcula_planilla
boolean visible = false
integer x = 640
integer y = 244
integer width = 87
integer height = 76
integer taborder = 40
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
	
	if gs_empresa = 'CANTABRIA' then
		// Si es cantabria entonces obtengo la fecha de proceso
		parent.event ue_fecha_proceso( )
	end if
	
	

end if
end event

type em_tipo_planilla from editmask within w_rh411_p_calcula_planilla
boolean visible = false
integer x = 453
integer y = 244
integer width = 183
integer height = 76
integer taborder = 30
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

event modified;string ls_data, ls_tipo_planilla, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_planilla = this.text

select usp_sigre_rrhh.of_tipo_planilla(:ls_tipo_planilla)
	into :ls_data
from dual;

em_desc_tipo_planilla.text = ls_data

parent.event ue_fecha_proceso( )
end event

type cbx_asig_familiar from checkbox within w_rh411_p_calcula_planilla
integer x = 1303
integer y = 488
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

type cbx_renta_quinta from checkbox within w_rh411_p_calcula_planilla
integer x = 1298
integer y = 420
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

type cb_reportes from commandbutton within w_rh411_p_calcula_planilla
integer x = 2130
integer y = 156
integer width = 334
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Reportes"
boolean cancel = true
end type

event clicked;String 	ls_origen, ls_tipo_trabaj, ls_tipo_planilla
Date		ld_fec_proceso
Integer	li_count

ls_origen 		= em_origen.text
ls_tipo_trabaj = em_ttrab.Text
em_fec_proceso.getData(ld_fec_proceso)
ls_tipo_planilla = em_tipo_planilla.text

if trim(ls_origen) = '' then
	gnvo_app.of_message_error('No ha especificado un origen, por favor verifique!')
	em_origen.SetFocus()
	return
end if

if trim(ls_tipo_trabaj) = '' then
	gnvo_app.of_message_error('No ha especificado un tipo de Trabajador, por favor verifique!')
	em_ttrab.SetFocus()
	return
end if

select count(*)
  into :li_count
  from calculo c,
  		 maestro	m
 where c.cod_trabajador 		= m.cod_trabajador
   and m.cod_origen				= :ls_origen
	and m.tipo_trabajador 		= :ls_tipo_trabaj
	and trunc(c.fec_proceso) 	= :ld_fec_proceso
	and c.tipo_planilla			= :ls_tipo_planilla;

im_reportes.is_origen = ls_origen
im_reportes.is_tipo_trabaj = ls_tipo_trabaj
im_reportes.id_fec_proceso = ld_fec_proceso
im_reportes.is_tipo_planilla = ls_tipo_planilla

im_reportes.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

type cbx_vacaciones from checkbox within w_rh411_p_calcula_planilla
integer x = 73
integer y = 348
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
string text = "Considerar solo vacaciones"
end type

type hpb_progreso from hprogressbar within w_rh411_p_calcula_planilla
integer y = 664
integer width = 2501
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cbx_cierre_mes from checkbox within w_rh411_p_calcula_planilla
integer x = 73
integer y = 564
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

type st_6 from statictext within w_rh411_p_calcula_planilla
integer x = 1298
integer y = 348
integer width = 398
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

type cbx_control from checkbox within w_rh411_p_calcula_planilla
integer x = 73
integer y = 420
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
string text = "No incluir Ganancias Fijas"
end type

type em_desc_ttrab from editmask within w_rh411_p_calcula_planilla
integer x = 727
integer y = 152
integer width = 983
integer height = 76
integer taborder = 40
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

type cb_origen from commandbutton within w_rh411_p_calcula_planilla
integer x = 640
integer y = 60
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
	parent.event ue_fecha_proceso( )
end if

end event

type em_ttrab from editmask within w_rh411_p_calcula_planilla
integer x = 453
integer y = 152
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
	em_desc_ttrab.text = gnvo_app.is_null
	return
end if

em_desc_ttrab.text = ls_data

parent.event ue_tipo_planilla()

parent.event ue_fecha_proceso( )
end event

type st_4 from statictext within w_rh411_p_calcula_planilla
integer x = 69
integer y = 160
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh411_p_calcula_planilla
integer x = 69
integer y = 72
integer width = 379
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

type dw_1 from datawindow within w_rh411_p_calcula_planilla
integer y = 804
integer width = 2501
integer height = 1264
string dataobject = "d_lista_calculo_planilla_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh411_p_calcula_planilla
integer x = 2130
integer y = 56
integer width = 334
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
boolean cancel = true
end type

event clicked;String  	ls_origen      		,ls_codtra        ,ls_mensaje     	  	, &
			ls_tipo_trabaj  		,ls_flag_control	,ls_flag_cierre_mes 	, &
			ls_flag_renta_quinta	,ls_flag_dso_af	,ls_tipo_planilla		, &
			ls_flag_descuento
			
Date    	ld_fec_proceso			, ld_fec_calculo		, ld_fecha1			, ld_fecha2

Long    	ln_reg_act				, ln_reg_tot			, ll_count			, ll_dias_mes, &
			ll_dias_mes_empleado	, ll_dias_mes_obrero
			
DateTime	ldt_inicio, ldt_fin

Decimal	ldc_tiempo, ldc_acum_tiempo, ldc_prom_tiempo, ldc_time_left

u_ds_base	lds_base

try 
	invo_wait.of_mensaje('Procesando Cálculo de Planilla')

	ls_origen 		 	= String (em_origen.text)
	ls_tipo_trabaj	 	= String (em_ttrab.text)
	ls_tipo_planilla = em_tipo_planilla.text
	em_fec_proceso.getData(ld_fec_proceso)
	
	if ls_tipo_trabaj = '' then
		gnvo_app.of_message_error("Debe especificar un tipo de trabajador, por favor verifique!")
		em_ttrab.SetFocus()
		return
	end if
	
	if ls_origen = '' then
		gnvo_app.of_message_error("Debe especificar un origen, por favor verifique!")
		em_origen.SetFocus()
		return
	end if
	
	if IsNull(ld_fec_proceso) or string(ld_fec_proceso, 'dd/mm/yyyy') = '01/01/1900' then
		gnvo_app.of_message_error("Debe especificar una Fecha de proceso, por favor verifique!")
		em_fec_proceso.SetFocus()
		return
	end if
	
	if ls_tipo_planilla = '' then
		gnvo_app.of_message_error("Debe especificar un tipo de PLANILLA, por favor verifique!")
		em_tipo_planilla.SetFocus()
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
	
	if cbx_asig_familiar.checked then
		ls_flag_dso_af = '1'
	else
		ls_flag_dso_af = '0'
	end if
	
	/***********************************************/
	/*************VALIDACIONES**********************/
	/***********************************************/
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
				  + "Tipo Trabajador: " + ls_tipo_trabaj &
				  + "Tipo Planilla: " + ls_tipo_planilla)
		return 
	end if
	
	//Valido si los partes de produccion estan duplicados, no hacerlo en caso de CEPIBO
	if gnvo_app.of_get_Parametro("RRHH_VALIDAR_PARTES_DESTAJO", "0") = "1"  then
		try 
			lds_base = create u_ds_base
			lds_base.DataObject = 'd_rpt_partes_duplicados_tbl'
			lds_base.SetTransObject(SQLCA)
			lds_base.Retrieve(ls_tipo_trabaj, ld_fecha1, ld_fecha2)
			
			if lds_base.RowCount()> 0 then
				gnvo_app.of_mensaje_error("Existen " + String(lds_base.RowCount()) + " Partes duplicados, correspondiente al tipo de trabajador " + ls_tipo_trabaj &
							 + ", por favor verifique", "")
				destroy lds_base
				
				str_parametros 	lstr_param
				w_cns_general		lw_cns
				lstr_param.dw1 	 = 'd_rpt_partes_duplicados_tbl'
				lstr_param.tipo 	 = '1S1D2D'
				lstr_param.string1 = ls_tipo_trabaj
				lstr_param.date1 	 = ld_fecha1
				lstr_param.date2   = ld_fecha2
				lstr_param.titulo	 = 'Partes Repetidos por Tipo de Trabajador'
					
				OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
				
				return
			end if
			
			
		catch ( Exception ex)
			gnvo_app.of_catch_exception( ex, "")
			
		finally
			if not IsNull(lds_base) then
				destroy lds_base
			end if
		end try
	end if
	
	
	//  Verifica que exista el tipo de cambio a la fecha de proceso
	invo_wait.of_mensaje("Obteniendo Fecha de proceso de CALCULO DE PLANILLA")
	select Count(*) 
		into :ll_count
		from calendario
	 where trunc(fecha) = :ld_fec_proceso ;
	  
	if ll_count = 0 then
		gnvo_app.of_message_error('No existe tipo de cambio a la fecha de proceso ' &
										+ string(ld_fec_proceso, 'dd/mm/yyyy') + '. Solicitarlo a Contabilidad')
		return
	end if
	
	select dias_mes_empleado , dias_mes_obrero 		 
	  into :ll_dias_mes_empleado , :ll_dias_mes_obrero  
	  from rrhhparam 
	 where (reckey = '1' ) ;
	
	
	//  Si la planilla existe en el histórico, no debe generar cálculo
	select count(*) 
		into :ll_count
		from historico_calculo hc, 
			  maestro m
	 where hc.cod_trabajador 	= m.cod_trabajador 
		and m.cod_origen 		 	= :ls_origen 
		and hc.tipo_trabajador 	= :ls_tipo_trabaj 
		and hc.fec_calc_plan  	= :ld_fec_proceso 
		and hc.tipo_planilla	 	= :ls_tipo_planilla;
			 
			 
	if ll_count > 0 then
		
		select hc.cod_trabajador
			into :ls_codtra
			from historico_calculo hc, 
				  maestro m
		 where hc.cod_trabajador 	= m.cod_trabajador 
			and m.cod_origen 		 	= :ls_origen 
			and hc.tipo_trabajador 	= :ls_tipo_trabaj 
			and hc.fec_calc_plan  	= :ld_fec_proceso 
			and hc.tipo_planilla	 	= :ls_tipo_planilla;
		
		gnvo_app.of_message_error("Planilla ha sido procesada y esta almacenada en el histórico, " &
									+ " imposible volverla a procesar. Verifique fecha de proceso. " &
									+ "Trabajador encontrado: " + ls_codtra)
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
		  from historico_calculo hc, maestro m
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
	
	//ACtualizo las horas al 100%, unicamente para seafrost
//	if gs_empresa = "SEAFROST" then
//		update asistencia a 
//			set a.hor_diu_nor = a.hor_ext_100
//		where a.hor_ext_100 <> 0
//		  and trunc(a.fec_movim) >= to_Date('29/08/2018', 'dd/mm/yyyy')
//		  and a.cod_trabajador in (select cod_trabajador from maestro m where m.tipo_trabajador = 'JOR');
//		  
//		update asistencia a 
//			set a.hor_ext_100 = 0
//		where a.hor_ext_100 <> 0
//		  and trunc(a.fec_movim) >= to_Date('29/08/2018', 'dd/mm/yyyy')
//		  and a.cod_trabajador in (select cod_trabajador from maestro m where m.tipo_trabajador = 'JOR');  
//		
//		commit;
//	end if
	
	//create or replace procedure USP_RH_HORAS_ASISTENCIA(
	//       adi_fecha1 IN DATE,
	//       adi_fecha2 IN DATE
	//       
	//) IS
	invo_Wait.of_mensaje("Procesando horas de Jornal de CAMPO")
	
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
	
	commit;
	
		
	// Recupera datos para procesar
	if not cbx_vacaciones.checked then
		if gs_empresa = 'SEAFROST' and (ls_tipo_trabaj = 'DES' or ls_tipo_trabaj = 'JOR') then
			dw_1.dataobject = 'd_lista_calculo_planilla_seafrost_tbl'
			
			dw_1.settransobject(sqlca)
			ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj)
		
		else
			dw_1.dataobject = 'd_lista_calculo_planilla_tbl'
			
			dw_1.settransobject(sqlca)
			ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj)
			
		end if
		
	else
		dw_1.dataobject = 'd_lista_trabaj_vaca_tbl'
		dw_1.settransobject(sqlca)
		ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj, ld_fec_proceso)
	end if
	
	if dw_1.Rowcount( ) = 0 then
		MessageBox('Error', 'No hay trabajadores que coincidan con los criterios a procesar ' &
					+ '~r~nOrigen: ' + ls_origen &
					+ '~r~nTipo Trabajador: ' + ls_tipo_trabaj)
		return
	end if
	
	invo_Wait.of_mensaje("Eliminando DOCUMENTO DE PAGO DIRECTO DE PLANILLA")
	// Primero Trato de eliminar el documento de pago de la planilla, y esto valida si ha sido pagado o no
	// Si ha sido pagado entonces ya no puedo volver a calcular la misma planilla
	//ELIMINO ARCHIVOS DE PAGO
	
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
		ls_mensaje = "PROCEDURE usp_rh_del_doc_cal_plla: " + SQLCA.SQLErrText
		Rollback ;
		Messagebox('Error',ls_mensaje, StopSign!)
		Return
	end if
	
	CLOSE usp_rh_del_doc_cal_plla ;
	
	commit;
	
	invo_Wait.of_mensaje("Eliminando CALCULO DE PLANILLA Anterior")
	//  Borra movimiento calculado de acuerdo al origen y fecha de proceso
	
	//create or replace procedure usp_rh_cal_borra_mov_calculo (
	//  asi_origen         in origen.cod_origen%TYPE,
	//  adi_fec_proceso    in date,
	//  asi_tipo_trabaj    in tipo_trabajador.tipo_trabajador %TYPE,
	//  asi_tipo_planilla  in calculo.tipo_planilla%TYPE
	//) is
	DECLARE USP_RH_CAL_BORRA_MOV_CALCULO PROCEDURE FOR 
		USP_RH_CAL_BORRA_MOV_CALCULO( :ls_origen, 
												:ld_fec_proceso, 
												:ls_tipo_trabaj,
												:ls_tipo_planilla ) ;
	EXECUTE USP_RH_CAL_BORRA_MOV_CALCULO ;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_RH_CAL_BORRA_MOV_CALCULO: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return 
	END IF
	
	CLOSE USP_RH_CAL_BORRA_MOV_CALCULO;
	
	//Las planillas quedan eliminadas
	commit;
	
	
	invo_Wait.of_mensaje("Procesando CALCULO DE PLANILLA")
	hpb_progreso.MAxPosition = ln_reg_tot
	
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
	
		FOR ln_reg_act = 1 TO ln_reg_tot
		
			yield()
			dw_1.ScrollToRow (ln_reg_act)
			dw_1.SelectRow (0, false)
			dw_1.SelectRow (ln_reg_act, true)
		 
			ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
			
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
					
					Rollback ;
					
					MessageBox('Error al procesar planilla de GRATIFICACION', &
								  'Error al procesar al trabajador: ' + ls_codtra &
								  + '~r~nError al llamar a procedure USP_SIGRE_RRHH.PROCESAR_GRATIF_TRIPULANTE. ' &
								  + 'Mensaje: ' + ls_mensaje, StopSign!)	
					return 
				END IF
		
			end if ;
		
			hpb_progreso.Position = ln_reg_act
			yield()
		NEXT
		
		CLOSE PKG_CALC_GRATIF_TRIP;	
		
	elseif ls_tipo_planilla = 'V' then
		
		//  --Procedimiento para Procesar Vacaciones de Tripulantes
		//  procedure PROCESAR_VACAC_TRIPULANTE (
		//    asi_codtra             in maestro.cod_trabajador%TYPE,
		//    asi_codusr             in usuario.cod_usr%TYPE,
		//    adi_fec_proceso        in date,
		//    asi_origen             in origen.cod_origen%TYPE,
		//    asi_flag_renta_quinta  in char
		//  );
		
		DECLARE PKG_CALC_VACAC_TRIP PROCEDURE FOR 
			USP_SIGRE_RRHH.PROCESAR_VACAC_TRIPULANTE(:ls_codtra,
																	:gs_user,
																	:ld_fec_proceso,
																	:ls_origen,
																	:ls_flag_renta_quinta) ;
	
		FOR ln_reg_act = 1 TO ln_reg_tot
		
			yield()
			dw_1.ScrollToRow (ln_reg_act)
			dw_1.SelectRow (0, false)
			dw_1.SelectRow (ln_reg_act, true)
		 
			ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
			
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
					Rollback ;
					MessageBox('Error al procesar planilla de VACACIONES', &
								  'Error al procesar al trabajador: ' + ls_codtra &
								  + '~r~nError al llamar a procedure USP_SIGRE_RRHH.PROCESAR_VACAC_TRIPULANTE. ' &
								  + 'Mensaje: ' + ls_mensaje, StopSign!)	
								
					return 
				END IF
		
			end if ;
		
			hpb_progreso.Position = ln_reg_act
			yield()
		NEXT
		
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
	
		FOR ln_reg_act = 1 TO ln_reg_tot
		
			yield()
			dw_1.ScrollToRow (ln_reg_act)
			dw_1.SelectRow (0, false)
			dw_1.SelectRow (ln_reg_act, true)
		 
			ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
			
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
					Rollback ;
					MessageBox('Error al procesar planilla de VACACIONES', &
								  'Error al procesar al trabajador: ' + ls_codtra &
								  + '~r~nError al llamar a procedure USP_SIGRE_RRHH.PROCESAR_CTS_TRIPULANTE. ' &
								  + 'Mensaje: ' + ls_mensaje, StopSign!)	
					return 
				END IF
		
			end if ;
		
			hpb_progreso.Position = ln_reg_act
			yield()
		NEXT
		
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
													
		FOR ln_reg_act = 1 TO ln_reg_tot
			//Tomo la hora de inicio
			select sysdate
				into :ldt_inicio
			from dual;
			
		
			yield()
			dw_1.ScrollToRow (ln_reg_act)
			dw_1.SelectRow (0, false)
			dw_1.SelectRow (ln_reg_act, true)
		 
			ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
			
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
			
			commit;
			
			//Tomo la hora de fin
			select sysdate
				into :ldt_fin
			from dual;
			
			//Obtengo el promedio de tiempo
			select (:ldt_fin - :ldt_inicio) * 24 * 60 * 60
				into :ldc_tiempo
			from dual;
			
			ldc_acum_tiempo += ldc_tiempo
			ldc_prom_tiempo = ldc_acum_tiempo / ln_reg_act
			
			//Obtengo el tiempo que queda
			ldc_time_left = (ln_reg_tot - ln_reg_act) * ldc_prom_tiempo
		
			hpb_progreso.Position = ln_reg_act
			st_3.text = 'Procesando ' + string(ln_reg_act) +  ' de ' + string (ln_reg_tot) + ' registros'
			
			st_left_time.Text = "Proceso medio: " + string(ldc_prom_tiempo, "###0.0000") + " seg."
			
			if ldc_time_left > 0 then
				//Agrego el tiempo que queda, en dias, horas, minutos y segundos
				st_left_time.Text += " - " + gnvo_app.utilitario.of_left_time_to_string(ldc_time_left)
			end if
			
			yield()
			
			
			
			
		NEXT
		
		CLOSE USP_RH_CAL_CALCULA_PLANILLA;	
	
	end if
	
	
	
	invo_Wait.of_mensaje("Generando DOCUMENTO DE PAGO DIRECTO de la PLANILLA")
	//ejecuto procesos de generacion de documentos de pago
	
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
	
	commit;
	
	invo_Wait.of_mensaje("Generando DOCUMENTO DE PAGO DIRECTO para las AFP")
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
	  from calculo c, 
			 maestro m
	 where c.cod_trabajador  = m.cod_trabajador 
		and m.cod_origen 	    = :ls_origen 		
		and m.tipo_trabajador = :ls_tipo_trabaj
		and c.tipo_planilla	 = :ls_tipo_planilla;
	
	if ll_count = 0 then
		cb_reportes.enabled = false
		gnvo_app.of_message_error("No hay registros calculados, por favor verifique antes de revisar algun reporte")
	else
		cb_reportes.enabled = true
		f_mensaje("Proceso concluido satisfactoriamente, se han generado " + string(ll_count) + " registros en planilla. Puede usar los reportes para validarlos", "")
	end if


catch ( Exception e )
	gnvo_app.of_catch_exception(e, 'Ha ocurrido una exception al procesar la planilla')
	
finally
	destroy lds_base
	invo_wait.of_close()
end try

end event

type cb_ttrab from commandbutton within w_rh411_p_calcula_planilla
integer x = 640
integer y = 152
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

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_planilla, ls_desc_tipo_planilla
Integer	li_count

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	em_origen.SetFocus()
	return
end if

ls_sql = "select tt.tipo_trabajador as tipo_trabajador, " &
		 + "tt.desc_tipo_tra as descripcion_tipo_trabajador " &
		 + "from tipo_trabajador tt, " &
		 + "     tipo_trabajador_user ttu " &
		 + "where tt.tipo_trabajador = ttu.tipo_trabajador " &
		 + "  and ttu.cod_usr        = '" + gs_user + "'" &
		 + "  and tt.flag_estado 	  = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_ttrab.text = ls_codigo
	em_desc_ttrab.text = ls_data
	
	// Si el tipo de trabajador es de tipo empleado entonces 
	// marco el flag de cierre de mes
	if ls_codigo = gnvo_app.rrhhparam.is_tipo_emp then
		cbx_cierre_mes.checked = true
	else
		cbx_cierre_mes.checked = false
	end if
	
	if gs_empresa = 'CANTABRIA' then
		cbx_renta_quinta.enabled = true
	end if
	
	if ls_codigo = gnvo_app.rrhhparam.is_tipo_tri or ls_codigo = gnvo_app.rrhhparam.is_tipo_jor then
		if ls_codigo = gnvo_app.rrhhparam.is_tipo_tri and gs_empresa = 'ARCOPA' then
			cbx_renta_quinta.checked = true
		else
			cbx_renta_quinta.checked = false
			cbx_renta_quinta.enabled = true
		end if
	else
		cbx_renta_quinta.checked = true
		cbx_renta_quinta.enabled = false
	end if
	
	//Obtengo el tipo de planilla por defecto
	parent.event ue_tipo_planilla()
	
	parent.event ue_fecha_proceso( )

end if
end event

type em_origen from editmask within w_rh411_p_calcula_planilla
integer x = 453
integer y = 60
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

parent.event ue_fecha_proceso( )

end event

type em_descripcion from editmask within w_rh411_p_calcula_planilla
integer x = 727
integer y = 60
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

type em_fec_proceso from editmask within w_rh411_p_calcula_planilla
integer x = 1710
integer y = 340
integer width = 434
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

type gb_1 from groupbox within w_rh411_p_calcula_planilla
integer y = 4
integer width = 2501
integer height = 652
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

