$PBExportHeader$w_fi301_cierre_caja.srw
forward
global type w_fi301_cierre_caja from w_abc_master_smpl
end type
type st_1 from statictext within w_fi301_cierre_caja
end type
type st_nom_banco from statictext within w_fi301_cierre_caja
end type
type sle_caja from n_cst_sle within w_fi301_cierre_caja
end type
end forward

global type w_fi301_cierre_caja from w_abc_master_smpl
integer width = 3259
integer height = 1748
string title = "[FI301]Apertura y cierre de caja"
string menuname = "m_mtto_smpl"
st_1 st_1
st_nom_banco st_nom_banco
sle_caja sle_caja
end type
global w_fi301_cierre_caja w_fi301_cierre_caja

on w_fi301_cierre_caja.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.st_1=create st_1
this.st_nom_banco=create st_nom_banco
this.sle_caja=create sle_caja
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_nom_banco
this.Control[iCurrent+3]=this.sle_caja
end on

on w_fi301_cierre_caja.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_nom_banco)
destroy(this.sle_caja)
end on

event ue_insert;//Overriding

String ls_mensaje

if sle_caja.text = "" then
	ls_mensaje = "No ha ingresado un código de Caja o Banco"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	sle_caja.setFocus( )
	return
end if

Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

type p_pie from w_abc_master_smpl`p_pie within w_fi301_cierre_caja
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_fi301_cierre_caja
end type

type uo_h from w_abc_master_smpl`uo_h within w_fi301_cierre_caja
end type

type st_box from w_abc_master_smpl`st_box within w_fi301_cierre_caja
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_fi301_cierre_caja
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_fi301_cierre_caja
end type

type p_logo from w_abc_master_smpl`p_logo within w_fi301_cierre_caja
end type

type st_filter from w_abc_master_smpl`st_filter within w_fi301_cierre_caja
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_fi301_cierre_caja
end type

type dw_master from w_abc_master_smpl`dw_master within w_fi301_cierre_caja
integer x = 512
integer y = 416
integer height = 648
string dataobject = "d_abc_cierre_caja_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.usr_apertura	[al_row] = gnvo_app.is_user
this.object.fec_registro	[al_row] = f_fecha_actual(0)
this.object.fecha				[al_row] = date(f_fecha_actual(0))
this.object.cod_banco		[al_row] = sle_caja.text
this.object.flag_estado		[al_row] = '1'
end event

event dw_master::buttonclicked;call super::buttonclicked;string 	 ls_fecha, ls_mensaje

choose case lower(dwo.name)
		
	case "b_cerrar"
		if this.object.flag_estado [row] <> '1' then
			ls_mensaje = "caja no se puede cerrar, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			return
		end if
		
		ls_fecha = string(this.object.fecha[row], 'dd/mm/yyyy')
		if MessageBox('AViso', 'Desea cerrar caja en la fecha ' + ls_fecha, &
			information!, YesNo!, 2 ) = 2 then return
		
		//Cierro la caja y grabo el nombre del usuario
		this.object.flag_estado [row] = '2'		
		this.object.usr_cierre	[row] = gnvo_app.is_user
		this.object.fec_cierre	[row] = f_fecha_actual(0)
		this.ii_update = 1
		
	
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

end event

type st_1 from statictext within w_fi301_cierre_caja
integer x = 626
integer y = 304
integer width = 274
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Banco:"
boolean focusrectangle = false
end type

type st_nom_banco from statictext within w_fi301_cierre_caja
integer x = 1394
integer y = 292
integer width = 1522
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_caja from n_cst_sle within w_fi301_cierre_caja
integer x = 928
integer y = 292
integer width = 457
integer taborder = 50
boolean bringtotop = true
end type

event dobleclick;call super::dobleclick;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_banco AS codigo_caja_banco, " &
		  + "nom_banco AS nombre_caja_banco " &
		  + "FROM banco " &
		  + "where cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_nom_banco.text = ls_data
	dw_master.retrieve(ls_codigo)
end if

end event

event modified;call super::modified;String ls_null, ls_desc, ls_data, ls_mensaje

SetNull( ls_null)
ls_data = this.text

if ls_data = "" then
	ls_mensaje = "Debe Ingresar un código valido"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)
	this.setFocus()
	return
end if

// Verifica que codigo ingresado exista			
Select nom_banco
	into :ls_desc
	from banco
Where cod_banco = :ls_data
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;

// Verifica que articulo solo sea de reposicion		
if SQLCA.SQLCode = 100 then
	ls_mensaje = "Código de banco ingresado " + ls_data &
				+ " no existe o no pertenece a la empresa, por favor verifique"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje)

	this.text =  ls_null
	st_nom_banco.text = ""
	dw_master.Reset()
	return 
end if

this.text = ls_desc
dw_master.Retrieve(ls_data)
		

end event

