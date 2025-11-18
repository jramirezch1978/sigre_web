$PBExportHeader$w_ope318_liberacion_amp.srw
forward
global type w_ope318_liberacion_amp from w_abc
end type
type sle_nro from u_sle_codigo within w_ope318_liberacion_amp
end type
type st_2 from statictext within w_ope318_liberacion_amp
end type
type st_1 from statictext within w_ope318_liberacion_amp
end type
type cb_1 from commandbutton within w_ope318_liberacion_amp
end type
type sle_origen from singlelineedit within w_ope318_liberacion_amp
end type
type dw_master from u_dw_abc within w_ope318_liberacion_amp
end type
type gb_1 from groupbox within w_ope318_liberacion_amp
end type
end forward

global type w_ope318_liberacion_amp from w_abc
integer width = 3470
integer height = 1956
string title = "Liberación de Requerimientos de la OT (OPE318)"
string menuname = "m_modifica_graba"
event ue_retrieve ( )
sle_nro sle_nro
st_2 st_2
st_1 st_1
cb_1 cb_1
sle_origen sle_origen
dw_master dw_master
gb_1 gb_1
end type
global w_ope318_liberacion_amp w_ope318_liberacion_amp

event ue_retrieve();String 	ls_origen, ls_nro_doc

ls_origen = sle_origen.text
ls_nro_doc 	 = sle_nro.text

dw_master.Retrieve(ls_origen, ls_nro_doc)
end event

on w_ope318_liberacion_amp.create
int iCurrent
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
this.sle_nro=create sle_nro
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
end on

on w_ope318_liberacion_amp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;string ls_doc_ot

select doc_ot 
	into :ls_doc_ot
from logparam
where reckey = '1';

sle_origen.text = ls_doc_ot

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente




of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;Long   ll_inicio,ll_nro_mov
String ls_flag_mov,ls_msj_err,ls_origen


dw_master.Accepttext( )


For ll_inicio = 1 to dw_master.Rowcount()
 	 ls_flag_mov 	= dw_master.object.flag_mov 	[ll_inicio]
	 ls_origen	 	= dw_master.object.cod_origen [ll_inicio]
	 ll_nro_mov		= dw_master.object.nro_mov 	[ll_inicio]
	 
	 IF ls_flag_mov = '1' THEN
		 //actualiza orden de compra	
		 Update articulo_mov_proy amp
		    set amp.org_amp_ref = null,
				  amp.nro_amp_ref	= null
		  where (amp.org_amp_ref = :ls_origen  ) and
		  		  (amp.nro_amp_ref = :ll_nro_mov ) ; 	
					 
					 
		 IF SQLCA.SQLCode = -1 THEN 
			 ls_msj_err = SQLCA.SQLErrText
 			 Rollback ;
	    	 MessageBox('SQL error', ls_msj_err)
			 ib_update_check = FALSE
			 return
		 END IF
		 
		 //actualiza orden de trabajo
		 Update articulo_mov_proy amp
		    set amp.cant_reservado = 0.00
		  where (amp.cod_origen = :ls_origen  ) and
				  (amp.nro_mov		= :ll_nro_mov ) ;
				  
		 IF SQLCA.SQLCode = -1 THEN 
			 ls_msj_err = SQLCA.SQLErrText
 			 Rollback ;
	    	 MessageBox('SQL error', ls_msj_err)
			 ib_update_check = FALSE
			 return
		 END IF
				  
	   
	 END IF
	
Next	
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF lbo_ok THEN
	COMMIT using SQLCA;
	Messagebox('Aviso','Liberación Realizada Satisfactoriamente')
	this.event ue_retrieve()
END IF

end event

type sle_nro from u_sle_codigo within w_ope318_liberacion_amp
integer x = 960
integer y = 76
integer width = 471
integer height = 88
integer taborder = 10
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.Triggerevent( clicked!)
end event

type st_2 from statictext within w_ope318_liberacion_amp
integer x = 41
integer y = 92
integer width = 256
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ope318_liberacion_amp
integer x = 526
integer y = 92
integer width = 425
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Documento:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope318_liberacion_amp
integer x = 1499
integer y = 56
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;parent.event dynamic ue_retrieve()


end event

type sle_origen from singlelineedit within w_ope318_liberacion_amp
integer x = 306
integer y = 76
integer width = 187
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_abc within w_ope318_liberacion_amp
integer y = 208
integer width = 3333
integer height = 1200
string dataobject = "d_abc_liberacion_amp_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst = dw_master

end event

type gb_1 from groupbox within w_ope318_liberacion_amp
integer x = 18
integer y = 16
integer width = 2117
integer height = 176
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Busqueda"
end type

