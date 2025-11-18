$PBExportHeader$w_pr039_tarifario.srw
forward
global type w_pr039_tarifario from w_abc_master_smpl
end type
type uo_search from n_cst_search within w_pr039_tarifario
end type
end forward

global type w_pr039_tarifario from w_abc_master_smpl
integer width = 2546
integer height = 1460
string title = "[PR039] Tarifario de Cortes por Especie"
string menuname = "m_mantto_smpl"
event ue_saveasexcel ( )
uo_search uo_search
end type
global w_pr039_tarifario w_pr039_tarifario

event ue_saveasexcel();//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_master, ls_file )
End If
end event

on w_pr039_tarifario.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_pr039_tarifario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

uo_search.width  = newwidth  - uo_search.x - 10
uo_search.event ue_resize(sizetype, uo_search.width, newheight)
end event

event ue_open_pre;call super::ue_open_pre;uo_search.of_set_dw(dw_master)
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr039_tarifario
integer y = 96
string dataobject = "d_abc_tarifario_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw
ii_ck[3] = 5				// columnas de lectrua de este dw
ii_ck[4] = 7				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_especie"

		ls_sql = "SELECT t.especie AS CODIGO_especie, " &
				  + "t.descr_especie AS descripcion_especie " &
				  + "FROM tg_especies t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_especie		[al_row] = ls_codigo
			this.object.descr_especie	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_presentacion"

		ls_sql = "SELECT t.cod_presentacion AS CODIGO_presentacion, " &
				  + "t.desc_presentacion AS descripcion_presentacion " &
				  + "FROM tg_presentacion t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_presentacion	[al_row] = ls_codigo
			this.object.desc_presentacion	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_tarea"

		ls_sql = "SELECT t.cod_tarea AS CODIGO_tarea, " &
				  + "t.desc_tarea AS descripcion_tarea " &
				  + "FROM tg_tareas t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_tarea	[al_row] = ls_codigo
			this.object.desc_tarea	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_proceso"

		ls_sql = "SELECT t.cod_proceso AS CODIGO_proceso, " &
				  + "t.desc_proceso AS descripcion_proceso " &
				  + "FROM tg_procesos t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_proceso		[al_row] = ls_codigo
			this.object.desc_proceso	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_labor"

		ls_sql = "SELECT t.cod_labor AS codigo_labor, " &
				  + "t.desc_labor AS descripcion_labor " &
				  + "FROM labor t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "und"

		ls_sql = "SELECT t.und AS unidad, " &
				  + "t.desc_unidad AS descripcion_unidad " &
				  + "FROM unidad t " &
				  + "where t.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.und		[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose



end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_row] = '1'
this.object.flag_destajo 	[al_row] = '0'
this.object.tarifa 			[al_row] = 0.0000
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_especie'
		
		// Verifica que codigo ingresado exista			
		Select descr_especie
	     into :ls_desc
		  from tg_especies
		 Where especie = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Especie no existe o no se encuentra activo, por favor verifique")
			this.object.cod_especie		[row] = ls_null
			this.object.descr_especie	[row] = ls_null
			return 1
			
		end if

		this.object.descr_especie	[row] = ls_desc

	CASE 'cod_presentacion' 

		// Verifica que codigo ingresado exista			
		Select desc_presentacion
	     into :ls_desc
		  from tg_presentacion
		 Where cod_presentacion = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Presentacion No existe o no se encuentra activo, por favor verifique")
			this.object.cod_presentacion	[row] = ls_null
			this.object.desc_presentacion	[row] = ls_null
			return 1
			
		end if

		this.object.desc_presentacion		[row] = ls_desc

	CASE 'cod_tarea' 

		// Verifica que codigo ingresado exista			
		Select desc_tarea
	     into :ls_desc
		  from tg_tareas
		 Where cod_tarea = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Tarea No existe o no se encuentra activo, por favor verifique")
			this.object.cod_tarea	[row] = ls_null
			this.object.desc_tarea	[row] = ls_null
			return 1
			
		end if

		this.object.desc_tarea		[row] = ls_desc

	CASE 'cod_proceso' 

		// Verifica que codigo ingresado exista			
		Select desc_proceso
	     into :ls_desc
		  from tg_procesos
		 Where cod_proceso = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Proceso No existe o no se encuentra activo, por favor verifique")
			this.object.cod_proceso		[row] = ls_null
			this.object.desc_proceso	[row] = ls_null
			return 1
			
		end if

		this.object.desc_proceso		[row] = ls_desc
	
	CASE 'cod_labor' 

		// Verifica que codigo ingresado exista			
		Select desc_labor
	     into :ls_desc
		  from labor
		 Where cod_labor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Labor No existe o no se encuentra activo, por favor verifique")
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
			
		end if

		this.object.desc_labor		[row] = ls_desc


	CASE 'und' 

		// Verifica que codigo ingresado exista			
		Select desc_unidad
	     into :ls_desc
		  from unidad
		 Where und = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Código de Unidad No existe o no se encuentra activo, por favor verifique")
			this.object.und		[row] = ls_null
			return 1
			
		end if

END CHOOSE
end event

type uo_search from n_cst_search within w_pr039_tarifario
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

