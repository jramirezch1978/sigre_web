$PBExportHeader$w_fi351_conciliacion_no_registrado.srw
forward
global type w_fi351_conciliacion_no_registrado from w_abc
end type
type pb_1 from picturebutton within w_fi351_conciliacion_no_registrado
end type
type st_1 from statictext within w_fi351_conciliacion_no_registrado
end type
type cb_cancel from commandbutton within w_fi351_conciliacion_no_registrado
end type
type cb_aceptar from commandbutton within w_fi351_conciliacion_no_registrado
end type
type dw_master from u_dw_abc within w_fi351_conciliacion_no_registrado
end type
end forward

global type w_fi351_conciliacion_no_registrado from w_abc
integer width = 4210
integer height = 1380
string title = "Eliminacion de Conciliacion de Documentos No Registrado (FI351)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_1 pb_1
st_1 st_1
cb_cancel cb_cancel
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_fi351_conciliacion_no_registrado w_fi351_conciliacion_no_registrado

type variables
str_parametros is_param 
end variables

on w_fi351_conciliacion_no_registrado.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_aceptar
this.Control[iCurrent+5]=this.dw_master
end on

on w_fi351_conciliacion_no_registrado.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones



//envia parametro
is_param = message.powerobjectparm

dw_master.retrieve(is_param.string1,is_param.longa[1],is_param.longa[2] )
end event

type pb_1 from picturebutton within w_fi351_conciliacion_no_registrado
integer x = 1189
integer y = 1112
integer width = 160
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\cancel.bmp"
alignment htextalign = left!
end type

type st_1 from statictext within w_fi351_conciliacion_no_registrado
integer x = 27
integer y = 1140
integer width = 1147
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Para Eliminar el Item debe darle dobleclicked"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_fi351_conciliacion_no_registrado
integer x = 3776
integer y = 1120
integer width = 402
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_fi351_conciliacion_no_registrado
integer x = 3337
integer y = 1120
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Boolean lbo_ok = TRUE
Long    ll_inicio
String  ls_flag

dw_master.accepttext( )




IF dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 THEN	// Grabación de Cabecera de  Asiento
		lbo_ok = FALSE
		Messagebox('Error de Grabación','Se Procedio al Rollback ',exclamation!)
	END IF
END IF	


IF lbo_ok THEN
	Commit ;
	dw_master.ii_update = 0
	Close(Parent)
ELSE
	Rollback ;
END IF
end event

type dw_master from u_dw_abc within w_fi351_conciliacion_no_registrado
integer x = 14
integer y = 12
integer width = 4178
integer height = 1080
string dataobject = "d_abc_lista_concil_mov_no_reg_tbl"
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
ii_ck[4] = 4

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.cod_ctabco [al_row] = is_param.string1
This.Object.banco_cnta_descripcion [al_row] = is_param.string2
This.Object.ano		  [al_row] = is_param.longa [1]
This.Object.mes		  [al_row] = is_param.longa [2]
This.Object.cod_usr	  [al_row] = gs_user
end event

event doubleclicked;call super::doubleclicked;if row = 0 then  return

choose case dwo.name
		 case 'b_1'
				this.ii_update = 1
				this.deleterow(row)
				
end choose

end event

