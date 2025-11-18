$PBExportHeader$w_cm020_servicios.srw
forward
global type w_cm020_servicios from w_abc_master_smpl
end type
end forward

global type w_cm020_servicios from w_abc_master_smpl
integer width = 2638
integer height = 1600
string title = "Maestro de Servicios (CM020)"
string menuname = "m_mantto_smpl"
end type
global w_cm020_servicios w_cm020_servicios

on w_cm020_servicios.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_cm020_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.servicio.Protect)

IF li_protect = 0 THEN
   dw_master.Object.servicio.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm020_servicios
event ue_display ( string as_columna,  long al_row )
integer width = 2551
integer height = 1240
string dataobject = "d_abc_servicios_tbl"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "und"
		ls_sql = "SELECT UND AS CODIGO, " &
				  + "DESC_UNIDAD AS DESCRIPCION " &
				  + "FROM UNIDAD " 
				 
		
		
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.und		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cod_sub_cat"
		ls_sql = "SELECT cod_sub_cat AS CODIGO, " &
				  + "DESC_sub_cat AS DESCRIPCION " &
				  + "FROM articulo_sub_categ " &
				  + "WHERE FLAG_SERVICIO = '1'"
				  
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.cod_sub_cat	[al_row] = ls_codigo
			this.object.desc_sub_cat[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cnta_prsp"
		ls_sql = "select pc.cnta_prsp as cnta_prsp, " &
       		 + "pc.descripcion as desc_cnta_prsp " &
				 + "from presupuesto_cuenta pc " &
				 + "where pc.flag_estado = '1'"
				  
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
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

event dw_master::itemchanged;call super::itemchanged;string ls_data

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cod_sub_cat"
		
		select desc_sub_cat
			into :ls_data
		from articulo_sub_categ
		where cod_sub_cat 	= :data
		  and flag_servicio 	= '1'
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Codigo de Subcategoría " + data &
									+ " NO EXISTE O no corresponde A UN SERVICIO o no se encuentra ACTIVO", StopSign!)
			this.object.cod_sub_cat	[row] = gnvo_app.is_null
			this.object.desc_sub_cat[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_sub_cat[row] = ls_data
	
	case "cnta_prsp"
		
		select pc.descripcion as desc_cnta_prsp
			into :ls_data
		from presupuesto_cuenta pc
		where pc.flag_estado = '1'
		  and pc.cnta_prsp 	= :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal " + data &
									+ " No existe o no se encuentra activo", StopSign!)
			this.object.cnta_prsp		[row] = gnvo_app.is_null
			this.object.desc_cnta_prsp	[row] = gnvo_app.is_null
			return 1
		end if

		this.object.desc_sub_cat[row] = ls_data
		
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

