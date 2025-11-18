$PBExportHeader$w_ma004_marca.srw
forward
global type w_ma004_marca from w_abc
end type
type st_1 from statictext within w_ma004_marca
end type
type dw_master from u_dw_abc within w_ma004_marca
end type
end forward

global type w_ma004_marca from w_abc
integer width = 1403
integer height = 1600
string title = "Marcas de maquinas o equipos (MA004)"
string menuname = "m_master_simple"
st_1 st_1
dw_master dw_master
end type
global w_ma004_marca w_ma004_marca

on w_ma004_marca.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_1=create st_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_ma004_marca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)		// Relacionar el dw con la base de datos
idw_1 = dw_master                   // asignar dw corriente
dw_master.retrieve()
dw_master.of_protect()         		// bloquear modificaciones 
of_position_window(50,50)      			// Posicionar la ventana en forma fija

end event

event ue_insert();call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
//--VERIFICACION Y ASIGNACION DE MARCA DE MAQUINA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
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

event ue_modify();Integer li_protect
idw_1.of_protect()
li_protect = integer(dw_master.Object.cod_marca.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_marca.Protect = 1
END IF 

end event

type st_1 from statictext within w_ma004_marca
integer x = 192
integer y = 24
integer width = 937
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Marcas de máquinas o equipos"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_ma004_marca
integer x = 27
integer y = 112
integer width = 1307
integer height = 1288
string dataobject = "d_abc_marca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master

end event

