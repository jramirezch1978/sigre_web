$PBExportHeader$w_pr002_objeto.srw
forward
global type w_pr002_objeto from w_abc_mastdet_smpl
end type
type st_master from statictext within w_pr002_objeto
end type
type st_detail from statictext within w_pr002_objeto
end type
end forward

global type w_pr002_objeto from w_abc_mastdet_smpl
integer width = 2181
integer height = 1468
string title = "Objetos para Control de Mediciones por Gráfico(PR002) "
string menuname = "m_prod_mant"
windowstate windowstate = maximized!
boolean center = true
st_master st_master
st_detail st_detail
end type
global w_pr002_objeto w_pr002_objeto

on w_pr002_objeto.create
int iCurrent
call super::create
if this.MenuName = "m_prod_mant" then this.MenuID = create m_prod_mant
this.st_master=create st_master
this.st_detail=create st_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_detail
end on

on w_pr002_objeto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.st_detail)
end on

event resize;call super::resize;st_master.width  = newwidth  - st_master.x - 10
st_detail.width  = newwidth  - st_detail.x - 10

end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_retrieve_list;call super::ue_retrieve_list;string ls_sql, ls_return1, ls_return2

this.event ue_update_request( )

ls_sql = "select objeto as codigo, obj_desc as nombre from vw_tg_objeto"

f_lista(ls_sql, ls_return1, ls_return2, '2')

if isnull(ls_return1) or trim(ls_return1) = '' then return

dw_master.reset( )
dw_detail.reset( )

if dw_master.retrieve( ls_return1 ) = 1 then 
	dw_master.object.p_objeto.filename = dw_master.object.imagen_base[1]
	dw_detail.retrieve( ls_return1 )
	dw_master.il_row = 1
else
	dw_master.il_row = 0
end if
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr002_objeto
integer x = 0
integer y = 76
integer width = 2103
integer height = 712
string dataobject = "d_objeto_pantalla_ff"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
ii_dk[1] = 1
end event

event dw_master::doubleclicked;call super::doubleclicked;integer li_file
string ls_col, ls_docname, ls_named, ls_sql, ls_return1, ls_return2, ls_cod_maquina

if this.ii_protect = 1 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'imagen_base'
		li_file = GetFileOpenName("Seleccione Archivo", ls_docname, ls_named, "BMP", "Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG, Archivos BMP (*.GIF),*.GIF")
		if li_file = 1 then
			this.object.imagen_base[row] = ls_docname
			this.object.p_objeto.filename = ls_docname
			this.ii_update = 1
		end if
	case 'cod_maquina'
		ls_sql = "select cod_maquina as codigo, desc_maq as nombre from maquina where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		this.object.atributo_default[row] = ''
		this.object.desc_atrib[row] = ''
		this.ii_update = 1
	case 'atributo_default'
		ls_cod_maquina = this.object.cod_maquina[row]
		if isnull(ls_cod_maquina) or trim(ls_cod_maquina) = '' then
			messagebox(parent.title, 'Debe seleccionar primero una máquina')
			return
		end if
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion from vw_pr_atributo_maquina where cod_maquina = '"+ ls_cod_maquina +"'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.atributo_default[row] = ls_return1
		this.object.desc_atrib[row] = ls_return2
		this.ii_update = 1
end choose


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen[al_row] = gs_origen
end event

event dw_master::itemchanged;call super::itemchanged;
integer li_file
string ls_col, ls_docname, ls_named, ls_sql, ls_return1, ls_return2, ls_cod_maquina

ls_col = lower(trim(string(dwo.name)))

this.accepttext( )

