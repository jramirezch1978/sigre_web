$PBExportHeader$w_pr047_enrolamiento.srw
forward
global type w_pr047_enrolamiento from w_abc_master_smpl
end type
end forward

global type w_pr047_enrolamiento from w_abc_master_smpl
integer width = 3886
integer height = 2068
string title = "[PR047] Registro y enrolamiento de tarjetas"
string menuname = "m_mantto_smpl"
end type
global w_pr047_enrolamiento w_pr047_enrolamiento

on w_pr047_enrolamiento.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr047_enrolamiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update;call super::ue_update;dw_master.of_set_flag_replicacion( )
this.event ue_dw_share()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;//Override
str_parametros	lstr_param
w_abc_enrolamiento lw_1

lstr_param.w1 = this
OpenWithParm(lw_1, lstr_param)

//this.event ue_retrieve( )
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 

this.event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;dw_master.Retrieve()
//this.event ue_query_retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr047_enrolamiento
event ue_display ( string as_columna,  long al_row )
integer width = 3799
integer height = 1780
string dataobject = "d_abc_enrolamiento_tbl"
end type

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event dw_master::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		ls_sql = "select und as codigo, desc_unidad as descripcion from unidad"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		this.ii_update = 1
		
	case 'grp_medicion'
		ls_sql = "select grp_medicion as codigo, descripcion as nombre from tg_med_act_atributo_grp"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim (ls_return1) = '' then return
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		this.ii_update = 1
end choose
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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2

If this.ii_protect = 1 or row <= 0 then return

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'und'
		select und, desc_unidad
			into :ls_return1, :ls_return2
			from unidad
			where und = :data;
			
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.und[row] = ls_return1
		this.object.desc_unidad[row] = ls_return2
		
		return 2
		
	case 'grp_medicion'
		select grp_medicion, descripcion 
			into :ls_return1, :ls_return2
			from tg_med_act_atributo_grp
			where grp_medicion = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, "No se encuentra la unidad")
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.grp_medicion[row] = ls_return1
		this.object.grp_descripcion[row] = ls_return2
		
		return 2
		
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

