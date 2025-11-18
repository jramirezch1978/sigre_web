$PBExportHeader$w_cn018_def_centro_costo.srw
forward
global type w_cn018_def_centro_costo from w_abc_master_lstmst
end type
type cb_1 from commandbutton within w_cn018_def_centro_costo
end type
type st_2 from statictext within w_cn018_def_centro_costo
end type
type sle_year from singlelineedit within w_cn018_def_centro_costo
end type
type uo_search from n_cst_search within w_cn018_def_centro_costo
end type
end forward

global type w_cn018_def_centro_costo from w_abc_master_lstmst
integer width = 4137
integer height = 2644
string title = "[CN018] Maestro de Centro de Costos"
string menuname = "m_abc_master_smpl"
cb_1 cb_1
st_2 st_2
sle_year sle_year
uo_search uo_search
end type
global w_cn018_def_centro_costo w_cn018_def_centro_costo

type variables
DatawindowChild idw_child_n2, idw_child_n3
end variables

on w_cn018_def_centro_costo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.cb_1=create cb_1
this.st_2=create st_2
this.sle_year=create sle_year
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_year
this.Control[iCurrent+4]=this.uo_search
end on

on w_cn018_def_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.sle_year)
destroy(this.uo_search)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cencos.protect")
IF ls_protect='0' THEN
  	dw_master.of_column_protect("cencos")
END IF

end event

event resize;// Override

dw_master.width  	= newwidth  - dw_master.x - 10
dw_master.height 	= newheight - dw_master.y - 10

dw_lista.height 	= newheight - dw_lista.y - 10

uo_search.width  = dw_lista.width
uo_search.event ue_resize( sizetype, dw_lista.width, newheight)


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

dw_master.of_set_flag_replicacion()

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return



ib_update_check = true
end event

event ue_open_pre;call super::ue_open_pre;sle_year.text = string(gnvo_app.of_fecha_actual(), 'yyyy')

this.event ue_retrieve()

uo_search.of_set_dw( dw_lista )
end event

event ue_dw_share;//Override
end event

event ue_retrieve;call super::ue_retrieve;Long	ll_row

ll_row = dw_lista.getRow()

dw_lista.Retrieve()

if dw_lista.RowCount() > ll_row and ll_row > 0 then
	dw_lista.SetRow(ll_row)
	dw_lista.SelectRow(0, false)
	dw_lista.SelectRow(ll_row, true)
	dw_lista.event ue_output(ll_row)
else
	dw_master.Reset()
	dw_master.ResetUpdate()
	dw_master.ii_update = 0
end if
end event

event ue_update;//Override

Boolean 	lbo_ok = TRUE
String	ls_crlf

ls_crlf = char(13) + char(10)

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		messagebox("Error", "Error en Grabacion en MAESTRO", StopSign!)
	END IF
END IF


IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ResetUpdate()
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	this.event ue_retrieve()
	
END IF


end event

