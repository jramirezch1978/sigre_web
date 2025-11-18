$PBExportHeader$w_fi006_concepto_financiero.srw
forward
global type w_fi006_concepto_financiero from w_abc
end type
type dw_master from u_dw_abc within w_fi006_concepto_financiero
end type
end forward

global type w_fi006_concepto_financiero from w_abc
integer width = 1824
integer height = 1020
string title = "Concepto Financiero (FI006)"
string menuname = "m_mtto_lista"
dw_master dw_master
end type
global w_fi006_concepto_financiero w_fi006_concepto_financiero

forward prototypes
public subroutine wf_retrieve ()
end prototypes

public subroutine wf_retrieve ();String ls_confin

SELECT confin
  INTO :ls_confin
  FROM concepto_financiero 
 WHERE rownum = 1 ;
  
IF Isnull(ls_confin) OR Trim(ls_confin) = ''  THEN
	TriggerEvent('ue_insert')
ELSE
	
	idw_1.Retrieve(ls_confin)
END IF
end subroutine

on w_fi006_concepto_financiero.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi006_concepto_financiero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF



dw_master.of_set_flag_replicacion ()
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0

	END IF
END IF
end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 

of_position_window(0,0)       		// Posicionar la ventana en forma fija
//ii_help = 101           				// help topic
wf_retrieve()
end event

event ue_insert();call super::ue_insert;Long  ll_row

TriggerEvent('ue_update_request')

idw_1.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify();call super::ue_modify;Integer li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.confin.Protect)

IF li_protect = 0 THEN
   dw_master.Object.confin.Protect = 1
END IF 
end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_lista_concepto_financiero_tbl'
sl_param.titulo = 'Concepto Financiero'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1])
	dw_master.ii_update = 0
	TriggerEvent('ue_modify')
END IF

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type ole_skin from w_abc`ole_skin within w_fi006_concepto_financiero
end type

type dw_master from u_dw_abc within w_fi006_concepto_financiero
integer width = 1742
integer height = 784
string dataobject = "d_abc_concepto_financiero_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master				// dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Int 	 li_count = 0
String ls_descripcion = ''

Accepttext()

CHOOSE CASE dwo.name
		 CASE 'matriz_cntbl'

				SELECT descripcion
				INTO	 :ls_descripcion		
				FROM   matriz_cntbl_finan
				WHERE  matriz = :data ;

				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					Messagebox('Aviso','Matriz No existe , Verifique! ',StopSign!)
					This.object.matriz_cntbl [row] = ''
					This.Object.matriz_cntbl_finan_descripcion [row] = ''
					Return 1
				ELSE
					This.Object.matriz_cntbl_finan_descripcion [row] = ls_descripcion
				END IF
				
		 CASE 'cnta_prsp'
			
				SELECT descripcion
				INTO	 :ls_descripcion
				FROM   presupuesto_cuenta
				WHERE  cnta_prsp = :data ; 
					
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					Messagebox('Aviso','Cuenta Presupuestal No existe, Verifique! ',StopSign!)
					This.object.cnta_prsp [row] = ''
					This.object.presupuesto_cuenta_descripcion [row] = ''
					Return 1
				ELSE
					This.object.presupuesto_cuenta_descripcion [row] = ls_descripcion
				END IF
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'matriz_cntbl'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MATRIZ_CNTBL_FINAN.MATRIZ 		 AS MATRIZ_CONTABLE,		'&
														 +'MATRIZ_CNTBL_FINAN.DESCRIPCION AS DESCRIPCION '& 
														 +'FROM   MATRIZ_CNTBL_FINAN'

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'matriz_cntbl',lstr_seleccionar.param1[1])
					Setitem(row,'matriz_cntbl_finan_descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
														 
		 CASE 'cnta_prsp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CUENTA_PRESUPUESTAL, '&
														 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
														 +'FROM PRESUPUESTO_CUENTA '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					Setitem(row,'presupuesto_cuenta_descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 
		CASE 'cofin_reverso'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CONCEPTO_FINANCIERO.CONFIN AS CONFIN, '&
														 +'CONCEPTO_FINANCIERO.DESCRIPCION AS DESCRIPCION '&
														 +'FROM CONCEPTO_FINANCIERO '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cofin_reverso',lstr_seleccionar.param1[1])
					//Setitem(row,'presupuesto_cuenta_descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
			
END CHOOSE


end event

