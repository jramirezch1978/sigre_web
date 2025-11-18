$PBExportHeader$w_procesar_vacaciones.srw
forward
global type w_procesar_vacaciones from w_abc
end type
type st_year from statictext within w_procesar_vacaciones
end type
type st_4 from statictext within w_procesar_vacaciones
end type
type hpb_progreso from hprogressbar within w_procesar_vacaciones
end type
type ddlb_mes from dropdownlistbox within w_procesar_vacaciones
end type
type em_fec_inicio from editmask within w_procesar_vacaciones
end type
type st_3 from statictext within w_procesar_vacaciones
end type
type st_2 from statictext within w_procesar_vacaciones
end type
type em_fec_proceso from editmask within w_procesar_vacaciones
end type
type st_1 from statictext within w_procesar_vacaciones
end type
type cb_cancelar from commandbutton within w_procesar_vacaciones
end type
type cb_procesar from commandbutton within w_procesar_vacaciones
end type
type gb_1 from groupbox within w_procesar_vacaciones
end type
end forward

global type w_procesar_vacaciones from w_abc
integer width = 1815
integer height = 668
string title = "Procesar Vacaciones ..."
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_procesar ( )
st_year st_year
st_4 st_4
hpb_progreso hpb_progreso
ddlb_mes ddlb_mes
em_fec_inicio em_fec_inicio
st_3 st_3
st_2 st_2
em_fec_proceso em_fec_proceso
st_1 st_1
cb_cancelar cb_cancelar
cb_procesar cb_procesar
gb_1 gb_1
end type
global w_procesar_vacaciones w_procesar_vacaciones

type variables
datawindow 	idw_datos
Long			il_registros, il_year
end variables

event ue_procesar();str_parametros lstr_param
Long		ll_i, ll_count
String	ls_cod_trabajador, ls_cnc_vacaciones, ls_mensaje
Integer	li_dias_vacaciones, li_dias_pendientes, li_mes, li_dias_laborados, li_year
Decimal	ldc_importe, ldc_fijo, ldc_variable
date		ld_fec_proceso, ld_fec_inicio, ld_fec_hasta

