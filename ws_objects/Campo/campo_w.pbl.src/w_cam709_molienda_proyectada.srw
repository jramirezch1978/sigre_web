$PBExportHeader$w_cam709_molienda_proyectada.srw
forward
global type w_cam709_molienda_proyectada from w_report_smpl
end type
type cb_reporte from commandbutton within w_cam709_molienda_proyectada
end type
type sle_sembrador from singlelineedit within w_cam709_molienda_proyectada
end type
type sle_desc_sembrador from singlelineedit within w_cam709_molienda_proyectada
end type
type rb_1 from radiobutton within w_cam709_molienda_proyectada
end type
type rb_2 from radiobutton within w_cam709_molienda_proyectada
end type
type cbx_1 from checkbox within w_cam709_molienda_proyectada
end type
type st_1 from statictext within w_cam709_molienda_proyectada
end type
type sle_year from singlelineedit within w_cam709_molienda_proyectada
end type
type rb_3 from radiobutton within w_cam709_molienda_proyectada
end type
type gb_1 from groupbox within w_cam709_molienda_proyectada
end type
end forward

global type w_cam709_molienda_proyectada from w_report_smpl
integer width = 3657
integer height = 1704
string title = "[CAM709] Rol de Molienda Proyectada"
string menuname = "m_rpt_smpl"
cb_reporte cb_reporte
sle_sembrador sle_sembrador
sle_desc_sembrador sle_desc_sembrador
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
st_1 st_1
sle_year sle_year
rb_3 rb_3
gb_1 gb_1
end type
global w_cam709_molienda_proyectada w_cam709_molienda_proyectada

on w_cam709_molienda_proyectada.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_reporte=create cb_reporte
this.sle_sembrador=create sle_sembrador
this.sle_desc_sembrador=create sle_desc_sembrador
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.st_1=create st_1
this.sle_year=create sle_year
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.sle_sembrador
this.Control[iCurrent+3]=this.sle_desc_sembrador
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_year
this.Control[iCurrent+9]=this.rb_3
this.Control[iCurrent+10]=this.gb_1
end on

on w_cam709_molienda_proyectada.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.sle_sembrador)
destroy(this.sle_desc_sembrador)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer	li_year
string 	ls_sembrador, ls_tipo_cultivo, ls_mensaje

li_year = Integer(sle_year.text)

if cbx_1.checked then
	ls_sembrador = '%%'
else
	ls_sembrador = trim(sle_sembrador.text) + '%'
end if

if rb_1.checked then
	ls_tipo_cultivo = 'P'
elseif rb_2.checked then
	ls_tipo_cultivo = 'S'
else
	ls_tipo_cultivo = '%%'
end if


//create or replace procedure USP_SEM_MOLIENDA_PROY(
//       ani_year          in number,
//       asi_sembrador     in proveedor.proveedor%TYPE,
//       asi_tipo_cultivo  in string
//) is

DECLARE USP_SEM_MOLIENDA_PROY PROCEDURE FOR
				USP_SEM_MOLIENDA_PROY( :li_year,
											  :ls_sembrador,
											  :ls_tipo_cultivo );
 
EXECUTE USP_SEM_MOLIENDA_PROY;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_SEM_MOLIENDA_PROY: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 RETURN 
END IF
		
COMMIT;

CLOSE USP_SEM_MOLIENDA_PROY;

idw_1.SetTransObject(SQLCA)
//ib_preview = true
//this.event ue_preview( )
idw_1.Retrieve()

//idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.t_empresa.text = gs_empresa
//idw_1.Object.t_usuario.text = gs_user
//idw_1.Object.t_objeto.text = this.ClassName( )

/*idw_1.Object.t_titulo1.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
									 +	string(ld_fecha2, 'dd/mm/yyyy')
idw_1.Object.t_titulo2.text = sle_desc_campana.text
idw_1.Object.t_titulo3.text = "Totos los LOTES -  Labor: " + sle_desc_labor.text
*/								 
end event

event ue_open_pre;//Override
idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False

sle_year.text = string(Date(f_fecha_actual()), 'yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_cam709_molienda_proyectada
integer x = 0
integer y = 300
integer width = 2711
integer height = 1036
string dataobject = "d_rpt_rol_molienda_proyect_cst"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row(this)
end if
end event

type cb_reporte from commandbutton within w_cam709_molienda_proyectada
integer x = 2743
integer y = 48
integer width = 334
integer height = 204
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve( )
SetPointer(Arrow!)
end event

type sle_sembrador from singlelineedit within w_cam709_molienda_proyectada
event dobleclick pbm_lbuttondblclk
integer x = 745
integer y = 144
integer width = 384
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct p.proveedor AS codigo_sembrador, " &
	  	 + "p.nom_proveedor AS descripcion_sembrador " &
	    + "FROM proveedor p, " &
		 + "     campo_sembradores cs " &
		 + "where cs.proveedor = p.proveedor " &
		 + " and p.flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_desc_sembrador.text 	= ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Sembrador')
	return
end if

SELECT p.nom_proveedor 
	INTO :ls_desc
FROM proveedor p,
	  campo_sembradores cs
where cs.proveedor = p.proveedor
  and p.proveedor  = :ls_codigo
  and p.flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Sembrador no existe o esta activo, por favor verifique')
	this.text = ''
	sle_desc_sembrador.text = ''
	return
end if

sle_desc_sembrador.text = ls_desc

end event

type sle_desc_sembrador from singlelineedit within w_cam709_molienda_proyectada
integer x = 1129
integer y = 144
integer width = 1111
integer height = 88
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_cam709_molienda_proyectada
integer x = 2286
integer y = 60
integer width = 384
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
string text = "Plantas"
end type

type rb_2 from radiobutton within w_cam709_molienda_proyectada
integer x = 2286
integer y = 132
integer width = 384
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
string text = "Socas"
end type

type cbx_1 from checkbox within w_cam709_molienda_proyectada
integer x = 32
integer y = 144
integer width = 695
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los sembradores"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_sembrador.enabled = false
else
	sle_sembrador.enabled = true
end if
end event

type st_1 from statictext within w_cam709_molienda_proyectada
integer x = 69
integer y = 36
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_cam709_molienda_proyectada
integer x = 320
integer y = 24
integer width = 343
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_cam709_molienda_proyectada
integer x = 2286
integer y = 204
integer width = 384
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
string text = "Todas"
boolean checked = true
end type

type gb_1 from groupbox within w_cam709_molienda_proyectada
integer x = 2249
integer width = 480
integer height = 296
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Cultivo"
end type

