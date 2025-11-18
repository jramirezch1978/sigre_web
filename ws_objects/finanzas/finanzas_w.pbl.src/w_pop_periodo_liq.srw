$PBExportHeader$w_pop_periodo_liq.srw
forward
global type w_pop_periodo_liq from window
end type
type cb_cancelar from commandbutton within w_pop_periodo_liq
end type
type cb_1 from commandbutton within w_pop_periodo_liq
end type
type dw_1 from datawindow within w_pop_periodo_liq
end type
end forward

global type w_pop_periodo_liq from window
integer width = 1847
integer height = 360
boolean titlebar = true
string title = "Ingrese Periodo de Pre - Asientos"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cb_cancelar cb_cancelar
cb_1 cb_1
dw_1 dw_1
end type
global w_pop_periodo_liq w_pop_periodo_liq

type variables
str_parametros istr_param
end variables

on w_pop_periodo_liq.create
this.cb_cancelar=create cb_cancelar
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_cancelar,&
this.cb_1,&
this.dw_1}
end on

on w_pop_periodo_liq.destroy
destroy(this.cb_cancelar)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;Long   	ll_nro_libro
Date		ld_fecha

/*Seleciono Nro de Libro*/
SELECT nro_libro
  INTO :ll_nro_libro
  FROM doc_tipo
 WHERE (tipo_doc = :gnvo_app.finparam.is_doc_og) ;
 
 
IF Isnull(ll_nro_libro) OR ll_nro_libro = 0 THEN
	Messagebox('Aviso','No se ha especificado el Nro Libro para el documento OG, por favor verifique en el maestro de Documentos!')	
END IF

istr_param = Message.PowerObjectParm

ld_fecha = istr_param.fecha1

dw_1.Object.nro_libro 	[1] = ll_nro_libro 
dw_1.object.ano 			[1] = Integer(string(ld_fecha, 'yyyy'))
dw_1.object.mes 			[1] = Integer(string(ld_fecha, 'mm'))
end event

type cb_cancelar from commandbutton within w_pop_periodo_liq
integer x = 1467
integer y = 136
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(Parent,lstr_param)
end event

type cb_1 from commandbutton within w_pop_periodo_liq
integer x = 1467
integer y = 28
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
boolean default = true
end type

event clicked;Long          ll_nro_libro,ll_ano,ll_mes
str_parametros lstr_param

dw_1.Accepttext()

ll_nro_libro = dw_1.object.nro_libro [1]
ll_ano       = dw_1.object.ano       [1] 
ll_mes		 = dw_1.object.mes       [1]	

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



lstr_param.b_return = true
lstr_param.longa[1] 	 = ll_nro_libro
lstr_param.longa[2] 	 = ll_ano
lstr_param.longa[3] 	 = ll_mes

CloseWithReturn(Parent,lstr_param)
end event

type dw_1 from datawindow within w_pop_periodo_liq
integer x = 27
integer y = 40
integer width = 1408
integer height = 208
integer taborder = 20
string title = "none"
string dataobject = "d_ext_liquidacion_ff"
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

