$PBExportHeader$w_fi325_aproba_prov_simpl.srw
forward
global type w_fi325_aproba_prov_simpl from w_abc
end type
type dw_master from u_dw_abc within w_fi325_aproba_prov_simpl
end type
type rb_aprobar from radiobutton within w_fi325_aproba_prov_simpl
end type
type rb_desaprobar from radiobutton within w_fi325_aproba_prov_simpl
end type
type cb_recuperar from commandbutton within w_fi325_aproba_prov_simpl
end type
type rb_prov from radiobutton within w_fi325_aproba_prov_simpl
end type
type uo_search from n_cst_search within w_fi325_aproba_prov_simpl
end type
type gb_1 from groupbox within w_fi325_aproba_prov_simpl
end type
type gb_2 from groupbox within w_fi325_aproba_prov_simpl
end type
end forward

global type w_fi325_aproba_prov_simpl from w_abc
integer width = 3131
integer height = 2368
string title = "[FI325] Aprobación de Facturación Simplificada"
string menuname = "m_filtrar_salir"
dw_master dw_master
rb_aprobar rb_aprobar
rb_desaprobar rb_desaprobar
cb_recuperar cb_recuperar
rb_prov rb_prov
uo_search uo_search
gb_1 gb_1
gb_2 gb_2
end type
global w_fi325_aproba_prov_simpl w_fi325_aproba_prov_simpl

type variables
n_cst_asiento_contable 	invo_asiento_cntbl
end variables

on w_fi325_aproba_prov_simpl.create
int iCurrent
call super::create
if this.MenuName = "m_filtrar_salir" then this.MenuID = create m_filtrar_salir
this.dw_master=create dw_master
this.rb_aprobar=create rb_aprobar
this.rb_desaprobar=create rb_desaprobar
this.cb_recuperar=create cb_recuperar
this.rb_prov=create rb_prov
this.uo_search=create uo_search
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.rb_aprobar
this.Control[iCurrent+3]=this.rb_desaprobar
this.Control[iCurrent+4]=this.cb_recuperar
this.Control[iCurrent+5]=this.rb_prov
this.Control[iCurrent+6]=this.uo_search
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_fi325_aproba_prov_simpl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.rb_aprobar)
destroy(this.rb_desaprobar)
destroy(this.cb_recuperar)
destroy(this.rb_prov)
destroy(this.uo_search)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_refresh;call super::ue_refresh;if rb_aprobar.checked then
	dw_master.dataobject = 'd_abc_aprobacion_prov_simpl_tbl'
elseif rb_desaprobar.checked then
	dw_master.dataObject = 'd_abc_desaprobacion_prov_simpl_tbl'
end if

dw_master.setTransObject(SQLCA)
dw_master.Retrieve(gs_user)

uo_search.of_set_dw(dw_master)
end event

event resize;call super::resize;uo_search.width 	= newwidth - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event close;call super::close;Destroy invo_asiento_cntbl
end event

event ue_open_pre;call super::ue_open_pre;invo_asiento_cntbl 	= create n_cst_asiento_contable
end event

type dw_master from u_dw_abc within w_fi325_aproba_prov_simpl
integer y = 336
integer width = 3022
integer height = 1788
integer taborder = 50
string dataobject = "d_abc_aprobacion_prov_simpl_tbl"
end type

event buttonclicked;call super::buttonclicked;string 	ls_regkey, ls_mensaje
Integer	li_year, li_mes

if row = 0 then return

li_year 	= Integer(this.object.ano [row])
li_mes	= Integer(this.object.mes [row])

if lower(dwo.name) = 'b_aprobar' then
	
	if invo_asiento_cntbl.of_mes_cerrado( li_year, li_mes, "R") then
		MessageBox('Error', 'El periodo ' + string(li_year) + '-' + string(li_mes) + ' esta cerrado, por favor verifica!', StopSign!)
		return
	end if
	
	ls_regkey = this.object.regkey [row]
	
	if MessageBox('Aviso', 'Desea APROBAR la PROVISION simplificada ' + ls_regkey + '?', &
						Information!, Yesno!, 1) = 2 then return
	
	update fin_provision_simpl oc
		set oc.usr_aprob 		= :gs_user,
			 oc.fecha_aprob 	= sysdate,
			 oc.flag_estado	= '1'
	where regkey = :ls_regkey
	  and flag_estado = '3';
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de aprobar la Provision Simplificada ' &
								+ ls_regkey + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	DECLARE sp_procesar_prov_simpl PROCEDURE FOR 
		PKG_FINANZAS.procesar_prov_simpl(:ls_regkey);
		
	EXECUTE sp_procesar_prov_simpl ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		Rollback ;
		CLOSE sp_procesar_prov_simpl ;
		MessageBox('SQL Error', "Error en PAQUETE PKG_FINANZAS.procesar_prov_simpl(" + ls_regkey + "): " + ls_mensaje)	
		return
	end if
	
	COMMIT ;
	
	CLOSE sp_procesar_prov_simpl ;
	
	
	//Envio el email
	//gnvo_app.logistica.of_send_Email_aprob_oc(ls_regkey, gs_user)
	
	event ue_refresh()

elseif lower(dwo.name) = 'b_desaprobar' then
	
	if invo_asiento_cntbl.of_mes_cerrado( li_year, li_mes, "R") then
		MessageBox('Error', 'El periodo ' + string(li_year) + '-' + string(li_mes) + ' esta cerrado, por favor verifica!', StopSign!)
		return
	end if
	
	ls_regkey = this.object.regkey [row]
	
	if MessageBox('Aviso', 'Desea ANULAR la PROVISION simplificada ' + ls_regkey + '?', &
						Information!, Yesno!, 1) = 2 then return
	
	DECLARE sp_anular_provision PROCEDURE FOR 
		PKG_FINANZAS.anular_provision(:ls_regkey);
		
	EXECUTE sp_anular_provision ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		Rollback ;
		CLOSE sp_anular_provision ;
		MessageBox('SQL Error', "Error en PAQUETE PKG_FINANZAS.anular_provision(" + ls_regkey + "): " + ls_mensaje)	
		return
	end if
	
	update fin_provision_simpl oc
		set oc.usr_aprob 		= null,
			 oc.fecha_aprob 	= null,
			 oc.flag_estado	= '3'
	where regkey = :ls_regkey
	  and flag_estado = '1';
			
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ocurrio un error al momento de ANULAR la Provision Simplificada ' &
								+ ls_regkey + '. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if

	CLOSE sp_anular_provision ;

	
	commit;
	
	//Envio el email
	//gnvo_app.logistica.of_send_Email_aprob_oc(ls_regkey, gs_user)
	
	event ue_refresh()
	

	
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw


end event

type rb_aprobar from radiobutton within w_fi325_aproba_prov_simpl
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

type rb_desaprobar from radiobutton within w_fi325_aproba_prov_simpl
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

type cb_recuperar from commandbutton within w_fi325_aproba_prov_simpl
integer x = 1202
integer y = 40
integer width = 343
integer height = 156
integer taborder = 30
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

type rb_prov from radiobutton within w_fi325_aproba_prov_simpl
integer x = 18
integer y = 60
integer width = 544
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Provision Simplificada"
boolean checked = true
end type

type uo_search from n_cst_search within w_fi325_aproba_prov_simpl
event destroy ( )
integer y = 240
integer taborder = 40
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type gb_1 from groupbox within w_fi325_aproba_prov_simpl
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

type gb_2 from groupbox within w_fi325_aproba_prov_simpl
integer x = 713
integer width = 1051
integer height = 232
integer taborder = 20
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

