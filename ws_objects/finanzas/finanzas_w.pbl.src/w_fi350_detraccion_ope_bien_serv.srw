$PBExportHeader$w_fi350_detraccion_ope_bien_serv.srw
forward
global type w_fi350_detraccion_ope_bien_serv from w_abc
end type
type sle_1 from singlelineedit within w_fi350_detraccion_ope_bien_serv
end type
type st_1 from statictext within w_fi350_detraccion_ope_bien_serv
end type
type cb_1 from commandbutton within w_fi350_detraccion_ope_bien_serv
end type
type dw_master from u_dw_abc within w_fi350_detraccion_ope_bien_serv
end type
end forward

global type w_fi350_detraccion_ope_bien_serv from w_abc
integer width = 2007
integer height = 772
string title = "Datos Detraccion "
string menuname = "m_proceso"
sle_1 sle_1
st_1 st_1
cb_1 cb_1
dw_master dw_master
end type
global w_fi350_detraccion_ope_bien_serv w_fi350_detraccion_ope_bien_serv

on w_fi350_detraccion_ope_bien_serv.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.sle_1=create sle_1
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_fi350_detraccion_ope_bien_serv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query


of_position_window(0,0)       			// Posicionar la ventana en forma fija

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
END IF

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type sle_1 from singlelineedit within w_fi350_detraccion_ope_bien_serv
integer x = 576
integer y = 36
integer width = 443
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi350_detraccion_ope_bien_serv
integer x = 37
integer y = 48
integer width = 489
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Detracción :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi350_detraccion_ope_bien_serv
integer x = 1518
integer y = 36
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;String ls_nro_detr 


ls_nro_detr = sle_1.text



dw_master.retrieve(ls_nro_detr)

end event

type dw_master from u_dw_abc within w_fi350_detraccion_ope_bien_serv
integer x = 9
integer y = 196
integer width = 1915
integer height = 356
string dataobject = "d_abc_detraccion_operac_bien_serv_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;String ls_null
Long   ll_count

Accepttext()


choose case dwo.name
		 case 'oper_detr'
				select Count(*) into :ll_count
				  from detr_operacion
				 where (oper_detr   = :data ) and
				 		 (flag_estado = '1'   ) ;
										 
				
				if ll_count = 0 then
					Messagebox('Aviso','Operacion de la detracción no existe ,Verifique!')
					dw_master.object.oper_detr [row] = SetNull(ls_null)
					Return 1
				end if
				
				
		 case 'bien_serv'
				select Count(*) into :ll_count
				  from detr_bien_serv
				 where (bien_serv   = :data) and
				 		 (flag_estado = '1'	) ;
						  
				if ll_count = 0 then		  
					Messagebox('Aviso','Tipo de Bien o servicio de la detracción no existe ,Verifique!')
					dw_master.object.bien_serv [row] = Setnull(ls_null)
				end if	
				
end choose



end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;str_seleccionar lstr_seleccionar


lstr_seleccionar.s_seleccion = 'S'


choose case dwo.name
		 case 'oper_detr'
				lstr_seleccionar.s_sql = 'SELECT OPER_DETR AS CODIGO				,'&
		   								  +'DESCRIPCION			   AS DETALLE_OPERACION  '&
										     +'FROM DETR_OPERACION '&
										     +'WHERE FLAG_ESTADO = '+"'"+'1'+"'"
										 

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					dw_master.object.oper_detr[row] = lstr_seleccionar.param1[1]
					dw_master.ii_update = 1
				END IF
				
		 case 'bien_serv'
				lstr_seleccionar.s_sql = 'SELECT BIEN_SERV   AS CODIGO         ,'&
	   										+'DESCRIPCION AS DETALLE_BIEN_SERVICIO  '&
											   +'FROM DETR_BIEN_SERV '&
                                    +'WHERE FLAG_ESTADO = '+"'"+'1'+"'"
										 

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					dw_master.object.bien_serv[row] = lstr_seleccionar.param1[1]
					dw_master.ii_update = 1					
				END IF

			
end choose



end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

idw_mst  = dw_master

end event

event itemerror;call super::itemerror;RETURN 1
end event

