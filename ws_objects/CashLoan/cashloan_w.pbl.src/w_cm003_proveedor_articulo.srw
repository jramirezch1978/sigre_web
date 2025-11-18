$PBExportHeader$w_cm003_proveedor_articulo.srw
forward
global type w_cm003_proveedor_articulo from w_abc
end type
type cb_1 from commandbutton within w_cm003_proveedor_articulo
end type
type dw_2 from datawindow within w_cm003_proveedor_articulo
end type
type dw_1 from datawindow within w_cm003_proveedor_articulo
end type
type gb_1 from groupbox within w_cm003_proveedor_articulo
end type
end forward

global type w_cm003_proveedor_articulo from w_abc
integer width = 2587
integer height = 1452
string title = "Proveedores Calificados (CM003)"
string menuname = "m_mantto_smpl"
cb_1 cb_1
dw_2 dw_2
dw_1 dw_1
gb_1 gb_1
end type
global w_cm003_proveedor_articulo w_cm003_proveedor_articulo

type variables
Integer ii_update = 0
end variables

on w_cm003_proveedor_articulo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_cm003_proveedor_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_row

ll_row = dw_2.insertrow(0)

end event

event ue_update;call super::ue_update;DateTime ldt_fecha
Boolean lbo_ok = TRUE
Long ll_row


ldt_fecha = dateTime(today())

dw_1.AcceptText()

ll_row = dw_1.getrow()
dw_1.object.fecha_calificacion[ll_row] = ldt_fecha
dw_1.object.cod_usr[ll_row] = gs_user


IF dw_1.Update() = -1 then		// Grabacion del detalle
	lbo_ok = FALSE
   Rollback ;
	messagebox("Error en Grabacion","Se ha procedido al rollback",exclamation!)
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	ii_update = 0
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF ii_update = 1  THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		ii_update = 0
	END IF
END IF

end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

type cb_1 from commandbutton within w_cm003_proveedor_articulo
integer x = 731
integer y = 148
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;String ls_proveedor, ls_flag, ls_cali
Datetime ldt_fecha

ls_proveedor = dw_2.object.proveedor[1]
ls_flag      = dw_2.object.flag_calificacion[1]
ldt_fecha    = datetime(today(),time(today()))

IF Trim(ls_flag)='' or isnull(ls_flag) then
   Messagebox('Aviso','Debe Ingresar tipo de Calificación')
Else   
	IF Trim(ls_proveedor)='' or isnull(ls_proveedor) then
	   Messagebox('Aviso','Debe Ingresar un Proveedor')
	Else

		UPDATE proveedor_articulo
			SET flag_calificacion  = :ls_flag,
		    	 fecha_calificacion = :ldt_fecha,
			 	 cod_usr = :gs_user
       WHERE proveedor = :ls_proveedor ;
	
		dw_1.SetTransObject(sqlca)
		dw_1.retrieve(ls_proveedor)
		
	END IF
End If

end event

type dw_2 from datawindow within w_cm003_proveedor_articulo
integer x = 78
integer y = 56
integer width = 2373
integer height = 168
integer taborder = 10
string title = "none"
string dataobject = "d_abc_proveedor_articulo_selec_tbl"
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long   ll_count
String ls_codigo,ls_nom_proveedor
Accepttext()

CHOOSE CASE dwo.name
		CASE 'proveedor'
				SELECT Count(*)
   			INTO :ll_count
			   FROM Proveedor
				WHERE (proveedor = :data);  
				IF ll_count <= 0 THEN
					messagebox('Aviso','Proveedor No Existe')
			      Return 1
			   END IF
				SELECT nom_proveedor
   			INTO :ls_nom_proveedor
			   FROM Proveedor
				WHERE (proveedor = :data);  
		      dw_2.object.t_proveedor.text = ls_nom_proveedor
END CHOOSE

end event

event doubleclicked;String ls_name, ls_prot, ls_descri, ls_codigo
IF Getrow() = 0 THEN Return
str_parametros sl_param


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


sl_param.dw1 = "d_sel_proveedores"
sl_param.titulo = "Proveedores"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	// Se ubica la cabecera
   Setitem(row,'proveedor',sl_param.field_ret[1])
   Select nom_proveedor Into :ls_descri
	From Proveedor Where Proveedor = :sl_param.field_ret[1];
	dw_2.object.t_proveedor.text = ls_descri
END IF
end event

event itemerror;return 1
end event

type dw_1 from datawindow within w_cm003_proveedor_articulo
integer x = 14
integer y = 264
integer width = 2510
integer height = 984
integer taborder = 10
string title = "none"
string dataobject = "d_abc_proveedor_articulo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;Long ll_row
datetime ldt_fecha

dw_1.AcceptText()

ii_update = 1


ldt_fecha = datetime(today(),time(today()))
ll_row = dw_1.getrow()

dw_1.object.fecha_calificacion	[ll_row] = ldt_fecha
dw_1.object.cod_usr					[ll_row] = gs_user
dw_1.object.flag_Replicacion		[ll_row] = '1'




end event

type gb_1 from groupbox within w_cm003_proveedor_articulo
integer x = 18
integer width = 2505
integer height = 244
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

