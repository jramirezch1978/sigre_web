$PBExportHeader$w_rh905_envio_boletas_email.srw
forward
global type w_rh905_envio_boletas_email from w_abc
end type
type st_procesando from statictext within w_rh905_envio_boletas_email
end type
type cb_filtro_trabajadores from commandbutton within w_rh905_envio_boletas_email
end type
type sle_average_record from singlelineedit within w_rh905_envio_boletas_email
end type
type st_5 from statictext within w_rh905_envio_boletas_email
end type
type sle_remaining_time from singlelineedit within w_rh905_envio_boletas_email
end type
type st_4 from statictext within w_rh905_envio_boletas_email
end type
type sle_elapsed_time from singlelineedit within w_rh905_envio_boletas_email
end type
type st_3 from statictext within w_rh905_envio_boletas_email
end type
type hpb_progreso from hprogressbar within w_rh905_envio_boletas_email
end type
type cb_enviar_email from commandbutton within w_rh905_envio_boletas_email
end type
type cb_buscar_periodo from commandbutton within w_rh905_envio_boletas_email
end type
type st_titulo1 from statictext within w_rh905_envio_boletas_email
end type
type st_titulo2 from statictext within w_rh905_envio_boletas_email
end type
type dw_listado_trabajadores from u_dw_abc within w_rh905_envio_boletas_email
end type
type dw_procesos_planilla from u_dw_abc within w_rh905_envio_boletas_email
end type
type st_2 from statictext within w_rh905_envio_boletas_email
end type
type em_year from editmask within w_rh905_envio_boletas_email
end type
type st_1 from statictext within w_rh905_envio_boletas_email
end type
type em_mes from editmask within w_rh905_envio_boletas_email
end type
end forward

global type w_rh905_envio_boletas_email from w_abc
integer width = 3671
integer height = 2748
string title = "[RH905] Envio de Boletas por Email"
string menuname = "m_abc_prc"
event ue_busqueda_periodo ( )
event ue_envio_email ( )
event ue_refresh_listado_trabajadores ( )
st_procesando st_procesando
cb_filtro_trabajadores cb_filtro_trabajadores
sle_average_record sle_average_record
st_5 st_5
sle_remaining_time sle_remaining_time
st_4 st_4
sle_elapsed_time sle_elapsed_time
st_3 st_3
hpb_progreso hpb_progreso
cb_enviar_email cb_enviar_email
cb_buscar_periodo cb_buscar_periodo
st_titulo1 st_titulo1
st_titulo2 st_titulo2
dw_listado_trabajadores dw_listado_trabajadores
dw_procesos_planilla dw_procesos_planilla
st_2 st_2
em_year em_year
st_1 st_1
em_mes em_mes
end type
global w_rh905_envio_boletas_email w_rh905_envio_boletas_email

type variables
n_cst_rrhh 			invo_rrhh
n_Cst_time			invo_time
n_cst_wait			invo_wait
n_cst_utilitario 	invo_util
end variables

event ue_busqueda_periodo();Integer li_year, li_mes

li_year = Integer(em_year.text)
li_mes = Integer(em_mes.text)

dw_procesos_planilla.retrieve(li_year, li_mes)

dw_listado_trabajadores.reset()

end event

event ue_envio_email();Long 		ll_row, ll_total_selected, ll_index
String 	ls_checked, ls_tipo_trabajador, ls_email, ls_cod_trabajador

try
	//invo_wait.of_mensaje('Procesando Cálculo de Planilla')
	
	if dw_listado_trabajadores.RowCount() = 0 then
		MessageBox('Error', 'No hay registros para procesar', StopSign!)
		return
	end if
	
	//Valido el total de registros seleccionados
	ll_total_selected = 0
	for ll_row = 1 to dw_listado_trabajadores.RowCount()
		ls_checked = dw_listado_trabajadores.object.checked [ll_row]
		if ls_checked = '1' then
			ll_total_selected ++
		end if
	next
	
	if ll_total_selected = 0 then
		MessageBox('Error', 'Debe Seleccionar al menos un registro para enviar email', StopSign!)
		return
	end if
	
	//Ahora recorro el datawindows, solo enviando los marcados
	ll_index = 0
	invo_time.Reset()
	invo_time.onStartTotalTime()
	invo_time.setTotalRecords(ll_total_selected)
	
	for ll_row = 1 to dw_listado_trabajadores.RowCount()
		ls_checked = dw_listado_trabajadores.object.checked [ll_row]
		
		if ls_checked = '1' then
			
			ll_index ++
			st_procesando.text = "Procesando " + string(ll_index) + " DE " + string(ll_total_selected)
			yield()
			
			invo_time.onStartEventTime()
			
			invo_rrhh.of_send_boleta_to_email(ll_row, dw_listado_trabajadores, dw_procesos_planilla)
			
			invo_time.onEndEventTime()
			
			hpb_progreso.Position = Integer(round(Dec(ll_index) / Dec(ll_total_selected) * 100, 0))
			yield()
			
			sle_average_record.text = String(invo_time.getAverageTime(), "###,##0.000000")
			yield()
			
			sle_remaining_time.text = String(invo_time.getRemainingTime(), "###,##0.000000")
			yield()
			
			yield()
		end if
	next
	
	invo_time.onEndTotalTime()
	
	sle_elapsed_time.text = String(invo_time.getTotalTime(), "###,##0.00")
	yield()
	
