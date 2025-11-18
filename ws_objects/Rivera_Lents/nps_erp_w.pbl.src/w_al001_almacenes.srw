$PBExportHeader$w_al001_almacenes.srw
forward
global type w_al001_almacenes from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_al001_almacenes
end type
end forward

global type w_al001_almacenes from w_abc_master
integer width = 3483
integer height = 1980
string title = "Mantenimiento de Almacenes (AL001)"
string menuname = "m_mtto_smpl"
dw_lista dw_lista
end type
global w_al001_almacenes w_al001_almacenes

on w_al001_almacenes.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_al001_almacenes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event ue_open_pre;call super::ue_open_pre;//f_centrar(this) 
ii_pregunta_delete = 1

uo_filter.of_set_dw( dw_master )
uo_filter.of_retrieve_fields( )
uo_h.of_set_title( this.title + ". Nro de Registros: " + string(dw_master.RowCount()))
end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.almacen.Protect)

IF li_protect = 0 THEN
   dw_master.Object.almacen.Protect = 1
END IF
end event

event resize;call super::resize;dw_lista.height = p_pie.y - dw_lista.y - cii_WindowBorder
end event

type p_pie from w_abc_master`p_pie within w_al001_almacenes
end type

type ole_skin from w_abc_master`ole_skin within w_al001_almacenes
end type

type uo_h from w_abc_master`uo_h within w_al001_almacenes
end type

type st_box from w_abc_master`st_box within w_al001_almacenes
end type

type phl_logonps from w_abc_master`phl_logonps within w_al001_almacenes
end type

type p_mundi from w_abc_master`p_mundi within w_al001_almacenes
end type

type p_logo from w_abc_master`p_logo within w_al001_almacenes
end type

type st_filter from w_abc_master`st_filter within w_al001_almacenes
end type

type uo_filter from w_abc_master`uo_filter within w_al001_almacenes
end type

type dw_master from w_abc_master`dw_master within w_al001_almacenes
event ue_display ( string as_columna,  long al_row )
integer x = 1998
integer y = 284
integer width = 1975
integer height = 904
string dataobject = "d_abc_almacen_ff"
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "prov_almacen"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.prov_almacen	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_origen"
		ls_sql = "SELECT distinct o.cod_origen AS CODIGO_origen, " &
				  + "o.nombre AS descripcion_origen " &
				  + "from origen o, " &
				  + "     user_empresa ue " &
				  + "where o.cod_origen = ue.cod_origen " &
				  + "  and o.flag_estado = '1' " &
				  + "  and ue.cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_responsable"
		ls_sql = "SELECT distinct u.cod_usr AS CODIGO_usuario, " &
				  + "u.NOMBRE AS nombre_usuario " &
				  + "FROM usuario u, " &
				  + "     user_empresa ue " &
				  + "WHERE ue.cod_usr = u.cod_usr " &
				  + "  and u.FLAG_ESTADO = '1' " &
				  + "  and ue.cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_responsable	[al_row] = ls_codigo
			this.object.nom_usuario			[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_empresa"
		ls_sql = "SELECT cod_empresa AS codigo_empresa, " &
				  + "NOMBRE AS nombre_empresa " &
				  + "FROM empresa " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_empresa		[al_row] = ls_codigo
			this.object.nom_empresa		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'form'

end event

event dw_master::itemerror;call super::itemerror;Return 1  // Fuerza a no mostrar ventana de error
end event

event dw_master::doubleclicked;call super::doubleclicked;Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc, ls_mensaje

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_responsable'
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from usuario
		 Where cod_usr = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de usuario ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cod_responsable[row] = ls_null
			this.object.nom_usuario		[row] = ls_null
			return 1
		end if

		this.object.nom_usuario		[row] = ls_desc
		

CASE 'cencos' 
		// Verifica que centro_costo exista
		Select desc_cencos
	     into :ls_desc
		  from centros_costo
		  Where cencos = :data 
		    and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Centro de Costo ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)

			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null			
			return 1
		end if

		this.object.desc_cencos[row] = ls_desc
		
	CASE "cod_origen" 
		//Verifica que exista dato ingresado	
		Select nombre
	     into :ls_desc
		  from origen
		  Where cod_origen = :data 
		    and flag_estado = '1';
					
		If SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Origen ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cod_origen	[row] = ls_null
			this.object.nom_origen	[row] = ls_null
			return 1
		end if
			
		this.object.nom_origen	[row] = ls_desc

END CHOOSE


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc

select nombre
	into :ls_desc
from origen
where cod_origen = :gnvo_app.is_origen;

this.object.cod_origen 			[al_row] = gnvo_app.is_origen
this.object.nom_origen 			[al_row] = ls_desc
this.object.flag_estado			[al_row] = '1'
this.object.flag_cntrl_lote 	[al_row] = '0'

this.object.cod_empresa			[al_row] = gnvo_app.invo_empresa.is_empresa
this.object.nom_empresa			[al_row] = gnvo_app.invo_empresa.is_desc_empresa
end event

type dw_lista from u_dw_list_tbl within w_al001_almacenes
integer x = 503
integer y = 284
integer width = 1477
integer height = 904
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_almacen_tbl"
end type

event constructor;call super::constructor;
ii_ck[1] = 1         // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

dw_master.SetTransObject(SQLCA)
dw_lista.of_share_lista(dw_master)
dw_master.Retrieve(gnvo_app.invo_empresa.is_empresa)
dw_lista.of_sort_lista()
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)   // Selecciona registro	

end event

