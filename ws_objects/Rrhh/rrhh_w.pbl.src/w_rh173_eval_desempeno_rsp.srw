$PBExportHeader$w_rh173_eval_desempeno_rsp.srw
forward
global type w_rh173_eval_desempeno_rsp from window
end type
type st_trabajador from statictext within w_rh173_eval_desempeno_rsp
end type
type cb_2 from commandbutton within w_rh173_eval_desempeno_rsp
end type
type cb_1 from commandbutton within w_rh173_eval_desempeno_rsp
end type
type dw_master from u_dw_abc within w_rh173_eval_desempeno_rsp
end type
end forward

global type w_rh173_eval_desempeno_rsp from window
integer width = 3013
integer height = 1524
boolean titlebar = true
string title = "Evaluacion de Actitudes del Trabajador"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_trabajador st_trabajador
cb_2 cb_2
cb_1 cb_1
dw_master dw_master
end type
global w_rh173_eval_desempeno_rsp w_rh173_eval_desempeno_rsp

on w_rh173_eval_desempeno_rsp.create
this.st_trabajador=create st_trabajador
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_master=create dw_master
this.Control[]={this.st_trabajador,&
this.cb_2,&
this.cb_1,&
this.dw_master}
end on

on w_rh173_eval_desempeno_rsp.destroy
destroy(this.st_trabajador)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_master)
end on

event open;integer li_ano, li_mes, li_verifica
string  ls_cod_area, ls_seccion, ls_codigo, ls_condes, ls_trabajador

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

li_ano  = lstr_rep.long1
li_mes = lstr_rep.long2
ls_codigo = lstr_rep.string1
ls_condes = lstr_rep.string2
ls_trabajador = lstr_rep.string3
ls_seccion = ''

st_trabajador.Text = ls_trabajador
SetPointer(HourGlass!)
DECLARE pb_usp_rh_av_evaluacion_desempeno PROCEDURE FOR USP_RH_AV_EVALUACION_DESEMPENO
 	     ( :li_ano, :li_mes, :ls_seccion, :ls_codigo, :ls_condes, :gs_user ) ;
EXECUTE pb_usp_rh_av_evaluacion_desempeno ;

dw_master.retrieve(li_ano, li_mes, ls_codigo, ls_condes)

SetPointer(Arrow!)
end event

type st_trabajador from statictext within w_rh173_eval_desempeno_rsp
integer x = 64
integer y = 60
integer width = 2542
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh173_eval_desempeno_rsp
integer x = 1527
integer y = 1264
integer width = 311
integer height = 92
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

type cb_1 from commandbutton within w_rh173_eval_desempeno_rsp
integer x = 1147
integer y = 1264
integer width = 311
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;dw_master.AcceptText()

/*THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
*/
//IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	else
		Commit using sqlca;
	END IF
	w_rh173_eval_desempeno.cb_genera.TriggerEvent(Clicked!)
	Close(Parent)
//END IF
end event

type dw_master from u_dw_abc within w_rh173_eval_desempeno_rsp
integer x = 64
integer y = 208
integer width = 2866
integer height = 972
string dataobject = "d_av_evaluacion_desempeno_tbl"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;str_parametros lstr_rep
lstr_rep.dw_m 	= dw_master
lstr_rep.string1 = "desempeno_descripcion"
lstr_rep.long1 = row
openwithparm (w_rsp_popup, lstr_rep)
end event

event clicked;call super::clicked;//Long    ll_row_master
//String  ls_calif_concepto, ls_protect, ls_flag_estado
//
//ll_row_master = dw_master.Getrow()
//
//IF ll_row_master = 0 THEN Return
//
//ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]
//
//if ls_flag_estado = '1' then return
//
//ls_calif_concepto = dw_master.Object.calif_concepto [ll_row_master]
//
//if ls_calif_concepto = 'ASICAP' then
//	ls_protect=dw_master.Describe("calif_valor.protect")
//	if ls_protect = '0' then
//	   dw_master.of_column_protect('calif_valor')
//	end if
//else
//	ls_protect=dw_master.Describe("calif_valor.protect")
//	if ls_protect = '1' then
//	   dw_master.of_column_protect('calif_valor')
//	end if
//end if
//
end event

event constructor;call super::constructor;SetTransObject(sqlca)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

