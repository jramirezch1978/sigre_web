$PBExportHeader$w_pr041_cuadrillas.srw
forward
global type w_pr041_cuadrillas from w_abc
end type
type cb_2 from commandbutton within w_pr041_cuadrillas
end type
type cb_1 from commandbutton within w_pr041_cuadrillas
end type
type tab_1 from tab within w_pr041_cuadrillas
end type
type tabpage_1 from userobject within tab_1
end type
type dw_cuadrilla_det from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_cuadrilla_det dw_cuadrilla_det
end type
type tabpage_2 from userobject within tab_1
end type
type dw_cuadrilla_lab from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_cuadrilla_lab dw_cuadrilla_lab
end type
type tab_1 from tab within w_pr041_cuadrillas
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_cuadrilla from u_dw_abc within w_pr041_cuadrillas
end type
end forward

global type w_pr041_cuadrillas from w_abc
integer height = 2132
string title = "[PR041] Cuadrillas de Trabajadores"
string menuname = "m_mantto_smpl"
event type integer ue_listar_data ( string as_file )
cb_2 cb_2
cb_1 cb_1
tab_1 tab_1
dw_cuadrilla dw_cuadrilla
end type
global w_pr041_cuadrillas w_pr041_cuadrillas

type variables
u_dw_abc	idw_cuadrilla_det, idw_cuadrilla_lab

end variables

forward prototypes
public subroutine of_set_dws ()
public function boolean of_validar_trabajador (string as_trabajador, long al_row)
public subroutine of_datos_tarifario (string as_tarea, long al_row, u_dw_abc adw_1)
end prototypes

event type integer ue_listar_data(string as_file);oleobject excel
Long		ll_item, ll_return, ll_max_rows, ll_fila1, ll_fila, ll_count
double 	dbl_precio
boolean 	lb_cek
String 	ls_cellValue , ls_nomcol, ls_codigo, ls_mensaje, ls_trabajador, ls_cuadrilla

oleobject  lole_workbook, lole_worksheet

try 
	excel = create oleobject;
	
	if not(FileExists( as_file )) then
		messagebox('Excel','Archivo ' + as_file + ' del archivo no existe', Information!) 
		return -1
	end if 
	
	//connect to office application
	ll_return = excel.connecttonewobject("excel.application")
	if ll_return <> 0 then
		messagebox('Error','No tiene instalado o configurado el MS.Excel, por favor verifique!',exclamation!)
		return -1
	end if
	
	//open file excel (you can make this string as variable)
	excel.workbooks.open( as_file )
	excel.application.visible = false
	excel.windowstate = 2
	
	//cek rows in excel sheet with return value copy
	lole_workbook 	= excel.workbooks(1)
	lb_cek 			= lole_workbook.activate
	lole_worksheet = lole_workbook.worksheets(1)
	ll_max_rows   	= lole_worksheet.UsedRange.Rows.Count
	
	if MessageBox('Information', "Va importar " + string(ll_max_rows) &
		+ " desea continuar?. De continuar con el proceso se añadirán los datos a las cuadrillas", &
		Information!, YesNo!, 2) = 2 then return -1
		
	//Borro todos los datos de las cuadrillas
	//delete from tg_cuadrillas_det ;
	
	ll_item = 1
	
	FOR ll_fila1 = 2 TO ll_max_rows
		yield()
		ls_trabajador	= string(lole_worksheet.cells(ll_fila1,1).value)
		ls_cuadrilla	= string(lole_worksheet.cells(ll_fila1,2).value )
		
		//Valido los datos
		select count(*)
		  into :ll_count
		from maestro m
		where m.cod_trabajador = :ls_trabajador;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("Codigo de Trabajador " + ls_trabajador + ", de la línea " + string(ll_fila1) &
											+ ", no existe en el maestro de trabajador, por favor verifique!")
			return -1
		end if
		
		select count(*)
		  into :ll_count
		from tg_cuadrillas t
		where t.cod_cuadrilla = :ls_cuadrilla;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("Cuadrilla " + ls_cuadrilla + ", de la línea " + string(ll_fila1) &
											+ ", no existe en el maestro de cuadrillas, por favor verifique!")
			return -1
		end if

		//Valido que exista o no el dato en las cuadrillas
		select count(*)
			into :ll_count
		from tg_cuadrillas_det
		where cod_cuadrilla = :ls_cuadrilla
		  and cod_trabajador = :ls_trabajador;
		
		if ll_count = 0 then
			
			insert into tg_cuadrillas_det(
				cod_cuadrilla, cod_trabajador, cod_usr, nro_item, fec_registro)
			values(
				:ls_cuadrilla, :ls_trabajador, :gs_user, :ll_item, sysdate);
				
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				gnvo_app.of_mensaje_error(ls_mensaje)
				return -1
			end if
			
		end if
		
	next
	
	commit;
	
	f_mensaje("Archivo de Excel " + as_file + " importado correctamente. Por favor verifique y luego proceselo!", "")
	
	RETURN 1
	
