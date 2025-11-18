$PBExportHeader$w_asi903_upgrade_zktime.srw
forward
global type w_asi903_upgrade_zktime from w_prc
end type
type rb_3 from radiobutton within w_asi903_upgrade_zktime
end type
type sle_origen from singlelineedit within w_asi903_upgrade_zktime
end type
type rb_2 from radiobutton within w_asi903_upgrade_zktime
end type
type rb_1 from radiobutton within w_asi903_upgrade_zktime
end type
type hpb_progreso from hprogressbar within w_asi903_upgrade_zktime
end type
type cb_1 from commandbutton within w_asi903_upgrade_zktime
end type
type gb_1 from groupbox within w_asi903_upgrade_zktime
end type
end forward

global type w_asi903_upgrade_zktime from w_prc
integer width = 2016
integer height = 684
string title = "[ASI903] Actualizar datos de ZKTIME"
string menuname = "m_proceso"
event ue_procesar ( )
rb_3 rb_3
sle_origen sle_origen
rb_2 rb_2
rb_1 rb_1
hpb_progreso hpb_progreso
cb_1 cb_1
gb_1 gb_1
end type
global w_asi903_upgrade_zktime w_asi903_upgrade_zktime

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
public function boolean of_opcion3 ()
end prototypes

event ue_procesar();boolean lb_ret
if rb_1.checked then
	lb_ret = of_opcion1()
elseif rb_2.checked then
	lb_ret = of_opcion2()
elseif rb_3.checked then
	lb_ret = of_opcion3()	
end if

if lb_ret then
	MessageBox('Aviso', 'Proceso realizado satisfactoriamente', Information!)
end if
end event

public function boolean of_opcion1 ();u_ds_base		lds_base
String			ls_cod_Seccion, ls_desc_seccion, ls_mensaje
transaction 	ltr_ZK
Long				ll_row, ll_count

try 
	hpb_progreso.position = 0
	hpb_progreso.visible = true
	
	ltr_ZK 	= create transaction
	
	// Me conecto a la base de datos destino
	ltr_ZK.DBMS = "ODBC"
	ltr_ZK.AutoCommit = False
	ltr_ZK.DBParm = "ConnectString='DSN=zk_time;'"
	connect using ltr_ZK;
	if ltr_ZK.SQLCode = -1 then
		ls_mensaje = ltr_ZK.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al conectar a zk_time. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
		
	//Obtengo las secciones anteriores
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_lista_areas_exp_tbl'
	lds_base.setTransobject( SQLCA )
	lds_base.Retrieve()
	
	for ll_row = 1 to lds_base.RowCount()
		ls_cod_seccion 	= lds_base.object.cod_seccion 	[ll_row]
		ls_desc_seccion 	= lds_base.object.desc_Seccion 	[ll_row]
		
		select count(*)
			into :ll_count
		from hr_department
		where dept_code = :ls_cod_Seccion
		using ltr_ZK;
		
		if ltr_ZK.SQLCode = -1 then
			ls_mensaje = ltr_ZK.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un consulta la tabla HR_DEPARTMENT. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
	
		
		if ll_count = 0 then
			insert into hr_department(
				dept_code, dept_name, dept_parentcode, dept_operationmode, dept_cmp_id)
			values(
				:ls_Cod_Seccion, :ls_desc_seccion, 0, 0, 1)
			using ltr_ZK;
		else
			update hr_department
			   set dept_name 	= :ls_desc_seccion
			where dept_code 	= :ls_cod_Seccion
			using ltr_ZK;
		end if;
		
		if ltr_ZK.SQLCode = -1 then
			ls_mensaje = ltr_ZK.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al actualizar la tabla hr_department. Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		
		hpb_progreso.position = ll_row / lds_base.RowCount() * 100
		yield()
		
	next
	
	commit using ltr_ZK;
	//f_mensaje("Proceso realizado satisfactoriamente", '')
	
	
	
	
catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
	
finally
	destroy lds_base
	destroy ltr_ZK
	
	hpb_progreso.position = 0
	hpb_progreso.visible = false
	
end try

return true
end function

public function boolean of_opcion2 ();u_ds_base		lds_base
String			ls_codigo, ls_nombres, ls_apellidos, ls_direccion, ls_cod_Seccion, &
					ls_dni, ls_mensaje, ls_origen
Long				ll_row, ll_count
Date				ld_fec_nacimiento, ld_fec_ingreso
transaction 	ltr_ZK