choose case ls_col
	case 'imagen_base'
		ls_return1 = data
		if fileexists(ls_return1) = false then
			messagebox(parent.title, 'No se encontró el archivo [' + trim(ls_return1) + ']')
			ls_return1 = ''
		end if
		this.object.imagen_base[row] = ls_return1
		this.object.p_objeto.filename = ls_return1
		return 2

	case 'cod_maquina'
		select cod_maquina, desc_maq
			into :ls_return1, :ls_return2
			from maquina 
			where flag_estado = '1'
			and cod_maquina = :data;
			
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'No se encontró la máquina ingresada')
		end if
		this.object.cod_maquina[row] = ls_return1
		this.object.desc_maq[row] = ls_return2
		this.object.atributo_default[row] = ''
		this.object.desc_atrib[row] = ''
		return 2
	case 'atributo_default'
		
		ls_cod_maquina = this.object.cod_maquina[row]
		
		if isnull(ls_cod_maquina) or trim(ls_cod_maquina) = '' then
			messagebox(parent.title, 'Debe seleccionar primero una máquina')
			ls_return1 = ''
			ls_return2 = ''
		else
			select atrib_cod, atrib_desc 
				into :ls_return1, :ls_return2
				from vw_pr_atributo_maquina 
				where cod_maquina = :ls_cod_maquina
				   and atrib_cod = :data;
			if sqlca.sqlcode <> 0 then
				messagebox(parent.title, 'No existe el atributo')
				ls_return1 = ''
				ls_return2 = ''
			end if
		end if
	
		this.object.atributo_default[row] = ls_return1
		this.object.desc_atrib[row] = ls_return2
		return 2
		
end choose


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr002_objeto
integer x = 0
integer y = 868
integer width = 2103
integer height = 392
string dataobject = "d_tg_objeto_estado_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;integer li_file
string ls_col, ls_sql, ls_return1, ls_return2, ls_cod_maquina, ls_docname, ls_named

ls_col = lower(trim(string(dwo.name)))

if this.ii_protect = 1 then return

choose case ls_col
	case 'atributo'
		ls_cod_maquina = dw_master.object.cod_maquina[dw_master.getrow( )]
		
		if isnull(ls_cod_maquina) or trim(ls_cod_maquina) = '' then
			messagebox(parent.title, 'Debe seleccionar primero una máquina')
			return
		end if
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion from vw_pr_atributo_maquina where cod_maquina = '"+ ls_cod_maquina +"'"
		
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.atributo[row] = ls_return1
		this.object.desc_atrib[row] = ls_return2
		this.ii_update = 1
	
	case 'imagen'
		li_file = GetFileOpenName("Seleccione Archivo", ls_docname, ls_named, "BMP", "Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG, Archivos BMP (*.GIF),*.GIF")
		if li_file = 1 then
			this.object.imagen[row] = ls_docname
			this.ii_update = 1
		end if
end choose
end event

event dw_detail::ue_insert;string ls_objeto
long ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No se ha generado el código del objeto")
		RETURN - 1
	END IF
END IF

ls_objeto = idw_mst.object.objeto[idw_mst.il_row]

if isnull(ls_objeto) or trim(ls_objeto) = '' then
	MessageBox("Error", "No se ha generado el código del objeto, selecciónelo de la lista")
	parent.event ue_retrieve_list( )
	RETURN - 1
end if

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event dw_detail::itemchanged;call super::itemchanged;integer li_file
string ls_col, ls_sql, ls_return1, ls_return2, ls_cod_maquina, ls_docname, ls_named

ls_col = lower(trim(string(dwo.name)))

this.accepttext( )

choose case ls_col
	case 'atributo'
		
		ls_cod_maquina = dw_master.object.cod_maquina[dw_master.getrow( )]
		
		if isnull(ls_cod_maquina) or trim(ls_cod_maquina) = '' then
			messagebox(parent.title, 'Debe seleccionar primero una máquina')
			return
		end if
		
		select atrib_cod, atrib_desc 
			into :ls_return1, :ls_return2
			from vw_pr_atributo_maquina 
			where cod_maquina = :ls_cod_maquina
				and atrib_cod = :data;
		
		if sqlca.sqlcode <> 0 then
			messagebox(parent.title, 'No se ha encontrado el atributo')
			ls_return1 = ''
			ls_return2 = ''
		end if
		
		this.object.atributo[row] = ls_return1
		this.object.desc_atrib[row] = ls_return2
		
		return 2
	
	case 'imagen'
		
		ls_return1 = data
		if fileexists(ls_return1) = false then
			messagebox(parent.title, 'No se encontró el archivo [' + trim(ls_return1) + ']')
			ls_return1 = ''
		end if
		
		this.object.imagen[row] = ls_return1
		
		return 2
end choose
end event

type st_master from statictext within w_pr002_objeto
integer width = 2103
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217737
long backcolor = 134217729
string text = "Objetos"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_pr002_objeto
integer y = 792
integer width = 2103
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217737
long backcolor = 134217729
string text = "Estados por atributo"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

