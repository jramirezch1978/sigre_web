$PBExportHeader$w_pop_datos_asiento.srw
forward
global type w_pop_datos_asiento from window
end type
type cb_2 from commandbutton within w_pop_datos_asiento
end type
type cb_1 from commandbutton within w_pop_datos_asiento
end type
type dw_1 from datawindow within w_pop_datos_asiento
end type
end forward

global type w_pop_datos_asiento from window
integer width = 1595
integer height = 472
boolean titlebar = true
string title = "Ingrese Periodo de Pre - Asientos"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_pop_datos_asiento w_pop_datos_asiento

on w_pop_datos_asiento.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_pop_datos_asiento.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;str_parametros lstr_param

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
lstr_param = Message.PowerObjectParm

dw_1.InsertRow(0)

dw_1.Object.ano 		 [1] = lstr_param.longa[1]
dw_1.object.mes		 [1] = lstr_param.longa[2]
dw_1.Object.nro_libro [1] = lstr_param.longa[3]
//dw_1.Object.fec_cntbl [1] = lstr_param.fecha1
end event

type cb_2 from commandbutton within w_pop_datos_asiento
integer x = 1202
integer y = 164
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;str_parametros lstr_param
lstr_param.titulo = 'n'

CloseWithReturn(Parent,lstr_param)
end event

type cb_1 from commandbutton within w_pop_datos_asiento
integer x = 1198
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Long	ll_nro_libro,ll_ano,ll_mes
Date	ld_fec_cntbl			
str_parametros lstr_param

dw_1.Accepttext()

ll_nro_libro = dw_1.object.nro_libro [1]
ll_ano       = dw_1.object.ano       [1] 
ll_mes		 = dw_1.object.mes       [1]	
ld_fec_cntbl = Date(dw_1.object.fec_cntbl [1])

IF Isnull(ll_ano) THEN
	Messagebox('Aviso','Debe Ingresar Año')
	Return
END IF

IF Isnull(ll_mes) THEN
	Messagebox('Aviso','Debe Ingresar Mes')
	Return
END IF

IF Isnull(ll_nro_libro) THEN
	Messagebox('Aviso','Debe Seleccionar algun Nro. de Libro')
   Return	
END IF	

IF Isnull(ld_fec_cntbl) THEN
	Messagebox('Aviso','Debe Seleccionar Una fecha contable correcta')
   Return	
END IF	

lstr_param.longa[1] 	 = ll_ano
lstr_param.longa[2] 	 = ll_mes
lstr_param.longa[3] 	 = ll_nro_libro
lstr_param.fecha1		 = ld_fec_cntbl

CloseWithReturn(Parent,lstr_param)
end event

type dw_1 from datawindow within w_pop_datos_asiento
integer x = 27
integer y = 40
integer width = 1079
integer height = 304
integer taborder = 20
string title = "none"
string dataobject = "d_ext_datos_asiento_ff"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()

end event

event itemerror;Return 1
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