try 
	//Obtengo el concepto de vacaciones
	ls_cnc_vacaciones = gnvo_app.of_get_parametro( "CONCEPTO_VACACIONES", "1463")
	em_fec_proceso.getdata( ld_fec_proceso )
	em_fec_inicio.getdata(ld_fec_inicio)
	li_mes = Integer(left(ddlb_mes.text,2))
	li_year = Integer(st_year.text)
	
	for ll_i = 1 to idw_datos.RowCount()
		//Le doy al procesador tiempo para dibujar
		yield()
		
		//si esta seleccionado proceso
		if idw_datos.object.checked[ll_i] = '1' then
	
			
			//Incremento el contador de registros seleccionados
			ll_count ++
			
			//Acualizo la barra de progreso
			hpb_progreso.Position = ll_count / il_registros * 100
			
			//Obtengo los datos que necesito
			ls_cod_trabajador 	= idw_datos.object.cod_trabajador [ll_i]
			li_dias_vacaciones 	= Integer(idw_datos.object.dias_vacaciones [ll_i])
			li_dias_pendientes 	= Integer(idw_datos.object.dias_pendientes [ll_i])
			li_dias_laborados		= Integer(idw_datos.object.dias_trabajados [ll_i])
			ldc_importe				= Dec(idw_datos.object.suma_importe[ll_i])
			
			//Sumo la parte fija
			select NVL(sum(decode(flag_fijo_variable, 'F', importe, 0)), 0),
					 NVL(sum(decode(flag_fijo_variable, 'V', importe, 0)), 0)
			  into :ldc_fijo, :ldc_variable
			  from TT_RRHH_VACACIONES_TRAB
			 where cod_trabajador = :ls_cod_trabajador;
			
			//Insertando la cabecera de las vacaciones
			select count(*)
				into :ll_count
			from RRHH_VACACIONES_TRABAJ
			where cod_trabajador = :ls_cod_trabajador
			  and periodo_inicio	= :il_year
			  and concep			= :ls_cnc_vacaciones;
			
			if ll_count = 0 then
				insert into RRHH_VACACIONES_TRABAJ(
					cod_trabajador, periodo_inicio, periodo_fin, dias_totales, dias_gozados,
					flag_estado, concep, cod_usr, item_laboral)
				values(
					:ls_cod_trabajador, :il_year, :il_year, :li_dias_vacaciones, :li_dias_pendientes,
					'1', :ls_cnc_vacaciones, :gs_user, 1);
				
				if gnvo_app.of_existserror( SQLCA, "Error al procesar trabajador " + ls_cod_trabajador + ". Tabla RRHH_VACACIONES_TRABAJ") then
					ROLLBACK;
					return
				end if
			end if
			
			//Ahora el detalle
			ld_fec_hasta = RelativeDate(ld_fec_inicio, li_dias_pendientes - 1)
			
			insert into inasistencia(
				cod_trabajador, concep, fec_movim, fec_desde, fec_hasta, dias_inasist,
				cod_usr, periodo_inicio, cod_suspension_lab, mes_periodo, 
				flag_vacac_adelantadas, importe)
			values(
				:ls_cod_trabajador, :ls_cnc_vacaciones, :ld_fec_proceso, :ld_fec_inicio, :ld_fec_hasta, :li_dias_pendientes,
				:gs_user, :il_year, '23', :li_mes,
				'0', :ldc_importe);

			if gnvo_app.of_existserror( SQLCA, "Error al procesar trabajador: " + ls_cod_trabajador + ". Tabla inasistencia") then
				ROLLBACK;
				return
			end if
			
			//Ahora inserto en la glosa del calculo para la boleta
			//Item 1: total Remuneracion Fija
			insert into GLOSA_VACACIONES(
				cod_trabajador, item, fec_proceso, glosa, cantidad, cod_usr)
			values(
				:ls_cod_trabajador, 1, :ld_fec_proceso, 'Total Remuneracion Fija', :ldc_fijo, :gs_user);
				
			if gnvo_app.of_existserror( SQLCA, "Error al insertar item 1 en Código de Trabajador: " + ls_cod_trabajador + ". Tabla GLOSA_VACACIONES") then
				ROLLBACK;
				return
			end if				
			
			//Item 2: total Remuneracion Variable
			insert into GLOSA_VACACIONES(
				cod_trabajador, item, fec_proceso, glosa, cantidad, cod_usr)
			values(
				:ls_cod_trabajador, 2, :ld_fec_proceso, 'Total Remuneracion Variable', :ldc_variable, :gs_user);
				
			if gnvo_app.of_existserror( SQLCA, "Error al insertar item 2 en Código de Trabajador: " + ls_cod_trabajador + ". Tabla GLOSA_VACACIONES") then
				ROLLBACK;
				return
			end if		
			
			//Item 3: total Días Laborados
			ls_mensaje = 'Total Días Laborados (ENE-DIC del ' + string(li_year) + ')'
			
			insert into GLOSA_VACACIONES(
				cod_trabajador, item, fec_proceso, glosa, cantidad, cod_usr)
			values(
				:ls_cod_trabajador, 3, :ld_fec_proceso, :ls_mensaje, :li_dias_laborados, :gs_user);
				
			if gnvo_app.of_existserror( SQLCA, "Error al insertar item 3 en Código de Trabajador: " + ls_cod_trabajador + ". Tabla GLOSA_VACACIONES") then
				ROLLBACK;
				return
			end if			

			//Item 4: Días Vacaciones
			insert into GLOSA_VACACIONES(
				cod_trabajador, item, fec_proceso, glosa, cantidad, cod_usr)
			values(
				:ls_cod_trabajador, 4, :ld_fec_proceso, 'Días Vacaciones', :li_dias_vacaciones, :gs_user);
				
			if gnvo_app.of_existserror( SQLCA, "Error al insertar item 4 en Código de Trabajador: " + ls_cod_trabajador + ". Tabla GLOSA_VACACIONES") then
				ROLLBACK;
				return
			end if	
			
			
			//Proceso para darle tiempo a que dibuje
			yield()
			
		end if
	next
	
	//Aplico todos los cambios
	commit;


	lstr_param.b_return = true
	
	CloseWithReturn(this, lstr_param)
	
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Exception al procesar vacaciones")
	
