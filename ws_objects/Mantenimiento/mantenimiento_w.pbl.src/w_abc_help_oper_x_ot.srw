$PBExportHeader$w_abc_help_oper_x_ot.srw
forward
global type w_abc_help_oper_x_ot from window
end type
type dw_datos from uo_datawindow within w_abc_help_oper_x_ot
end type
type cb_3 from commandbutton within w_abc_help_oper_x_ot
end type
type cb_2 from commandbutton within w_abc_help_oper_x_ot
end type
type cb_1 from commandbutton within w_abc_help_oper_x_ot
end type
type dw_arg from datawindow within w_abc_help_oper_x_ot
end type
end forward

global type w_abc_help_oper_x_ot from window
integer width = 2066
integer height = 1220
boolean titlebar = true
string title = "Operaciones x Orden Trabajo"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_aceptar ( )
event ue_cancel ( )
dw_datos dw_datos
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_arg dw_arg
end type
global w_abc_help_oper_x_ot w_abc_help_oper_x_ot

type variables
str_seleccionar istr_seleccionar
end variables

event ue_aceptar();Long ll_inicio , ll_j


FOR ll_inicio = 1 TO dw_datos.rowcount ()
 	 IF dw_datos.IsSelected(ll_inicio)  THEN 
		 ll_j = ll_j + 1
		 
		 istr_seleccionar.paramdc1[ll_j] = dw_datos.GetItemDecimal (ll_inicio, 5)  //oper_sec
		 istr_seleccionar.paramdt2[ll_j] = dw_datos.GetItemDateTime(ll_inicio,7)  //fecha inicio estimada
		 istr_seleccionar.paramdc3[ll_j] = dw_datos.GetItemDecimal (ll_inicio, 8)  //nro personas
		 istr_seleccionar.paramdc4[ll_j] = dw_datos.GetItemDecimal (ll_inicio, 9)  //cant_proyect
		 istr_seleccionar.param5  [ll_j] = dw_datos.GetItemString  (ll_inicio, 1)  //labor
		 istr_seleccionar.param6  [ll_j] = dw_datos.GetItemString  (ll_inicio, 3)  //maquina
		 		 
	END IF			  
	 
NEXT


istr_seleccionar.s_action = 'aceptar'
CloseWithReturn(this,istr_seleccionar)

end event

event ue_cancel();istr_seleccionar.s_action = 'cancelar'
CloseWithReturn(this,istr_seleccionar)

end event

on w_abc_help_oper_x_ot.create
this.dw_datos=create dw_datos
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_arg=create dw_arg
this.Control[]={this.dw_datos,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_arg}
end on

on w_abc_help_oper_x_ot.destroy
destroy(this.dw_datos)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_arg)
end on

event open;f_centrar(this)
dw_datos.SettransObject(sqlca)


istr_seleccionar.s_seleccion = 'M'



end event

type dw_datos from uo_datawindow within w_abc_help_oper_x_ot
integer x = 14
integer y = 416
integer width = 1970
integer height = 692
integer taborder = 50
string dataobject = "d_abc_lista_oper_x_ot_x_ccr_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event rowfocuschanged;call super::rowfocuschanged;

uf_seleccion(dw_datos,istr_seleccionar.s_seleccion)

end event

type cb_3 from commandbutton within w_abc_help_oper_x_ot
integer x = 1682
integer y = 228
integer width = 357
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
end type

event clicked;Parent.TriggerEvent('ue_cancel')
end event

type cb_2 from commandbutton within w_abc_help_oper_x_ot
integer x = 1682
integer y = 120
integer width = 357
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
end type

event clicked;Parent.TriggerEvent('ue_aceptar')
end event

type cb_1 from commandbutton within w_abc_help_oper_x_ot
integer x = 1682
integer y = 12
integer width = 357
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;String ls_cc_resp,ls_fecha_inicio,ls_fecha_final

dw_arg.accepttext()

ls_cc_resp      = dw_arg.Object.cencos       [1] 
ls_fecha_inicio = String(dw_arg.Object.fecha_inicio [1],'yyyymmdd')
ls_fecha_final  = String(dw_arg.Object.fecha_final  [1],'yyyymmdd')

IF Isnull(ls_cc_resp) OR Trim(ls_cc_resp) = '' THEN
	Messagebox('Aviso','Debe Ingresar Algun Centro de Costo')
	Return
END IF



dw_datos.Retrieve(ls_cc_resp,ls_fecha_inicio,ls_fecha_final)
end event

type dw_arg from datawindow within w_abc_help_oper_x_ot
integer x = 14
integer y = 12
integer width = 1614
integer height = 360
integer taborder = 10
string title = "none"
string dataobject = "d_ext_datos_x_ope_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_cencos,ls_desc_cencos
Long   ll_count


Accepttext()



CHOOSE CASE dwo.name
		 CASE 'cencos'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM centros_costo
				 WHERE (cencos = :data) ;
				 
				IF ll_count > 0 THEN
					SELECT desc_cencos
					  INTO :ls_desc_cencos
					  FROM centros_costo
					 WHERE (cencos = :data) ;
					 
					 This.Object.desc_cencos [row] = ls_desc_cencos
					
				ELSE
					SetNull(ls_cencos)
					SetNull(ls_desc_cencos)
					Messagebox('Aviso','Debe Ingresar Un Centro de Costo Valido , Verifique!')
					This.Object.cencos      [row] = ls_cencos
					This.Object.desc_cencos [row] = ls_desc_cencos
					Return 1
				END IF
		
END CHOOSE

end event

event itemerror;Return 1 
end event

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;IF row < 1 then return 1
Datawindow ldw
str_seleccionar lstr_seleccionar
dwobject   dwo1


CHOOSE CASE dwo.name
		 CASE 'cencos'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
		      										 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
					 		   						 +'FROM CENTROS_COSTO '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)	
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
				IF lstr_seleccionar.s_action = "aceptar" THEN
				   Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
				END IF
				
		CASE 'fecha_inicio','fecha_final'
			
				ldw = this
			   f_call_calendar(ldw,dwo.name,dwo.coltype,row)
		
END CHOOSE

				
				
				
				
end event

