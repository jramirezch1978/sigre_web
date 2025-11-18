$PBExportHeader$w_pr007_incidencias.srw
forward
global type w_pr007_incidencias from w_abc_master_smpl
end type
end forward

global type w_pr007_incidencias from w_abc_master_smpl
integer width = 3118
integer height = 1612
string title = "Maestro de incidencias (PR007)"
string menuname = "m_prod_mant"
end type
global w_pr007_incidencias w_pr007_incidencias

on w_pr007_incidencias.create
call super::create
if this.MenuName = "m_prod_mant" then this.MenuID = create m_prod_mant
end on

on w_pr007_incidencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_incidencia.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_incidencia')
END IF


end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 7
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

//--VERIFICACION Y ASIGNACION DE TIPO DE MAQUINA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_pr007_incidencias
integer x = 0
integer y = 0
integer width = 3063
integer height = 1308
string dataobject = "d_abc_incidencias_tbl"
end type

event dw_master::itemchanged;call super::itemchanged;String  ls_codigo,ls_descripcion, ls_null
SetNull(ls_null)

this.Accepttext()

CHOOSE CASE dwo.name
	// Busca si cuenta contable existe
	CASE 'clase'
		SELECT descripcion
		  INTO :ls_descripcion
		  FROM incidencia_clase
		 WHERE clase = :data ; 

		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Clase de incidencia no existe, Verifique! ',StopSign!)
			This.object.clase 		[row] = ls_null
			This.object.desc_clase 	[row] = ls_null
			Return 1
		END IF
			 
		This.object.desc_clase [row] = ls_descripcion
			
END CHOOSE

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	CASE 'clase'
	
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT INCIDENCIA_CLASE.CLASE AS CLASE, '&
												 +'INCIDENCIA_CLASE.DESCRIPCION AS DESCRIPCION '&
												 +'FROM INCIDENCIA_CLASE ' 
		
								  
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.clase 		[row] = lstr_seleccionar.param1[1]
			this.object.desc_clase	[row] = lstr_seleccionar.param2[1]
			this.ii_update = 1
		END IF
	
END CHOOSE

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

