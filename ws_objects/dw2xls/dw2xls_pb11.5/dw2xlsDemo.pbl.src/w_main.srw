$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type rb_13 from radiobutton within w_main
end type
type rb_12 from radiobutton within w_main
end type
type rb_11 from radiobutton within w_main
end type
type rb_10 from radiobutton within w_main
end type
type rb_9 from radiobutton within w_main
end type
type st_1 from statictext within w_main
end type
type ddlb_1 from dropdownlistbox within w_main
end type
type rb_8 from radiobutton within w_main
end type
type rb_7 from radiobutton within w_main
end type
type rb_6 from radiobutton within w_main
end type
type cbx_2 from checkbox within w_main
end type
type cbx_1 from checkbox within w_main
end type
type rb_5 from radiobutton within w_main
end type
type rb_2 from radiobutton within w_main
end type
type dw_1 from datawindow within w_main
end type
type cb_2 from commandbutton within w_main
end type
type rb_4 from radiobutton within w_main
end type
type rb_3 from radiobutton within w_main
end type
type rb_1 from radiobutton within w_main
end type
type cb_1 from commandbutton within w_main
end type
type gb_1 from groupbox within w_main
end type
type gb_2 from groupbox within w_main
end type
end forward

global type w_main from window
integer width = 5157
integer height = 2260
boolean titlebar = true
string title = "dw->Excel  HuangGuoChou@163.Net"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_export ( string as_filetype )
rb_13 rb_13
rb_12 rb_12
rb_11 rb_11
rb_10 rb_10
rb_9 rb_9
st_1 st_1
ddlb_1 ddlb_1
rb_8 rb_8
rb_7 rb_7
rb_6 rb_6
cbx_2 cbx_2
cbx_1 cbx_1
rb_5 rb_5
rb_2 rb_2
dw_1 dw_1
cb_2 cb_2
rb_4 rb_4
rb_3 rb_3
rb_1 rb_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_main w_main

type prototypes
FUNCTION ulong GetSysColor(ulong nIndex) LIBRARY "user32.dll"
end prototypes

type variables

end variables

event ue_export(string as_filetype);Boolean lb_SetBorder ,lb_MergeColumnHeader
Boolean lb_SetMaxRow 
String  ls_ObjName 
String   ls_BorderBeinObj, ls_BorderEndObj
String   ls_FileName
Int li_PrintHeader
n_cst_dw2excel  n_excel




//设置报表从列标题行开始，到报表的最后一行，是否需要输出单元边框
//如果报表是Grid形式的报表，不需要设置

IF rb_3.Checked OR rb_7.Checked Then
	lb_SetBorder=True
	
	//让程序尝试自动合并数据列标题
	lb_MergeColumnHeader=True
	ls_ObjName="t_1"
	
	//设置边框的起止对象
	ls_BorderBeinObj="t_1"
	ls_BorderEndObj="t_7"
END IF

IF rb_13.Checked Then
	lb_SetBorder=True
	lb_MergeColumnHeader=True
	ls_ObjName="t_3"
	
		//设置边框的起止对象
	ls_BorderBeinObj="t_3"
	ls_BorderEndObj="t_6"
	
	lb_SetMaxRow=True 
END IF


IF as_FileType="excel" Then
	ls_FileName="c:\1.xls"
ELSE
	ls_FileName="C:\1.vts"
END IF 


//n_Excel.OF_SetFileType(as_FileType)
n_Excel.OF_OpenExcelFile(cbx_1.Checked)
n_Excel.OF_SetTipsWindow("w_tipsabc","正在生成Excel文件,请稍候.....")

IF as_FileType="vts" Then
//	n_Excel.OF_SetShowTips(False)
	OpenWithParm(w_Tipsabc,"正在进行数据处理,请稍候.....")
//	n_Excel.OF_SetMaxRow(lb_SetMaxRow) 
END IF 

n_Excel.OF_SetGridBorder(lb_SetBorder,ls_BorderBeinObj,ls_BorderEndObj)
//n_Excel.OF_SetBackColor(cbx_2.Checked)
n_excel.OF_MergeColumnHeader(lb_MergeColumnHeader,ls_ObjName)
n_Excel.OF_SetPrintHeader(li_PrintHeader)
n_Excel.OF_OpenExcelFile(cbx_1.Checked)
n_Excel.OF_SetTipsWindow("w_tipsabc","正在生成Excel文件,请稍候.....")
n_excel.OF_dw2Excel(dw_1,ls_FileName)

end event

on w_main.create
this.rb_13=create rb_13
this.rb_12=create rb_12
this.rb_11=create rb_11
this.rb_10=create rb_10
this.rb_9=create rb_9
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.rb_8=create rb_8
this.rb_7=create rb_7
this.rb_6=create rb_6
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.rb_5=create rb_5
this.rb_2=create rb_2
this.dw_1=create dw_1
this.cb_2=create cb_2
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_1=create rb_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.rb_13,&
this.rb_12,&
this.rb_11,&
this.rb_10,&
this.rb_9,&
this.st_1,&
this.ddlb_1,&
this.rb_8,&
this.rb_7,&
this.rb_6,&
this.cbx_2,&
this.cbx_1,&
this.rb_5,&
this.rb_2,&
this.dw_1,&
this.cb_2,&
this.rb_4,&
this.rb_3,&
this.rb_1,&
this.cb_1,&
this.gb_1,&
this.gb_2}
end on

