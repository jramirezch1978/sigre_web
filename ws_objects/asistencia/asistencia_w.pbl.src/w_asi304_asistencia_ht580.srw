$PBExportHeader$w_asi304_asistencia_ht580.srw
forward
global type w_asi304_asistencia_ht580 from w_abc_master_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_asi304_asistencia_ht580
end type
type pb_1 from picturebutton within w_asi304_asistencia_ht580
end type
type sle_codigo from singlelineedit within w_asi304_asistencia_ht580
end type
type sle_nombre from singlelineedit within w_asi304_asistencia_ht580
end type
type cbx_todos from checkbox within w_asi304_asistencia_ht580
end type
type sle_area from singlelineedit within w_asi304_asistencia_ht580
end type
type sle_desc_area from singlelineedit within w_asi304_asistencia_ht580
end type
type sle_seccion from singlelineedit within w_asi304_asistencia_ht580
end type
type sle_desc_seccion from singlelineedit within w_asi304_asistencia_ht580
end type
type st_3 from statictext within w_asi304_asistencia_ht580
end type
type em_horas from editmask within w_asi304_asistencia_ht580
end type
type cb_procesar from commandbutton within w_asi304_asistencia_ht580
end type
type cbx_1 from checkbox within w_asi304_asistencia_ht580
end type
type st_1 from statictext within w_asi304_asistencia_ht580
end type
type st_2 from statictext within w_asi304_asistencia_ht580
end type
type hpb_1 from hprogressbar within w_asi304_asistencia_ht580
end type
type st_4 from statictext within w_asi304_asistencia_ht580
end type
type cb_1 from commandbutton within w_asi304_asistencia_ht580
end type
type gb_1 from groupbox within w_asi304_asistencia_ht580
end type
type gb_4 from groupbox within w_asi304_asistencia_ht580
end type
end forward

global type w_asi304_asistencia_ht580 from w_abc_master_smpl
integer width = 3136
integer height = 2192
string title = "[ASI304] Modificación de Asistencia de Personal HT580"
string menuname = "m_abc_master_smpl"
event ue_procesar ( )
event ue_adicionar_trabaj ( )
uo_fechas uo_fechas
pb_1 pb_1
sle_codigo sle_codigo
sle_nombre sle_nombre
cbx_todos cbx_todos
sle_area sle_area
sle_desc_area sle_desc_area
sle_seccion sle_seccion
sle_desc_seccion sle_desc_seccion
st_3 st_3
em_horas em_horas
cb_procesar cb_procesar
cbx_1 cbx_1
st_1 st_1
st_2 st_2
hpb_1 hpb_1
st_4 st_4
cb_1 cb_1
gb_1 gb_1
gb_4 gb_4
end type
global w_asi304_asistencia_ht580 w_asi304_asistencia_ht580

event ue_procesar();Long 		ll_row
DateTime	ldt_ingreso, ldt_salida
Integer	li_count, li_segundos_ant, li_segundos
String	ls_codigo, ls_mensaje, ls_reckey
decimal 	ldc_horas
Long		ll_ult_nro
boolean	lb_new

if dw_master.RowCount() = 0 then
	return
end if

//Obtengo las Horas
em_horas.getdata( ldc_horas )

//Ordeno el datawindows
dw_master.Sort()

hpb_1.Position = 0
st_4.Text = '0 de ' + string(dw_master.RowCount())
st_4.visible = true
hpb_1.Visible = true
yield()

dw_master.setSort("dni A, fec_movimiento A, flag_in_out A")
dw_master.Sort( )

li_segundos_ant = -1