try 
	hpb_progreso.position = 0
	hpb_progreso.visible = true
	
	ltr_ZK 	= create transaction
	
	// Me conecto a la base de datos destino
	ltr_ZK.DBMS = "ODBC"
	ltr_ZK.AutoCommit = False
	ltr_ZK.DBParm = "ConnectString='DSN=zk_time;'"
	connect using ltr_ZK;
	
	if ltr_ZK.SQLCode = -1 then
		ls_mensaje = ltr_ZK.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al conectar a zk_time. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if

	//Obtengo las secciones anteriores
	ls_origen = sle_origen.text
	
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_lista_personal_exp_tbl'
	lds_base.setTransobject( SQLCA )
	lds_base.Retrieve(ls_origen)
	
	for ll_row = 1 to lds_base.RowCount()
		ls_codigo		 	= lds_base.object.cod_trabajador 	[ll_row]
		ls_nombres		 	= lds_base.object.nombres			 	[ll_row]
		ls_apellidos	 	= lds_base.object.apellidos		 	[ll_row]
		ls_direccion	 	= lds_base.object.direccion		 	[ll_row]
		ls_cod_seccion	 	= lds_base.object.cod_seccion		 	[ll_row]
		ls_dni			 	= lds_base.object.dni				 	[ll_row]
		
		ld_fec_nacimiento	= Date(lds_base.object.fec_nacimiento 	[ll_row])
		ld_fec_ingreso		= Date(lds_base.object.fec_ingreso	 	[ll_row])
		
		select count(*)
			into :ll_count
		from hr_employee
		where emp_pin = :ls_codigo
		using ltr_ZK;
		
		if ll_count = 0 then
			
			insert into hr_employee(
				emp_pin, emp_firstname, emp_lastname, emp_pin2, emp_privilege, emp_hiredate, emp_active, 
				emp_hourlyrate1, emp_hourlyrate2, emp_hourlyrate3, emp_hourlyrate4, emp_hourlyrate5, 
				emp_gender, emp_birthday, emp_operationmode, IsSelect, emp_dept)
			values(
				:ls_codigo, :ls_nombres, :ls_apellidos, :ls_dni, 0, :ld_fec_ingreso, '1', 
				0, 0, 0, 0, 0, 
				-1, :ld_fec_nacimiento, 0, 0, :ls_cod_seccion 
			)using ltr_ZK;
			
		else
			
			update hr_employee
			   set 	emp_firstname 	= :ls_nombres,
						emp_lastname	= :ls_apellidos,
						emp_pin2			= :ls_dni,
						emp_hiredate	= :ld_fec_ingreso,
						emp_birthday	= :ld_fec_nacimiento,
						emp_dept			= :ls_cod_seccion
			where emp_pin 	= :ls_codigo
			using ltr_ZK;
			
		end if;
		
		if ltr_ZK.SQLCode = -1 then
			ls_mensaje = ltr_ZK.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al actualizar la tabla hr_employee. ' &
									+ 'Trabajador : ' + ls_nombres &
									+ "~r~n" &
									+ 'Mensaje: ' + ls_mensaje, StopSign!)
			return false
		end if
		
		//Elimino
//		delete from att_employee_zone
//		where employee_id = :ls_codigo
//		using ltr_ZK;
//		
//		if ltr_ZK.SQLCode = -1 then
//			ls_mensaje = ltr_ZK.SQLErrText
//			ROLLBACK;
//			MessageBox('Error', 'Ha ocurrido un error al eliminar la tabla att_employee_zone. ' &
//									+ 'Trabajador : ' + ls_nombres &
//									+ "~r~n" &
//									+ 'Mensaje: ' + ls_mensaje, StopSign!)
//			return false
//		end if
//		
//		//Insert
//		insert into att_employee_zone(employee_id, zone_id)
//		values(:ls_Codigo, 1)
//		using ltr_ZK;
//		
//		if ltr_ZK.SQLCode = -1 then
//			ls_mensaje = ltr_ZK.SQLErrText
//			ROLLBACK;
//			MessageBox('Error', 'Ha ocurrido un error al insertar la tabla att_employee_zone. ' &
//									+ 'Trabajador : ' + ls_nombres &
//									+ "~r~n" &
//									+ 'Mensaje: ' + ls_mensaje, StopSign!)
//			return false
//		end if
		
		hpb_progreso.position = ll_row / lds_base.RowCount() * 100
		yield()
		
		commit using ltr_ZK;
		
	next
	
	//f_mensaje("Proceso realizado satisfactoriamente", '')
	
	
	
	
catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
	
finally
	destroy lds_base
	destroy ltr_ZK
	
	hpb_progreso.position = 0
	hpb_progreso.visible = false
	
end try

return true
end function

