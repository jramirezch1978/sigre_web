$PBExportHeader$w_cn044_tipo_mov_matriz_subcateg.srw
forward
global type w_cn044_tipo_mov_matriz_subcateg from w_abc_master_smpl
end type
type sle_tipo_mov from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
end type
type st_1 from statictext within w_cn044_tipo_mov_matriz_subcateg
end type
type pb_1 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
end type
type sle_grp_contab from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
end type
type st_2 from statictext within w_cn044_tipo_mov_matriz_subcateg
end type
type pb_2 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
end type
type sle_sub_categ from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
end type
type sle_matriz from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
end type
type st_3 from statictext within w_cn044_tipo_mov_matriz_subcateg
end type
type st_4 from statictext within w_cn044_tipo_mov_matriz_subcateg
end type
type cb_1 from commandbutton within w_cn044_tipo_mov_matriz_subcateg
end type
type pb_3 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
end type
type gb_1 from groupbox within w_cn044_tipo_mov_matriz_subcateg
end type
end forward

global type w_cn044_tipo_mov_matriz_subcateg from w_abc_master_smpl
integer width = 3662
integer height = 1796
string title = "Matrices Contables por Sub categoria de articulos (CN044)"
string menuname = "m_abc_master_smpl"
sle_tipo_mov sle_tipo_mov
st_1 st_1
pb_1 pb_1
sle_grp_contab sle_grp_contab
st_2 st_2
pb_2 pb_2
sle_sub_categ sle_sub_categ
sle_matriz sle_matriz
st_3 st_3
st_4 st_4
cb_1 cb_1
pb_3 pb_3
gb_1 gb_1
end type
global w_cn044_tipo_mov_matriz_subcateg w_cn044_tipo_mov_matriz_subcateg

on w_cn044_tipo_mov_matriz_subcateg.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.sle_tipo_mov=create sle_tipo_mov
this.st_1=create st_1
this.pb_1=create pb_1
this.sle_grp_contab=create sle_grp_contab
this.st_2=create st_2
this.pb_2=create pb_2
this.sle_sub_categ=create sle_sub_categ
this.sle_matriz=create sle_matriz
this.st_3=create st_3
this.st_4=create st_4
this.cb_1=create cb_1
this.pb_3=create pb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_tipo_mov
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.sle_grp_contab
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.sle_sub_categ
this.Control[iCurrent+8]=this.sle_matriz
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.pb_3
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn044_tipo_mov_matriz_subcateg.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_tipo_mov)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.sle_grp_contab)
destroy(this.st_2)
destroy(this.pb_2)
destroy(this.sle_sub_categ)
destroy(this.sle_matriz)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.pb_3)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
sle_tipo_mov.text = '%'
sle_grp_contab.text = '%'
sle_sub_categ.text = '%'
sle_matriz.text = '%'

