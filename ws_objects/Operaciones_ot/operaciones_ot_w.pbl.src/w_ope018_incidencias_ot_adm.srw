$PBExportHeader$w_ope018_incidencias_ot_adm.srw
forward
global type w_ope018_incidencias_ot_adm from w_abc_master_smpl
end type
end forward

global type w_ope018_incidencias_ot_adm from w_abc_master_smpl
integer width = 3063
integer height = 1792
string title = "Incidencias por OT_ADM  (OPE018)"
string menuname = "m_master_sin_lista"
end type
global w_ope018_incidencias_ot_adm w_ope018_incidencias_ot_adm

on w_ope018_incidencias_ot_adm.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope018_incidencias_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_incidencia.protect")
ls_protect=dw_master.Describe("ot_adm.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_incidencia')
	dw_master.of_column_protect('ot_adm')
END IF


end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 7
end event

event ue_update_pre;call super::ue_update_pre;
//--VERIFICACION Y ASIGNACION DE TIPO DE MAQUINA
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_ope018_incidencias_ot_adm
integer x = 0
integer y = 4
integer width = 2999
integer height = 1308
string dataobject = "d_abc_incidencias_ot_adm_tbl"
end type

event dw_master::itemchanged;call super::itemchanged;String  ls_codigo,ls_descripcion, ls_null
SetNull(ls_null)
this.Accepttext()

CHOOSE CASE dwo.name
	// Busca si cuenta contable existe
	CASE 'ot_adm'
		SELECT descripcion
		  INTO :ls_descripcion
		  FROM ot_administracion
		 WHERE ot_adm = :data ; 
	
		// Verifica si existe el codigo
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','OT_ADM No existe, Verifique! ',StopSign!)
			This.object.ot_adm 		[row] = ls_null
			This.object.abrev_cnta 	[row] = ls_null
			Return 1
		END IF
			 
	 	This.object.desc_ot_adm [row] = ls_descripcion
			
	CASE 'cod_incidencia'
	
		SELECT desc_incidencia
		  INTO :ls_descripcion
		  FROM incidencias_dma
		 WHERE cod_incidencia = :data 
		   and flag_estado = '1';
				
			IF SQLCA.SQLCode = 100 THEN
				
				Messagebox('Aviso','Incidencia No existe o no esta activo, Verifique! ',StopSign!)
				This.object.cod_incidencia [row] = ls_null
				This.object.desc_incidencia[row] = ls_null
				Return 1
			END IF
				 
			This.object.desc_incidencia [row] = ls_descripcion
			
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
	 CASE 'ot_adm'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO, '&
													 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&
													 +'FROM OT_ADMINISTRACION ' 
	
									  
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				this.object.ot_adm	[row] 	= lstr_seleccionar.param1[1]
				this.object.desc_ot_adm [row] = lstr_seleccionar.param2[1]
				this.ii_update = 1
			END IF
	
	CASE 'cod_incidencia'
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT INCIDENCIAS_DMA.COD_INCIDENCIA AS CODIGO, '&
													 +'INCIDENCIAS_DMA.DESC_INCIDENCIA AS DESCRIPCION '&
													 +'FROM INCIDENCIAS_DMA ' 
	
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
					this.object.cod_incidencia [row] = lstr_seleccionar.param1 [1]
					this.object.desc_incidencia[row] = lstr_seleccionar.param2 [1]
					this.ii_update = 1
			END IF
END CHOOSE

end event