type dw_master from w_abc_master_lstmst`dw_master within w_cn018_def_centro_costo
integer x = 1952
integer y = 88
integer width = 1659
integer height = 1512
string dataobject = "d_centros_costo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
ii_ck[1] = 1			// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;String ls_desc, ls_cod_n1, ls_cod_n2
Long ll_count

IF Getrow() = 0 THEN Return

this.AcceptText()

CHOOSE CASE dwo.name
		
	CASE 'grp_cntbl'	
	
		SELECT DESC_GRP_CNTBL
		  INTO :ls_desc
		  FROM GRUPO_CONTABLE c 
		WHERE c.GRP_CNTBL = :data ; 
		
		IF SQLCA.SQLCOde = 100 THEN
			MessageBox('Aviso','Grupo Contable no existe o no esta activo')
			this.object.grp_cntbl		[row] = gnvo_app.is_null
			this.object.desc_grp_cntbl	[row] = gnvo_app.is_null
			this.ii_update = 1
			Return	1
		END IF 
		
		this.object.desc_grp_cntbl	[row] = ls_desc
		this.ii_update = 1

	CASE 'cod_n1'	
	
		SELECT descripcion
		  INTO :ls_desc
		  FROM cencos_niv1 c 
		WHERE c.flag_estado = '1' 
		  AND c.cod_n1 = :data ; 
		
		IF SQLCA.SQLCOde = 100 THEN
			MessageBox('Aviso','Registro de nivel 1 no existe')
			this.object.cod_n1		[row] = gnvo_app.is_null
			this.object.desc_nivel1	[row] = gnvo_app.is_null
			this.ii_update = 1
			Return	1
		END IF 
		
		this.object.desc_nivel1	[row] = ls_desc
		this.ii_update = 1
				
	CASE 'cod_n2'
		ls_cod_n1 = dw_master.object.cod_n1[row]
		
		if ls_cod_n1 = "" or ISNull(ls_cod_n1) then
			MessageBox('Aviso','Debe indicar primero el nivel 1, por favor verifique')
			this.SetColumn('cod_n1')
			return 1
		end if
		
		SELECT descripcion
		  INTO :ls_desc
		  FROM cencos_niv2 c 
		WHERE c.flag_estado = '1' 
		  AND c.cod_n1 = :ls_cod_n1 
		  AND c.cod_n2 = :data; 
	
		IF SQLCA.SQLCOde = 100 THEN
			MessageBox('Aviso','Registro de nivel 2 no existe')
			this.object.cod_n2		[row] = gnvo_app.is_null
			this.object.desc_nivel2	[row] = gnvo_app.is_null
			this.ii_update = 1
			Return	1
		END IF 
		
		this.object.desc_nivel2	[row] = ls_desc
		this.ii_update = 1

	CASE 'cod_n3'
		ls_cod_n1 = dw_master.object.cod_n1[row]
		if ls_cod_n1 = "" or ISNull(ls_cod_n1) then
			MessageBox('Aviso','Debe indicar primero el nivel 1, por favor verifique')
			this.SetColumn('cod_n1')
			return 1
		end if

		ls_cod_n2 = dw_master.object.cod_n2[row]
		if ls_cod_n2 = "" or ISNull(ls_cod_n2) then
			MessageBox('Aviso','Debe indicar primero el nivel 2, por favor verifique')
			this.SetColumn('cod_n2')
			return 1
		end if
		
		SELECT descrippcion
		  INTO :ls_desc
		FROM cencos_niv3 c 
		WHERE c.flag_estado='1' 
		  and c.cod_n1 = :ls_cod_n1 
		  AND c.cod_n2 = :ls_cod_n2 
		  AND c.cod_n3 = :data ; 
	
		IF SQLCA.SQLCOde = 100 THEN
			MessageBox('Aviso','Registro de nivel 3 no existe')
			this.object.cod_n3		[row] = gnvo_app.is_null
			this.object.desc_nivel3	[row] = gnvo_app.is_null
			this.ii_update = 1
			Return	1
		END IF 
		
		this.object.desc_nivel3	[row] = ls_desc
		this.ii_update = 1

END CHOOSE

end event

event dw_master::ue_insert_pre;THIS.OBJECT.origen 		[al_row] = gs_origen
THIS.OBJECT.flag_estado [al_row] = '1'
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cencos_niv1, ls_cencos_niv2

choose case lower(as_columna)
	case "cod_n1"
		ls_sql = "SELECT COD_N1 AS CENCOS_NIV1, "&
				 + "DESCRIPCION AS descripcion_niv1 "&
				 + "FROM CENCOS_NIV1 " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n1		[al_row] = ls_codigo
			this.object.desc_nivel1	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_n2"
		ls_cencos_niv1 = this.object.cod_n1[this.GetRow()]
		
		if ls_cencos_niv1 = '' or IsNull(ls_cencos_niv1) then
			f_mensaje("Debe Seleccionar primero el nivel1, por favor verifica", "")
			this.SetColumn("cod_n1")
		end if
		
		ls_sql = "SELECT COD_N2 AS CENCOS_NIV2, "&				
				 + "DESCRIPCION AS DESCRIPCION_NIV2 "&
				 + "FROM CENCOS_NIV2 " &
				 + "WHERE COD_N1 = '" + ls_cencos_niv1 + "'" &
				 + "  and FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n2		[al_row] = ls_codigo
			this.object.desc_nivel2	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_n3"
		ls_cencos_niv1 = this.object.cod_n1[this.GetRow()]
		
		if ls_cencos_niv1 = '' or IsNull(ls_cencos_niv1) then
			f_mensaje("Debe Seleccionar el nivel1, por favor verifica", "")
			this.SetColumn("cod_n1")
		end if
		
		ls_cencos_niv2 = this.object.cod_n2[this.GetRow()]
		
		if ls_cencos_niv2 = '' or IsNull(ls_cencos_niv2) then
			f_mensaje("Debe Seleccionar el nivel2, por favor verifica", "")
			this.SetColumn("cod_n2")
		end if

		ls_sql = "SELECT COD_N3 AS CENCOS_NIV3, "&
				 + "DESCRIPPCION AS DESCRIPCION_NIV3 "&
				 + "FROM CENCOS_NIV3 " &
				 + "WHERE COD_N1 = '" + ls_cencos_niv1 + "'" &
				 + "  AND COD_N2 = '" + ls_cencos_niv2 + "'" &
				 + "  and FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_n3		[al_row] = ls_codigo
			this.object.desc_nivel3	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "grp_cntbl"
		ls_sql = "SELECT GRP_CNTBL AS GRUPO_CONTABLE, " &
				  + "DESC_GRP_CNTBL AS DESC_GRUPO_CONTABLE " &
				  + "FROM GRUPO_CONTABLE " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.GRP_CNTBL		[al_row] = ls_codigo
			this.object.DESC_GRP_CNTBL	[al_row] = ls_data
			this.ii_update = 1
		end if

END CHOOSE

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

type dw_lista from w_abc_master_lstmst`dw_lista within w_cn018_def_centro_costo
integer x = 0
integer y = 88
integer width = 1938
integer height = 1676
string dataobject = "d_lista_centros_costo_tbl"
end type

