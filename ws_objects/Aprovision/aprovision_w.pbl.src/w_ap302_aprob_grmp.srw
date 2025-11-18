$PBExportHeader$w_ap302_aprob_grmp.srw
forward
global type w_ap302_aprob_grmp from w_abc
end type
type uo_search from n_cst_search within w_ap302_aprob_grmp
end type
type rb_grmp from radiobutton within w_ap302_aprob_grmp
end type
type cb_recuperar from commandbutton within w_ap302_aprob_grmp
end type
type rb_desaprobar from radiobutton within w_ap302_aprob_grmp
end type
type rb_aprobar from radiobutton within w_ap302_aprob_grmp
end type
type dw_master from u_dw_abc within w_ap302_aprob_grmp
end type
type gb_1 from groupbox within w_ap302_aprob_grmp
end type
type gb_2 from groupbox within w_ap302_aprob_grmp
end type
end forward

global type w_ap302_aprob_grmp from w_abc
integer width = 3113
integer height = 2432
string title = "[AP302] Aprobación de Guia de Recepcion MP"
string menuname = "m_filtrar_salir"
uo_search uo_search
rb_grmp rb_grmp
cb_recuperar cb_recuperar
rb_desaprobar rb_desaprobar
rb_aprobar rb_aprobar
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
end type
global w_ap302_aprob_grmp w_ap302_aprob_grmp

type variables
n_cst_usuario 		invo_aprobador
n_cst_utilitario	invo_util
end variables

on w_ap302_aprob_grmp.create
int iCurrent
call super::create
if this.MenuName = "m_filtrar_salir" then this.MenuID = create m_filtrar_salir
this.uo_search=create uo_search
this.rb_grmp=create rb_grmp
this.cb_recuperar=create cb_recuperar
this.rb_desaprobar=create rb_desaprobar
this.rb_aprobar=create rb_aprobar
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.rb_grmp
this.Control[iCurrent+3]=this.cb_recuperar
this.Control[iCurrent+4]=this.rb_desaprobar
this.Control[iCurrent+5]=this.rb_aprobar
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_ap302_aprob_grmp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
destroy(this.rb_grmp)
destroy(this.cb_recuperar)
destroy(this.rb_desaprobar)
destroy(this.rb_aprobar)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;uo_search.width 	= newwidth - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_refresh;call super::ue_refresh;if rb_grmp.checked then
	if rb_aprobar.checked then
		dw_master.dataobject = 'd_abc_aprobacion_grmp_tbl'
	elseif rb_desaprobar.checked then
		dw_master.dataObject = 'd_abc_desaprobacion_grmp_tbl'
	end if
end if

dw_master.setTransObject(SQLCA)
dw_master.Retrieve(gs_user, gs_origen)

uo_search.of_set_dw(dw_master)
end event

event ue_open_pre;call super::ue_open_pre;invo_aprobador = create n_cst_usuario

invo_aprobador.of_aprobador( gs_user )
end event

event close;call super::close;destroy invo_aprobador
end event

type uo_search from n_cst_search within w_ap302_aprob_grmp
event destroy ( )
integer y = 240
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type rb_grmp from radiobutton within w_ap302_aprob_grmp
integer x = 18
integer y = 60
integer width = 562
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Guia de Recepcion MP"
boolean checked = true
end type

type cb_recuperar from commandbutton within w_ap302_aprob_grmp
integer x = 1202
integer y = 40
integer width = 343
integer height = 156
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_refresh( )
setPointer(Arrow!)
end event

type rb_desaprobar from radiobutton within w_ap302_aprob_grmp
integer x = 741
integer y = 132
integer width = 411
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desaprobar"
end type

type rb_aprobar from radiobutton within w_ap302_aprob_grmp
integer x = 741
integer y = 60
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobar"
boolean checked = true
end type

type dw_master from u_dw_abc within w_ap302_aprob_grmp
integer y = 336
integer width = 3022
integer height = 1788
string dataobject = "d_abc_aprobacion_grmp_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event buttonclicked;call super::buttonclicked;string 				ls_nro_grmp, ls_mensaje
str_parametros  	lstr_param
Long					ll_count
w_rpt_preview		lw_1

if row = 0 then return

if lower(dwo.name) = 'b_aprobar_grmp' then
	ls_nro_grmp = this.object.cod_guia_rec [row]
	
	update ap_guia_recepcion grmp
		set grmp.aprobador 		= :gs_user,
			 grmp.FEC_APROBACION	= sysdate,
			 grmp.flag_estado		= '1'
	where grmp.COD_GUIA_REC	= :ls_nro_grmp
	  and flag_estado 		= '3';
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de aprobar la GUIA DE RECEPCION DE M.P. ' &
								+ ls_nro_grmp + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	update ap_guia_recepcion_det grmpd
		set 	grmpd.flag_estado		= '1',
				grmpd.aprobador		= :gs_user,
				grmpd.FEC_APROBACION	= sysdate
	where grmpd.COD_GUIA_REC 	= :ls_nro_grmp
	  and grmpd.flag_estado 	= '3';
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de aprobar el detalle de la GUIA DE ' &
								+ 'RECEPCION DE M.P., tabla AP_GUIA_RECEPCION_dET, Nro grmp: ' &
								+ ls_nro_grmp + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	commit;
	
	event ue_refresh()
	
elseif lower(dwo.name) = 'b_desaprobar_grmp' then
	
	ls_nro_grmp = this.object.cod_guia_rec [row]
	
	update ap_guia_recepcion grmp
		set grmp.aprobador 		= null,
			 grmp.FEC_APROBACION	= null,
			 grmp.flag_estado		= '3'
	where grmp.COD_GUIA_REC	= :ls_nro_grmp;
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de DESAPROBAR la GUIA DE RECEPCION DE M.P. ' &
								+ ls_nro_grmp + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	update ap_guia_recepcion_det grmpd
		set 	grmpd.flag_estado		= '3',
				grmpd.aprobador		= null,
				grmpd.FEC_APROBACION	= null
	where grmpd.COD_GUIA_REC 	= :ls_nro_grmp;
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de DESAPROBAR el detalle de la GUIA ' &
								+ 'DE RECEPCION DE M.P., tabla AP_GUIA_RECEPCION_DET, ' &
								+ ls_nro_grmp + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	commit;
	
	event ue_refresh()	


elseif lower(dwo.name) = 'b_detalle_grmp' then
	
	if rb_aprobar.checked and rb_grmp.checked then
		lstr_param.dw1     = 'd_cns_detalle_grmp_tbl'
		lstr_param.titulo  = "Detalle de GRMP pendientes de Aprobar"
		lstr_param.tipo 	 = '1S'
		lstr_param.string1 = this.object.cod_guia_rec[row]
		lstr_param.b_preview = false
	
		OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
	end if
	
	
	

	return

end if
end event

type gb_1 from groupbox within w_ap302_aprob_grmp
integer width = 686
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento"
end type

type gb_2 from groupbox within w_ap302_aprob_grmp
integer x = 713
integer width = 1051
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

