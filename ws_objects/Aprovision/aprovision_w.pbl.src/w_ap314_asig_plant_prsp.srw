$PBExportHeader$w_ap314_asig_plant_prsp.srw
forward
global type w_ap314_asig_plant_prsp from w_abc_mastdet_smpl
end type
type em_ano from editmask within w_ap314_asig_plant_prsp
end type
type st_1 from statictext within w_ap314_asig_plant_prsp
end type
end forward

global type w_ap314_asig_plant_prsp from w_abc_mastdet_smpl
integer width = 1778
integer height = 1788
string title = "Asignacion de Plantillas Presupuestales (AP314)"
string menuname = "m_mantto_smpl"
em_ano em_ano
st_1 st_1
end type
global w_ap314_asig_plant_prsp w_ap314_asig_plant_prsp

on w_ap314_asig_plant_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.em_ano=create em_ano
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_1
end on

on w_ap314_asig_plant_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master

em_ano.text = string(Today(), 'yyyy')

end event

event ue_query_retrieve;integer li_ano

li_ano = integer(em_ano.text)

if li_ano = 0 then
	MessageBox('APROVISIONAMIENTO', 'EL AÑO NO ES VALIDO', stopSign!)
	dw_master.Reset()
	dw_detail.Reset()
	return
end if
dw_master.Retrieve(li_ano)

dw_master.ii_protect = 0
dw_master.of_protect( )
dw_master.ii_update = 0

dw_detail.ii_protect = 0
dw_detail.of_protect( )
dw_detail.ii_update = 0


end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap314_asig_plant_prsp
integer x = 0
integer y = 136
integer width = 1705
integer height = 708
string dataobject = "d_lista_aprovis_proyectado_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

MenuId.item[1].item[1].item[1].enabled = false
MenuId.item[1].item[1].item[2].enabled = false
MenuId.item[1].item[1].item[3].enabled = false
MenuId.item[1].item[1].item[4].enabled = false

MenuId.item[1].item[1].item[1].visible = false
MenuId.item[1].item[1].item[2].visible = false
MenuId.item[1].item[1].item[3].visible = false
MenuId.item[1].item[1].item[4].visible = false

MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
MenuId.item[1].item[1].item[2].ToolbarItemvisible = false
MenuId.item[1].item[1].item[3].ToolbarItemvisible = false
MenuId.item[1].item[1].item[4].ToolbarItemvisible = false

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1		  	// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::ue_output;call super::ue_output;if al_row > 0 then
	THIS.EVENT ue_retrieve_det(al_row)
end if
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2],aa_id[3])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap314_asig_plant_prsp
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 852
integer width = 1705
integer height = 696
string dataobject = "d_ap_asign_plant_prsp_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_FL_PLANTILLA"
		
		ls_sql ="SELECT COD_FL_PLANTILLA AS CODIGO, " &
				+ "DESCRIPCION AS DESCR_PLANTILLA " &
				+ "FROM FL_PLANT_PRESUP " &
				+ "WHERE TO_CHAR(FECHA_FIN_VIGENCIA, 'yyyymmdd') >= " + string(today(), 'yyyymmdd') &
				+ " AND TO_CHAR(FECHA_INICIO_VIGENCIA, 'yyyymmdd') <= " + string(today(), 'yyyymmdd')
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_fl_plantilla[al_row]	= ls_codigo
			this.object.desc_plantilla[al_row] 	 	= ls_data
			this.ii_update = 1
		end if
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master


end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

MenuId.item[1].item[1].item[2].enabled = true
MenuId.item[1].item[1].item[3].enabled = true
MenuId.item[1].item[1].item[4].enabled = true
MenuId.item[1].item[1].item[5].enabled = true

MenuId.item[1].item[1].item[2].visible = true
MenuId.item[1].item[1].item[3].visible = true
MenuId.item[1].item[1].item[4].visible = true
MenuId.item[1].item[1].item[5].visible = true

MenuId.item[1].item[1].item[2].ToolbarItemvisible = true
MenuId.item[1].item[1].item[3].ToolbarItemvisible = true
MenuId.item[1].item[1].item[4].ToolbarItemvisible = true
MenuId.item[1].item[1].item[5].ToolbarItemvisible = true

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;date ld_fecha

ld_fecha = Today()

this.object.fecha_registro[al_row] = ld_fecha
this.object.cod_usr[al_row] 		  = gs_user
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_data, ls_codigo
date ld_fecha
this.AcceptText()

if row = 0 then
	return
end if

choose case upper(dwo.name)
		
	case "COD_FL_PLANTILLA"
		
		ls_codigo = trim(this.object.cod_fl_plantilla[row])
		ld_fecha  = Today()
		
		SetNull(ls_data)
		SELECT DESCRIPCION
			into :ls_data
		FROM FL_PLANT_PRESUP
		WHERE TO_CHAR(FECHA_FIN_VIGENCIA, 'yyyymmdd') >= to_char(:ld_fecha, 'yyyymmdd') 
		  AND TO_CHAR(FECHA_INICIO_VIGENCIA, 'yyyymmdd') <= to_char(:ld_fecha, 'yyyymmdd') 
		  AND ORIGEN = :gs_origen
		  and cod_fl_plantilla = :ls_codigo;
		  
		if IsNull(ls_data) or ls_data = '' then
			MessageBox('APROVISIONAMIENTO', 'CODIGO DE PLANTILLA PRESUPUESTAL NO EXISTE', stopSign!)
			SetNull(ls_codigo)
			this.object.cod_fl_plantilla[row] = ls_codigo
			this.object.desc_plantilla[row] = ls_codigo
			return 1
		end if

		this.object.desc_plantilla[row] 	 	= ls_data
		
end choose
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type em_ano from editmask within w_ap314_asig_plant_prsp
event ue_keyup pbm_keyup
integer x = 933
integer y = 32
integer width = 334
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event ue_keyup;If Key = KeyEnter! or Key=KeyTab! Then
	parent.event ue_query_retrieve()
end if
end event

type st_1 from statictext within w_ap314_asig_plant_prsp
integer x = 475
integer y = 44
integer width = 439
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el año :"
alignment alignment = right!
boolean focusrectangle = false
end type

