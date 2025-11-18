$PBExportHeader$w_sg700_usr_grp_obj.srw
forward
global type w_sg700_usr_grp_obj from w_report_smpl
end type
type cb_1 from commandbutton within w_sg700_usr_grp_obj
end type
type cbx_pasados from checkbox within w_sg700_usr_grp_obj
end type
type cbx_cn from checkbox within w_sg700_usr_grp_obj
end type
type cbx_sc from checkbox within w_sg700_usr_grp_obj
end type
type cbx_lm from checkbox within w_sg700_usr_grp_obj
end type
type cbx_sp from checkbox within w_sg700_usr_grp_obj
end type
type cbx_ps from checkbox within w_sg700_usr_grp_obj
end type
type dw_new from datawindow within w_sg700_usr_grp_obj
end type
type ddlb_1 from u_ddlb within w_sg700_usr_grp_obj
end type
type gb_1 from groupbox within w_sg700_usr_grp_obj
end type
end forward

global type w_sg700_usr_grp_obj from w_report_smpl
integer width = 3374
integer height = 1952
string title = "Accesos x Usuario (SG700)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
cb_1 cb_1
cbx_pasados cbx_pasados
cbx_cn cbx_cn
cbx_sc cbx_sc
cbx_lm cbx_lm
cbx_sp cbx_sp
cbx_ps cbx_ps
dw_new dw_new
ddlb_1 ddlb_1
gb_1 gb_1
end type
global w_sg700_usr_grp_obj w_sg700_usr_grp_obj

type variables
String  is_usuario
end variables

forward prototypes
public subroutine of_regenera_ddlb_usuarios ()
public function string of_regenera_where ()
end prototypes

public subroutine of_regenera_ddlb_usuarios ();ddlb_1.reset()
string ls_where
ls_where = of_regenera_where()

String 	ls_report_type, ls_style, ls_sql_syntax, ls_dw_err, &
			ls_dw_syntax, ls_type_font
Integer 	i
ls_report_type  = "grid"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=6 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) '

 
ls_sql_syntax = "select u.cod_usr, u.nombre, u.origen_alt, u.flag_estado " + &
                " from usuario u " + &
                ls_where + " order by u.cod_usr"

ls_dw_err     = ""
ls_dw_syntax  = SyntaxFromSQL(sqlca, ls_sql_syntax, ls_style, ls_dw_err)

IF len(trim(ls_dw_err)) > 0 THEN
	messagebox('Error',ls_dw_err,StopSign!)
	RETURN
END IF
dw_new.Create(ls_dw_syntax, ls_dw_err)
dw_new.SetTransObject(sqlca)
dw_new.retrieve()
ddlb_1.event ue_item_add()
end subroutine

public function string of_regenera_where ();string ls_where
ls_where = ''
if cbx_cn.checked then 
	ls_where = "origen_alt = 'CN'"
end if
if cbx_sc.checked then 
	if len(ls_where) = 0 then 
		ls_where = "origen_alt = 'SC'"
   else 
		ls_where = ls_where + " or origen_alt = 'SC'"
	end if
end if
if cbx_sp.checked then 
	if len(ls_where) = 0 then 
		ls_where = "origen_alt = 'SP'"
   else 
		ls_where = ls_where + " or origen_alt = 'SP'"
	end if
end if
if cbx_lm.checked then 
	if len(ls_where) = 0 then 
		ls_where = "origen_alt = 'LM'"
   else 
		ls_where = ls_where + " or origen_alt = 'LM'"
	end if
end if
if cbx_ps.checked then 
	if len(ls_where) = 0 then 
		ls_where = "origen_alt = 'PS'"
   else 
		ls_where = ls_where + " or origen_alt = 'PS'"
	end if
end if
if len(ls_where) > 0 then 
   ls_where = 'where (' + ls_where + ' )'
end if
// que usuarios se desea ver?
if len(ls_where) = 0 then 
	ls_where = "where flag_estado = '1' or flag_estado='2'"
else 
	ls_where = ls_where + " and flag_estado = '1' or flag_estado='2'"
end if

if cbx_pasados.checked then 
	if len(ls_where) = 0 then 
		ls_where = "where flag_estado = '0' or flag_estado='3'"
   else 
		ls_where = ls_where + " and flag_estado = '0' or flag_estado='3'"
	end if
end if
return ls_where
end function