for ll_row = 1 to dw_master.RowCount()
	hpb_1.Position = ll_row / dw_master.RowCount() * 100
	st_4.Text = string(ll_row) + ' de ' + string(dw_master.RowCount())
	yield()
	
	//Proceso unicamente si es un ingreso
	if dw_master.object.flag_in_out [ll_row] = '1' then
		
		//Obtengo la fecha de ingreso
		ldt_ingreso = DateTime(dw_master.object.fec_movimiento [ll_row])
		ls_codigo	= dw_master.object.codigo [ll_Row]
		
		//Aleatorio de los segundos de salida
		do
			li_segundos = Rand(30 * 60)
			yield()
		loop until li_segundos <> li_segundos_ant

		
		//Obtengo la fecha y hora de salida
		select :ldt_ingreso + :ldc_horas/24 + :li_segundos / (24 * 3600)
			into :ldt_salida
		from dual;
		
   	lb_new = false;
		if ll_row < dw_master.RowCount() then
			if dw_master.object.flag_in_out[ll_row + 1] = '2' and dw_master.object.codigo [ll_row + 1] = ls_codigo then
			
				dw_master.object.fec_movimiento [ll_row + 1] = ldt_salida
				dw_master.SelectRow(0, false)
				dw_master.SelectRow(ll_row + 1, true)
				dw_master.ScrollToRow(ll_row + 1)
				dw_master.ii_update = 1
			else
				lb_new = true
			end if
		else
			lb_new = true
		end if
			
		if lb_new then
			
			//Valido que el registro no exista en la base de datos
			select count(*)
				into :li_count
			from asistencia_ht580
			where COD_ORIGEN = :gs_origen
			  and CODIGO	  = :ls_codigo
			  and FLAG_IN_OUT = '2'
			  and FEC_MOVIMIENTO = :ldt_salida;
			
			//Inserto en la tabla
			if li_count = 0 then

				//hay que generar un nuevo registro de autocompletado
				select count(*)
					into :li_count
					from num_asistencia_ht580
				where cod_origen = :gs_origen;
				
				if li_count = 0 then
					insert into num_asistencia_ht580(cod_origen, ult_nro)
					values(:gs_origen, 1);
					
					if SQLCA.SQLCode < 0 then
						ls_mensaje = SQLCA.SQLErrtext
						ROLLBACK;
						MessageBox("Error al insertar", "Ha ocurrido un error al insertar en num_asistencia_ht580, Mensaje: " + ls_mensaje, StopSign!)
						return
					end if
				end if
				
				//Obtengo el numerador
				select ult_nro
					into :ll_ult_nro
				from num_asistencia_ht580
				where cod_origen = :gs_origen for update;
				
				ls_reckey = trim(gs_origen) + trim(string(ll_ult_nro, '00000000'))
			
				insert into ASISTENCIA_HT580(
					RECKEY, COD_ORIGEN, CODIGO, FLAG_IN_OUT, FEC_REGISTRO, FEC_MOVIMIENTO, COD_USR)
				values(
					:ls_reckey, :gs_origen, :ls_codigo, '2', sysdate, :ldt_salida, :gs_user);
					
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox("Error al insertar", "Ha ocurrido un error al insertar en ASISTENCIA_HT580, Mensaje: " + ls_mensaje, StopSign!)
					return

				end if
				
				//ACtualizo el contador
				update num_asistencia_ht580
					set ult_nro = :ll_ult_nro + 1
				where cod_origen = :gs_origen;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrtext
					ROLLBACK;
					MessageBox("Error al actualizar", "Ha ocurrido un error al actualizar en num_asistencia_ht580, Mensaje: " + ls_mensaje, StopSign!)
					return
				end if
				
			end if
			
		end if
		
		li_segundos_ant = li_segundos
		
	end if
	
next

hpb_1.Visible = false
st_4.visible = false

dw_master.setSort("nombre A, fec_movimiento A, flag_in_out A")
dw_master.Sort( )

commit;


MessageBox("Aviso", "Proceso de ajuste realizado satisfactoriamente, por favor grabe para que los cambios se guarden", Information!)
end event

event ue_adicionar_trabaj();Date 		ld_fecha1, ld_fecha2
String	ls_mensaje

ld_Fecha1 = uo_fechas.of_get_fecha1()
ld_Fecha2 = uo_fechas.of_get_fecha2()

if ld_Fecha1 <> ld_Fecha2 then
	MessageBox('Error', 'Esta opcion solo esta disponible para rangos de la misma fecha de inicio y termino', StopSign!)
	return
end if

if MessageBox('Aviso', 'Desea añadir el resto de trabajadores que no hayan marcado y que esten activos en el maestro de trabajadore?', Information!, YesNo!, 2) = 2 then return