catch ( Exception ex )
	ROLLBACK;
	gnvo_app.of_catch_exception( ex, "")
	return -1
	
finally
	if not IsNull(excel) and IsValid(excel) then
		excel.application.quit
		excel.disconnectobject()
		destroy excel;
	end if
end try
end event

public subroutine of_set_dws ();idw_cuadrilla_det = tab_1.tabpage_1.dw_cuadrilla_det
idw_cuadrilla_lab = tab_1.tabpage_2.dw_cuadrilla_lab
end subroutine

public function boolean of_validar_trabajador (string as_trabajador, long al_row);integer li_row

for li_row = 1 to idw_cuadrilla_det.RowCount()
	if li_row <> al_row then
		if as_trabajador = idw_cuadrilla_det.object.cod_trabajador[li_row] then
			MessageBox('Error', 'Código de Trabajador ya existe en el parte de produccion')
			return false
		end if
	end if
next

return true
end function

public subroutine of_datos_tarifario (string as_tarea, long al_row, u_dw_abc adw_1);string 	ls_cod_especie, ls_desc_especie, ls_cod_presentacion, &
			ls_desc_presentacion

select tf.cod_especie, te.descr_especie,
       tf.cod_presentacion, tp.desc_presentacion
	into 	:ls_cod_especie, :ls_desc_especie, 
			:ls_cod_presentacion, :ls_desc_presentacion
from tg_tarifario tf,
     tg_especies  te,
     tg_presentacion tp
where tf.cod_especie = te.especie
  and tf.cod_presentacion = tp.cod_presentacion
  and tf.cod_tarea		  = :as_tarea
  and tf.flag_estado		  = '1';

adw_1.object.cod_presentacion 	[al_row] = ls_cod_presentacion
adw_1.object.desc_presentacion 	[al_row] = ls_desc_presentacion
adw_1.object.especie		 			[al_row] = ls_cod_especie
adw_1.object.descr_especie 		[al_row] = ls_desc_especie

end subroutine

on w_pr041_cuadrillas.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_2=create cb_2
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_cuadrilla=create dw_cuadrilla
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.dw_cuadrilla
end on

on w_pr041_cuadrillas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_cuadrilla)
end on

event resize;call super::resize;of_set_dws()

dw_cuadrilla.width  = newwidth  - dw_cuadrilla.x - 10
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_cuadrilla_det.width  = tab_1.tabpage_1.width  - idw_cuadrilla_det.x - 10
idw_cuadrilla_det.height  = tab_1.tabpage_1.height  - idw_cuadrilla_det.y - 10

idw_cuadrilla_lab.width  = tab_1.tabpage_1.width  - idw_cuadrilla_lab.x - 10
idw_cuadrilla_lab.height  = tab_1.tabpage_1.height  - idw_cuadrilla_lab.y - 10

end event

event ue_open_pre;call super::ue_open_pre;of_set_dws()

dw_cuadrilla.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_cuadrilla_det.SetTransObject(sqlca)
idw_cuadrilla_lab.SetTransObject(sqlca)

idw_1 = dw_cuadrilla              				// asignar dw corriente
//idw_query = dw_master								// ventana para query

dw_cuadrilla.of_protect()         		// bloquear modificaciones 
idw_cuadrilla_det.of_protect()
idw_cuadrilla_lab.of_protect()

idw_1.Retrieve(gs_user)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
//ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

