$PBExportHeader$w_fi002_tipo_impuesto.srw
forward
global type w_fi002_tipo_impuesto from w_abc
end type
type dw_master from u_dw_abc within w_fi002_tipo_impuesto
end type
end forward

global type w_fi002_tipo_impuesto from w_abc
integer width = 3072
integer height = 1008
string title = "[FI002] Tipo de Impuesto"
string menuname = "m_mtto_smpl"
dw_master dw_master
end type
global w_fi002_tipo_impuesto w_fi002_tipo_impuesto

on w_fi002_tipo_impuesto.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi002_tipo_impuesto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)    // Relacionar el dw con la base de datos
dw_master.retrieve()
idw_1 = dw_master              	  // asignar dw corriente
dw_master.of_protect()         	  // bloquear modificaciones 

of_position_window(0,0)       	  // Posicionar la ventana en forma fija
//ii_help = 101           			  // help topic

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

event ue_update_pre();call super::ue_update_pre;
//--VERIFICACION Y ASIGNACION 
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;
Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()
li_protect = integer(dw_master.Object.tipo_impuesto.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_impuesto.Protect = 1
END IF 

end event

event ue_insert();call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

type ole_skin from w_abc`ole_skin within w_fi002_tipo_impuesto
end type

type dw_master from u_dw_abc within w_fi002_tipo_impuesto
integer width = 3003
integer height = 800
string dataobject = "d_abc_tipo_impuesto_tbl"
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Integer li_count
Accepttext()

CHOOSE CASE dwo.name
		 CASE 'matriz'
				SELECT Count(*)
				INTO	 :li_count
				FROM   matriz_cntbl_finan
				WHERE  matriz = :data ; 

					
				IF li_count = 0 THEN
					Messagebox('Aviso','Matriz No existe, Verifique! ',StopSign!)
					This.object.matriz [row] = ''
					Return 1
				END IF
				
		 CASE 'cnta_ctbl'
				SELECT Count(*)
				INTO	 :li_count
				FROM   cntbl_cnta
				WHERE  cnta_ctbl = :data ; 
					
				IF li_count = 0 THEN
					Messagebox('Aviso','Cuenta Contable No existe, Verifique! ',StopSign!)
					This.object.cnta_ctbl [row] = ''
					Return 1
				END IF				
END CHOOSE


end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss 	= 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("tipo_impuesto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_impuesto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tasa_impuesto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("signo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("matriz.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_ctbl.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_dh_cxp.Protect='1~tIf(IsRowNew(),0,1)'")


end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
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
		 CASE 'matriz'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MATRIZ_CNTBL_FINAN.MATRIZ 		 AS MATRIZ, '&   
								         			 +'MATRIZ_CNTBL_FINAN.DESCRIPCION AS DESCRIPCION '&  
														 +'FROM MATRIZ_CNTBL_FINAN '&  
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'matriz',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
		 CASE 'cnta_ctbl'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA '

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF				
END CHOOSE


end event

