$PBExportHeader$w_estructura_pop_preg.srw
forward
global type w_estructura_pop_preg from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_estructura_pop_preg
end type
type cb_ok from commandbutton within w_estructura_pop_preg
end type
end forward

global type w_estructura_pop_preg from w_abc_master_smpl
integer width = 2254
integer height = 648
string title = "Datos para Centro Beneficio"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_aceptar ( )
cb_1 cb_1
cb_ok cb_ok
end type
global w_estructura_pop_preg w_estructura_pop_preg

event ue_aceptar();str_parametros  lstr_param
string			ls_cenbef_padre, ls_cenbef_hijo, ls_usuario, ls_flag_fijo_var
decimal			ldc_ratio
datetime			ldt_fecha
Long				ll_row

if dw_master.GetRow() = 0 then return
ll_row = dw_master.GetRow()

if f_row_Processing( dw_master, "form") <> true then return

lstr_param.string1   = dw_master.object.cenbef_padre [ll_row]
lstr_param.string2   = dw_master.object.cenbef_hijo  [ll_row]
lstr_param.datetime1 = DateTime(dw_master.object.fec_registro [ll_row])
lstr_param.string3 	= dw_master.object.cod_usr  		[ll_row]
lstr_param.dec1		= Dec(dw_master.object.ratio[ll_row])
lstr_param.string4	= dw_master.object.flag_fijo_var[ll_row]

CloseWithReturn(this, lstr_param)
end event

on w_estructura_pop_preg.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_ok
end on

on w_estructura_pop_preg.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_ok)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros  lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

event open;//Ancestor overriding

THIS.EVENT ue_open_pre()

end event

event ue_open_pre;call super::ue_open_pre;str_parametros 	lstr_param
string			ls_desc
Long				ll_row

ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

if IsNull(Message.PowerObjectParm) or &
	not ISValid(Message.PowerObjectParm) then return

lstr_param = message.powerobjectparm

dw_master.Retrieve(lstr_param.string1, lstr_param.string2)
dw_master.of_protect()

if dw_master.RowCount() = 0 then
	ll_row = dw_master.event ue_insert()
	if ll_row > 0 then
		select desc_Centro
			into :ls_desc
		from centro_beneficio
		where centro_benef = :lstr_param.string1;
		
		dw_master.object.cenbef_padre			[ll_row] = lstr_param.string1
		dw_master.object.desc_centro_padre	[ll_row] = ls_desc
		
		select desc_Centro
			into :ls_desc
		from centro_beneficio
		where centro_benef = :lstr_param.string2;
		
		dw_master.object.cenbef_hijo		[ll_row] = lstr_param.string2
		dw_master.object.desc_centro_hijo[ll_row] = ls_desc
	end if
	
end if
	
	


end event

event ue_set_access;//Ancestor overriding
end event

event ue_set_access_cb;//Ancestor Overriding
end event

event closequery;//Ancestor Overriding
THIS.Event ue_close_pre()

Destroy	im_1

of_close_sheet()


end event

type dw_master from w_abc_master_smpl`dw_master within w_estructura_pop_preg
integer width = 2171
integer height = 412
string dataobject = "d_abc_cenbef_estruct"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_Actual()
this.object.cod_usr	  		[al_row] = gs_user
this.object.ratio		  		[al_row] = 0.00
this.object.flag_fijo_var	[al_row] = 'F'
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw

end event

type cb_1 from commandbutton within w_estructura_pop_preg
integer x = 1257
integer y = 436
integer width = 297
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar( )
end event

type cb_ok from commandbutton within w_estructura_pop_preg
integer x = 946
integer y = 436
integer width = 297
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar()
end event

