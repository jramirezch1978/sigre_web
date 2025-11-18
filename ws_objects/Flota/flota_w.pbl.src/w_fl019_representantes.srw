$PBExportHeader$w_fl019_representantes.srw
forward
global type w_fl019_representantes from w_abc_master_smpl
end type
end forward

global type w_fl019_representantes from w_abc_master_smpl
integer width = 2816
integer height = 900
string title = "Representantes y/o Administradores (FL019)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl019_representantes w_fl019_representantes

on w_fl019_representantes.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl019_representantes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl019_representantes
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2683
integer height = 616
string dataobject = "d_representantes_grid"
end type

event dw_master::ue_display(string as_columna, long al_row);string 	ls_codigo, ls_data, ls_sql
long 		ll_count
integer 	li_i
boolean 	lb_ret
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "CODIGO_BANCO"
		
		ls_sql = "SELECT CODIGO_BANCO AS CODIGO, " &
				 + "NOMBRE_DEL_BANCO AS DESCRIPCION " &
             + "FROM FL_BANCO"	
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.codigo_banco[al_row] 	  = ls_codigo
			this.object.nombre_banco[al_row] 	  = ls_data
			this.ii_update = 1
		end if

	case "PROVEEDOR"

		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROVEEDOR, " &
				 + "NOM_PROVEEDOR AS DESCRIPCION " &
             + "FROM PROVEEDOR " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.proveedor[al_row] 	  		= ls_codigo
			this.object.nombre_proveedor[al_row] 	= ls_data
			this.ii_update = 1
		end if
	
end choose
end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_null
long ll_row, ll_count

SetNull(ls_null)
this.AcceptText()
ll_row = this.GetRow()

choose case upper(dwo.name)
	case "CODIGO_BANCO"
//		ls_codigo = this.object.codigo_banco[ll_row]
		
	//	SetNull(ls_data)
		select nombre_del_banco
		 into :ls_data
		from fl_banco
		where codigo_banco = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CODIGO DE BANCO NO EXISTE", StopSign!)
			this.object.codigo_banco[ll_row] = ls_null
			this.object.nombre_banco[ll_row] = ls_null
			RETURN  1
		END IF
		
		this.object.nombre_banco[ll_row] = ls_data

	case "PROVEEDOR"

	//	ls_codigo = this.object.proveedor[ll_row]
		
//		SetNull(ls_data)
		select nom_proveedor
			into :ls_data
		from proveedor
		where proveedor = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CODIGO DE PROVEEDOR NO EXISTE", StopSign!)
			this.object.proveedor			[ll_row] = ls_null
			this.object.nombre_proveedor	[ll_row] = ls_null
			RETURN 1
		END IF
		
		this.object.nombre_proveedor[ll_row] = ls_data

	case "REPRESENTANTE"
		
		select count(*)
			into :ll_count
		from tg_representante
		where representante = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "CODIGO DE REPRESENTANTE YA EXISTE", StopSign!)
			return 1
		end if

end choose


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

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

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
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_codigo, ls_tmp
long		ll_tmp, ll_row

ll_tmp = 0
ls_codigo = gs_origen + string(ll_tmp, '000000')

for ll_row = 1 to this.RowCount()
	ls_tmp = this.object.representante[ll_row]
	if ls_tmp > ls_codigo then
		ll_tmp = Integer( Mid(ls_tmp, 3, 6) )
		ls_codigo = ls_tmp
	end if
next

ll_tmp ++
ls_codigo = gs_origen + string(ll_tmp, '000000')

this.object.representante[al_row] = ls_codigo


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