end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_mov.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_mov")
END IF
ls_protect=dw_master.Describe("grp_cntbl.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("grp_cntbl")	
END IF
ls_protect=dw_master.Describe("cod_sub_cat.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_sub_cat")
END IF
ls_protect=dw_master.Describe("item.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("item")
END IF



end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

event ue_dw_share;// Override

//IF ii_lec_mst = 1 THEN dw_master.Retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn044_tipo_mov_matriz_subcateg
integer y = 216
integer width = 3589
integer height = 1344
string dataobject = "d_abc_tipo_mov_matriz_subcateg_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_ck[3] = 3				// columnas de lectura de este dw
ii_ck[4] = 4				// columnas de lectura de este dw

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::itemchanged;call super::itemchanged;// Ventanas de ayuda
String ls_descrip
Long ll_count
IF Getrow() = 0 THEN Return

CHOOSE CASE dwo.name
		 CASE 'tipo_mov'
			SELECT count(*) INTO :ll_count
			FROM articulo_mov_tipo
			WHERE tipo_mov = :data ;
			
			IF ll_count > 0 THEN
				select desc_tipo_mov into :ls_descrip
				from articulo_mov_tipo
				where tipo_mov = :data ;
			
				this.SetItem( row, 'desc_tipo_mov', ls_descrip)
			ELSE
				messagebox('Aviso','Tipo de movimiento no existe')
			END IF
			
			ii_update = 1
			
		 CASE 'matriz'
			SELECT count(*) INTO :ll_count
			FROM matriz_cntbl_finan
			WHERE matriz = :data ;

			IF ll_count >0 THEN
				select descripcion into :ls_descrip
				from matriz_cntbl_finan
				where matriz = :data ;
				
				this.SetItem( row, 'desc_matriz', ls_descrip)
			ELSE
				messagebox('Aviso','Matriz contable no existe')
			END IF
			ii_update = 1

		 CASE 'cod_sub_cat'
			SELECT count(*) INTO :ll_count
			FROM articulo_sub_categ
			WHERE cod_sub_cat = :data ;
			
			IF ll_count > 0 THEN			
				select desc_sub_cat into :ls_descrip
				from articulo_sub_categ
				where cod_sub_cat = :data ;

				this.SetItem( row, 'desc_sub_cat', ls_descrip)
			ELSE
				messagebox('Aviso','Sub Categoria no existe')
			END IF

			ii_update = 1

END CHOOSE

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cat_Art
choose case lower(as_columna)

	 CASE 'tipo_mov'
		
			ls_sql = "SELECT TIPO_MOV AS TIPO_MOV, "&
					 + "DESC_TIPO_MOV AS DESC_TIPO_MOV "&
					 + "FROM ARTICULO_MOV_TIPO " &
					 + "WHERE FLAG_CONTABILIZA= '1' " &
					 + "  and flag_estado = '1'"
			
			IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
				this.object.tipo_mov			[al_row] = ls_codigo
				this.object.desc_tipo_mov	[al_row] = ls_data
				this.ii_update = 1
			END IF
			
	 CASE 'grp_cntbl'
			
			ls_sql = 'SELECT GRUPO_CONTABLE.GRP_CNTBL AS GRP_CNTBL, '&
					 + 'GRUPO_CONTABLE.DESC_GRP_CNTBL AS DESCRIP '&
					 + 'FROM GRUPO_CONTABLE ' 
					 
			IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
				this.object.grp_cntbl			[al_row] = ls_codigo
				this.ii_update = 1
			END IF

	CASE 'matriz'
			
			ls_sql = 'SELECT t.MATRIZ AS MATRIZ, '&
					 + 't.DESCRIPCION AS DESCRIPCION_matriz '&
					 + 'FROM MATRIZ_CNTBL_FINAN t ' &
					 + "where substr(t.matriz, 1, 2) in ('NI', 'VS') " &
					 + " and t.flag_estado = '1'"
					 
			IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
				this.object.matriz		[al_row] = ls_codigo
				this.object.desc_matriz	[al_row] = ls_data
				this.ii_update = 1
			END IF
			
	CASE 'cat_art'
			
		ls_sql = "select a1.cat_Art as codigo_Categoria, " &
				 + "a1.desc_categoria as descripcion_categoria " &
				 + "from articulo_categ a1 " &
				 + "where a1.flag_estado = '1'"
				 
		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
			this.object.cat_art			[al_row] = ls_codigo
			this.object.desc_categoria	[al_row] = ls_data
			this.ii_update = 1
		END IF
			
	CASE 'cod_sub_cat'
		ls_cat_art = this.object.cat_art [al_row]
		
		if IsNull(ls_cat_art) or trim(ls_cat_Art) = '' then
			MessageBox('Error', 'Debe especificar primero una categoria', StopSign!)
			this.setColumn('cat_art')
			return
		end if
		
		ls_sql = 'SELECT a2.COD_SUB_CAT AS SUB_CATEG, '&
				 + 'a2.DESC_SUB_CAT AS DESCRIPCION '&
				 + 'FROM ARTICULO_SUB_CATEG a2 ' &
				 + "where a2.car_art = '" + ls_cat_art + "'" &
				 + "  and a2.flag_estado = '1'"
					 
			IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
				this.object.cod_sub_cat		[al_row] = ls_codigo
				this.object.desc_sub_cat	[al_row] = ls_data
				this.ii_update = 1

			END IF

end choose

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

type sle_tipo_mov from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
integer x = 297
integer y = 68
integer width = 178
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
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn044_tipo_mov_matriz_subcateg
integer x = 50
integer y = 88
integer width = 238
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo mov."
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
integer x = 494
integer y = 68
integer width = 114
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\SIGRE\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO_MOV_TIPO.TIPO_MOV AS TIPO, '&
										 +'ARTICULO_MOV_TIPO.DESC_TIPO_MOV AS DESCRIPCION '&
										 +'FROM ARTICULO_MOV_TIPO ' 
						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_tipo_mov.text =lstr_seleccionar.param1[1]
END IF

end event

type sle_grp_contab from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
integer x = 905
integer y = 68
integer width = 110
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cn044_tipo_mov_matriz_subcateg
integer x = 672
integer y = 88
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "GContab:"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
integer x = 2222
integer y = 68
integer width = 114
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\SIGRE\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_flag_estado

ls_flag_estado = '1'

			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT MATRIZ_CNTBL_FINAN.MATRIZ AS CODIGO, '&
										 +'MATRIZ_CNTBL_FINAN.DESCRIPCION AS DESCRIP, '&
										 +'MATRIZ_CNTBL_FINAN.FLAG_ESTADO AS ESTADO '&										 
										 +'FROM MATRIZ_CNTBL_FINAN ' & 
										 +'WHERE FLAG_ESTADO = ' + +"'"+ls_flag_estado+"'"
						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_matriz.text =lstr_seleccionar.param1[1]
END IF


end event

type sle_sub_categ from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
integer x = 1394
integer y = 68
integer width = 201
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_matriz from singlelineedit within w_cn044_tipo_mov_matriz_subcateg
integer x = 2002
integer y = 68
integer width = 192
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn044_tipo_mov_matriz_subcateg
integer x = 1152
integer y = 88
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sub Cat:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn044_tipo_mov_matriz_subcateg
integer x = 1829
integer y = 88
integer width = 165
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Matriz:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn044_tipo_mov_matriz_subcateg
integer x = 2391
integer y = 72
integer width = 288
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_tipo_mov, ls_grp_contab, ls_sub_categ, ls_matriz

ls_tipo_mov = TRIM(sle_tipo_mov.text)+'%'
ls_grp_contab = TRIM(sle_grp_contab.text)+'%'
ls_sub_categ = TRIM(sle_sub_categ.text)+'%'
ls_matriz = TRIM(sle_matriz.text)+'%'

//IF ISNULL(ls_tipo_mov) OR ls_tipo_mov='' THEN
//	ls_tipo_mov = '%%'
//END IF 	
//IF ISNULL(ls_grp_contab) OR ls_grp_contab='' THEN
//	ls_grp_contab = '%%' 
//END IF	
//IF ISNULL(ls_sub_categ) OR ls_sub_categ='' THEN	
//	ls_sub_categ = '%%' 
//END IF 	
//IF ISNULL(ls_matriz) OR ls_matriz='' THEN		
//	ls_matriz = '%%'
//END IF	

idw_1.retrieve(ls_tipo_mov, ls_grp_contab, ls_sub_categ, ls_matriz)
end event

type pb_3 from picturebutton within w_cn044_tipo_mov_matriz_subcateg
integer x = 1623
integer y = 68
integer width = 114
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\SIGRE\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO_SUB_CATEG.COD_SUB_CAT AS CODIGO, '&
										 +'ARTICULO_SUB_CATEG.DESC_SUB_CAT AS DESCRIPCION, '&
										 +'ARTICULO_SUB_CATEG.FLAG_ESTADO AS ESTADO '&										 
										 +'FROM ARTICULO_SUB_CATEG ' 
						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_sub_categ.text =lstr_seleccionar.param1[1]
END IF

end event

type gb_1 from groupbox within w_cn044_tipo_mov_matriz_subcateg
integer x = 27
integer y = 8
integer width = 2706
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