event dw_lista::constructor;call super::constructor;ii_ck[1] = 1      // columnas de lectrua de este dw

end event

event dw_lista::ue_output;call super::ue_output;if al_row = 0 then 
	dw_master.reset()

else
	dw_master.retrieve(this.object.cencos		[al_row])
end if

dw_master.ResetUpdate()

dw_master.ii_protect = 0

end event

event dw_lista::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
if currentrow > 0 then
	this.event ue_output(currentrow)
end if
end event

type cb_1 from commandbutton within w_cn018_def_centro_costo
integer x = 2761
integer width = 617
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Crear presupuesto"
end type

event clicked;integer	li_year

li_year = integer(sle_year.text)

update presupuesto_partida pp
   set pp.tipo_prtda_prsp = (select pc.tipo_cuenta
                               from presupuesto_cuenta pc
                              where pc.cnta_prsp = pp.cnta_prsp)
where pp.tipo_prtda_prsp is null;  

if gnvo_app.of_ExistsError(SQLCA, 'ACTUALIZAR TABLA presupuesto_partida') then
	rollback;
	return
end if

commit;

insert into presupuesto_partida(
       ano, cencos, cnta_prsp, flag_estado, flag_ctrl, flag_ingr_egr, flag_cmp_directa, TIPO_PRTDA_PRSP)
select :li_year,
       s.cencos, 
       s.cnta_prsp,
       '1',
       '0',
       DECODE(pc2.niv1, 'EG', 'E', 'I') as flag_ing_egr,
       '2',
		 pc2.tipo_cuenta
from (       
	SELECT cc.cencos, pc.cnta_prsp
	  FROM CENTROS_COSTO CC,
			 PRESUPUESTO_CUENTA PC
	where cc.flag_estado = '1'
	  and pc.flag_estado = '1' 
	minus
	select p.cencos, p.cnta_prsp
	  from presupuesto_partida p
	where p.flag_estado <> '0'
	  and p.ano = :li_year
) s,
presupuesto_cuenta pc2
where pc2.cnta_prsp = s.cnta_prsp;

if gnvo_app.of_ExistsError(SQLCA, 'INSERTAR TABLA presupuesto_partida') then
	rollback;
	return
end if

commit;
f_mensaje("Proceso ejecutado satisfactoriamente", "")
end event

type st_2 from statictext within w_cn018_def_centro_costo
integer x = 2021
integer y = 8
integer width = 201
integer height = 68
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

type sle_year from singlelineedit within w_cn018_def_centro_costo
integer x = 2286
integer width = 443
integer height = 84
integer taborder = 20
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

type uo_search from n_cst_search within w_cn018_def_centro_costo
integer width = 1911
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

