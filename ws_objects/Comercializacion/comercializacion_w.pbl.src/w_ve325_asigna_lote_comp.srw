$PBExportHeader$w_ve325_asigna_lote_comp.srw
forward
global type w_ve325_asigna_lote_comp from w_abc_master_smpl
end type
type st_4 from statictext within w_ve325_asigna_lote_comp
end type
type sle_year from singlelineedit within w_ve325_asigna_lote_comp
end type
type st_3 from statictext within w_ve325_asigna_lote_comp
end type
type sle_mes from singlelineedit within w_ve325_asigna_lote_comp
end type
type cb_buscar from commandbutton within w_ve325_asigna_lote_comp
end type
type gb_3 from groupbox within w_ve325_asigna_lote_comp
end type
end forward

global type w_ve325_asigna_lote_comp from w_abc_master_smpl
integer x = 0
integer y = 0
integer width = 3465
integer height = 1792
string title = "[VE325] Asignar Lotes y Letras a un comprobante"
string menuname = "m_mantenimiento_sl"
long backcolor = 67108864
integer ii_x = 0
boolean ib_update_check = false
st_4 st_4
sle_year sle_year
st_3 st_3
sle_mes sle_mes
cb_buscar cb_buscar
gb_3 gb_3
end type
global w_ve325_asigna_lote_comp w_ve325_asigna_lote_comp

forward prototypes
public function string of_get_puerto ()
end prototypes