on w_main.destroy
destroy(this.rb_13)
destroy(this.rb_12)
destroy(this.rb_11)
destroy(this.rb_10)
destroy(this.rb_9)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.rb_8)
destroy(this.rb_7)
destroy(this.rb_6)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.rb_5)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;dw_1.Resize(NewWidth -30 ,NewHeight - dw_1.y -30) 

end event

event open;dw_1.Modify("sys_lastcol.width='0'")
ddlb_1.SelectItem(1) 


end event

type rb_13 from radiobutton within w_main
integer x = 1573
integer y = 196
integer width = 297
integer height = 60
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Free"
end type

event clicked;dw_1.DataObject="rp_kfyjd1"
//Int li
//For li=1 To 10
//	dw_1.InsertRow(0)
//Next 

end event

type rb_12 from radiobutton within w_main
integer x = 1257
integer y = 200
integer width = 297
integer height = 60
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Free"
end type

event clicked;
dw_1.DataObject="d_1"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()


end event

type rb_11 from radiobutton within w_main
integer x = 878
integer y = 200
integer width = 270
integer height = 60
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Nested"
end type

event clicked;

dw_1.DataObject="d_dept_manage_emp"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()


end event

type rb_10 from radiobutton within w_main
integer x = 485
integer y = 200
integer width = 270
integer height = 60
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Nested"
end type

event clicked;
dw_1.dataobject="d_select_customer"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve("yost","alberto")


end event

type rb_9 from radiobutton within w_main
integer x = 46
integer y = 200
integer width = 329
integer height = 72
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Composite"
end type

event clicked;dw_1.DataObject="d_Composite"
dw_1.InsertRow(0) 
end event

type st_1 from statictext within w_main
integer x = 1029
integer y = 348
integer width = 357
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "表头打印设置"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_main
integer x = 1390
integer y = 336
integer width = 1221
integer height = 300
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
boolean sorted = false
string item[] = {"每页都打印报表表头和组表头","每页都打印报表表头，但组表头只在第一页打印","只在第一页打印"}
borderstyle borderstyle = stylelowered!
end type

type rb_8 from radiobutton within w_main
integer x = 1733
integer y = 76
integer width = 338
integer height = 60
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crosstab2"
end type

event clicked;

dw_1.DataObject="d_dwexample_crosstab"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

end event

type rb_7 from radiobutton within w_main
integer x = 1134
integer y = 76
integer width = 261
integer height = 60
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Free3"
end type

event clicked;dw_1.DataObject="d_kccbhzb_notline"

end event

type rb_6 from radiobutton within w_main
integer x = 2103
integer y = 76
integer width = 242
integer height = 60
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sparse"
end type

event clicked;

dw_1.DataObject="d_dwexample_grid"
//dw_1.dataobject="d_1"
//dw_1.DataObject="d_select_customer" 

dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

end event

type cbx_2 from checkbox within w_main
integer x = 2994
integer y = 80
integer width = 411
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 16711680
long backcolor = 67108864
string text = "输出背景颜色"
boolean checked = true
end type

type cbx_1 from checkbox within w_main
integer x = 2418
integer y = 80
integer width = 549
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 16711680
long backcolor = 67108864
string text = "提示打开Excel文件"
boolean checked = true
end type

type rb_5 from radiobutton within w_main
integer x = 1399
integer y = 76
integer width = 302
integer height = 60
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crosstab"
end type

event clicked;
dw_1.DataObject="d_crosstab"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

end event

type rb_2 from radiobutton within w_main
integer x = 306
integer y = 76
integer width = 270
integer height = 60
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grid2"
end type

event clicked;dw_1.DataObject="d_sds_gzdy"
dw_1.Modify("sys_lastcol.width='0'")

end event

type dw_1 from datawindow within w_main
integer x = 9
integer y = 444
integer width = 2368
integer height = 784
integer taborder = 90
string title = "none"
string dataobject = "d_sale_detail_report"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_main
integer x = 366
integer y = 320
integer width = 306
integer height = 104
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "退出"
end type

event clicked;Close(Parent)
end event

type rb_4 from radiobutton within w_main
integer x = 878
integer y = 76
integer width = 297
integer height = 60
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 67108864
string text = "Free2"
end type

event clicked;dw_1.dataobject="d_sales_rep_report"
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()


end event

type rb_3 from radiobutton within w_main
integer x = 581
integer y = 76
integer width = 402
integer height = 60
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Free 1"
end type

event clicked;dw_1.DataObject="d_kccbhzb"
end event

type rb_1 from radiobutton within w_main
integer x = 41
integer y = 76
integer width = 251
integer height = 60
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grid1"
boolean checked = true
end type

event clicked;dw_1.DataObject="d_sale_detail_report"
//dw_1.dataobject="d_loading_list"
//dw_1.importfile("loadig.dbf")
dw_1.Modify("sys_lastcol.width='0'")
end event

type cb_1 from commandbutton within w_main
integer x = 46
integer y = 320
integer width = 306
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "dw->Excel"
end type

event clicked;Event ue_Export("excel") 
end event

type gb_1 from groupbox within w_main
integer x = 14
integer width = 2363
integer height = 304
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "选择报表格式"
end type

type gb_2 from groupbox within w_main
integer x = 2386
integer width = 1147
integer height = 176
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 33554432
long backcolor = 67108864
string text = "其它"
end type