on w_sg700_usr_grp_obj.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_1=create cb_1
this.cbx_pasados=create cbx_pasados
this.cbx_cn=create cbx_cn
this.cbx_sc=create cbx_sc
this.cbx_lm=create cbx_lm
this.cbx_sp=create cbx_sp
this.cbx_ps=create cbx_ps
this.dw_new=create dw_new
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_pasados
this.Control[iCurrent+3]=this.cbx_cn
this.Control[iCurrent+4]=this.cbx_sc
this.Control[iCurrent+5]=this.cbx_lm
this.Control[iCurrent+6]=this.cbx_sp
this.Control[iCurrent+7]=this.cbx_ps
this.Control[iCurrent+8]=this.dw_new
this.Control[iCurrent+9]=this.ddlb_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_sg700_usr_grp_obj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_pasados)
destroy(this.cbx_cn)
destroy(this.cbx_sc)
destroy(this.cbx_lm)
destroy(this.cbx_sp)
destroy(this.cbx_ps)
destroy(this.dw_new)
destroy(this.ddlb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_nombre, ls_estado
is_usuario = mid(ddlb_1.text,1,6)
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Retrieve(is_usuario)

// Leer nombre de usuario
  SELECT "USUARIO"."NOMBRE",   
         "USUARIO"."FLAG_ESTADO"  
    INTO :ls_nombre,   
         :ls_estado  
    FROM "USUARIO"  
   WHERE "USUARIO"."COD_USR" = :is_usuario;


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'SG700'
idw_1.object.t_usuario.text = is_usuario + ':  ' + ls_nombre
IF ls_estado = '1' THEN	
	idw_1.object.t_estado.text = 'ACTIVO'
ELSE
	idw_1.object.t_estado.text = 'DESACTIVADO'
END IF
end event

event open;call super::open;dw_new.hide()
end event

type dw_report from w_report_smpl`dw_report within w_sg700_usr_grp_obj
integer x = 18
integer y = 176
string dataobject = "d_usr_grp_objeto_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_tbl'
		lstr_1.Width = 1700
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Relacionados'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_doc"
		ls_tipo_doc = TRIM(GetItemString(row,'tipo_doc'))	
		CHOOSE CASE ls_tipo_doc
			CASE 'OT'
				lstr_1.DataObject = 'd_orden_trabajo_oper_sec_ff'
				lstr_1.Width = 2000
				lstr_1.Height= 1800
				lstr_1.Arg[1] = GetItemString(row,'nro_doc')
				lstr_1.Arg[2] = GetItemString(row,'oper_sec')
				lstr_1.Title = 'Orden de Trabajo'
			CASE 'SC'
				lstr_1.DataObject = 'd_sol_compra_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1200
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Compra'
			CASE 'SL'
				lstr_1.DataObject = 'd_solicitud_salida_ff'
				lstr_1.Width = 2100
				lstr_1.Height= 800
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Salida'
			CASE 'OC'
				lstr_1.DataObject = 'd_orden_compra_ff'
				lstr_1.Width = 2400
				lstr_1.Height= 1300
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Compra'
			CASE 'OV'
				lstr_1.DataObject = 'd_orden_venta_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1500
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Venta'
		END CHOOSE
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_sg700_usr_grp_obj
integer x = 2917
integer y = 24
integer width = 325
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type cbx_pasados from checkbox within w_sg700_usr_grp_obj
integer x = 2501
integer y = 32
integer width = 393
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "¿pasados?"
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type cbx_cn from checkbox within w_sg700_usr_grp_obj
integer x = 27
integer y = 44
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CN"
boolean checked = true
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type cbx_sc from checkbox within w_sg700_usr_grp_obj
integer x = 261
integer y = 44
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SC"
boolean checked = true
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type cbx_lm from checkbox within w_sg700_usr_grp_obj
integer x = 727
integer y = 44
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LM"
boolean checked = true
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type cbx_sp from checkbox within w_sg700_usr_grp_obj
integer x = 494
integer y = 44
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SP"
boolean checked = true
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type cbx_ps from checkbox within w_sg700_usr_grp_obj
integer x = 960
integer y = 44
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PS"
boolean checked = true
end type

event clicked;of_regenera_ddlb_usuarios()
end event

type dw_new from datawindow within w_sg700_usr_grp_obj
integer x = 1943
integer y = 540
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_1 from u_ddlb within w_sg700_usr_grp_obj
integer x = 1138
integer y = 16
integer width = 1321
integer height = 780
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

event modified;call super::modified;//String ls_usr
//
//ls_usr = this.text
//
//dw_1.Retrieve(ls_usr)
//dw_2.Retrieve(ls_usr)
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_usuario_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

type gb_1 from groupbox within w_sg700_usr_grp_obj
integer x = 5
integer width = 1152
integer height = 152
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen Alterno"
end type

