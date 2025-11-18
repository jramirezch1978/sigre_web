$PBExportHeader$w_cm302_solicitud_compra_aprobacion.srw
forward
global type w_cm302_solicitud_compra_aprobacion from w_abc
end type
type cb_1 from commandbutton within w_cm302_solicitud_compra_aprobacion
end type
type rb_2 from radiobutton within w_cm302_solicitud_compra_aprobacion
end type
type rb_1 from radiobutton within w_cm302_solicitud_compra_aprobacion
end type
type sle_origen from singlelineedit within w_cm302_solicitud_compra_aprobacion
end type
type st_1 from statictext within w_cm302_solicitud_compra_aprobacion
end type
type p_help from picture within w_cm302_solicitud_compra_aprobacion
end type
type st_help from statictext within w_cm302_solicitud_compra_aprobacion
end type
type pb_aceptar from picturebutton within w_cm302_solicitud_compra_aprobacion
end type
type pb_salir from picturebutton within w_cm302_solicitud_compra_aprobacion
end type
type dw_master from u_dw_abc within w_cm302_solicitud_compra_aprobacion
end type
end forward

global type w_cm302_solicitud_compra_aprobacion from w_abc
integer width = 3589
integer height = 1816
string title = "Aprobacion de Solicitud de compra (CM302)"
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
sle_origen sle_origen
st_1 st_1
p_help p_help
st_help st_help
pb_aceptar pb_aceptar
pb_salir pb_salir
dw_master dw_master
end type
global w_cm302_solicitud_compra_aprobacion w_cm302_solicitud_compra_aprobacion

type variables
String is_col
integer ii_ik[]
end variables

on w_cm302_solicitud_compra_aprobacion.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.sle_origen=create sle_origen
this.st_1=create st_1
this.p_help=create p_help
this.st_help=create st_help
this.pb_aceptar=create pb_aceptar
this.pb_salir=create pb_salir
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.p_help
this.Control[iCurrent+7]=this.st_help
this.Control[iCurrent+8]=this.pb_aceptar
this.Control[iCurrent+9]=this.pb_salir
this.Control[iCurrent+10]=this.dw_master
end on

on w_cm302_solicitud_compra_aprobacion.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.p_help)
destroy(this.st_help)
destroy(this.pb_aceptar)
destroy(this.pb_salir)
destroy(this.dw_master)
end on

event resize;dw_master.width  = newwidth  - dw_master.x - 50
dw_master.height = newheight - dw_master.y - 300
pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200

p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones


is_col = 'nro_solicitud'

//TriggerEvent('ue_retrieve_list')
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

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE
String ls_msg1, ls_msg2

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Error en Grabacion Master"
		ls_msg2 = "Se ha procedido al rollback"		
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2,exclamation!)
END IF
end event

event ue_retrieve_list();call super::ue_retrieve_list;idw_1.retrieve()
IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type cb_1 from commandbutton within w_cm302_solicitud_compra_aprobacion
integer x = 1573
integer y = 24
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;string ls_flag

if rb_1.checked = true then
	ls_flag = '1'
else
	ls_flag = '2'
end if

dw_master.retrieve(sle_origen.text, ls_flag)
end event

type rb_2 from radiobutton within w_cm302_solicitud_compra_aprobacion
integer x = 1115
integer y = 44
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobados"
end type

type rb_1 from radiobutton within w_cm302_solicitud_compra_aprobacion
integer x = 663
integer y = 40
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes"
boolean checked = true
end type

type sle_origen from singlelineedit within w_cm302_solicitud_compra_aprobacion
event ue_display ( )
event ue_tecla pbm_keydown
event ue_dobleclick pbm_lbuttondblclk
integer x = 334
integer y = 32
integer width = 219
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_display();boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select cod_origen as codigo_origen, " &
		 +	"nombre as descripcion_origen " &
		 +	"from origen " 
 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

event ue_tecla;// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
 	this.event dynamic ue_display( )
end if

end event

event ue_dobleclick;this.event dynamic ue_display()
end event

type st_1 from statictext within w_cm302_solicitud_compra_aprobacion
integer x = 119
integer y = 44
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type p_help from picture within w_cm302_solicitud_compra_aprobacion
integer x = 14
integer y = 1552
integer width = 110
integer height = 76
string picturename = "h:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_cm302_solicitud_compra_aprobacion
integer x = 165
integer y = 1572
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Cambiar de Estado a Solicitud "
boolean focusrectangle = false
end type

type pb_aceptar from picturebutton within w_cm302_solicitud_compra_aprobacion
integer x = 2624
integer y = 1500
integer width = 325
integer height = 180
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_update')
end event

type pb_salir from picturebutton within w_cm302_solicitud_compra_aprobacion
integer x = 3013
integer y = 1500
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type dw_master from u_dw_abc within w_cm302_solicitud_compra_aprobacion
integer x = 23
integer y = 168
integer width = 3502
integer height = 1380
integer taborder = 20
string dataobject = "d_abc_solicitud_compra_aprobacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event doubleclicked;call super::doubleclicked;Integer li_opcion
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user, &
   ls_cod_origen, ls_nro_sol_comp
datetime ld_apro

Accepttext()

IF row = 0 THEN Return

ls_cod_origen 		= this.object.cod_origen	[row]
ls_nro_sol_comp 	= this.object.nro_sol_comp	[row]

ls_estado_act = This.Object.flag_estado 	[row]
ls_aprobacion = This.Object.cod_usr			[row]

IF ls_estado_act = '1' THEN //Generado Pasara Aprobarse
	ls_estado_pos = 'Aprobar'
	ls_estado_act = '2'
	ls_user			= gs_user
	ld_apro		  = DATETIME(TODAY())
		 
ELSEIF ls_estado_act = '2' THEN //Aprobado Pasar a Generado
	IF Trim(ls_aprobacion) <> Trim(gs_user) THEN
	 	Messagebox('Aviso','Usted No Puede Revertir Aprobacion, Verifique !')
		 Return
	END IF
		 
	ls_estado_pos = 'Revertir Aprobacion de'	
	ls_user			= ''
 	ls_estado_act = '1'
	SetNull( ld_apro)
END IF	

li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' la Solicitud?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN	
	This.Object.flag_estado [row] = ls_estado_act
	This.Object.cod_usr		[row] = ls_user
	This.Object.fecha_aprob	[row] = ld_apro
	This.ii_update = 1
	
	Update sol_comp_det 
		set flag_estado = :ls_estado_act 
	 where cod_origen 	= :ls_cod_origen 
	   and nro_sol_comp 	= :ls_nro_sol_comp;
   
END IF
end event

