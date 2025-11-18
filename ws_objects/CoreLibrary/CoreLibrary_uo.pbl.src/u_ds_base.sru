$PBExportHeader$u_ds_base.sru
forward
global type u_ds_base from datastore
end type
end forward

global type u_ds_base from datastore
event type boolean of_existtext ( string as_campo )
end type
global u_ds_base u_ds_base

type variables
Integer  ii_update
end variables

forward prototypes
public subroutine of_set_flag_replicacion ()
public function boolean of_existstext (string as_campo)
public function boolean of_existecampo (string as_campo)
public function boolean of_existscampo (string as_campo)
public function boolean of_existepicture (string as_campo)
public function boolean of_existspicturename (string as_campo)
end prototypes

event type boolean of_existtext(string as_campo);IF this.Describe(as_campo + ".text") = '!' THEN return false
end event

public subroutine of_set_flag_replicacion ();// Verificar si este DW tiene FLAG_REPLICACION
IF this.Describe("flag_replicacion.ColType") = '!' THEN return

Long ll_nro_regs, ll_row = 0, ll_count = 0

THIS.AcceptText()

ll_nro_regs = this.RowCount()

DO WHILE ll_row <= ll_nro_regs
   ll_row = this.GetNextModified(ll_row, Primary!)
   IF ll_row <= 0 THEN EXIT
   THIS.object.flag_replicacion[ll_row]='1'
//   ll_count = ll_count + 1
LOOP

//MessageBox("Modified Count", String(ll_count) + " rows were modified.")
end subroutine

public function boolean of_existstext (string as_campo);IF this.Describe(as_campo + ".text") = '!' THEN return false

return true
end function

public function boolean of_existecampo (string as_campo);IF this.Describe(as_campo + ".ColType") = '!' THEN return false

return true
end function

public function boolean of_existscampo (string as_campo);return this.of_ExisteCampo(as_campo)
end function

public function boolean of_existepicture (string as_campo);IF this.Describe(as_campo + ".filename") = '!' THEN return false

return true
end function

public function boolean of_existspicturename (string as_campo);IF this.Describe(as_campo + ".filename") = '!' THEN return false

return true
end function

event dberror;String 	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer 	li_pos_ini, li_pos_fin, li_pos_nc
 
if sqldbcode > 20000 then
	ls_msg = SQLErrText
	ROLLBACK;
	MessageBox('Error en objeto u_ds_base ' + This.Classname(), "Error en base de datos: " + ls_msg, StopSign!)
	return
end if
 
ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1
 
ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)
 
CHOOSE CASE sqldbcode 
	CASE 02292                         
		// Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
			INTO :ls_name
		FROM ALL_CONSTRAINTS
		WHERE OWNER          	= :ls_prop 
		  AND CONSTRAINT_NAME 	= :ls_const ;
		
		ROLLBACK;
		Messagebox('Error FK en u_ds_base','Registro Tiene Movimientos en Tabla: '+ls_name, stopSign!)
		Return 1
		
	CASE ELSE
		ls_msg += 'Mensaje de Error: ' + SQLErrText + ls_crlf
		ls_msg += '/********************************************/' + ls_crlf
		ls_msg += 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		ROLLBACK;
		messagebox("Error en objeto u_ds_base " + this.ClassName(), ls_msg, StopSign!)
		
END CHOOSE


end event

on u_ds_base.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_base.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event itemchanged;ii_update = 1



end event