public function boolean of_opcion3 ();u_ds_base		lds_base
String			ls_codigo, ls_nombres, ls_apellidos, ls_direccion, ls_cod_Seccion, &
					ls_dni, ls_origen, ls_mensaje
Long				ll_row, ll_count, ll_id
Date				ld_fec_nacimiento, ld_fec_ingreso
transaction 	ltr_ZK
n_cst_wait		lnvo_wait



try 
	lnvo_wait = create n_Cst_Wait
	
	hpb_progreso.position = 0
	hpb_progreso.visible = true
	
	ltr_ZK 	= create transaction
	
	// Me conecto a la base de datos destino
	ltr_ZK.DBMS = "ODBC"
	ltr_ZK.AutoCommit = False
	ltr_ZK.DBParm = "ConnectString='DSN=zk_time;'"
	connect using ltr_ZK;
	
	if ltr_ZK.SQLCode = -1 then
		ls_mensaje = ltr_ZK.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al conectar a zk_time. Mensaje: ' + ls_mensaje, StopSign!)
		return false
	end if
	
	lnvo_wait.of_mensaje( "REcuperando informacion de hr_employee" )
	
	//Obtengo las secciones anteriores
	ls_origen = sle_origen.text
	
	lds_base = create u_ds_base
	lds_base.DataObject = 'd_lista_empleados_zktime_tbl'
	lds_base.setTransobject( ltr_ZK )
	lds_base.Retrieve()
	
	lnvo_wait.of_mensaje( "Procesando la informacion" )
	
	for ll_row = 1 to lds_base.RowCount()
		yield()
		
		ll_id			= Long(lds_base.object.id 	[ll_row])
		ls_codigo	= lds_base.object.emp_pin 	[ll_row]
		
		//Obtengo los datos del nombre y apellidos
		select 	trim(trim(m.nombre1) || ' ' || trim(m.nombre2)), 
       			trim(trim(m.apel_paterno) || ' ' || trim(m.apel_materno))
		  into :ls_nombres, :ls_apellidos
  		from maestro m
		 where m.cod_trabajador = :ls_codigo;
		 
		if SQLCA.SQLCOde < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar los datos: ' + ls_mensaje, StopSign!)
			return false
		end if;
		
		if SQLCA.SQLCode <> 100 then
			//Actualizo la data en la base de datos
			update hr_employee
			   set emp_firstname = :ls_nombres,
					 emp_lastname  = :ls_apellidos
			where id = :ll_id
			using ltr_ZK;
			
			if ltr_ZK.SQLCOde < 0 then
				ls_mensaje = ltr_ZK.SQLErrText
				ROLLBACK using ltr_ZK;
				MessageBox('Error', 'Error al actualizar los datos en zk_time: ' + ls_mensaje, StopSign!)
				return false
			end if;
			
			commit using ltr_ZK;
			
			hpb_progreso.position = ll_row / lds_base.RowCount() * 100
			yield()
		
		end if;
		 
	next
	
	//f_mensaje("Proceso realizado satisfactoriamente", '')
	
	
	
	
catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
	
finally
	
	lnvo_wait.of_close()
	
	destroy lds_base
	destroy ltr_ZK
	destroy lnvo_Wait
	
	hpb_progreso.position = 0
	hpb_progreso.visible = false
	
end try

return true
end function

on w_asi903_upgrade_zktime.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.rb_3=create rb_3
this.sle_origen=create sle_origen
this.rb_2=create rb_2
this.rb_1=create rb_1
this.hpb_progreso=create hpb_progreso
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.hpb_progreso
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_asi903_upgrade_zktime.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.sle_origen)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.hpb_progreso)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;sle_origen.text = gs_origen
end event

type rb_3 from radiobutton within w_asi903_upgrade_zktime
integer x = 50
integer y = 272
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Download data del ZKTIME"
end type

type sle_origen from singlelineedit within w_asi903_upgrade_zktime
integer x = 882
integer y = 176
integer width = 343
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_asi903_upgrade_zktime
integer x = 50
integer y = 176
integer width = 832
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualizar datos de Trabajadores"
end type

type rb_1 from radiobutton within w_asi903_upgrade_zktime
integer x = 50
integer y = 72
integer width = 1266
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualizar datos de Secciones"
boolean checked = true
end type

type hpb_progreso from hprogressbar within w_asi903_upgrade_zktime
boolean visible = false
integer x = 18
integer y = 404
integer width = 1925
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_1 from commandbutton within w_asi903_upgrade_zktime
integer x = 1591
integer y = 52
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;event ue_procesar()

end event

type gb_1 from groupbox within w_asi903_upgrade_zktime
integer width = 1961
integer height = 496
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opcion a Procesar"
end type

