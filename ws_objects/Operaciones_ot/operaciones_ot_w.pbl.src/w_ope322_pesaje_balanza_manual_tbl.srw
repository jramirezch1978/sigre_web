$PBExportHeader$w_ope322_pesaje_balanza_manual_tbl.srw
forward
global type w_ope322_pesaje_balanza_manual_tbl from w_abc
end type
type uo_2 from u_ingreso_rango_fechas_horas_new within w_ope322_pesaje_balanza_manual_tbl
end type
type cb_1 from commandbutton within w_ope322_pesaje_balanza_manual_tbl
end type
type dw_master from u_dw_abc within w_ope322_pesaje_balanza_manual_tbl
end type
type gb_1 from groupbox within w_ope322_pesaje_balanza_manual_tbl
end type
end forward

global type w_ope322_pesaje_balanza_manual_tbl from w_abc
integer width = 3849
integer height = 1816
string title = "Pesaje Manual (OPE322)"
string menuname = "m_master_sin_lista"
uo_2 uo_2
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_ope322_pesaje_balanza_manual_tbl w_ope322_pesaje_balanza_manual_tbl

forward prototypes
public subroutine wf_update_partes_pesajes ()
public subroutine wf_proc_partes ()
end prototypes

public subroutine wf_update_partes_pesajes ();String ls_msj_err
Long ll_inicio
Date ld_fecha
Boolean lb_ret = TRUE

dw_master.Accepttext()



For ll_inicio = 1 to dw_master.rowcount ()
	 ld_fecha = Date(dw_master.object.fecha [ll_inicio])
	 
	 Insert Into tt_ope_fechas 
	 (fecha,origen,cod_usr)
	 Values
	 (:ld_fecha,:gs_origen,:gs_user) ;
	 
	 
	 IF SQLCA.SQLCode = -1 THEN 
		 LB_RET = FALSE
       ls_msj_err = SQLCA.SQLErrText + ' Comunicarse con el Area de Sistemas '
		 GOTO SALIDA
	 END IF
Next	


SALIDA:
IF lb_ret = false then
	Messagebox('Aviso',ls_msj_err)
end if
end subroutine

public subroutine wf_proc_partes ();String  ls_nada,ls_msj_err
Boolean lb_ret = TRUE

//ejecuta procedimeinto de asigancion de labores
DECLARE PB_usp_ope_partes_destajo_man PROCEDURE FOR usp_ope_partes_destajo_man
(:ls_nada);
EXECUTE pb_usp_ope_partes_destajo_man ;
	
IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText + ' Comunicarse con el Area de Sistemas '
	lb_ret = FALSE
END IF

IF lb_ret then
	Commit ;
	DELETE FROM tt_ope_fechas ;
Else
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF


end subroutine

on w_ope322_pesaje_balanza_manual_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.uo_2=create uo_2
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.gb_1
end on

on w_ope322_pesaje_balanza_manual_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_2)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

dw_master.of_protect()         		// bloquear modificaciones 


of_position_window(0,0)       			// Posicionar la ventana en forma fija


DELETE FROM tt_ope_fechas ;
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0

	//ejecutar proced
	wf_update_partes_pesajes ()
	
	wf_proc_partes()
END IF
end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if
end event

event ue_delete;Long ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

wf_update_partes_pesajes ()


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

type uo_2 from u_ingreso_rango_fechas_horas_new within w_ope322_pesaje_balanza_manual_tbl
integer x = 82
integer y = 72
integer height = 140
integer taborder = 70
end type

on uo_2.destroy
call u_ingreso_rango_fechas_horas_new::destroy
end on

type cb_1 from commandbutton within w_ope322_pesaje_balanza_manual_tbl
integer x = 3154
integer y = 48
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Datetime ld_fecha_inicial,ld_fecha_final


ld_fecha_inicial = uo_2.of_get_fecha1()
ld_fecha_final   = uo_2.of_get_fecha2()






dw_master.Retrieve(ld_fecha_inicial,ld_fecha_final)



end event

type dw_master from u_dw_abc within w_ope322_pesaje_balanza_manual_tbl
integer x = 27
integer y = 264
integer width = 3758
integer height = 1344
string dataobject = "d_abc_pesaje_prod_manual_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3


idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot 

Str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'codprd'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRODUCTO_PESAJE.CODPRD AS CODIGO,'&
														 +'PRODUCTO_PESAJE.DESCRIPCION AS DESCRIPCION '&
			   										 +'FROM PRODUCTO_PESAJE '&
														 +'WHERE PRODUCTO_PESAJE.FLAG_ESTADO = '+"'"+'1'+"'"
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'codprd',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'cod_trabajador'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT vw_ope_maestro_tarjetas.COD_TRABAJADOR  AS CLIENTE,'&
		      							 			 +'vw_ope_maestro_tarjetas.APEL_PATERNO AS APELLIDO_PATERNO,'&
								 					    +'vw_ope_maestro_tarjetas.APEL_MATERNO AS APELLIDO_MATERNO, '&
								 						 +'vw_ope_maestro_tarjetas.NOMBRE1 AS NOMBRE1,'&
								 						 +'vw_ope_maestro_tarjetas.NOMBRE2 AS NOMBRE2,'&
								 						 +'vw_ope_maestro_tarjetas.COD_ORIGEN AS ORIGEN,'&
								 						 +'vw_ope_maestro_tarjetas.COD_TARJETA AS TARJETA '&
			   				 						 +'FROM vw_ope_maestro_tarjetas'&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					if isnull(lstr_seleccionar.param2[1])  then
						lstr_seleccionar.param2[1] = ''
					end if

					if isnull(lstr_seleccionar.param3[1]) then
						lstr_seleccionar.param3[1] = ''
					end if
	
					if isnull(lstr_seleccionar.param4[1])  then
						lstr_seleccionar.param4[1] = ''
					end if
	
					if isnull(lstr_seleccionar.param5[1])  then
						lstr_seleccionar.param5[1] = ''
					end if
					
					Setitem(row,'cod_trabajador',lstr_seleccionar.param1[1])
					Setitem(row,'nombres',lstr_seleccionar.param2[1]+' '+lstr_seleccionar.param3[1]+' '+lstr_seleccionar.param4[1]+' '+lstr_seleccionar.param5[1])
					Setitem(row,'codtjt',lstr_seleccionar.param7[1])
					ii_update = 1
				END IF
				
							
END CHOOSE


end event

event ue_insert_pre;call super::ue_insert_pre;Datetime ld_fecha_inicial

ld_fecha_inicial = uo_2.of_get_fecha1()

this.object.FLAG_ING_INF [al_row] = 'M'
this.object.fecha        [al_row] = ld_fecha_inicial

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)	
end event

event itemerror;call super::itemerror;return 1
end event

type gb_1 from groupbox within w_ope322_pesaje_balanza_manual_tbl
integer x = 27
integer y = 24
integer width = 2331
integer height = 216
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha"
end type