if upper(gs_empresa) = "FISHOLG" or upper(gs_empresa) = "ARCOPA" then
	cb_1.enabled = true
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_cuadrilla.AcceptText()
idw_cuadrilla_det.AcceptText()
idw_cuadrilla_lab.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_cuadrilla.of_create_log()
	idw_cuadrilla_det.of_create_log()
	idw_cuadrilla_lab.of_create_log()
END IF

IF	dw_cuadrilla.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_cuadrilla.Update(True, False) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_cuadrilla_det.ii_update = 1 THEN
	IF idw_cuadrilla_det.Update(True, False) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle de Trabajadores","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_cuadrilla_lab.ii_update = 1 THEN
	IF idw_cuadrilla_lab.Update(True, False) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle de Labores","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_cuadrilla.of_save_log()
		lbo_ok = idw_cuadrilla_det.of_save_log()
		lbo_ok = idw_cuadrilla_lab.of_save_log()
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_cuadrilla.ii_update = 0
	idw_cuadrilla_det.ii_update = 0
	idw_cuadrilla_lab.ii_update = 0
	
	dw_cuadrilla.ResetUpdate()
	idw_cuadrilla_det.ResetUpdate()
	idw_cuadrilla_lab.ResetUpdate()
	
	f_mensaje("Cambios Guardados satisfactoriamente", "")
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;call super::ue_modify;dw_cuadrilla.of_protect()
idw_cuadrilla_det.of_protect()
idw_cuadrilla_lab.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_cuadrilla ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_cuadrilla_det ) <> true then	return




dw_cuadrilla.of_set_flag_replicacion()
idw_cuadrilla_det.of_set_flag_replicacion()

ib_update_check = true




end event

type cb_2 from commandbutton within w_pr041_cuadrillas
integer x = 759
integer y = 8
integer width = 475
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar de XLS"
end type

event clicked;Integer	li_value
string 	ls_docname, ls_named, ls_codigo, ls_filtro, ls_mensaje

li_value =  GetFileOpenName("Abrir ..",  ls_docname, ls_named, "XLS",  "Archivos Excel (*.XLS),*.XLS" )

if li_value = 1 then
	IF parent.event ue_listar_data(ls_docname) = -1 THEN 
		RETURN -1
	END IF
end if




end event

type cb_1 from commandbutton within w_pr041_cuadrillas
integer y = 8
integer width = 741
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Eliminar Detalle"
end type

event clicked;String ls_mensaje

if MessageBox('Aviso', 'Desea eliminar todo el detalle de las cuadrillas de personal?.' &
		+ "~r~nUna vez realizado este procedimiento ya no hay forma de recuperar la informacion", &
		Information!, YesNo!, 2) = 2 then return

delete tg_cuadrillas_det;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'No se ha podido eliminar el detalle de cuadrillas. Mensaje: ' + ls_mensaje)
	return
end if

commit;

MessageBox('Aviso', 'Todo el detalle de la cuadrilla se ha eliminado satisfactoriamente')

dw_cuadrilla.event ue_output(dw_cuadrilla.getRow())
end event

type tab_1 from tab within w_pr041_cuadrillas
integer y = 996
integer width = 2473
integer height = 888
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2437
integer height = 760
long backcolor = 79741120
string text = "Personal"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cuadrilla_det dw_cuadrilla_det
end type

on tabpage_1.create
this.dw_cuadrilla_det=create dw_cuadrilla_det
this.Control[]={this.dw_cuadrilla_det}
end on

on tabpage_1.destroy
destroy(this.dw_cuadrilla_det)
end on

type dw_cuadrilla_det from u_dw_abc within tabpage_1
integer width = 2409
integer height = 868
integer taborder = 20
string dataobject = "d_abc_cuadrillas_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_cuadrilla	[al_row] = dw_cuadrilla.object.cod_cuadrilla[dw_cuadrilla.getRow()]

this.object.cod_usr 			[al_row] = gs_user
this.object.fec_registro	[al_row] = f_fecha_Actual()

this.object.nro_item			[al_row] = f_numera_item(this)