catch ( Exception e )
	gnvo_app.of_catch_exception(e, 'Ha ocurrido una exception al enviar Boletas por email')
	
finally

	invo_wait.of_close()
end try

end event

event ue_refresh_listado_trabajadores();String 	ls_filtro[]
String	ls_checked, ls_origen, ls_tipo_trabajador, ls_tipo_planilla, ls_fec_proceso
Date		ld_fec_proceso
Long		ll_row, ll_index

dw_procesos_planilla.AcceptText()

if dw_procesos_planilla.RowCount() = 0 then
	return
end if

ll_index = 1

for ll_row = 1 to dw_procesos_planilla.RowCount()
	ls_checked = dw_procesos_planilla.object.checked [ll_row]
	if ls_checked = '1' then
		
		ls_origen 				= dw_procesos_planilla.object.cod_origen 			[ll_row]
		ls_tipo_trabajador 	= dw_procesos_planilla.object.tipo_trabajador 	[ll_row]
		ls_tipo_planilla 		= dw_procesos_planilla.object.tipo_planilla 		[ll_row]
		ld_fec_proceso 		= Date(dw_procesos_planilla.object.fec_proceso 	[ll_row])
		
		ls_fec_proceso = String(ld_fec_proceso, "dd/mm/yyyy")
		
		/*
			select distinct
					 case
						when m.email is not null then
						  '1'
						else
						  '0'
					 end as checked,
					 m.COD_TRABAJADOR,
					 m.NOM_TRABAJADOR,
					 m.TIPO_DOC_IDENT_RTPS,
					 m.NRO_DOC_IDENT_RTPS,
					 m.EMAIL
			  from historico_calculo hc,
					 vw_pr_trabajador  m
			 where hc.cod_trabajador = m.COD_TRABAJADOR
				and trim(hc.cod_origen)  || '|'  || to_char(hc.fec_calc_plan, 'dd/mm/yyyy') || '|' || hc.tipo_trabajador || '|' || 
					 hc.tipo_planilla in ('CH|15/12/2023|EMP|N')
		*/
		
		ls_filtro [ll_index] = trim(ls_origen) + '|' + ls_fec_proceso + '|' + trim(ls_tipo_trabajador) + '|' + trim(ls_tipo_planilla)
		
		ll_index ++
		
	end if
next

if UpperBound(ls_filtro) > 0 then
	
	dw_listado_trabajadores.Retrieve(ls_filtro)
end if
end event

on w_rh905_envio_boletas_email.create
int iCurrent
call super::create
if this.MenuName = "m_abc_prc" then this.MenuID = create m_abc_prc
this.st_procesando=create st_procesando
this.cb_filtro_trabajadores=create cb_filtro_trabajadores
this.sle_average_record=create sle_average_record
this.st_5=create st_5
this.sle_remaining_time=create sle_remaining_time
this.st_4=create st_4
this.sle_elapsed_time=create sle_elapsed_time
this.st_3=create st_3
this.hpb_progreso=create hpb_progreso
this.cb_enviar_email=create cb_enviar_email
this.cb_buscar_periodo=create cb_buscar_periodo
this.st_titulo1=create st_titulo1
this.st_titulo2=create st_titulo2
this.dw_listado_trabajadores=create dw_listado_trabajadores
this.dw_procesos_planilla=create dw_procesos_planilla
this.st_2=create st_2
this.em_year=create em_year
this.st_1=create st_1
this.em_mes=create em_mes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_procesando
this.Control[iCurrent+2]=this.cb_filtro_trabajadores
this.Control[iCurrent+3]=this.sle_average_record
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.sle_remaining_time
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_elapsed_time
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.hpb_progreso
this.Control[iCurrent+10]=this.cb_enviar_email
this.Control[iCurrent+11]=this.cb_buscar_periodo
this.Control[iCurrent+12]=this.st_titulo1
this.Control[iCurrent+13]=this.st_titulo2
this.Control[iCurrent+14]=this.dw_listado_trabajadores
this.Control[iCurrent+15]=this.dw_procesos_planilla
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.em_year
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.em_mes
end on

on w_rh905_envio_boletas_email.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_procesando)
destroy(this.cb_filtro_trabajadores)
destroy(this.sle_average_record)
destroy(this.st_5)
destroy(this.sle_remaining_time)
destroy(this.st_4)
destroy(this.sle_elapsed_time)
destroy(this.st_3)
destroy(this.hpb_progreso)
destroy(this.cb_enviar_email)
destroy(this.cb_buscar_periodo)
destroy(this.st_titulo1)
destroy(this.st_titulo2)
destroy(this.dw_listado_trabajadores)
destroy(this.dw_procesos_planilla)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.em_mes)
end on

