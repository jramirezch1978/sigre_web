$PBExportHeader$w_ma300_manten_prog_maq.srw
forward
global type w_ma300_manten_prog_maq from w_abc
end type
type dw_master from u_dw_abc within w_ma300_manten_prog_maq
end type
end forward

global type w_ma300_manten_prog_maq from w_abc
integer width = 3040
integer height = 1184
string title = "Programa de mantenimiento de máquinas (MA300)"
string menuname = "m_abc_master_list"
dw_master dw_master
end type
global w_ma300_manten_prog_maq w_ma300_manten_prog_maq

type variables
DatawindowChild idw_child
String is_accion
end variables

forward prototypes
public subroutine wf_retrieve_dw (long al_nro_manten_prog)
public function long wf_asig_nro_manten_prog ()
end prototypes

public subroutine wf_retrieve_dw (long al_nro_manten_prog);
IF al_nro_manten_prog = 0 THEN
	SELECT NVL(MAX(nro_mantenimiento),0)
	INTO   :al_nro_manten_prog
	FROM   manten_prog ;
END IF

IF Isnull(al_nro_manten_prog) OR al_nro_manten_prog = 0 THEN
	TriggerEvent('ue_insert')	
ELSE
	dw_master.retrieve(al_nro_manten_prog)
	is_accion = 'fileopen'
END IF


end subroutine

public function long wf_asig_nro_manten_prog ();Long ll_ult_nro

SELECT NVL(ULT_NRO,0) 
INTO	 :ll_ult_nro
FROM   NUM_MANTEN_PROG
WHERE  RECKEY = '1' 
FOR UPDATE ;
	
UPDATE NUM_MANTEN_PROG
SET    ULT_NRO = :ll_ult_nro + 1
WHERE  RECKEY = '1' ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	ll_ult_nro = 0
END IF

Return ll_ult_nro
end function

on w_ma300_manten_prog_maq.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ma300_manten_prog_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)

idw_1 = dw_master              // asignar dw corriente

dw_master.of_protect()         // bloquear modificaciones 

of_position_window(0,0)        // Posicionar la ventana en forma fija

//Help
ii_help = 300    

wf_retrieve_dw(0)

//Insertamos un child como filtro
dw_master.Getchild("tipo_manten",idw_child)
idw_child.settransobject(sqlca)
end event

event ue_insert();Long  ll_row

TriggerEvent('ue_update_request')
idw_1.Reset()
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
	is_accion = 'new'
END IF

end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result, li_update

li_update = dw_master.ii_update 
// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF li_update > 0 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event ue_update_pre();call super::ue_update_pre;
Long    ll_nro_mant_prog

dw_master.AcceptText() 

IF is_accion = 'delete' THEN RETURN


//--VERIFICACION Y ASIGNACION DE DATOS DE ORDEN DE TRABAJO
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if



IF is_accion = 'new' THEN
	ll_nro_mant_prog =	wf_asig_nro_manten_prog ()	
	IF Isnull(ll_nro_mant_prog) OR ll_nro_mant_prog = 0 THEN
		Messagebox('Aviso','Verifique Tabla NUM_MANTEN_PROG ,Comuniquese con Sistemas')
		ib_update_check = False	
		Return
	END IF	
	
	dw_master.object.nro_mantenimiento [1] = ll_nro_mant_prog
ELSE
	ll_nro_mant_prog = dw_master.object.nro_mantenimiento [1] 
END IF

end event

event ue_update();Boolean lbo_ok = TRUE




THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

dw_master.AcceptText()


	
IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	IF is_accion = 'delete'	THEN
		wf_retrieve_dw(0)
	ELSE
		is_accion = 'fileopen'		
	END IF

ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = "d_abc_manten_prog_tbl"
sl_param.titulo = "Mantenimientos Programados"
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	wf_retrieve_dw(Long(sl_param.field_ret[1]))
	is_accion = 'fileopen'
	dw_master.ii_update = 0
	TriggerEvent('ue_modify')
END IF

end event

event ue_delete();call super::ue_delete;is_accion = 'delete'
end event

type dw_master from u_dw_abc within w_ma300_manten_prog_maq
integer x = 23
integer y = 16
integer width = 2958
integer height = 968
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_manten_prog_ff"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw



end event

event doubleclicked;call super::doubleclicked;IF row < 1 THEN RETURN
String ls_prot, ls_name
Str_seleccionar lstr_seleccionar
Datawindow ldw
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

ldw = this
IF dwo.type <> 'column' THEN return 1

CHOOSE CASE dwo.name
	CASE 'mant_precedente'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT VW_MAN_MANTEN_PROG.MANTEN AS PROG_MANTEN, '&
										 +'VW_MAN_MANTEN_PROG.MAQUINA AS MAQUINA, '&
										 +'VW_MAN_MANTEN_PROG.DESCRIP AS DESCRIP, '&
										 +'VW_MAN_MANTEN_PROG.TIPO_MANTEN AS TIPO_MANTEN, '&
										 +'VW_MAN_MANTEN_PROG.FEC_ESTIMADA AS FEC_ESTIMADA, '&
										 +'VW_MAN_MANTEN_PROG.FEC_REAL AS FEC_REAL '&
										 +'FROM VW_MAN_MANTEN_PROG ' 
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				Setitem( row, 'mant_precedente', lstr_seleccionar.paramdc1[1] )
				ii_update = 1
			END IF
	CASE 'cod_maquina'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS COD_MAQUINA, '&
										 +'MAQUINA.DESC_MAQ AS DESCRIPCION, '&
										 +'MAQUINA.COD_MARCA AS MARCA, '&
										 +'MAQUINA.MODELO AS MODELO '&
										 +'FROM MAQUINA ' 
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
				ii_update = 1
			END IF

	CASE 'fec_real'
        f_call_calendar(ldw,'fec_real',dwo.coltype,row)
	CASE 'fec_proyect'
		  f_call_calendar(ldw,'fec_proyect',dwo.coltype,row)
END CHOOSE		  

////////////////

CHOOSE CASE dwo.name
		 CASE 'cnta_oper'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
				//										 +'WHERE LENGTH(LTRIM(RTRIM(CNTBL_CNTA.CNTA_CTBL))) = 10'
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_oper',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		CASE 'labor_cnta_prsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CUENTA_PPTTO, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA ' 

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'labor_cnta_prsp',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;DATE ld_fec_estimada
ld_fec_estimada = today()
dw_master.SetItem( al_row, "manten_prog_fec_estimada" , ld_fec_estimada )


end event

event itemchanged;call super::itemchanged;Accepttext()

end event

event itemerror;call super::itemerror;Return 1
end event