insert into asistencia_ht580(
       cod_origen, codigo, flag_in_out, fec_registro, fec_movimiento, cod_usr, direccion_ip, flag_verify_type, turno)
select t.COD_ORIGEN, t.COD_TRABAJADOR, 'I', sysdate, :ld_fecha1, :gs_user, null,  '0', t.turno
  from vw_pr_trabajador t
where t.turno is not null
  and t.COD_TRABAJADOR in (select m.cod_trabajador 
                              from maestro m
                             where m.flag_estado = '1'
                               and m.flag_cal_plnlla = '1'
                            minus
                            select distinct t.codigo
                            from asistencia_ht580 t
                            where trunc(t.fec_movimiento) = :ld_fecha1);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MEssageBox('Error', 'Error al momento de insertar en asitencia_ht580. Mensaje: ' + ls_mensaje, StopSign!)
	return
end if

commit;

this.event Dynamic ue_retrieve()

end event

on w_asi304_asistencia_ht580.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_fechas=create uo_fechas
this.pb_1=create pb_1
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.cbx_todos=create cbx_todos
this.sle_area=create sle_area
this.sle_desc_area=create sle_desc_area
this.sle_seccion=create sle_seccion
this.sle_desc_seccion=create sle_desc_seccion
this.st_3=create st_3
this.em_horas=create em_horas
this.cb_procesar=create cb_procesar
this.cbx_1=create cbx_1
this.st_1=create st_1
this.st_2=create st_2
this.hpb_1=create hpb_1
this.st_4=create st_4
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.cbx_todos
this.Control[iCurrent+6]=this.sle_area
this.Control[iCurrent+7]=this.sle_desc_area
this.Control[iCurrent+8]=this.sle_seccion
this.Control[iCurrent+9]=this.sle_desc_seccion
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.em_horas
this.Control[iCurrent+12]=this.cb_procesar
this.Control[iCurrent+13]=this.cbx_1
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.hpb_1
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_4
end on

on w_asi304_asistencia_ht580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.pb_1)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.cbx_todos)
destroy(this.sle_area)
destroy(this.sle_desc_area)
destroy(this.sle_seccion)
destroy(this.sle_desc_seccion)
destroy(this.st_3)
destroy(this.em_horas)
destroy(this.cb_procesar)
destroy(this.cbx_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.hpb_1)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_4)
end on

event ue_retrieve;Date	 	ld_fecha_inicio,ld_fecha_final	
string	ls_area, ls_seccion, ls_codigo

ld_fecha_inicio = uo_fechas.of_get_fecha1()
ld_fecha_final  = uo_fechas.of_get_fecha2()

if cbx_1.checked then
	ls_area = '%%'
	ls_seccion = '%%'
else
	
	if trim(sle_area.text) = '' then
		gnvo_app.of_mensaje_Error("Debe indicar el area, por favor verifique!")
		sle_area.setFocus()
		return
	end if

	if trim(sle_seccion.text) = '' then
		gnvo_app.of_mensaje_Error("Debe indicar la seccion, por favor verifique!")
		sle_seccion.setFocus()
		return
	end if
	
 	ls_area 		= trim(sle_area.text) + '%'
	ls_seccion 	= trim(sle_seccion.text) + '%'
	
end if

//Codigo de Trabajador
if cbx_todos.checked then
	ls_codigo = '%%'
else
	if trim(sle_codigo.text) = '' then
		gnvo_app.of_mensaje_Error("Debe indicar el código de Trabajador, por favor verifique!")
		sle_codigo.setFocus()
		return
	end if
	
 	ls_codigo 		= trim(sle_codigo.text) + '%'
	
end if

	
idw_1.Retrieve(ld_fecha_inicio,ld_fecha_final, ls_area, ls_seccion, ls_codigo)

if idw_1.RowCount() > 0 then
	cb_procesar.enabled = true
	em_horas.enabled = true
	em_horas.text = "8.00"
else
	cb_procesar.enabled = false
	em_horas.enabled = false
	em_horas.text = "0.00"
end if

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

