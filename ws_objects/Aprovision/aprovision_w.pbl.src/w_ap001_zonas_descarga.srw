$PBExportHeader$w_ap001_zonas_descarga.srw
forward
global type w_ap001_zonas_descarga from w_abc_master
end type
end forward

global type w_ap001_zonas_descarga from w_abc_master
integer width = 2473
integer height = 1372
string title = "Zonas de Descarga (ap001) "
string menuname = "m_mantto_smpl"
boolean center = true
end type
global w_ap001_zonas_descarga w_ap001_zonas_descarga

on w_ap001_zonas_descarga.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap001_zonas_descarga.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()
//idw_query = dw_master

//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

type dw_master from w_abc_master`dw_master within w_ap001_zonas_descarga
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2414
integer height = 1168
string dataobject = "d_chatas_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_origen"
		 ls_sql = "select cod_origen as codigo_origen, " &
		       + "nombre as descripcion_origen " &
				 + "from origen " 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_origen	[al_row] = ls_codigo
			THIS.object.nombre		[al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                      //  'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = 	dw_master

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

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null
SetNull(ls_null)
this.accepttext( )

choose case lower(dwo.name)
	case 'cod_origen'
		select nombre 
			into :ls_desc
		from origen 
		where cod_origen = :data;
		
		if sqlca.sqlcode = 100 then 
			messagebox(parent.title, 'Codigo de origen no existe')
			this.object.cod_origen	[row] = ls_null
			this.object.nombre		[row] = ls_null
			return 1
		end if

		this.object.nombre	[row] = ls_desc
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_nombre

select o.nombre
   into :ls_nombre
   from origen o
   where trim(o.cod_origen) = trim(:gs_origen);

this.object.cod_origen[al_row] = gs_origen
this.object.nombre[al_row] = ls_nombre
end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

