$PBExportHeader$w_al013_almacenes_tacitos.srw
forward
global type w_al013_almacenes_tacitos from w_abc_master_smpl
end type
end forward

global type w_al013_almacenes_tacitos from w_abc_master_smpl
integer width = 2373
integer height = 1140
string title = "(AL013) Almacenes tácitos"
string menuname = "m_mantenimiento_sl"
end type
global w_al013_almacenes_tacitos w_al013_almacenes_tacitos

on w_al013_almacenes_tacitos.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_al013_almacenes_tacitos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then
	ib_update_check = False
else
	ib_update_check = True
end if	

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_al013_almacenes_tacitos
event ue_display ( string as_columna,  long al_row )
integer width = 2304
integer height = 928
string dataobject = "d_abc_almacen_tacito"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_origen"
		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
				  + "nombre AS descripcion_origen " &
				  + "FROM origen " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.desc_origen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_clase"
		ls_sql = "SELECT cod_clase AS CODIGO_clase, " &
				  + "desc_clase AS descripcion_clase " &
				  + "FROM articulo_clase " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_clase	[al_row] = ls_codigo
			this.object.desc_clase	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc
Long ll_count

this.Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_origen'
		Select nombre
	     into :ls_desc
		  from origen
		 Where cod_origen = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de origen')
			this.object.cod_origen [row] = ls_null
			this.object.desc_origen[row] = ls_null
			return 1
		end if
		
		this.object.desc_origen [row] = ls_desc

	CASE 'almacen' 
		Select desc_almacen
	     into :ls_desc
		  from almacen
		 Where almacen = :data
		   and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de almacen o no esta activo')
			this.object.almacen 		[row] = ls_null
			this.object.desc_almacen[row] = ls_null
			return 1
		end if
		
		this.object.desc_almacen [row] = ls_desc
		
	CASE "cod_clase" 
		Select desc_clase
	     into :ls_desc
		  from articulo_clase
		 Where cod_clase = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Codigo de Clase de Articulo')
			this.object.cod_clase [row] = ls_null
			this.object.desc_clase[row] = ls_null
			return 1
		end if
		
		this.object.desc_clase [row] = ls_desc
END CHOOSE


end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