end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo_trabaj, ls_cuad, ls_flag_estado
ls_cuad = ''
choose case lower(as_columna)
	case "cod_trabajador"
		ls_sql = "SELECT cod_Trabajador AS codigo_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador, " &
				  + "tipo_trabajador AS tipo_trabajador, " &
				  + "flag_estado as flag_estado " &
				  + "FROM vw_pr_trabajador " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "  AND TIPO_TRABAJADOR IN ('DES', 'SER','JOR', 'EJO')"

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tipo_trabaj, ls_flag_estado, '2')

		if ls_codigo <> '' and of_validar_trabajador(ls_codigo, al_row) then
			this.object.cod_trabajador		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.tipo_trabajador	[al_row] = ls_tipo_trabaj
			this.object.tipo_trabajador	[al_row] = ls_flag_estado
			this.ii_update = 1
		end if
		
end choose

SELECT tcd.cod_cuadrilla
 into :ls_cuad
 from tg_cuadrillas_det tcd
 where tcd.cod_trabajador = :ls_codigo;
 
if ls_cuad <> '' then
	MessageBox('Asivo S.I.G.R.E.','El Trabajador '+ls_data+' está asignado a la cuadrilla '+ls_cuad)
end if
end event

event itemchanged;call super::itemchanged;string 	ls_col, ls_codigo, ls_nom_trabajador, ls_tipo_trabajador, ls_cod_trabajador, ls_flag_estado

this.accepttext()

choose case trim(lower(string(dwo.name)))

	case 'cod_trabajador'
		ls_codigo = trim(data)
		
		if len(ls_codigo) < 8 then
			ls_codigo = '%' + ls_codigo
		end if
		
		select m.cod_trabajador, m.nom_trabajador, m.tipo_trabajador, m.flag_estado
		   into :ls_cod_trabajador, :ls_nom_trabajador, :ls_tipo_trabajador, :ls_flag_estado
			from 	vw_pr_trabajador m
			where m.cod_trabajador like :ls_codigo
				and m.flag_estado = '1'
				and m.cod_origen = :gs_origen
				and m.tipo_trabajador in ('DES', 'EJO', 'JOR');
			
		if SQLCA.SQLCode = 100 then
			messagebox("Error", 'No existe código de trabajador ' + trim(data) &
								+ ', no está activo o no es un trabajador de TIPO DES, JOR o EJO')
			this.object.cod_trabajador	[row] = gnvo_app.is_null
			this.object.nom_trabajador	[row] = gnvo_app.is_null
			this.object.tipo_trabajador[row] = gnvo_app.is_null
			this.object.flag_estado		[row] = gnvo_app.is_null
			return
		end if
		
		this.object.cod_trabajador	[row] = ls_cod_trabajador
		this.object.nom_trabajador	[row] = ls_nom_trabajador
		this.object.tipo_trabajador[row] = ls_tipo_trabajador
		this.object.flag_estado		[row] = ls_flag_estado
		
		return 2
	
	End choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2437
integer height = 760
long backcolor = 79741120
string text = "Tareas Asignadas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cuadrilla_lab dw_cuadrilla_lab
end type

on tabpage_2.create
this.dw_cuadrilla_lab=create dw_cuadrilla_lab
this.Control[]={this.dw_cuadrilla_lab}
end on

on tabpage_2.destroy
destroy(this.dw_cuadrilla_lab)
end on

