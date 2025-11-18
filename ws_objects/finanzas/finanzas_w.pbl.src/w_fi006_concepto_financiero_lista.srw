$PBExportHeader$w_fi006_concepto_financiero_lista.srw
forward
global type w_fi006_concepto_financiero_lista from w_abc
end type
type dw_master from u_dw_abc within w_fi006_concepto_financiero_lista
end type
end forward

global type w_fi006_concepto_financiero_lista from w_abc
integer width = 4078
integer height = 1252
string title = "[FI006] Maestro Conceptos Financieros"
string menuname = "m_mantenimiento_cl"
dw_master dw_master
end type
global w_fi006_concepto_financiero_lista w_fi006_concepto_financiero_lista

type variables

end variables

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

on w_fi006_concepto_financiero_lista.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi006_concepto_financiero_lista.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF gnvo_app.of_row_Processing( dw_master ) <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF



dw_master.of_set_flag_replicacion ()
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

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

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
END IF


end event

event ue_open_pre();dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 

of_position_window(0,0)       		// Posicionar la ventana en forma fija
//ii_help = 101           				// help topic
wf_retrieve()
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;call super::ue_modify;Integer li_protect

dw_master.of_protect()


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_print;call super::ue_print;OpenWithParm(w_print_opt, dw_master)
If Message.DoubleParm = -1 Then Return
dw_master.Print(True)
end event

type dw_master from u_dw_abc within w_fi006_concepto_financiero_lista
integer width = 4014
integer height = 876
string dataobject = "d_abc_concepto_financiero_lista_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master				// dw_master
is_dwform = 'tabular'
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

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "grupo"
		ls_sql = "select grupo as grupo, " &
				 + "descripcion as desc_grupo " &
				 + "from cofin_grupo"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.grupo			[al_row] = ls_codigo
			this.object.desc_grupo	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "matriz_cntbl"
		ls_sql = "select m.matriz as matriz, " &
				 + "m.descripcion as desc_matriz " &
				 + "from matriz_cntbl_finan m " &
				 + "where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.matriz_cntbl		[al_row] = ls_codigo
			this.object.desc_matriz_cntbl	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_flujo_caja"
		ls_sql = "select m.cod_flujo_caja as codigo_flujo_caja, " &
				 + "m.descripcion as desc_flujo_caja " &
				 + "from codigo_flujo_caja m " &
				 + "where m.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_flujo_caja		[al_row] = ls_codigo
			this.object.desc_flujo_caja	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_Row] = '1'

this.setColumn('grupo')
end event