finally
	/*statementBlock*/
end try

end event

on w_procesar_vacaciones.create
int iCurrent
call super::create
this.st_year=create st_year
this.st_4=create st_4
this.hpb_progreso=create hpb_progreso
this.ddlb_mes=create ddlb_mes
this.em_fec_inicio=create em_fec_inicio
this.st_3=create st_3
this.st_2=create st_2
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_procesar=create cb_procesar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_year
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.hpb_progreso
this.Control[iCurrent+4]=this.ddlb_mes
this.Control[iCurrent+5]=this.em_fec_inicio
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_fec_proceso
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_cancelar
this.Control[iCurrent+11]=this.cb_procesar
this.Control[iCurrent+12]=this.gb_1
end on

on w_procesar_vacaciones.destroy
call super::destroy
destroy(this.st_year)
destroy(this.st_4)
destroy(this.hpb_progreso)
destroy(this.ddlb_mes)
destroy(this.em_fec_inicio)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_procesar)
destroy(this.gb_1)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;//Valido recibir algun parametros
str_parametros lstr_param
Date				ld_fec_proceso

if Isnull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then
	gnvo_app.of_mensaje_error("No ha enviado ningun parametros a estar ventana, por favor verifique!")
	this.post event closequery()
	return
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	gnvo_app.of_mensaje_error("El parametro recibido no es del tipo STR_PARAMETROS, por favor verifique!")
	this.post event closequery()
	return
end if

lstr_param = Message.PowerObjectParm

//ahora rescato los datos enviados
il_registros 	= lstr_param.long2
il_year 			= lstr_param.long1
idw_datos		= lstr_param.dw_1

//Creo la fecha de proceso en el año y lleno los datos por defecto
ld_fec_proceso = date('01/01/' + string(il_year + 1, '0000'))

em_fec_proceso.text 	= string(ld_fec_proceso, 'dd/mm/yyyy')
em_fec_inicio.text 	= string(ld_fec_proceso, 'dd/mm/yyyy')
ddlb_mes.text			= '01. Enero'
st_year.text			= string(il_year)
end event

type st_year from statictext within w_procesar_vacaciones
integer x = 535
integer y = 52
integer width = 713
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_procesar_vacaciones
integer x = 105
integer y = 52
integer width = 402
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_procesar_vacaciones
boolean visible = false
integer x = 37
integer y = 484
integer width = 1710
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
boolean smoothscroll = true
end type

type ddlb_mes from dropdownlistbox within w_procesar_vacaciones
integer x = 535
integer y = 376
integer width = 718
integer height = 416
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"01. Enero","02. Febrero","03. Marzo","04. Abril","05. Mayo","06. Junio","07. Julio","08. Agosto","09. Setiembre","10. Octubre","11. Noviembre","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type em_fec_inicio from editmask within w_procesar_vacaciones
integer x = 535
integer y = 268
integer width = 713
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_3 from statictext within w_procesar_vacaciones
integer x = 110
integer y = 268
integer width = 402
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Inicio : "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_procesar_vacaciones
integer x = 110
integer y = 376
integer width = 402
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fec_proceso from editmask within w_procesar_vacaciones
integer x = 535
integer y = 160
integer width = 713
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_procesar_vacaciones
integer x = 110
integer y = 160
integer width = 407
integer height = 92
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha proceso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_procesar_vacaciones
integer x = 1312
integer y = 180
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_procesar from commandbutton within w_procesar_vacaciones
integer x = 1312
integer y = 64
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
boolean default = true
end type

event clicked;parent.event ue_procesar()
end event

type gb_1 from groupbox within w_procesar_vacaciones
integer width = 1783
integer height = 576
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