event ue_open_pre;call super::ue_open_pre;Integer 	li_year, li_mes
DateTime ldt_hoy

ldt_hoy = gnvo_app.of_fecha_Actual()

li_year 	= year(Date(ldt_hoy))
li_mes	= month(date(ldt_hoy))

em_year.text = string(li_year)
em_mes.text = string(li_mes)
end event

event resize;call super::resize;dw_procesos_planilla.width  = newwidth  - dw_procesos_planilla.x - 10
st_titulo1.width				 = dw_procesos_planilla.width

hpb_progreso.width  = newwidth  - hpb_progreso.x - 10

dw_listado_trabajadores.width  = newwidth  - dw_listado_trabajadores.x - 10
dw_listado_trabajadores.height = newheight - dw_listado_trabajadores.y - 10
st_titulo2.width					 = dw_listado_trabajadores.width
end event

event open;call super::open;invo_rrhh = create n_cst_rrhh
invo_wait = create n_cst_wait

invo_rrhh.load_param()
end event

event close;call super::close;destroy invo_rrhh
destroy invo_wait
end event

type st_procesando from statictext within w_rh905_envio_boletas_email
integer y = 816
integer width = 608
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_filtro_trabajadores from commandbutton within w_rh905_envio_boletas_email
integer x = 64
integer y = 372
integer width = 800
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Filtro Trabajadores"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_refresh_listado_trabajadores()

hpb_progreso.Position = 0

sle_elapsed_time.text = "0.00"
sle_remaining_time.text = "0.00"
sle_average_record.text = "0.00"

if dw_listado_trabajadores.RowCount() > 0 then
	cb_enviar_email.enabled = true
else
	cb_enviar_email.enabled = false
end if

setPointer(Arrow!)
end event

type sle_average_record from singlelineedit within w_rh905_envio_boletas_email
integer x = 3223
integer y = 812
integer width = 343
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0.00"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type st_5 from statictext within w_rh905_envio_boletas_email
integer x = 2597
integer y = 820
integer width = 608
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Promedio x Registro (seg) :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_remaining_time from singlelineedit within w_rh905_envio_boletas_email
integer x = 2235
integer y = 812
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0.00"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type st_4 from statictext within w_rh905_envio_boletas_email
integer x = 1682
integer y = 820
integer width = 535
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tiempo Restante (seg) :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_elapsed_time from singlelineedit within w_rh905_envio_boletas_email
integer x = 1321
integer y = 812
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "0.00"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type st_3 from statictext within w_rh905_envio_boletas_email
integer x = 695
integer y = 820
integer width = 608
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tiempo Transcurrido (seg):"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_rh905_envio_boletas_email
integer y = 736
integer width = 3579
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 5
end type

type cb_enviar_email from commandbutton within w_rh905_envio_boletas_email
event ue_refresh_listado_trabajadores ( )
integer x = 64
integer y = 488
integer width = 800
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Enviar por Email"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_envio_email()

parent.event ue_refresh_listado_trabajadores()
setPointer(Arrow!)
end event

type cb_buscar_periodo from commandbutton within w_rh905_envio_boletas_email
integer x = 64
integer y = 256
integer width = 800
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar por periodo"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_busqueda_periodo()

hpb_progreso.Position = 0

sle_elapsed_time.text = "0.00"
sle_remaining_time.text = "0.00"
sle_average_record.text = "0.00"

if dw_procesos_planilla.RowCount() > 0 then
	cb_filtro_trabajadores.enabled = true
else
	cb_filtro_trabajadores.enabled = false
end if

cb_enviar_email.enabled = false



setPointer(Arrow!)
end event

type st_titulo1 from statictext within w_rh905_envio_boletas_email
integer x = 923
integer width = 2670
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Procesos de Planilla CERRADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_titulo2 from statictext within w_rh905_envio_boletas_email
integer x = 9
integer y = 900
integer width = 3616
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Listado de Trabajadores"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_listado_trabajadores from u_dw_abc within w_rh905_envio_boletas_email
integer x = 9
integer y = 984
integer width = 3616
integer height = 1500
string dataobject = "d_lista_trabajadores_envio_email_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_procesos_planilla from u_dw_abc within w_rh905_envio_boletas_email
integer x = 923
integer y = 84
integer width = 2670
integer height = 644
integer taborder = 20
string dataobject = "d_lista_procesos_planilla_cerrados_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type st_2 from statictext within w_rh905_envio_boletas_email
integer x = 14
integer y = 48
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_rh905_envio_boletas_email
integer x = 485
integer y = 36
integer width = 347
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type st_1 from statictext within w_rh905_envio_boletas_email
integer x = 18
integer y = 156
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes from editmask within w_rh905_envio_boletas_email
integer x = 485
integer y = 144
integer width = 347
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~12"
end type