type dw_master from w_abc_master_smpl`dw_master within w_asi304_asistencia_ht580
integer y = 484
integer width = 2702
integer height = 1280
string dataobject = "d_abc_asistencia_ht580_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.fec_movimiento	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_origen 		[al_row] = gs_origen
this.object.cod_usr 			[al_row] = gs_user
this.object.direccion_ip	[al_row] = left(gs_estacion, 20)

end event

event dw_master::ue_display;call super::ue_display;string 	ls_sql, ls_return1, ls_return2, ls_ot_adm, ls_nro_ot, ls_return3
DATE   	ld_fec_desde, ld_fec_hasta, ld_null
INTEGER 	ld_dias

if dw_master.ii_protect = 1 then return

choose case lower(as_columna)

	case 'cod_trabajador'
		ls_sql = "select m.cod_trabajador as codigo_trabajador, " &
				 + "m.nom_trabajador as nom_trabajador, " &
				 + "m.tipo_trabajador as tipo_trabajador, " &
				 + "m.nro_doc_ident_rtps as nro_dni " &
				 + "from vw_pr_trabajador m " &
				 + "where m.flag_estado = '1' "
				 
		
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, ls_return3, '2') then return
		
		this.object.cod_trabajador		[al_row] = ls_return1
		this.object.nom_trabajador		[al_row] = ls_return2
		this.object.tipo_trabajador	[al_row] = ls_return3
		
		ii_update = 1
		return 

	case 'turno'
		ls_sql = "SELECT turno as Codigo, " &
				 + "descripcion as descripcion " &
				 + "FROM turno " &
			  	 + "WHERE flag_estado = '1'"
					
		if not gnvo_app.of_lista(ls_sql, ls_return1, ls_return2, '2') then return
		
		this.object.turno			[al_row] = ls_return1
		ii_update = 1
		return 
		
end choose

end event

type uo_fechas from u_ingreso_rango_fechas within w_asi304_asistencia_ht580
integer x = 55
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_asi304_asistencia_ht580
integer x = 2025
integer y = 36
integer width = 402
integer height = 224
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_codigo from singlelineedit within w_asi304_asistencia_ht580
event dobleclick pbm_lbuttondblclk
integer x = 613
integer y = 384
integer width = 279
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_area, ls_seccion

ls_area = trim(sle_area.text) 
ls_seccion = trim(sle_seccion.text) 

ls_sql = "SELECT distinct m.cod_trabajador AS codigo_trabajador, " &
		  + "m.nom_trabajador AS nombre_trabajador " &
		  + "FROM vw_pr_trabajador m " &
		  + "WHERE m.cod_area = '" + ls_area + "'" &
		  + "  and m.cod_seccion = '" + ls_seccion + "'" &
		  + "  and m.flag_estado = '1'" 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_codigo.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

type sle_nombre from singlelineedit within w_asi304_asistencia_ht580
integer x = 901
integer y = 384
integer width = 1344
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
borderstyle borderstyle = stylelowered!
end type

type cbx_todos from checkbox within w_asi304_asistencia_ht580
integer x = 37
integer y = 384
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos los trabajadores"
boolean checked = true
end type

event clicked;if this.checked then
	sle_codigo.enabled = false
else
	sle_codigo.enabled = true
end if
end event

type sle_area from singlelineedit within w_asi304_asistencia_ht580
event dobleclick pbm_lbuttondblclk
integer x = 343
integer y = 208
integer width = 279
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_area, ls_seccion

ls_area = trim(sle_area.text) 
ls_seccion = trim(sle_seccion.text) 

ls_sql = "SELECT m.cod_area AS codigo_area, " &
		  + "m.desc_area AS descripcion_area " &
		  + "FROM area m " &
		  + "WHERE m.flag_estado = '1'" 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_area.text = ls_codigo
	sle_desc_area.text = ls_data
	
	sle_seccion.enabled = true
end if
end event

event modified;string ls_desc_area, ls_area

ls_area = trim(this.text)

if ls_area = '' then
	gnvo_app.of_message_error( "Debe elegir un area")
	sle_seccion.enabled = false
	This.text = gnvo_app.is_null
	sle_Desc_area.text = gnvo_app.is_null
	return
end if

SELECT desc_area
	INTO :ls_desc_area
FROM area
WHERE cod_area = :ls_area
  and flag_estado = '1';
					 

IF SQLCA.SQLCode = 100 THEN
	gnvo_app.of_mensaje_error('Código de área No Existe , Verifique!')
	This.text = gnvo_app.is_null
	sle_Desc_area.text = gnvo_app.is_null
	Return 
END IF

sle_desc_area.text = ls_desc_area
end event

type sle_desc_area from singlelineedit within w_asi304_asistencia_ht580
integer x = 631
integer y = 208
integer width = 846
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_seccion from singlelineedit within w_asi304_asistencia_ht580
event dobleclick pbm_lbuttondblclk
integer x = 343
integer y = 284
integer width = 279
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_area

ls_area = trim(sle_area.text) 

ls_sql = "SELECT m.cod_seccion AS codigo_Seccion, " &
		  + "m.desc_seccion AS descripcion_seccion " &
		  + "FROM seccion m " &
		  + "WHERE m.cod_area = '" + ls_area + "'" &
		  + "  and m.flag_estado = '1'" 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_seccion.text = ls_codigo
	sle_desc_seccion.text = ls_data
	
end if
end event

event modified;string ls_desc_seccion, ls_area, ls_seccion

ls_area = trim(sle_area.text)

if ls_area = '' then
	gnvo_app.of_message_error( "Debe primero elegir un area")
	this.enabled = false
	This.text = gnvo_app.is_null
	sle_Desc_seccion.text = gnvo_app.is_null
	sle_area.setFocus( )
	return
end if

ls_seccion = trim(this.text)

SELECT desc_seccion
	INTO :ls_desc_seccion
FROM seccion
WHERE cod_area = :ls_area
  and cod_seccion = :ls_seccion
  and flag_estado = '1';
					 

IF SQLCA.SQLCode = 100 THEN
	gnvo_app.of_mensaje_error('Código de sección No Existe o no esta activo, Verifique!')
	This.text = gnvo_app.is_null
	sle_Desc_seccion.text = gnvo_app.is_null
	Return 
END IF

sle_Desc_seccion.text = ls_desc_seccion
end event

type sle_desc_seccion from singlelineedit within w_asi304_asistencia_ht580
integer x = 631
integer y = 284
integer width = 846
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_asi304_asistencia_ht580
integer x = 2565
integer y = 48
integer width = 279
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cantidad de Horas:"
boolean focusrectangle = false
end type

type em_horas from editmask within w_asi304_asistencia_ht580
integer x = 2839
integer y = 48
integer width = 219
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
borderstyle borderstyle = stylelowered!
string mask = "##0.00"
boolean spin = true
double increment = 1
string minmax = "0~~24"
end type

type cb_procesar from commandbutton within w_asi304_asistencia_ht580
integer x = 2565
integer y = 164
integer width = 498
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_procesar()
SetPointer(Arrow!)
end event

type cbx_1 from checkbox within w_asi304_asistencia_ht580
integer x = 78
integer y = 132
integer width = 622
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtrar por área y sección"
boolean checked = true
end type

event clicked;if this.checked then
	sle_area.enabled = false
	sle_seccion.enabled = false
	sle_area.text = ''
	sle_seccion.text = ''
else
	sle_area.enabled = true
	sle_seccion.enabled = true
	sle_area.text = ''
end if
end event

type st_1 from statictext within w_asi304_asistencia_ht580
integer x = 87
integer y = 212
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Area:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi304_asistencia_ht580
integer x = 87
integer y = 292
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Sección:"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_asi304_asistencia_ht580
boolean visible = false
integer x = 1842
integer y = 288
integer width = 1253
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type st_4 from statictext within w_asi304_asistencia_ht580
boolean visible = false
integer x = 2258
integer y = 360
integer width = 841
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_asi304_asistencia_ht580
integer x = 2345
integer y = 360
integer width = 498
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Adicionar Trabaj"
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_adicionar_trabaj()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_asi304_asistencia_ht580
integer x = 37
integer y = 124
integer width = 1801
integer height = 252
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

type gb_4 from groupbox within w_asi304_asistencia_ht580
integer width = 3150
integer height = 476
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