public function string of_get_puerto ();long 		ll_row, ll_number, ll_temp
string 	ls_puerto, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.puerto[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long(mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_puerto = gs_origen + string(ll_number,'000000')

return ls_puerto

end function

on w_ve325_asigna_lote_comp.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_4=create st_4
this.sle_year=create sle_year
this.st_3=create st_3
this.sle_mes=create sle_mes
this.cb_buscar=create cb_buscar
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.cb_buscar
this.Control[iCurrent+6]=this.gb_3
end on

on w_ve325_asigna_lote_comp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.cb_buscar)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

sle_year.text 	= string(gnvo_app.of_fecha_actual(), 'yyyy')
sle_mes.text 	= string(gnvo_app.of_fecha_actual(), 'mm')
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

event ue_retrieve;call super::ue_retrieve;Integer li_year, li_mes

li_year 	= integer(sle_year.text)
li_mes 	= integer(sle_mes.text)

dw_master.Retrieve(li_year, li_mes)
end event

type dw_master from w_abc_master_smpl`dw_master within w_ve325_asigna_lote_comp
integer y = 212
integer width = 3401
integer height = 1108
string dataobject = "d_abc_lotes_comprobantes_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_puerto

ls_puerto = of_get_puerto()

this.object.puerto		[al_row] = ls_puerto
this.object.profundidad [al_row] = 0
this.object.flag_estado	[al_row] = '1'
end event

event dw_master::itemchanged;call super::itemchanged;this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'tipo_ref'
		
		this.object.nro_ref				[row] = gnvo_app.is_null
		this.object.item_ref				[row] = gnvo_app.is_null
		this.object.full_nro_doc_ref	[row] = gnvo_app.is_null
		
		this.ii_update = 1

END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_sql, ls_cliente, ls_tipo_ref, ls_nro_ref, &
			ls_nro_letra, ls_item_ref, ls_full_nro_doc_ref, ls_Cod_art, ls_mnz, &
			ls_lote, ls_centro_benef, ls_desc_centro, ls_tipo_doc
			
choose case lower(as_columna)
		
	case "tipo_ref"
		ls_cliente = this.object.cod_relacion [al_row]
		
		ls_tipo_doc = this.object.tipo_doc [al_row]
		
		if trim(ls_tipo_doc) = 'FAC' or trim(ls_tipo_doc) = 'BVC' then
		
			ls_sql = "select distinct " &
					 + "       ccd.tipo_doc as tipo_doc, " &
					 + "       ccd.nro_doc as nro_doc,  " &
					 + "       lpad(trim(cc.nro_letra), 2, '00') as nro_letra, " &
					 + "       ccd.item as item, " &
					 + "       substr(pkg_fact_electronica.of_get_full_nro(cc.nro_doc),1,20) as full_nro_doc, " &
					 + "       ccd.cod_art as codigo_articulo, " &
					 + "       a.mnz as manzana, " &
					 + "       a.lote as lote, " &
					 + "       cb.centro_benef as centro_beneficio, " &
					 + "       cb.desc_centro as desc_centro_beneficio " &
					 + "from cntas_cobrar cc, " &
					 + "     cntas_cobrar_det ccd, " &
					 + "     articulo         a, " &
					 + "     centro_beneficio cb, " &
					 + "     (select cc.tipo_doc, cc.nro_doc " &
					 + "        from cntas_cobrar cc " &
					 + "      minus " &
					 + "      select ccd.tipo_ref, ccd.nro_ref " &
					 + "        from cntas_cobrar     cc, " &
					 + "             cntas_cobrar_det ccd " &
					 + "       where cc.tipo_doc  = ccd.tipo_doc " &
					 + "         and cc.nro_doc   = ccd.nro_doc " &
					 + "         and cc.flag_estado <> '0' " &
					 + "         and ccd.tipo_ref is not null " &
					 + "         and ccd.nro_ref   is not null) s " &
					 + "where cc.tipo_doc = ccd.tipo_doc " &
					 + "  and cc.nro_doc  = ccd.nro_doc " &
					 + "  and cc.tipo_doc = s.tipo_doc " &
					 + "  and cc.nro_doc  = s.nro_doc " &
					 + "  and ccd.cod_art = a.cod_art " &
					 + "  and ccd.centro_benef = cb.centro_benef " &
					 + "  and ccd.cod_art is not null " &
					 + "  and cc.tipo_doc = 'LTC' " &
					 + "  and cc.cod_relacion = '" + ls_cliente + "' " &
					 + "order by a.mnz, a.lote, nro_letra"

		else
			
			//cuando sea nota de credito o nota de debito
			ls_sql = "select distinct " &
					 + "       ccd.tipo_doc as tipo_doc, " &
					 + "       ccd.nro_doc, " &
					 + "       lpad(trim(cc2.nro_letra), 2, '000') as nro_letra, " &
					 + "       ccd.item as item, " &
					 + "       pkg_fact_electronica.of_get_full_nro(cc.nro_doc) as full_nro_doc, " &
					 + "       ccd.cod_art as cpdigo_articulo, " &
					 + "       a.mnz as manzana, " & 
					 + "       a.lote as lote, " &
					 + "       cb.centro_benef as centro_benef, " &
					 + "       cb.desc_centro as desc_centro_benef " &
					 + "from cntas_cobrar cc, " &
					 + "     cntas_cobrar_det ccd, " &
					 + "     articulo         a, " &
					 + "     centro_beneficio cb, " &
					 + "     cntas_cobrar     cc2, " &
					 + "     (select cc.tipo_doc, cc.nro_doc " &
					 + "        from cntas_cobrar cc " &
					 + "      minus " &
					 + "      select ccd.tipo_ref, ccd.nro_ref " &
					 + "        from cntas_cobrar     cc, " &
					 + "             cntas_cobrar_det ccd " &
					 + "       where cc.tipo_doc  = ccd.tipo_doc " &
					 + "         and cc.nro_doc   = ccd.nro_doc " &
					 + "         and cc.flag_estado <> '0' " &
					 + "         and ccd.tipo_ref is not null " &
					 + "         and ccd.nro_ref   is not null) s " &
					 + "where cc.tipo_doc = ccd.tipo_doc " &
					 + "  and cc.nro_doc  = ccd.nro_doc" &
					 + "  and cc.tipo_doc = s.tipo_doc" &
					 + "  and cc.nro_doc  = s.nro_doc" &
					 + "  and ccd.tipo_ref = cc2.tipo_doc (+)" &
					 + "  and ccd.nro_ref  = cc2.nro_doc  (+)" &
					 + "  and ccd.cod_art = a.cod_art" &
					 + "  and ccd.centro_benef = cb.centro_benef" &
					 + "  and ccd.cod_art is not null" &
					 + "  and cc.tipo_doc in ('BVC', 'FAC')  " &
					 + "  and cc.cod_relacion like '" + ls_cliente + "'" &
					 + "order by a.mnz, a.lote, nro_letra" &

			
		end if
		
		
		lb_ret = f_lista_5ret(ls_sql, ls_tipo_ref, ls_nro_ref, ls_nro_letra, ls_item_ref, ls_full_nro_doc_ref, '3')
		
		if ls_tipo_ref <> '' then
			this.object.tipo_ref				[al_row] = ls_tipo_ref
			this.object.nro_ref				[al_row] = ls_nro_ref
			this.object.item_ref				[al_row] = Long(ls_item_ref)
			this.object.full_nro_doc_ref	[al_row] = ls_full_nro_doc_ref
			
			// Obtengo los dats de la manzana, lote y centro beneficio
			select ccd.cod_art, a.mnz, a.lote, cb.centro_benef, cb.desc_centro
				into :ls_Cod_art, :ls_mnz, :ls_lote, :ls_centro_benef, :ls_desc_centro
			from 	cntas_cobrar_det ccd,
					articulo         a,
					centro_beneficio cb
			where ccd.cod_art 		= a.cod_art
			  and ccd.centro_benef 	= cb.centro_benef     
			  and ccd.tipo_doc		= :ls_tipo_ref
			  and ccd.nro_doc			= :ls_nro_ref;
			
			this.object.cod_art 		[al_row] = ls_cod_art
			this.object.mnz 			[al_row] = ls_mnz
			this.object.lote 			[al_row] = ls_lote
			this.object.centro_benef[al_row] = ls_centro_benef
			this.object.desc_centro	[al_row] = ls_desc_centro
  
			this.ii_update = 1
		end if

end choose



end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type st_4 from statictext within w_ve325_asigna_lote_comp
integer x = 32
integer y = 80
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_ve325_asigna_lote_comp
integer x = 201
integer y = 72
integer width = 192
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ve325_asigna_lote_comp
integer x = 416
integer y = 80
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_ve325_asigna_lote_comp
integer x = 649
integer y = 72
integer width = 105
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_ve325_asigna_lote_comp
integer x = 795
integer y = 68
integer width = 265
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type gb_3 from groupbox within w_ve325_asigna_lote_comp
integer width = 1125
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

