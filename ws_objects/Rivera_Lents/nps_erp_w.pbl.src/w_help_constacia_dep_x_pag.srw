$PBExportHeader$w_help_constacia_dep_x_pag.srw
forward
global type w_help_constacia_dep_x_pag from window
end type
type cb_4 from commandbutton within w_help_constacia_dep_x_pag
end type
type cb_3 from commandbutton within w_help_constacia_dep_x_pag
end type
type st_6 from statictext within w_help_constacia_dep_x_pag
end type
type st_5 from statictext within w_help_constacia_dep_x_pag
end type
type st_4 from statictext within w_help_constacia_dep_x_pag
end type
type st_3 from statictext within w_help_constacia_dep_x_pag
end type
type sle_2 from singlelineedit within w_help_constacia_dep_x_pag
end type
type sle_1 from singlelineedit within w_help_constacia_dep_x_pag
end type
type cbx_1 from checkbox within w_help_constacia_dep_x_pag
end type
type st_2 from statictext within w_help_constacia_dep_x_pag
end type
type st_1 from statictext within w_help_constacia_dep_x_pag
end type
type em_2 from editmask within w_help_constacia_dep_x_pag
end type
type em_1 from editmask within w_help_constacia_dep_x_pag
end type
type cb_2 from commandbutton within w_help_constacia_dep_x_pag
end type
type cb_1 from commandbutton within w_help_constacia_dep_x_pag
end type
end forward

global type w_help_constacia_dep_x_pag from window
integer width = 1970
integer height = 636
boolean titlebar = true
string title = "Constancia Deposito"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_4 cb_4
cb_3 cb_3
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
sle_2 sle_2
sle_1 sle_1
cbx_1 cbx_1
st_2 st_2
st_1 st_1
em_2 em_2
em_1 em_1
cb_2 cb_2
cb_1 cb_1
end type
global w_help_constacia_dep_x_pag w_help_constacia_dep_x_pag

on w_help_constacia_dep_x_pag.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.sle_2=create sle_2
this.sle_1=create sle_1
this.cbx_1=create cbx_1
this.st_2=create st_2
this.st_1=create st_1
this.em_2=create em_2
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cb_4,&
this.cb_3,&
this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.sle_2,&
this.sle_1,&
this.cbx_1,&
this.st_2,&
this.st_1,&
this.em_2,&
this.em_1,&
this.cb_2,&
this.cb_1}
end on

on w_help_constacia_dep_x_pag.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;String ls_bien_serv

//f_centrar(This)


ls_bien_serv = Message.StringParm

sle_1.text = ls_bien_serv
end event

type cb_4 from commandbutton within w_help_constacia_dep_x_pag
integer x = 805
integer y = 328
integer width = 69
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;


str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT OPER_DETR AS CODIGO				,'&
									    +'DESCRIPCION			   AS DETALLE_OPERACION  '&
										 +'FROM DETR_OPERACION '&
										 +'WHERE FLAG_ESTADO = '+"'"+'1'+"'"
										 

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_2.text = lstr_seleccionar.param1[1]
		st_6.text  = lstr_seleccionar.param2[1]
	END IF
end event

type cb_3 from commandbutton within w_help_constacia_dep_x_pag
integer x = 805
integer y = 232
integer width = 69
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT BIEN_SERV   AS CODIGO                ,'&
										 +'DESCRIPCION AS DETALLE_BIEN_SERVICIO  '&
										 +'FROM DETR_BIEN_SERV '&
										 +'WHERE FLAG_ESTADO = '+"'"+'1'+"'"
										 

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_1.text = lstr_seleccionar.param1[1]
		st_5.text  = lstr_seleccionar.param2[1]
	END IF


end event

type st_6 from statictext within w_help_constacia_dep_x_pag
integer x = 887
integer y = 328
integer width = 1042
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_5 from statictext within w_help_constacia_dep_x_pag
integer x = 887
integer y = 232
integer width = 1042
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 328
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Operacion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 232
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Bien o Servicio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_help_constacia_dep_x_pag
event ue_enter pbm_keydown
integer x = 530
integer y = 328
integer width = 256
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Long   ll_count
String ls_oper_detr,ls_descrip

if key = KeyEnter! then
	ls_oper_detr = sle_2.text
	
	select count (*) into :ll_count
	  from detr_operacion
    where ( oper_detr   =	:ls_oper_detr ) and
	 		 ( flag_estado = '1'				  ) ;
			  
	if ll_count > 0  then
		select descripcion into :ls_descrip
		  from detr_operacion
    	 where ( oper_detr   =	:ls_oper_detr ) and
	 			 ( flag_estado = '1'				  ) ;
		
		st_6.text = ls_descrip
	end if
	
end if
end event

type sle_1 from singlelineedit within w_help_constacia_dep_x_pag
event ue_enter pbm_keydown
integer x = 530
integer y = 232
integer width = 256
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Long   ll_count
String ls_bien_serv,ls_descrip

if key = KeyEnter! then
	ls_bien_serv = sle_1.text
	
	select Count (*)
	  into :ll_count
	  from detr_bien_serv
	 where (bien_serv    = :ls_bien_serv) and
	 		 (flag_estado	= '1'          ) ;
			 
	if ll_count > 0 then
		select descripcion
	     into :ls_descrip
	     from detr_bien_serv
	    where (bien_serv    = :ls_bien_serv) and
	 		    (flag_estado	= '1'          ) ;

		st_5.text = ls_descrip
	end if	
			 
end if
end event

type cbx_1 from checkbox within w_help_constacia_dep_x_pag
integer x = 27
integer y = 448
integer width = 1157
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Genera Detracción en Cuenta Corriente"
boolean checked = true
end type

type st_2 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 132
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Deposito :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 32
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Constancia Deposito :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_2 from editmask within w_help_constacia_dep_x_pag
integer x = 530
integer y = 132
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean usecodetable = true
end type

type em_1 from editmask within w_help_constacia_dep_x_pag
integer x = 530
integer y = 32
integer width = 343
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

type cb_2 from commandbutton within w_help_constacia_dep_x_pag
integer x = 1536
integer y = 124
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;str_parametros lstr_param

lstr_param.bret = FALSE

CloseWithReturn(Parent,lstr_param)
end event

type cb_1 from commandbutton within w_help_constacia_dep_x_pag
integer x = 1536
integer y = 24
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_const_dep,ls_cta_cte,ls_bien_serv,ls_tip_ope
Date   ldt_fecha_dep
str_parametros lstr_param


ls_const_dep  = em_1.text
ldt_fecha_dep = Date(em_2.text)
ls_bien_serv  = sle_1.text
ls_tip_ope    = sle_2.text



IF cbx_1.checked THEN
	ls_cta_cte = '1'
ELSE
	ls_cta_cte = '0'
END IF	

IF Len(ls_const_dep) > 15 THEN
	Messagebox('Aviso','Solamente debe Considerar 15 Caracteres para la Constancia del Deposito')
	Return
END IF

lstr_param.string1 = ls_const_dep
lstr_param.string2 = ls_cta_cte
lstr_param.string3 = ls_bien_serv
lstr_param.string4 = ls_tip_ope
lstr_param.date1 	 = ldt_fecha_dep
lstr_param.bret 	 = TRUE


CloseWithReturn(Parent,lstr_param)
end event

