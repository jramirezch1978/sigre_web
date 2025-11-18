$PBExportHeader$w_pr013_aprob_parte_piso.srw
forward
global type w_pr013_aprob_parte_piso from w_abc_master_smpl
end type
end forward

global type w_pr013_aprob_parte_piso from w_abc_master_smpl
integer width = 2528
integer height = 2048
string title = "Aprobadores de Partes de Piso y Formatos de Medición(PR013)"
string menuname = "m_mantto_smpl"
end type
global w_pr013_aprob_parte_piso w_pr013_aprob_parte_piso

on w_pr013_aprob_parte_piso.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr013_aprob_parte_piso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = true
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing(dw_master, 'tabular') = false then
	return
	ib_update_check = false
end if

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr013_aprob_parte_piso
event ue_display ( string as_columna,  long al_row )
integer width = 2395
integer height = 1820
string dataobject = "d_abc_aprob_parte_piso"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case upper(as_columna)
		
	case "APROBADOR"
		ls_sql = "SELECT upper(COD_USR) AS CODIGO_USUARIO, " &
				  + "NOMBRE AS NOMBRE_USUARIO " &
				  + "FROM USUARIO " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.aprobador		[al_row] = lower(ls_codigo)
			this.object.usuario_nombre	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

//str_seleccionar lstr_seleccionar

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if


//string 	ls_columna
//long 		ll_row 
//
//this.AcceptText()
//If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
//ll_row = row
//
//if row > 0 then
//	ls_columna = upper(dwo.name)
//	this.event dynamic ue_display(ls_columna, ll_row)
//end if
//
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "aprobador"
		
		ls_codigo = this.object.aprobador[row]

		SetNull(ls_data)
		select nombre
			into :ls_data
		from usuario
		where cod_usr = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Código de Usuario no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.aprobador	 [row] = ls_codigo
			this.object.usuario_nombre[row] = ls_codigo
			return 1
		end if

		this.object.usuario_nombre[row] = ls_data
end choose
end event