type dw_cuadrilla_lab from u_dw_abc within tabpage_2
integer width = 2405
integer height = 864
integer taborder = 20
string dataobject = "d_abc_cuadrilla_labor_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_especie, ls_presentacion, ls_tarea
choose case lower(as_columna)
		
	case "cod_tarea"
		ls_sql = "SELECT distinct ta.cod_tarea AS codigo_tarea, " &
				  + "ta.desc_tarea AS descripcion_tarea " &
				  + "FROM tg_tareas ta, " &
				  + "     tg_tarifario tf " &
				  + "WHERE ta.cod_tarea = tf.cod_tarea " &
				  + "  and ta.FLAG_ESTADO = '1' " &
				  + "  and tf.FLAG_ESTADO = '1' " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_tarea	[al_row] = ls_codigo
			this.object.desc_tarea	[al_row] = ls_data
			//of_datos_tarifario(ls_codigo, al_row, this)
			this.ii_update = 1
		end if
		
	case "especie"
		// primero vemos si ha seleccionado la especie
		ls_tarea = this.object.cod_tarea [al_row]
		if ISNull(ls_tarea) or ls_tarea = '' then
			MessageBox('Error', 'Debe seleccionar primero una tarea', StopSign!)
			this.SetColumn('cod_tarea')
			return
		end if
		
		ls_sql = "SELECT distinct te.especie AS CODIGO_especie, " &
				  + "te.descr_especie AS descripción_especie " &
				  + "FROM tg_especies te, " &
				  + " 	 tg_tarifario tf " &
				  + "WHERE te.especie = tf.cod_especie " &
				  + "  and te.FLAG_ESTADO = '1' " &
				  + "  and tf.FLAG_ESTADO = '1' " &
				  + "  and tf.cod_tarea   = '" + ls_tarea + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.especie			[al_row] = ls_codigo
			this.object.descr_especie	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_presentacion"
		// primero vemos si ha seleccionado la especie
		ls_tarea = this.object.cod_tarea [al_row]
		if ISNull(ls_tarea) or ls_tarea = '' then
			MessageBox('Error', 'Debe seleccionar primero una tarea', StopSign!)
			this.SetColumn('cod_tarea')
			return
		end if
		
		// primero vemos si ha seleccionado la especie
		ls_especie = this.object.especie [al_row]
		
		if ISNull(ls_especie) or ls_especie = '' then
			MessageBox('Error', 'Debe seleccionar primero una especie')
			this.SetColumn('especie')
			return
		end if
		
		ls_sql = "SELECT distinct tp.cod_presentacion AS codigo_presentacion, " &
				  + "tp.desc_presentacion AS descripcion_presentacion " &
				  + "FROM tg_presentacion tp, " &
				  + "     tg_tarifario tf " &
				  + "WHERE tp.cod_presentacion = tf.cod_presentacion " &
				  + "  and tp.FLAG_ESTADO = '1' " &
				  + "  and tf.FLAG_ESTADO = '1' " &
				  + "  and tf.cod_especie = '" + ls_especie + "'" &
				  + "  and tf.cod_tarea   = '" + ls_tarea + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_presentacion	[al_row] = ls_codigo
			this.object.desc_presentacion	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr [al_row] = gs_user

this.object.cod_cuadrilla [al_row] = dw_cuadrilla.object.cod_cuadrilla [dw_cuadrilla.getRow()]
this.setColumn('cod_tarea')
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 4				// columnas de lectrua de este dw
ii_ck[4] = 6				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_cuadrilla from u_dw_abc within w_pr041_cuadrillas
integer y = 116
integer width = 2459
integer height = 876
string dataobject = "d_abc_cuadrillas_cab_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_planta"
		ls_sql = "SELECT cod_planta AS codigo_planta, " &
				  + "desc_planta AS descripcion_planta " &
				  + "FROM tg_plantas " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_planta	[al_row] = ls_codigo
			this.object.desc_planta	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_turno"
		ls_sql = "SELECT turno AS CODIGO_turno, " &
				  + "descripcion AS descripcion_turno " &
				  + "FROM turno " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_turno	[al_row] = ls_codigo
			this.object.desc_turno	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "ot_adm"
		
		ls_sql = "select ota.ot_adm as ot_adm, " &
				 + "ota.descripcion as descripcion_ot_adm " &
				 + "  from ot_administracion ota, " &
				 + "       ot_adm_usuario    otu " &
				 + "where ota.ot_adm = otu.ot_adm " &
				 + "  and ota.flag_estado = '1'" &
				 + "  and otu.cod_usr = '" + gs_user + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm			[al_row] = ls_codigo
			this.object.desc_ot_adm		[al_row] = ls_data
			this.ii_update = 1
		end if		
		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 		[al_row] = gs_user
this.object.flag_estado [al_row] = '1'
this.object.prima_frio 	[al_row] = 0.00
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event ue_output;call super::ue_output;idw_cuadrilla_det.Retrieve(this.object.cod_cuadrilla[al_row])
idw_cuadrilla_lab.Retrieve(this.object.cod_cuadrilla[al_row])
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

