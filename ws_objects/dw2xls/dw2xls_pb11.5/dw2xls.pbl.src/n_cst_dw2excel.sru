$PBExportHeader$n_cst_dw2excel.sru
forward
global type n_cst_dw2excel from nonvisualobject
end type
type os_size from structure within n_cst_dw2excel
end type
type os_fontlist from structure within n_cst_dw2excel
end type
end forward

type os_size from structure
	long		l_cx
	long		l_cy
end type

type os_fontlist from structure
	string		fontname
	integer		fontsize
	integer		fontweight
	integer		fontheight
end type

global type n_cst_dw2excel from nonvisualobject autoinstantiate
event of_test ( datawindow adw )
end type

type prototypes
FUNCTION ulong GetSysColor(ulong nIndex) LIBRARY "user32.dll"

Function ulong GetDC(ulong hWnd) Library "USER32.DLL"
Function long ReleaseDC(ulong hWnd, ulong hdcr) Library "USER32.DLL"
Function boolean GetTextExtentPoint32W(ulong hdcr, string lpString, long nCount, ref os_size size) Library "GDI32.DLL" 
Function ulong SelectObject(ulong hdc, ulong hWnd) Library "GDI32.DLL"
FUNCTION ulong GetLocaleInfo(ulong Locale,ulong LCType,ref string lpLCData,ulong cchData) LIBRARY "kernel32.dll" ALIAS FOR "GetLocaleInfoW" 




end prototypes

type variables
 Boolean  	ib_OpenExcel =false       //在导出完成之后,是否提示用户打开Excel文件
 boolean		ib_showmsg = true			//在导出完成之后，是否提示导出成功的提示信息(taoqing增加)

Private:
	
 Datastore  ids_Column
 DataStore  ids_Objects
 Datastore  ids_dwcObjects 
 DataStore  ids_ReportObj
 DataStore  ids_MergeCells 
 Datastore  ids_Bands 
 
 DataStore  ids_Line
 DataStore  ids_RowHeight
 datawindow idw_Requestor       //数据窗口对象
 
 
 String 		is_OldBand
 String 		is_dwcOldBand 
 Boolean    lb_NestedFlag=False    //报表是否组合报表或嵌套报表
 
 Int    		ii_MaxCol
 LOng   		ii_BorderBeginRow, ii_BorderEndRow 
 Long    	ii_DetailRow
 Boolean  	ib_GridBorder=True
 Boolean  	ib_MergeColumnHeader=False     //列标题是否尝试自动合并单元
 Boolean  	ib_SparseFlag
 String   	is_TipsWindow="w_tips"
 String   	is_OpenParm
 Boolean  	ib_GroupNewPage[] 
 String   	is_BeginRowObj
 Boolean  	ib_OutLine =False 
 Boolean    ib_GroupOutFlag =True // True 分组输出方式,每个分组都正常输出  False  组头和组尾只输出一次,如个人所得税明细表的声明,不需要每页都输出
                                   // 否则报表格式变得有点乱 
											  
 Boolean    ib_FormFlag=True      //如果是True，则程序会自动根据报表是否有线条来判断报表是否表格报表
                                  //如果为False， 则程序不会把报表作为表格报表进行处理
 Int        ii_FirstColumn=2  
 String   	is_BorderEndObj  
 String   	is_BorderBeginObj 
  Int       ii_PrintHeader=2   //每页都打印   /2只打印表头区的对象 不打印分组表头区的对象   /  只在第一页打印,其它页不打印
 String     is_Units

Window       iw_Parent
StaticText   iuo_Text


//新增变量   2004-9-10
 long 		 ii_RowSpace  =30
 long        ii_ColSpace  =30
 String      is_LineTag='0' 
 
 
n_xls_workbook   invo_workbook
n_xls_worksheet  invo_worksheet 
n_xls_cell       invo_cell 
n_dwr_colors	  invo_colors 

String is_Format_Currency  //"￥#,#0.00"

//新增变量   2004 -11 -11 
os_fontlist    istr_FontList[] 

end variables

forward prototypes
public subroutine of_openexcelfile (boolean ab_flag)
public subroutine of_settipswindow (string as_winname, string as_openparm)
public subroutine of_setprintheader (integer ai_style)
public subroutine of_setgridborder (boolean ab_flag, string as_beginobj, string as_endobj)
public subroutine of_setgridborder (boolean ab_flag)
public subroutine of_about ()
public function integer of_dw2excel (datawindow adw, string as_filename)
public subroutine of_setobjspace (integer ai_rowspace, integer ai_colspace)
public subroutine of_setformflag (boolean ab_flag)
public subroutine of_setlinetag (string as_tag)
protected subroutine of_guage (unsignedlong al_step)
protected function string of_get_currency_format ()
protected subroutine of_get_format (ref string as_format, ref string as_exp, string as_type)
protected function string of_evaluate (string as_express, long al_row)
protected subroutine of_colrowinfo ()
protected function long of_arraytostring (string as_source[], string as_delimiter, ref string as_ref_string)
protected subroutine of_check_property (ref string as_str, ref string as_expression)
protected subroutine of_closeuserobject ()
protected function string of_evaluate (datastore a_ds, string as_express, long al_row)
protected function integer of_get_penwidth (integer ai_width)
protected subroutine of_getcolumninfo ()
protected subroutine of_getobjects ()
protected function integer of_getobjects (string as_objname)
protected function string of_getobjspace (long al_width)
protected subroutine of_getrowheight ()
protected function unsignedlong of_getsyscolor (unsignedlong al_pbcolor)
protected function integer of_outdata (datastore a_ds, string as_reportname, long ai_currow, string as_band, long ai_row)
protected function integer of_groupcount ()
protected subroutine of_gridinfo (string as_reportname, string as_bands[])
public subroutine of_mergecolumnheader (boolean ab_flag, string as_objname)
protected function boolean of_openuserobject ()
protected function string of_replaceall (string as_string1, string as_string2, string as_string3)
protected function integer of_outdata (long ai_currow, string as_band, long ai_row)
protected function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[])
public subroutine of_setgroupoutflag (boolean as_flag)
protected function string of_getdata (readonly long ai_row, readonly string as_objectname, readonly string as_coltype, string as_format, string as_displayvalue, string as_columnflag, boolean ab_overlap)
protected function string of_getdata (datastore a_ds, long ai_row, string as_objectname, string as_coltype, string as_format, string as_displayvalue, string as_columnflag, boolean ab_overlap)
public function long of_lastpos (string as_source, string as_target)
public function long of_lastpos (string as_source, string as_target, long al_start)
public function integer of_iswraptext (string as_fontname, integer ai_fontsize, integer ai_fontweight, integer ai_height)
end prototypes

public subroutine of_openexcelfile (boolean ab_flag);ib_OpenExcel=ab_Flag
end subroutine

public subroutine of_settipswindow (string as_winname, string as_openparm);is_TipsWindow=as_WinName
is_OpenParm=as_OpenParm
end subroutine

public subroutine of_setprintheader (integer ai_style);ii_PrintHeader=ai_Style
end subroutine

public subroutine of_setgridborder (boolean ab_flag, string as_beginobj, string as_endobj);
//对于非Grid形式的数据窗口，需要在代码中指定是否需要设置报表单元的边框
//如果是Grid形式的数据窗口，不需要指定

ib_GridBorder=ab_Flag 

is_BorderBeginObj=as_BeginObj
is_BorderEndObj=as_EndObj
end subroutine

public subroutine of_setgridborder (boolean ab_flag);ib_GridBorder=ab_Flag
end subroutine

public subroutine of_about ();MessageBox("关于DW2XLS","程序设计: HuangGuoChou ~r~n"+&
                        "电子邮箱: huanggc@163.com ~n~n~r~n" +&
								"如果对程序有任何意见或建议,请写信与我联系,谢谢!!")
								
end subroutine

public function integer of_dw2excel (datawindow adw, string as_filename);Long li,lj,lk, li_row, li_col
Long li_Rows_Per_Detail 
Double ld_Width 
Long li_CurRow,li_Count
Int li_GroupCount
Boolean   lb_TrailerFlag  



Window   lw 
OleObject	xlapp  //用于连接Excel 


IF Not IsValid(adw) THEN
	MessageBox("提示","数据窗口未指定或数据窗口已被关闭!",stopsign!)
	Return  -1
END IF

/*-------------------------------------------------------------------------------*/
//如果是Grid形式的数据窗口,则采用Formula one的版本进行导入
//使用F1导出的效率较高，但格式与采用原来的方式会有些不同
//所以根据实际需要看是否需要该功能，否自已在代码中增加相应的输出选项
IF adw.Describe("DataWindow.Processing")="1" Then 
	n_cst_dw2Excel_Grid   n_dw2xls
	n_dw2xls.is_TipsWindow = this.is_TipsWindow
	n_dw2xls.is_OpenParm = this.is_OpenParm
	Return n_dw2xls.OF_dw2Excel(adw,as_FileName)
END IF 
/*-------------------------------------------------------------------------------*/

	
	
	
//如果文件已存在,则先删除它,不然,EXCEL会显示提示信息
If FileExists (as_filename ) Then
  IF MessageBox("提示","文件 "+ as_filename+" 已经存在,是否继续?",Question!,YesNo!)=2 Then
	  Return -1
  END IF  
	FileDelete(as_filename)
END IF	

//检查给定的文件路径是否可以写入
li_row=FileOpen(as_filename,StreamMode!,Write!,LockWrite!,Replace!)
FileClose(li_row)
filedelete(as_filename)
IF li_row=-1  OR IsNull(li_row) THEN
	MessageBox("提示","指定的文件路径不能写入数据,请检查!",StopSign!)
	Return -1
END IF


idw_Requestor=adw
invo_workbook=create n_xls_workbook
IF invo_workbook.of_create(as_filename)<0 Then
	 Destroy invo_workbook
	 Return  -1 
END IF 


SetPointer(HourGlass! )
IF  Trim(is_TipsWindow)<>"" Then
	OpenWithParm(lw,is_OpenParm, is_TipsWindow)
END IF

invo_worksheet=invo_workbook.of_add_worksheet()
invo_colors=Create n_dwr_colors 
invo_colors.invo_writer=invo_workbook


//读取对象列表并计算分组数目
idw_Requestor.AcceptText()
li_GroupCount=OF_GroupCount() 
IF li_GroupCount>0 Then
	idw_Requestor.GroupCalc()
END IF

OF_GetObjects()
IF ib_SparseFlag Then
	ids_MergeCells=Create DataStore 
	ids_MergeCells.DataObject="d_dw2xls_mergecells"
END IF 

//设置细节区各列的列宽及文本格式
ids_Column.SetFilter("")
ids_Column.SetSort("StartCol A")
ids_Column.Filter()
ids_Column.Sort() 

//要处理数据窗口的Sparse，一定要按列排序
ids_Objects.SetSort(" X A, StartCol A , SartRow A ")
ids_Objects.Sort()

IF IsValid( ids_dwcObjects) Then 
	ids_dwcObjects.SetSort("X A, StartCol A , SartRow A  ")
	ids_dwcObjects.Sort()
END IF 


For li=1 To ids_Column.RowCount()
	 	  li_col=ids_Column.Object.StartCol[li]
		  ld_Width =ids_Column.Object.Width[li]
		  
		  Choose Case is_units 
				Case '1'
					 ld_Width = PixelsToUnits(ld_Width,XPixelsToUnits!)
				Case '2'
					ld_Width = PixelsToUnits(ld_Width * 96 / 1000, XPixelsToUnits!)
				Case '3'
					ld_Width = PixelsToUnits(ld_Width * 37.8 /1000 ,XPixelsToUnits!)
			END CHOOSE
			
		  //  2004-11-27  原来除以的值是30,会导致部份列的宽度不足以显示单元内容
		  //  虽然会导致部分报表在一页内不能完全打印,但原来的设置也会有这个情况,所以不考虑打印的情况
		  
		  ld_Width=ld_Width / 28   //如果缺省字体大小12,则应除以40 
		  IF ld_Width>0 Then
		  		invo_worksheet.of_set_column_width(li_col -1, ld_Width ) 
		  END IF
			
NEXT 	

//输出数据
//输出表头区
IF idw_Requestor.RowCount()>0 Then
	li_CurRow=Of_OutData(0,"header",1)
ELSE
	li_CurRow=Of_OutData(0,"header",0)
END IF

li_Count=idw_Requestor.RowCount() 
li_Rows_Per_Detail=Long(idw_Requestor.Describe("datawindow.rows_per_detail"))
FOR li_Row=1 To li_Count
	
	  lb_TrailerFlag=False
	  FOR lj=1 To li_GroupCount 
				 IF ib_GroupOutFlag Then
							 IF idw_Requestor.FindGroupChange(li_Row,lj)=li_Row Then    //分组的开始
										IF li_Row<>1 AND Not lb_TrailerFlag Then      //第一次,不用输出组的尾区
												 //组尾区的显示顺序,与组头区是倒过来的
												 lb_TrailerFlag=True 
												 For lk=li_GroupCount TO lj Step -1
													
															  IF Long(idw_Requestor.Describe("datawindow.trailer."+String(lk)+".height"))>0 Then
																		li_CurRow+=Of_OutData(li_CurRow,"trailer."+string(lk),li_Row -1)
																END IF
																
																//是否按组分页打印
																IF lj<=UpperBound(ib_GroupNewPage) Then
																	 IF ib_GroupNewPage[lk] Then
																			invo_WorkSheet.OF_Add_H_PageBreak(li_CurRow)
																			//保存分页的行号
																		END IF
																 END IF
												Next
										END IF
							
									 IF ii_PrintHeader<>1 OR li_Row=1 Then   //  ii_PrintHeader为1时,通过设置报表打印的标题行,来控制每页都打印标题
											IF Long(idw_Requestor.Describe("datawindow.header."+String(lj)+".height"))>0 Then
													li_CurRow+=Of_OutData(li_CurRow,"header."+string(lj),li_Row )
											END IF
									 END IF
							END IF
								 
					ELSEIF li_Row=1 Then
								IF Long(idw_Requestor.Describe("datawindow.header."+String(lj)+".height"))>0 Then
										li_CurRow+=Of_OutData(li_CurRow,"header."+string(lj),li_Row )
								END IF
					 END IF

		NEXT
	  //输出当前记录
	  li_CurRow+=Of_OutData(li_CurRow,"detail",li_Row)
	  li_Row=li_Row+li_Rows_Per_Detail -1
	 
		
NEXT 

//输出所有组的最后一组脚尾区

FOR lj=li_GroupCount To 1  Step -1 
   li_CurRow+=Of_OutData(li_CurRow,"trailer."+string(lj),idw_Requestor.RowCount())
NEXT 	

//输出汇总区
li_CurRow+=of_outdata(li_CurRow,"summary",idw_Requestor.rowcount())


//设置边线
IF ii_BorderBeginRow<=0 Then
	ii_BorderBeginRow=ii_DetailRow
END IF

IF ib_GridBOrder Then
	 
	IF ii_BorderEndRow<=0 Then
		ii_BorderEndRow=li_CurRow
	END IF
	
	IF ii_MaxCol>0 AND  ii_BorderBeginRow>0 AND ii_BorderEndRow>ii_BorderBeginRow Then
		For li=ii_BorderBeginRow TO  ii_BorderEndRow
			For lj=ii_FirstColumn To ii_MaxCol
				  invo_Cell=invo_WorkSheet.OF_GetCell(li,lj)
				  invo_Cell.invo_Format.ii_Left=1
				  invo_Cell.invo_Format.ii_Right=1
				  invo_Cell.invo_Format.ii_Top=1
				 invo_Cell.invo_Format.ii_Bottom=1
					
			Next
		Next
	END IF
	
	
	IF IsValid(ids_MergeCells) Then
			li_Count=ids_MergeCells.RowCount()
			For li=1 To li_Count
				
				 IF (ids_MergeCells.Object.EndRow[li] - ids_MergeCells.Object.StartRow[li])>0 Then
						 For li_Row=ids_MergeCells.Object.StartRow[li] To ids_MergeCells.Object.EndRow[li] 
							  For li_Col = ids_MergeCells.Object.StartCol[li] To ids_MergeCells.Object.EndCol[li]
							       invo_Cell=invo_WorkSheet.OF_GetCell(li_Row,li_Col)
									 If invo_Cell.ib_Empty Then
										 	Continue
									  END IF
										
									  IF li_Row=ids_MergeCells.Object.StartRow[li] Then
											 invo_Cell.invo_Format.ii_Bottom = 0 
									  ELSEIF li_Row=ids_MergeCells.Object.EndRow[li] Then
											invo_Cell.invo_Format.ii_Top = 0 
									  ELSE
											invo_Cell.invo_Format.ii_Bottom = 0 
											invo_Cell.invo_Format.ii_Top = 0 
									  END IF
								Next
						 Next
					END IF
			Next
	 END IF
END IF

li_CurRow+=of_outdata(li_CurRow,"footer",idw_Requestor.rowcount())

//关闭打开的用户对象
OF_CloseUserObject() 

IF ii_PrintHeader<>0 Then
	li_CurRow=0
	ids_Objects.SetFilter("band='header'")
	ids_Objects.Filter()
	li_CurRow=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',0)"))
	
	IF ii_PrintHeader=1 tHEN
		For li=1 To li_GroupCount 
			ids_Objects.SetFilter("band='header."+String(li)+"'")
			ids_Objects.Filter()
			li_CurRow+=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',0)"))
		Next
   END IF
		
	IF li_CurRow>0   Then   //设置标题行
			invo_worksheet.of_repeat_rows(0,li_CurRow -1 ) 
			invo_worksheet.of_freeze_panes (li_CurRow,0,li_CurRow ,0 ) 
	END IF
END IF


//输出打印设置
invo_worksheet.of_Set_Paper(Long(idw_Requestor.Describe("datawindow.print.paper.size")))

IF idw_Requestor.Describe("datawindow.print.Orientation")='1' Then
	invo_WorkSheet.of_set_orientation(0)
ELSE
	invo_WorkSheet.of_set_orientation(1)
END IF 
invo_worksheet.of_Set_print_scale(Long(idw_Requestor.Describe("datawindow.zoom ")))

//是否单色打印   2004-11-11 
IF idw_Requestor.Describe("datawindow.print.color")<>"1" Then 
	invo_worksheet.of_Set_print_NoColor(True)
ELSE
	invo_worksheet.of_Set_print_NoColor(False)
END IF
	

ld_Width= Long(idw_Requestor.Describe("datawindow.print.margin.Left"))
Choose Case is_Units 
	Case '0'
		  ld_Width = UnitsToPixels(ld_Width ,XUnitsToPixels!) * 0.0104 
	Case '1' 
		  ld_Width = ld_Width *  0.0104 
		Case '3'
	  	   	ld_Width =ld_Width / 1000  /2.54 
END CHOOSE
invo_WorkSheet.of_set_margin_left(ld_Width) 

ld_Width= Long(idw_Requestor.Describe("datawindow.print.margin.right"))
Choose Case is_Units 
	Case '0'
		  ld_Width = UnitsToPixels(ld_Width ,XUnitsToPixels!) * 0.0104 
	Case '1' 
		  ld_Width = ld_Width *  0.0104 
		Case '3'
	  	   	ld_Width =ld_Width / 1000  /2.54 
END CHOOSE
invo_WorkSheet.of_set_margin_right(ld_Width) 



ld_Width= Long(idw_Requestor.Describe("datawindow.print.margin.top"))
Choose Case is_Units 
	Case '0'
		  ld_Width = UnitsToPixels(ld_Width ,XUnitsToPixels!) * 0.0104 
	Case '1' 
		  ld_Width = ld_Width *  0.0104 
		Case '3'
	  	   	ld_Width =ld_Width / 1000  /2.54 
END CHOOSE
invo_WorkSheet.of_set_margin_Top(ld_Width) 

ld_Width= Long(idw_Requestor.Describe("datawindow.print.margin.bottom"))
Choose Case is_Units 
	Case '0'
		  ld_Width = UnitsToPixels(ld_Width ,XUnitsToPixels!) * 0.0104 
	Case '1' 
		  ld_Width = ld_Width *  0.0104 
		Case '3'
	  	   	ld_Width =ld_Width / 1000  /2.54 
END CHOOSE
invo_WorkSheet.of_set_margin_bottom(ld_Width) 
	


//invo_WorkSheet.of_insert_bitmap(20,1,"c:\1.bmp") 


//保存文件
invo_workbook.of_close() 

IF isvalid(lw) Then
	Close(lw)
END IF

IF ib_OpenExcel Then 
	IF MessageBox("提示","~r~n报表已成功导出到< "+as_FIleNAME+" >!~r~n你是否需要现在就打开这个Excel文件?~r~n~r~n",Question!,YesNo!,2)=1 Then
			
		xlApp=Create OleObject 	
		li_row= xlApp.ConnectToNewObject( "Excel.Application" )
		IF li_row < 0  Then
			MessageBox("提示","不能运行Excel程序,请检查是否已安装Microsoft Excel软件!")
		 ELSE
			  XlApp.Workbooks.Open(as_FileName)
			 xlApp.ActiveWindow.WindowState= -4137   //最大化窗口
			 xlApp.Visible = True
			 xlApp.DisConnectObject()
		 END IF
			
	 END IF
ELSE
   MessageBox("提示","报表已成功导出!文件路径为："+as_FIleNAME+"")
END IF 

destroy invo_workbook
destroy invo_worksheet

IF IsValid(ids_Line) Then
	Destroy ids_Line 
END IF

IF IsValid(ids_RowHeight) Then
	Destroy ids_RowHeight
END IF 

Destroy ids_Column
Destroy ids_Objects 

IF IsValid(ids_MergeCells) Then
	Destroy ids_MergeCells
END IF

IF IsValid(ids_reportobj) Then
	Destroy ids_reportobj
END IF

IF IsValid(ids_dwcObjects) Then
	Destroy ids_dwcObjects
END IF

IF IsValid(ids_Bands) Then
	Destroy ids_Bands
END IF

IF IsValid(xlApp) Then
	Destroy xlApp
END IF 

SetPointer(Arrow!)

Return 1 
end function

public subroutine of_setobjspace (integer ai_rowspace, integer ai_colspace);IF ai_RowSpace>0 Then
	ii_RowSpace=ai_RowSpace
END IF

IF ai_ColSpace>0 Then
	ii_ColSpace=ai_ColSpace
END IF 

end subroutine

public subroutine of_setformflag (boolean ab_flag);ib_FormFlag=ab_Flag 
end subroutine

public subroutine of_setlinetag (string as_tag);is_LineTag=as_Tag
end subroutine

protected subroutine of_guage (unsignedlong al_step);
end subroutine

protected function string of_get_currency_format ();INT LOCALE_USER_DEFAULT=1024 
INT LOCALE_SCURRENCY =20         //本位币货币符号
INT LOCALE_SMONDECIMALSEP=22    //货币小数点分割符 
INT LOCALE_SMONTHOUSANDSEP =23   //千位分割符
INT LOCALE_ICURRDIGITS = 25      //小数位数
INT LOCALE_SINTLSYMBOL= 21      
INT LOCALE_SMONGROUPING=24      //货币国际符号

Int li_Len = 100
Int li_Digits 
String ls_Temp 
String ls_Format 
String ls_symbol
String ls_SMONDECIMALSEP 
String ls_LOCALE_SMONTHOUSANDSEP

ls_Temp = Space(li_Len)

GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SCURRENCY, Ref ls_Temp, li_Len)
ls_symbol=Trim(ls_Temp)

GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_ICURRDIGITS, Ref ls_Temp, li_Len)
li_digits=Long(Trim(ls_Temp))

GetLocaleInfo ( LOCALE_USER_DEFAULT,LOCALE_SMONTHOUSANDSEP, Ref ls_Temp, li_Len)
ls_LOCALE_SMONTHOUSANDSEP=Trim(ls_Temp)

GetLocaleInfo ( LOCALE_USER_DEFAULT,LOCALE_SMONDECIMALSEP, Ref ls_Temp, li_Len)
ls_SMONDECIMALSEP= Trim(ls_Temp)


IF li_digits>0 Then
	ls_Format = ls_symbol+"#"+ls_LOCALE_SMONTHOUSANDSEP+"##0"+ls_SMONDECIMALSEP+Fill("0",li_digits)
ELSE
	ls_Format = ls_symbol+"#,##0"
END IF 

Return ls_Format
end function

protected subroutine of_get_format (ref string as_format, ref string as_exp, string as_type);long ll_pos
long ll_cnt
string ls_arr[]
string ls_emp[]
long ll_i


as_exp=""
ll_pos = pos(as_format, "@")
if ll_pos > 0 then
    as_format = "[general]"
end if
ll_pos = pos(lower(as_format), "[general]")

do while ll_pos > 0

    if as_Type = "D" then
        as_format = replace(as_format, ll_pos, 9, "dd.mm.yyyy")
    elseif as_Type = "DT" then
        as_format = replace(as_format, ll_pos, 9, "dd.mm.yyyy hh:mm")
    elseif as_Type = "T" then
        as_format = replace(as_format, ll_pos, 9, "hh:mm")
    else
        as_format = replace(as_format, ll_pos, 9, "@")
    end if

    ll_pos = pos(lower(as_format), "[general]")
loop

ll_pos = pos(lower(as_format), "[currency]")

do while ll_pos > 0
    as_format = replace(as_format, ll_pos, 10, is_Format_Currency)
    ll_pos = pos(lower(as_format), "[currency]")
loop

ll_pos = pos(lower(as_format), "[shortdate]")

do while ll_pos > 0
    as_format = replace(as_format, ll_pos, 11, "dd.mm.yyyy")
    ll_pos = pos(lower(as_format), "[shortdate]")
loop

ll_pos = pos(lower(as_format), "[date]")

do while ll_pos > 0
    as_format = replace(as_format, ll_pos, 6, "dd.mm.yyyy")
    ll_pos = pos(lower(as_format), "[date]")
loop

ll_pos = pos(lower(as_format), "[time]")

do while ll_pos > 0
    as_format = replace(as_format, ll_pos, 6, "hh:mm")
    ll_pos = pos(lower(as_format), "[time]")
loop

 as_format = of_replaceAll(as_format, "'", "~"")
 as_format =of_replaceAll(as_format, "@", "General")
 
 if pos(as_format, ";") > 0 then
    ll_cnt = of_parsetoarray(as_format, ";", ls_arr)

    choose case as_type
        case "N"

            if ll_cnt > 3 then
                ll_cnt = 3
            end if

    end choose

     of_arraytostring(ls_emp, ";", as_format)
end if


 ll_pos = pos(lower(as_format), "~t")

 if ll_pos > 0 then
        as_exp = right(as_format, len(as_format) - ll_pos)

        if right(as_exp, 1) = "~"" then
            as_exp =Trim(left(as_exp, len(as_exp) - 1))
        end if

        as_format = left(as_format, ll_pos - 1)

        if left(as_format, 1) = "~"" then
            as_format = right(as_format, len(as_format) - 1)
        end if

end if



end subroutine

protected function string of_evaluate (string as_express, long al_row);/*----------------------------------------------------------------------------
    求指定表达式的值
	 
	 返回值是字符串类型
	 如果计算有错误,返回空值
	 
	 
	 应用示例：
	            long l_sum
					int li_page,li_pagecount
					l_sum=long(of_getvalud("1+30+120",1))
					li_page=integer(of_getvale("page()",1))
					li_pagecount=integer(of_getvalue("pagecount()",1))
					
					
------------------------------------------------------------------------------*/
String ls_ret
Int li_Pos
as_Express=Trim(as_Express) 

IF Left(as_Express,1)="'" AND Right(as_Express,1)="'"  Then
	as_Express=Mid(as_Express,2,Len(as_Express) -2) 
ELSE
	IF Left(as_Express,1)='"' AND Right(as_Express,1)='"'  Then
	   as_Express=Mid(as_Express,2,Len(as_Express) -2) 
  END IF
END IF 




li_Pos=Pos(as_Express,"~t")   //检查表达式是否数据窗口对象属性表达式的语法,如 font.color='200~tif(a=1,255,0)' 
IF li_Pos>0 Then
	as_Express=Mid(as_Express,li_POs+1) 
END IF 

as_Express=OF_ReplaceAll(as_Express,"'",'"' ) //把单引号换成双引号
ls_ret=idw_Requestor.describe("Evaluate('"+as_express+"', "	+string(al_row)+ ")")

IF ls_ret="?" OR ls_ret="!" THEN
	ls_ret=""
END IF

Return ls_ret
end function

protected subroutine of_colrowinfo ();Long li,lj,li_Row
Long li_Count
Long li_StartCol,li_EndCol 
Long li_Y
Long li_BeginRow
Long li_ColCount
String ls_Processing
String ls_Band
Boolean lb_ForeGroundFlag
Boolean   lb_Border

DataStore lds_Temp 

Long   ll_ObjSpace = 100  //用于判断两个对象的间隔
Long   ll_Space 


//对象上下是否有线条
Long    li_Line_Top
Long    li_Line_Bottom
Long    li_Line_Left
Long    li_Line_Right


ls_Processing=idw_Requestor.Describe("datawindow.processing")
ids_Column.SetSort("x A ")
ids_Column.Sort()
ii_MaxCol=Long(ids_Column.Describe("Evaluate('Max(EndCol)',1)"))

ids_Objects.SetFilter("isReport<>'1' ")   //2004-11-28 
ids_Objects.Filter()

ids_Line.SetFilter("")
ids_Line.Filter()
IF ids_Line.RowCount()>0 Then
	 lb_Border=True
END IF

IF lb_Border Then

		lds_Temp=Create DataStore 
		lds_Temp.DataObject=ids_Line.DataObject
		
		ids_Line.SetFilter("lineType='v'")
		ids_Line.Filter()
		ids_Line.RowsCopy(1,ids_Line.RowCount(),Primary!,lds_Temp,1,Primary!) 
		
		ids_Line.SetFilter("lineType='h'")
		ids_Line.SetSort("ReportName A, Band A, Y1 A ")
		ids_Line.Filter()
		ids_Line.Sort()
		
		lds_Temp.SetSort("ReportName A, Band A, X1 A ")
		lds_Temp.Sort()


		
	
		IF ids_Line.RowCount()>0 AND ib_FormFlag Then
				//先取得对象的四条边线
				For li=1 TO ids_Objects.RowCount()
					 
					  //找到对象的上一条横线
						li_Row=ids_Line.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND y1<= "+String(ids_Objects.Object.y[li]+ ii_RowSpace)+" and x1< "+string(ids_objects.object.x2[li])+" and x2> " +string(ids_objects.object.x[li]) ,ids_Line.rowcount(),1)
						IF li_Row>0 Then
							 ids_Objects.Object.TopLine[li]=ids_Line.Object.y1[li_Row]
						END IF
						  
						//找到对象的下边线
						li_Row=ids_Line.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"'  AND y1>= "+String(ids_Objects.Object.y2[li] - ii_RowSpace)+" and x1< "+string(ids_objects.object.x2[li])+" and x2> "+string(ids_objects.object.x[li]) ,1,ids_Line.rowcount())
						IF li_Row>0 Then
								ids_Objects.Object.BottomLine[li]=ids_Line.Object.y1[li_Row]
						END IF 
				
					  //左边线
					  li_Row=lds_Temp.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' " +&
													 "  AND y1<= "+String(ids_Objects.Object.Y[li] +ii_RowSpace)+" AND Y2>= "+String(ids_Objects.Object.Y2[li] - ii_RowSpace)+" AND x1< "+String(ids_Objects.Object.x[li]+ii_ColSpace),lds_Temp.RowCount(),1)
					  IF li_Row>0 Then
							  ids_Objects.Object.LeftLine[li]=lds_Temp.Object.x1[li_Row]
							  ids_Objects.Object.StartCol[li]=lds_Temp.Object.StartCol[li_Row] 
					  END IF 
					  
						//找到对象的右边线
					  li_Row=lds_Temp.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND  Band='"+ids_Objects.Object.Band[li]+"' " +&
												 " AND y1<= "+String(ids_Objects.Object.Y[li] + ii_RowSpace)+" AND Y2>= "+String(ids_Objects.Object.Y2[li] - ii_RowSpace)+" AND x1> "+String(ids_Objects.Object.x2[li] - ii_ColSpace),1,lds_Temp.RowCount())
				
						IF li_Row>0 then
							 ids_Objects.Object.RightLine[li]=lds_Temp.Object.x1[li_Row]
							 ids_Objects.Object.EndCol[li]=lds_Temp.Object.StartCol[li_Row] -1
						END IF
							
				Next 
				Destroy lds_Temp
		END IF
END IF
	


ids_Objects.SetSort("reportName A , Band A, y A  ")  
ids_Objects.Sort() 
//判断对象在第几行
li_Count=ids_Objects.RowCount()
For lj=1 To 2
	For li=1 To li_Count
		         
					
					
					//找到对象的开始行
					li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND y2< "+String(ids_Objects.Object.y[li])+" AND Band='"+ids_Objects.Object.Band[li]+"'",li -1 ,1 )
					IF li_Row>0 Then
						 
						ids_Objects.Object.StartRow[li]=ids_Objects.Object.EndRow[li_Row] +1
						ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li]
				  END IF
					
							
					//找到对象的结束行
					li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND y>"+String(ids_Objects.Object.y2[li] -  ii_RowSpace )+" AND Band='"+ids_Objects.Object.Band[li]+"'",li+1 ,ids_Objects.RowCount())
					IF li_Row>0 Then
						 IF ids_Objects.Object.StartRow[li_Row]>ids_Objects.Object.StartRow[li] Then
								ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li_Row] -1
						 END IF
					ELSE
						 li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND EndRow>"+String(ids_Objects.Object.EndRow[li])+" AND Band='"+ids_Objects.Object.Band[li]+"'",1,ids_Objects.RowCount())
						 IF li_Row>0 Then
								 ids_Objects.Object.EndRow[li]=ids_Objects.Object.EndRow[li_Row] 
						 END IF
					END IF
	Next 
Next


//判断对象在第几列
ids_Objects.SetSort(" x A   ")  //如果同一列有多个对象,则按上下位置排序
ids_Objects.SetFilter("isreport<>'1' ") //name<>'' 
ids_Objects.Filter() 
ids_Objects.Sort() 
li_Count=ids_Objects.RowCount()





For	li=1 To li_Count
       li_StartCol=0
		 li_EndCol=0
		 
		 IF ids_Objects.Object.Name[li]="report_title" AND ids_Objects.Object.ReportName[li]="" Then // 
			 IF ids_Objects.Find("startrow="+string(ids_objects.object.startrow[li])+" AND Name<>'report_title'",1,ids_objects.RowCount())<=0 Then 
					 ids_Objects.Object.StartCol[li]=ii_FirstColumn
					 ids_Objects.Object.EndCol[li]=ii_MaxCol
					 Continue 
			 END IF
				
		 END IF
		 
	   
		   //找到对象的结束列
		   li_Row=1
			IF ids_Objects.Object.LeftLine[li]>0 AND ids_Objects.Object.RightLine[li]>0 Then
				
						li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND  Band='"+ids_Objects.Object.Band[li]+"' " +&
												 " AND name<>'"+ids_Objects.Object.Name[li]+"' AND TopLine="+String(ids_Objects.Object.TopLine[li]) +&
												 " AND BottomLine="+String(ids_Objects.Object.BottomLine[li] )+" AND LeftLine="+String(ids_Objects.Object.LeftLine[li])+ & 
												 " AND RightLine="+String(ids_Objects.Object.RightLine[li] ),1,ids_Objects.RowCount())
												 
                 IF li_Row>0 Then
						    //先保存起来,以免下面再找一次
							 ids_Objects.Object.CellFlag[li]='1'
					  END IF
						
			 END IF
											
												 
         IF li_Row>0  Then   //单元内有其它对象或非表格
			
  					 //找到对象的开始列
					 
					    li_Row=ids_Column.Find("x2<="+String(ids_Objects.Object.x[li] + ii_ColSpace),ids_Column.RowCount(),ii_FirstColumn)
						 IF li_Row>0 Then
								li_StartCol=ids_Column.Object.EndCol[li_Row]+1
		 				  ELSE
								li_StartCol=ii_FirstColumn 	
		              END IF
		 
							li_Row=ids_Column.Find("x>"+string(ids_Objects.Object.x2[li] -ii_ColSpace ) ,ii_FirstColumn,ids_Column.RowCount())
							if li_Row>0 then
								li_EndCol=ids_Column.Object.StartCol[li_Row] -1
							ELSE
								li_EndCol=ii_MaxCol
							End if
							
							ids_Objects.Object.StartCol[li]=li_StartCol
							ids_Objects.Object.EndCol[li]=li_EndCol 
			END IF
	
	  	
		
		IF ids_Objects.Object.EndCol[li]<ids_Objects.Object.StartCol[li] Then
			ids_Objects.Object.EndCol[li]=ids_Objects.Object.StartCol[li]
		END IF
Next 




//使单元格合并,报表格式比较好
ids_Objects.SetFilter("LeftLine>0 AND RightLine>0 AND (TopLine>0 OR BottomLine>0) AND CellFlag<>'1' ")
ids_Objects.SetSort("ReportName A ,Band A , y A, X A   ")  //如果同一列有多个对象,则按上下位置排序
ids_Objects.Filter() 
ids_Objects.Sort() 

IF ids_Line.RowCount()>0 AND ids_Objects.RowCount()>0 Then
 	  // MessageBox('a',String(ids_Objects.RowCount()))

		For li=1 To ids_Objects.RowCount()
				IF ids_Objects.Object.TopLine[li]=0 AND ids_Objects.Object.Band[li]="header" Then
					 Continue
				ELSEIF ids_Objects.Object.BottomLine[li]=0 AND ids_Objects.Object.Band[li]="summary" THEN
					Continue
				END IF
				
				li_Line_Top=0
				li_Line_Bottom=0
				
				//重新找到横线
				IF ids_Objects.Object.TopLine[li]>0 Then   
						li_Line_Top=ids_Line.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND LineType='h' "+& 
						                          " and x1< "+string(ids_objects.object.x2[li])+" and x2> " +string(ids_objects.object.x[li]) +" AND y1= "+String(ids_Objects.Object.TopLine[li]) ,ids_Line.rowcount(),1)
				END IF
					
				//取单元的起始行
				IF li_Line_Top>0 Then
						li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' "+ &
													" AND name<>'' AND y>= "+string(ids_Line.Object.Y1[li_Line_Top] -ii_RowSpace )+" AND x< "+string(ids_Line.Object.x2[li_Line_Top] )+" AND x2> "+string(ids_Line.Object.x1[li_Line_Top] ),1,li -1 )
						IF li_Row>0 Then
								ids_Objects.Object.StartRow[li]=ids_Objects.Object.StartRow[li_Row]
						END IF
				ELSE
					  IF ids_Objects.Object.Band[li]<>"summary" AND ids_Objects.Object.Band[li]<>"footer" Then
						   ids_Objects.Object.StartRow[li]=1
					 END IF
					
			   END IF
				
				//取单元的结束行
				IF ids_Objects.Object.BottomLine[li]>0 Then   
						li_Line_Bottom=ids_Line.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND LineType='h' "+& 
						                            " and x1< "+string(ids_objects.object.x2[li])+" and x2> " +string(ids_objects.object.x[li]) +" AND y1= "+String(ids_Objects.Object.BottomLine[li]) ,ids_Line.rowcount(),1)
				END IF
				IF li_Line_Bottom>0 Then
						li_Row=ids_Objects.Find("reportname='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' "+ &
														" AND name<>'' AND y< "+string(ids_Line.Object.Y1[li_Line_Bottom] )+" AND x< "+string(ids_Line.Object.x2[li_Line_Bottom] )+" AND x2> "+string(ids_Line.Object.x1[li_Line_Bottom] ),ids_Objects.RowCount(),li +1 )
						IF li_Row>0 Then
							  IF ids_Objects.Object.EndRow[li_Row]>ids_Objects.Object.EndRow[li] Then
									ids_Objects.Object.EndRow[li]=ids_Objects.Object.EndRow[li_Row]
									
							 END IF
					   END IF
				ELSE
						//在表头区,可能没有在最后加一个横线
						IF ids_Objects.Object.Band[li]<>"summary" AND ids_Objects.Object.Band[li]<>"footer" Then
						    li_Row=ids_Objects.Find(" reportname='"+ids_Objects.Object.ReportName[li]+"'  AND Band='"+ids_Objects.Object.Band[li]+"' "+ &
							                         " AND name<>'' AND EndRow>"+String(ids_Objects.Object.EndRow[li]),ids_Objects.RowCount(), li+1)
                      IF li_Row>0 Then
								  ids_Objects.Object.EndRow[li]=ids_Objects.Object.EndRow[li_Row]
							 END IF
						END IF
				END IF

				IF  ids_Objects.Object.EndRow[li]<ids_Objects.Object.StartRow[li] then
					ids_Objects.Object.EndRow[li]=ids_Objects.Object.StartRow[li]
				END IF 
		Next
		
		Destroy lds_Temp
END IF



//如果是交叉报表,需要进一步进行处理
IF ls_Processing="4" Then
	ids_Objects.SetFilter("reportName='' AND band='header[1]' And name<>'' ")   //加Header是因为有些对象在 foreGround
	ids_Objects.Filter()
	For li_Row=1 TO ids_Objects.RowCount()
			 ids_Objects.Object.Band[li_Row]="header"
 	Next
	
	//计算出标题的行数
	li_BeginRow=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
	IF lb_ForeGroundFlag Then
	     ii_BorderBeginRow=li_BeginRow
	END IF
	ii_BorderBeginRow=ii_BorderBeginRow+1
	li_BeginRow=li_BeginRow+1
	
	
	li_Count=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
	li_Y=Long(idw_Requestor.Describe("datawindow.header[1].height"))
	li=2
	
	ls_Band="header["+String(li)+"]"
	Do While idw_Requestor.Describe("datawindow."+ls_Band+".height")<>"!"
		ids_Objects.SetFilter("reportName='' AND band='"+ls_Band+"'")
		ids_Objects.Filter()
		ids_Objects.Sort() 
		For li_Row=1 TO ids_Objects.RowCount()
			 ids_Objects.Object.Band[li_Row]="header"
			 ids_Objects.Object.Y[li_Row]= ids_Objects.Object.Y[li_Row]+li_Y
			 ids_Objects.Object.StartRow[li_Row]=ids_Objects.Object.StartRow[li_Row]+li_Count
			 ids_Objects.Object.EndRow[li_Row]=ids_Objects.Object.EndRow[li_Row]+li_Count
		Next
		
		li_Count=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
		li_Y+=Long(idw_Requestor.Describe("datawindow."+ls_Band+".height"))
		
		li++
		ls_Band="header["+String(li)+"]"
		

	Loop
END IF


IF lb_Border Then 
			//处理边框
			ids_Objects.SetFilter("isReport<>'1' ")
			ids_Objects.Filter()
			ids_Objects.SetSort("StartRow A, EndRow A  ")
			ids_Objects.Sort()
			
			ids_Line.SetFilter("")
			ids_Line.Filter()
			ids_Line.SetSort(" Y1 A ")// reportname A, Band A ,
			ids_Line.Sort() 
			For li=1 To ids_Line.RowCount()
					  li_Row=0
					
					  IF ids_Line.Object.LineType[li]='h' Then
							li_Row=ids_Objects.Find("reportname='"+ids_Line.object.ReportName[li]+"' AND Band='"+ids_Line.Object.Band[li]+"' AND  y2<= "+string(ids_Line.Object.Y1[li] +ii_RowSpace ) , ids_Objects.RowCount(),1  )  //
							IF li_Row>0  Then
								  ids_Line.Object.StartRow[li]=ids_Objects.Object.StartRow[li_Row]
							ELSE
								ids_Line.Object.StartRow[li]=1
							END IF
					  ELSE
							
							li_Row=ids_Objects.Find("reportname='"+ids_Line.object.ReportName[li]+"' AND Band='"+ids_Line.Object.Band[li]+"' AND  y>= "+string(ids_Line.Object.Y1[li] -ii_RowSpace ) ,1,ids_Objects.RowCount() )
							iF li_Row>0 Then
									 ids_Line.Object.StartRow[li]=ids_Objects.Object.StartRow[li_Row] 
							 END IF
					  END IF
						  
					 
					 ids_Line.Object.EndRow[li]=ids_Line.Object.StartRow[li]
					
					IF ids_Line.Object.LineType[li]='v' Then
						 li_Row=ids_Objects.Find("reportname='"+ids_Line.object.ReportName[li]+"' AND Band='"+ids_Line.Object.Band[li]+"' AND y2<= "+String(ids_Line.Object.Y2[li]+ii_RowSpace ),ids_Objects.RowCount(),1)			
						 IF li_Row>0 Then
								ids_Line.Object.EndRow[li]=ids_Objects.Object.EndRow[li_Row] 
						 END IF
					END IF
			Next
			
			ids_Line.SetFilter("")
			ids_Line.Filter()
			ids_Line.SetSort("x1 A  ")
			ids_Line.Sort() 
			li_ColCount=Long(ids_Column.Describe("Evaluate('Max(EndCol)',1)"))
			
			//取得需要输出边框的单元
			For li=1 To ids_Line.RowCount()
					LI_Row=ids_Column.Find("x<= "+String(ids_Line.Object.x1[li]+ii_ColSpace),ids_Column.RowCount(),ii_FirstColumn)
					 IF li_Row>0 Then
						 ids_Line.Object.StartCol[li]=ids_Column.Object.StartCol[li_Row]
					 ELSE
						  ids_Line.Object.StartCol[li]=ii_FirstColumn
					 END IF
				  
				 
				 ids_Line.Object.EndCol[li]=ids_Line.Object.StartCol[li]
				 
				 IF ids_Line.Object.LineType[li]='h' Then
						li_Row=ids_Column.Find("x>= "+String(ids_Line.object.x2[li] -ii_ColSpace), ii_FirstColumn, ids_Column.RowCount())
						IF li_Row>0 Then
							  IF ids_Column.Object.StartCol[li_Row]> ids_Line.Object.StartCol[li] Then
									ids_Line.Object.EndCol[li]=ids_Column.Object.StartCol[li_Row] -1
							  END IF
						ELSE
							ids_Line.Object.EndCol[li]=li_ColCount
						END IF
				 END IF 
			Next
END IF
		

//以下代码是避免不同的对象,同时写入Excel的同一单元
ids_Column.SetFilter("")
ids_Column.Filter()
ids_Column.SetSort("StartCol A")
ids_Column.Sort() 

ids_Objects.SetFilter("isreport<>'1' ")
ids_Objects.Filter() 
ids_Objects.SetSort("ReportName A,Band A , X  A ,StartRow A ,X2 A ")
ids_Objects.Sort() 
li_Count=ids_Objects.RowCount()

Choose Case is_units 
	Case '1'
			ll_ObjSpace = UnitsToPixels(ll_ObjSpace,XUnitsToPixels!)
	Case '2'
		   ll_ObjSpace = UnitsToPixels(ll_ObjSpace , XUnitsToPixels!) *  0.01041 * 1000 
	Case '3'
		   ll_ObjSpace =UnitsToPixels(ll_ObjSpace  , XUnitsToPixels!) * 0.02646 * 1000 
END Choose

For li=1 To li_Count
	
	 //如果对象只是用于设置边框 
	 IF ids_Objects.Object.IsBorderOnly[li]='1' Then
		   Continue
	 END IF
	
	 //如果对象是左对齐
	 IF ids_Objects.Object.Alignment[li]=1   Then   //Alignment已变为Excel的常量值
          IF ids_Objects.Object.StartCol[li]>=1 AND ids_Objects.Object.StartCol[li]<=ids_Column.RowCount() Then
				    
					 ll_Space= ids_Objects.Object.X[li] - ids_Column.Object.X[ids_Objects.Object.StartCol[li]]
					 
					 Choose Case is_Units
						  Case '1'
							   ll_Space=PixelsToUnits(ll_Space,XPixelsToUnits!)
						Case '2'
								  ll_Space=PixelsToUnits(ll_Space * 96 /1000 ,XPixelsToUnits!)
						Case '3'
								  ll_Space=PixelsToUnits(ll_Space * 37.8 /1000 ,XPixelsToUnits!)
						END CHOOSE
						
						IF ll_Space<= 50 Then
						 	ll_Space=0
						END IF
						
						ids_Objects.Object.ObjSpace[li]=	ll_Space		
						
		    END IF		 
    END IF	
	
	 //与前面是否有对象重复输出相同的单元
	 IF  li>1 Then  //ids_Objects.Object.EndCol[li]>ids_Objects.Object.StartCol[li] and
		  
			  li_Row=ids_Objects.Find("reportname='"+ids_ObjectS.Object.ReportName[li]+"' AND "+&
										 "band='"+ids_objects.object.band[li]+"' and "+& 
										 "isborderonly<>'1' and "+& 
										 "startrow<="+String(ids_Objects.Object.EndRow[li])+ " and "+ &
										 "endrow>="+String(ids_Objects.Object.StartRow[li])+" AND " + &
										 "endcol>="+String(ids_Objects.Object.StartCol[li]),li -1 ,1  )
										 
			 IF li_Row>0 Then
				
				      //如果对象离下一列的位置很近,则把它移到下一列输出
						IF ids_Objects.Object.EndCol[li]>ids_Objects.Object.EndCol[li_Row] Then
							 IF (ids_Column.Object.X[ids_Objects.Object.StartCol[li]+1] - ids_Objects.Object.x[li] )<ll_ObjSpace Then
                              ids_Objects.Object.StartCol[li]=  ids_Objects.Object.StartCol[li]+1
										ids_Objects.Object.ObjSpace[li]=0
	                          Continue
								END IF
						
						END IF
					   
								
										
							//如果上一对象离右边线很近,或者两个单元的字体不同
						 IF ids_Objects.Object.StartCol[li]>0 AND ids_Objects.Object.StartCol[li]<= ids_Column.RowCount() Then 
									IF ids_Objects.Object.x2[li_Row] - ids_Column.Object.X[ids_Objects.Object.StartCol[li]] <ll_ObjSpace Then
										IF ids_Objects.Object.EndCol[li_Row]>ids_Objects.Object.StartCol[li_Row]  Then  //AND ids_Objects.Object.FontSize[li_Row]<>ids_Objects.Object.FontSize[li] Then
												ids_Objects.Object.EndCol[li_Row]=  ids_Objects.Object.StartCol[li] - 1
												ids_Objects.Object.ObjSpace[li]=0
							
												Continue
												  
											ELSEIF  ids_Objects.Object.EndCol[li]>ids_Objects.Object.StartCol[li] Then
													  ids_Objects.Object.EndCol[li] = ids_Objects.Object.EndCol[li] -1 
												  Continue
										END IF
								  END IF 
							END IF
							
				        
						
							
		            ids_Objects.Object.StartCol[li]=ids_Objects.Object.StartCol[li_Row]
						IF ids_Objects.Object.x[li]> ids_Objects.Object.x2[li_Row] AND ids_Objects.Object.StartRow[li]= ids_Objects.Object.StartRow[li_Row] Then 
								ll_Space=ids_Objects.Object.x[li] - ids_Objects.Object.x2[li_Row]
								Choose Case is_Units
										Case '1'
												 ll_Space=PixelsToUnits(ll_Space,XPixelsToUnits!)
										Case '2'
												 ll_Space=PixelsToUnits(ll_Space * 96 /1000 ,XPixelsToUnits!)
										Case '3'
												ll_Space=PixelsToUnits(ll_Space * 37.8 /1000 ,XPixelsToUnits!)
								END CHOOSE
								IF ll_Space<= 50 Then
									ll_Space=0
								END IF 
								ids_Objects.Object.ObjSpace[li]=ll_Space 
						
								//把对象Width 换算成pb units 
								ids_Objects.Object.MergeFlag[li_Row]="1"
								ll_Space= ids_Objects.Object.Width[li_Row] 
								Choose Case is_Units
										Case '1'
												 ll_Space=PixelsToUnits(ll_Space,XPixelsToUnits!)
										Case '2'
												 ll_Space=PixelsToUnits(ll_Space * 96 /1000 ,XPixelsToUnits!)
										Case '3'
												ll_Space=PixelsToUnits(ll_Space * 37.8 /1000 ,XPixelsToUnits!)
								END CHOOSE
								IF ll_Space<= 50 Then
									ll_Space=0
								END IF 
								ids_Objects.Object.Width[li_Row]=ll_Space
								
					  END IF
			 
		    //2004-11-15
	       ELSE
				     
					   //当前单元范围内有没有对象只用于设置单元边框
					   li_Row=ids_Objects.Find("reportname='"+ids_ObjectS.Object.ReportName[li]+"' AND "+&
																	 "band='"+ids_objects.object.band[li]+"' and "+& 
																	 "isborderonly='1' and "+& 
																	 "startrow<="+String(ids_Objects.Object.EndRow[li])+ " and "+ &
																	 "endrow>="+String(ids_Objects.Object.StartRow[li])+" AND " + &
																	 "startcol<="+String(ids_Objects.Object.EndCol[li])+" AND " +& 
																	 "endcol>="+String(ids_Objects.Object.StartCol[li]),1 ,ids_ObjectS.RowCount())
						 IF li_Row>0 Then 
							  
							  //单元内是否有其它对象
							  li_BeginRow=ids_Objects.Find("reportname='"+ids_ObjectS.Object.ReportName[li_Row]+"' AND "+&
													 "band='"+ids_objects.object.band[li_Row]+"' and "+& 
													 "isborderonly<>'1' and "+& 
													 "startrow<="+String(ids_Objects.Object.EndRow[li_Row])+ " and "+ &
													 "endrow>="+String(ids_Objects.Object.StartRow[li_Row])+" AND " + &
													 "startcol<="+String(ids_Objects.Object.EndCol[li_Row])+" AND " +& 
													 "endcol>="+String(ids_Objects.Object.StartCol[li_Row])+" AND " + &
													 "getRow()<>"+String(li),1 ,ids_ObjectS.RowCount())
                      
							 //没有,则取边框单元的行列
                      IF li_BeginRow<=0 Then
									 ids_Objects.Object.StartRow[li] = ids_Objects.Object.StartRow[li_Row] 
									 ids_Objects.Object.EndRow[li] = ids_Objects.Object.EndRow[li_Row] 
									 ids_Objects.Object.StartCol[li] = ids_Objects.Object.StartCol[li_Row] 
									 ids_Objects.Object.EndCOL[li] = ids_Objects.Object.EndCOL[li_Row] 
							END IF
						END IF
			 END IF
		END IF
Next 

IF IsValid(ids_ReportObj) Then
	For li=1 To ids_ReportObj.RowCount()
			 li_Row = ids_Objects.Find("ReportName='"+ids_ReportObj.Object.Name[li]+"'",1,ids_Objects.RowCount())
			 IF li_Row>0 Then
				  ids_ReportObj.Object.StartCol[li]= ids_Objects.Object.StartCol[li_Row]
			  END IF
			
			 li_Row = ids_Objects.Find("ReportName='"+ids_ReportObj.Object.Name[li]+"'",ids_Objects.RowCount(),1)
			 IF li_Row>0 Then
				  ids_ReportObj.Object.EndCol[li]= ids_Objects.Object.EndCol[li_Row]
			  END IF
			  
	Next
END IF

	
Destroy lds_Temp 
//OpenWithParm(w3,ids_objects) 
end subroutine

protected function long of_arraytostring (string as_source[], string as_delimiter, ref string as_ref_string);long ll_dellen
long ll_pos
long ll_count
long ll_arrayupbound
string ls_holder
boolean lb_entryfound

ll_arrayupbound = upperbound(as_source)

if isnull(as_delimiter) or not ll_arrayupbound > 0 then
    return -1
end if

as_ref_string = ""

for ll_count = 1 to ll_arrayupbound

    if as_source[ll_count] <> "" then

        if len(as_ref_string) = 0 then
            as_ref_string = as_source[ll_count]
        else
            as_ref_string = as_ref_string + as_delimiter + as_source[ll_count]
        end if

    end if

next

return 1


end function

protected subroutine of_check_property (ref string as_str, ref string as_expression);string ls_str
long ll_pos

as_expression=""
if as_str <> "!" and as_str <> "?" and as_str <> "" then
    ll_pos = pos(lower(as_str), "~t")

    if ll_pos > 0 then
        as_expression = right(as_str, len(as_str) - ll_pos)

        if right(as_expression, 1) = "~"" then
            as_expression = Trim(left(as_expression, len(as_expression) - 1))
        end if

       
        as_str = left(as_str, ll_pos - 1)

        if left(as_str, 1) = "~"" then
            as_str = right(as_str, len(as_str) - 1)
        end if

    end if

    as_str = Trim(as_str)
else
	as_str="" 
	as_expression="" 
end if 
end subroutine

protected subroutine of_closeuserobject ();IF IsValid(iw_Parent) AND IsValid(iuo_Text) Then
	iw_Parent.CloseUserObject(iuo_Text)
END IF

end subroutine

protected function string of_evaluate (datastore a_ds, string as_express, long al_row);/*----------------------------------------------------------------------------
    求指定表达式的值
	 
	 返回值是字符串类型
	 如果计算有错误,返回空值
	 
	 
	 应用示例：
	            long l_sum
					int li_page,li_pagecount
					l_sum=long(of_getvalud("1+30+120",1))
					li_page=integer(of_getvale("page()",1))
					li_pagecount=integer(of_getvalue("pagecount()",1))
					
					
------------------------------------------------------------------------------*/
String ls_ret
Int li_Pos
as_Express=Trim(as_Express) 
IF Left(as_Express,1)="'" AND Right(as_Express,1)="'"  Then
	as_Express=Mid(as_Express,2,Len(as_Express) -2) 
ELSE
	IF Left(as_Express,1)='"' AND Right(as_Express,1)='"'  Then
	   as_Express=Mid(as_Express,2,Len(as_Express) -2) 
  END IF
END IF 

li_Pos=Pos(as_Express,"~t")   //检查表达式是否数据窗口对象属性表达式的语法,如 font.color='200~tif(a=1,255,0)' 
IF li_Pos>0 Then
	as_Express=Mid(as_Express,li_POs+1) 
END IF 

as_Express=OF_ReplaceAll(as_Express,"'",'"' ) //把单引号换成双引号ls_ret=a_ds.describe("Evaluate('"+as_express+"', "	+string(al_row)+ ")")

ls_ret=a_ds.describe("Evaluate('"+as_express+"', "	+string(al_row)+ ")")
IF ls_ret="?" OR ls_ret="!" THEN
	ls_ret=""
END IF

Return ls_ret


end function

protected function integer of_get_penwidth (integer ai_width);Choose Case is_Units
	
	Case '1' 
		ai_Width= PixelsToUnits(ai_Width, YPixelsToUnits!)
	
   Case '2'
	   ai_Width=PixelsToUnits(ai_Width * 0.096, YPixelsToUnits!)
	
  Case '3'
	   
	   ai_Width= PixelsToUnits(ai_Width * 0.0378, YPixelsToUnits!)
END CHOOSE

IF ai_Width>10 Then
	ai_Width =5
ELSEIF ai_Width >5 Then
	ai_Width =2
ELSE
	ai_Width =1
END IF

Return ai_Width 

end function

protected subroutine of_getcolumninfo ();Long li,lj, lk ,li_Row
Long li_ColCount
String ls_Processing
uint   li_startcol 
Long   ll_MinWidth 
Long   ll_LineSpace 

ls_Processing=idw_Requestor.Describe("datawindow.processing")
ll_LineSpace= 50
Choose Case is_Units 
	Case '1'
		 ll_LineSpace= UnitsToPixels(ll_LineSpace,XUnitsToPixels!)
	Case "2"
		 ll_LineSpace= UnitsToPixels(ll_LineSpace,XUnitsToPixels!) * 0.1041
	Case "3"
		 ll_LineSpace = UnitsToPixels(ll_LineSpace, XUnitsToPixels!) *2.646 
END CHOOSE 

//取得列
//ids_Column.InsertRow(0)
//ids_Column.Object.ReportName[1]=''
//ids_Column.Object.Band[1]=''
//ids_Column.Object.X[1]= -100
//ids_Column.Object.Width[1]=100

IF ii_FirstColumn<=1 Then
	ii_FirstColumn=1
ELSE 
	ii_FirstColumn=2 
END IF 

li_startcol= ii_FirstColumn -1
IF ls_Processing="1" OR ls_Processing="4" Then
	      ids_Objects.SetFilter("band='detail' AND Stype<>'line' ")
			ids_Objects.Filter() 
			ids_Objects.RowsCopy(1,ids_Objects.RowCount(),Primary!,ids_Column,ids_Column.RowCount()+1,Primary!) 
			
			ids_Column.SetSort("x a , y A " )
			ids_Column.Sort()
			For li=1 To ids_Column.RowCount()
				li_startcol++
				ids_Column.Object.StartCol[li]=li_startcol
				ids_Column.Object.EndCol[li]=li_startcol 
				ids_Column.Object.StartRow[li]=1 
				ids_Column.Object.EndRow[li]=1 
			
		Next
ELSE
			IF ib_FormFlag Then
					ids_Line.SetFilter("linetype='v'")
					ids_Line.Filter() 
					ids_Line.SetSort("x1 A ")
					ids_Line.Sort() 
					ib_FormFlag=False 
					
					IF ids_Line.RowCount()>0 Then
							//多于两条竖线
							IF ids_Line.Find("x1> "+String(ids_Line.Object.X1[1]+ll_LineSpace)+" AND X2< "+String(ids_Line.Object.X2[ids_Line.RowCount()] - ll_LineSpace)+" AND Band='"+ids_Line.Object.Band[1]+"'" ,1,ids_Line.RowCount())>0 Then
									ids_Objects.SetFilter("name<>'report_title' and  band<>'footer' and stype<>'report' and x< "+String(ids_Line.Object.X1[1]))
									ids_Objects.Filter()
									ib_FormFlag=True 
									ib_GridBorder=False   //2004-11-15 
								END IF
					END IF
			END IF
			
			IF Not ib_FormFlag  Then
					ids_Objects.SetFilter("name<>'report_title' and band<>'footer' and stype<>'report'  ")
					ids_Objects.Filter() 
			END IF 
			
			
			ids_Objects.SetSort("x A  ")
			ids_Objects.Sort() 
			IF ids_Objects.RowCount()>0 Then
			      li_startcol++
					li_Row=ids_Column.InsertRow(0)
					ids_Column.Object.Name[li_Row]=ids_Objects.Object.Name[1]
					ids_Column.Object.ReportName[li_Row]=ids_Objects.Object.ReportName[1]
					ids_Column.Object.x[li_Row]=ids_Objects.Object.x[1]
					ids_Column.Object.StartCol[li_Row]=li_startcol
					ids_Column.Object.EndCol[li_Row]=li_startcol
					
					
					For li=1 To ids_Objects.RowCount()
						  lj=ids_Column.RowCount() 
						  IF (ids_Objects.Object.x[li] - ids_Column.Object.x[lj])>ii_ColSpace Then   //如果列之前的间隔小于20,则忽略它,以免生成太多的列
							   ids_Column.Object.Width[lj]=ids_Objects.Object.x[li] - ids_Column.Object.x[lj]
							   li_startcol++
							   li_Row=ids_Column.InsertRow(0)
							   ids_Column.Object.x[li_Row]=ids_Objects.Object.x[li]
							   ids_Column.Object.Name[li_Row]=ids_Objects.Object.Name[li]
								ids_Column.Object.ReportName[li_Row]=ids_Objects.Object.ReportName[li]
							   ids_Column.Object.StartCol[li_Row]=li_startcol
							   ids_Column.Object.EndCol[li_Row]=  li_startcol
								ids_Column.Object.Width[li_Row]=ids_Objects.Object.Width[li] 
								
		       			 END IF 
						 
						 ids_Objects.Object.StartCol[li]=li_startcol
						 ids_Objects.Object.EndCol[li]=li_startcol
	
					Next
			END IF 
			
			
			IF ids_Column.RowCount()<=0 And ids_Line.RowCount()>0 Then
				li_startcol++ 
				li_Row=ids_Column.InsertRow(0)
				ids_Column.Object.ReportName[li_Row]=ids_Line.Object.ReportName[1]
				ids_Column.Object.Name[li_Row]=ids_Line.Object.Name[1]
				ids_Column.Object.x[li_Row]=ids_Line.Object.x1[1]
				ids_Column.Object.StartCol[li_Row]=li_startcol
				ids_Column.Object.EndCol[li_Row]=li_startcol
				ids_Line.Object.StartCol[1]=li_Row
			
			END IF 
			
			For li=1 TO ids_Line.RowCount()
				  lj=ids_Column.RowCount()
				  
				 IF (ids_Line.Object.x1[li] - ids_Column.Object.x[lj])>ii_ColSpace Then   //如果列之前的间隔小于20,则忽略它,以免生成太多的列
					  ids_Column.Object.Width[lj]=ids_Line.Object.x1[li] - ids_Column.Object.x[lj]
					  li_startcol++
					  li_Row=ids_Column.InsertRow(0)
					  ids_Column.Object.ReportName[li_Row]=ids_Line.Object.ReportName[li]
					  ids_Column.Object.x[li_Row]=ids_Line.Object.x1[li]
					  ids_Column.Object.Name[li_Row]=ids_Line.Object.Name[li]
					  ids_Column.Object.StartCol[li_Row]=li_startcol
					  ids_Column.Object.EndCol[li_Row]=  li_startcol
					  ids_Column.Object.Width[li_Row]=ids_Line.Object.x2[li] - ids_Line.Object.x1[li]
					  
					 END IF 
				 
				
					ids_Line.Object.StartCol[li]=li_startcol
					ids_Line.Object.EndCol[li]=li_startcol
				
			Next
			
			IF ib_FormFlag Then
						li=ids_Line.RowCount()
						IF li>0 Then
								ids_Objects.SetFilter("x> "+String(ids_Line.Object.X2[li]))
								ids_Objects.Filter()
								ids_Objects.SetSort("x A  ")
								ids_Objects.Sort() 
								
								
								IF ids_Objects.RowCount()>0 Then
										IF ids_Column.RowCount()<=0 Then
											li_startcol++
											li_Row=ids_Column.InsertRow(0)
											ids_Column.Object.ReportName[li_Row]=ids_Objects.Object.ReportName[1]
											ids_Column.Object.Name[li_Row]=ids_Objects.Object.Name[1]
											ids_Column.Object.x[li_Row]=ids_Objects.Object.x[1]
											ids_Column.Object.StartCol[li_Row]=li_startcol
											ids_Column.Object.EndCol[li_Row]=li_startcol
											ids_Objects.Object.StartCol[1]=li_startcol
											
										END IF
									
										For li=1 To ids_Objects.RowCount()
												  lj=ids_Column.RowCount() 
												  IF (ids_Objects.Object.x[li] - ids_Column.Object.x[lj])>ii_ColSpace Then   //如果列之前的间隔小于20,则忽略它,以免生成太多的列
													  ids_Column.Object.Width[lj]=ids_Objects.Object.x[li] - ids_Column.Object.x[lj]
													  
													  li_startcol++
													  li_Row=ids_Column.InsertRow(0)
													  ids_Column.Object.x[li_Row]=ids_Objects.Object.x[li]
													  ids_Column.Object.ReportName[li_Row]=ids_Objects.Object.ReportName[li]
													  ids_Column.Object.Name[li_Row]=ids_Objects.Object.Name[li]
													  ids_Column.Object.StartCol[li_Row]=li_startcol
													  ids_Column.Object.EndCol[li_Row]=  li_startcol
													  ids_Column.Object.Width[li_Row]=ids_Objects.Object.Width[li] 
													  
												  END IF 
												 
													
													 ids_Objects.Object.StartCol[li]=li_startcol
													ids_Objects.Object.EndCol[li]=li_startcol
													
										 Next
								END IF 
						END IF
			END IF
END IF

IF li_startcol>256 Then
	MessageBox("提示","报表的列数不能大于256列,生成文件失败!")
	ids_Objects.Reset()
	ids_Column.Reset()
	ids_Line.Reset()
	Return 
END IF 

ll_MinWidth= 20
Choose Case is_Units 

	Case '1'
		 ll_MinWidth= UnitsToPixels(ll_MinWidth,XUnitsToPixels!)
	Case "2"
		 ll_MinWidth= UnitsToPixels(ll_MinWidth,XUnitsToPixels!) * 0.1041
	Case "3"
		 ll_MinWidth = UnitsToPixels(ll_MinWidth, XUnitsToPixels!) *2.646 
		 
END CHOOSE 





IF ii_FirstColumn>1 AND ids_Column.RowCount()>0 Then
	ids_Column.InsertRow(1)
	ids_Column.Object.Width[1]=ids_Column.Object.X[2]
	IF ids_Column.Object.Width[1]<ll_MinWidth Then
		ids_Column.Object.Width[1]=ll_MinWidth
	END IF
	ids_Column.Object.StartCol[1]=1
	ids_Column.Object.EndCol[1]=1
	ids_Column.Object.X[1]= ids_Column.Object.Width[1] * -1
END IF

//openwithparm(w3,ids_column) 
end subroutine

protected subroutine of_getobjects ();String ls_Type,ls_Band
String ls_OldBand ,ls_Expression
String ls_Name 
String ls_Objects[]   
String ls_Processing
String ls_Format,ls_ColType
int    li,lj, lk,li_Row,li_Col, li_count
Long   li_x,li_Y,li_x2, li_Height
Int    li_BeginRow,li_EndRow 
Boolean lb_ForeGroundFlag
String ls_Bands[]
String ls_Exp
String ls_Visible ,ls_VisibleExp 

uLong  li_Color 
Datastore lds_Temp


IF Not IsValid(idw_Requestor) Then
	 Return
END IF

SetPointer(HourGlass!)
ls_Processing=idw_Requestor.Describe("datawindow.Processing")
IF ls_Processing="4" Then
	idw_Requestor.Modify("DataWindow.Crosstab.StaticMode=Yes")
END IF


lds_Temp=Create DataStore
lds_Temp.DataObject=idw_Requestor.DataObject 


ids_Column=Create Datastore
ids_Objects=Create DataStore
ids_Column.Dataobject="d_dw2xls_objects"
ids_objects.Dataobject="d_dw2xls_objects"

ids_Line=Create Datastore
ids_Line.DataObject="d_dw2xls_LineObjects"

ids_RowHeight=Create Datastore
ids_RowHeight.DataObject="d_dw2xls_RowHeight"
is_LineTag=Trim(is_LineTag)   //不输出线型的标识

ids_Bands=Create Datastore
ids_Bands.DataObject="d_dw2xls_bands" 

is_Format_Currency=OF_Get_Currency_Format() 

is_units=idw_Requestor.Describe("datawindow.units")

IF ii_RowSpace<0 Then
	ii_RowSpace=30
END IF
IF ii_ColSpace<0 Then
	ii_ColSpace=30
END IF 

Choose Case is_units 
	Case '1'
			ii_RowSpace = UnitsToPixels(ii_RowSpace,XUnitsToPixels!)
			ii_ColSpace = UnitsToPixels(ii_ColSpace,YUnitsToPixels!)
	Case '2'
		   ii_RowSpace = UnitsToPixels(ii_RowSpace, XUnitsToPixels!) *  0.01041 * 1000 
			ii_ColSpace=  UnitsToPixels(ii_ColSpace, YUnitsToPixels!) * 0.01041 * 1000 
			
	Case '3'
		   ii_RowSpace = UnitsToPixels(ii_RowSpace, XUnitsToPixels!) * 0.02646  * 1000 
			ii_ColSpace= UnitsToPixels(ii_ColSpace, YUnitsToPixels!) * 0.02646  * 1000 
END Choose

//为了更方便的调用导出功能,如果报表不是一个表格时(或者输出线条影响报表的导出效果)
//可以把 FormFlag参数设置为 False
// 可以在制作报表的时候,增加 dw2xls_formflag 对象,然后设置 Tag为1或者 为0,来进行控制
ls_Exp=idw_Requestor.Describe("dw2xls_formflag.Tag")
idw_Requestor.Modify("dw2xls_formflag.visible='0'") 
IF ls_Exp="0" Then
	ib_Formflag=False
ELSEIF ls_Exp="1" Then
	ib_FormFlag=True
END IF 

//如果报表确实需要输出表格的边框,而表格的竖线很少,而导致报表的输出效果很差时
//可考虑用文本对象(设置border为2,文本内容为空) 来建立表格
//这时导出的效果会比较好,但可惜不能设置表格的边框类型和颜色




////带区信息
li_Count=OF_ParseToArray(idw_Requestor.Describe("datawindow.bands"),"~t",ls_Bands)
For li=1 TO li_Count 
	 li_Row = ids_Bands.InsertRow(0) 
	 
	 ids_Bands.Object.Reportname[li_Row]=''
	 ids_Bands.Object.Band[li_Row]= ls_bands[li]
	 ids_Bands.Object.Band[li_Row]= ls_bands[li]
	 ids_Bands.Object.OldBand[li_Row]= ls_bands[li]
	 lj=Pos(ls_bands[li],"[")
	 IF lj>0 Then
		 ids_Bands.Object.Band[li_Row]= Left(ls_bands[li],lj -1)
	 END IF
	 
	 ls_format= idw_Requestor.Describe("datawindow."+ls_bands[li]+".color") 
    of_check_property(ls_format,ls_exp)
	 ids_Bands.Object.ColorExp[li_Row]=ls_Exp 
	 if ls_exp="" then
		 li_Color=invo_colors.of_get_color(long(ls_format))
		 IF li_Color<>0 then
		 		 ids_Bands.Object.Color[li_row]=invo_colors.of_get_custom_color_index( li_Color ) 
		  else
				ids_Bands.Object.Color[li_row]= 65 
		  end if
 	  END IF
	
	 //ids_Bands.Object.Height[li_Row]=Long(idw_Requestor.Describe("datawindow."+ls_Bands[li]+".height"))
	 //ids_Bands.Object.AutoHeight[li_Row]=idw_Requestor.Describe("datawindow."+ls_bands[li]+".height.autosize") 
Next 



ls_Type=idw_Requestor.Describe("datawindow.objects")
li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)
ls_Type=""
For li=1 To li_Count
	  
	  
	  IF ids_Objects.Find("ReportName='' AND Name='"+ls_Objects[li]+"'",1,li_Count)>0 Then
		   Continue
	  END IF
    
	  ls_Band=idw_Requestor.Describe(ls_Objects[li]+".Band")
	  IF ls_Band="?" OR ls_Band="!" Then
		  Continue
	  END IF
	  
     ls_Type=idw_Requestor.Describe(ls_Objects[li]+".Type")
	  ls_OldBand=ls_Band
	  
		IF ls_Band="foreground" OR ls_Band="background" Then
			IF ls_Type<>'line' Then
			    ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Y")
		   ELSE
				 ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Y1")	
			END IF
		    OF_Check_Property(ls_Format,ls_Exp)
		    IF ls_Exp<>"" Then
				  ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
		    END IF
			 li_Y=Long(ls_Format)
			
		   IF ls_Processing="4" Then
					IF li_Y<=Long(idw_Requestor.Describe("datawindow.header[1].height")) Then
						ls_Band="header[1]"
						lb_ForeGroundFlag=True
					ELSE
						 //IF ls_Type<>"line" Then   //不特别处理线条
						//		 li_Row = UpperBound(istr_Foregroundobj)+1
						//		 istr_Foregroundobj[li_Row].Name = ls_Objects[li]
						//		 istr_Foregroundobj[li_Row].y = li_Y 
						// END IF
						 
						Continue
					END IF
			ELSE
					IF li_Y<=Long(idw_Requestor.Describe("datawindow.header.height")) Then		
						 ls_Band="header"
					ELSE
						 //IF ls_Type<>"line" Then   //不特别处理线条
						 //	 li_Row = UpperBound(istr_Foregroundobj)+1
						 //	 istr_Foregroundobj[li_Row].Name = ls_Objects[li]
						 //	 istr_Foregroundobj[li_Row].y = li_Y 
						 //END IF
						 
						 Continue
					 END IF
			END IF
	   END IF
		
		
		 //如果带区的高度为0,不读入对象
		  li_Height=Long(idw_Requestor.Describe("datawindow."+ls_band+".height"))
		  IF li_Height<=10 Then
				COntinue
		  END IF
		  
		 //如果对象的Y值大于带区高度,也不读入
		  IF ls_Type="line" Then
				  IF Long(idw_Requestor.Describe(ls_Objects[li]+".Y1"))> li_Height Then
						Continue
				  END IF
			ELSE
		  
				  IF Long(idw_Requestor.Describe(ls_Objects[li]+".Y"))> li_Height Then
						Continue
				  END IF
			END IF
	   
	  	   ls_Visible=Trim(idw_Requestor.Describe(ls_Objects[li]+".Visible"))
         OF_Check_Property(ls_Visible,ls_VisibleExp) 
	   
		
	   IF  ls_Type="report" Then
			
				IF ls_Visible='0' OR ls_VisibleExp='0' Then
						Continue
				END IF
		
			IF Not IsValid(ids_ReportObj) Then
				 ids_reportobj=Create DataStore
				 ids_ReportObj.DataObject=ids_Objects.DataObject
			END IF
			
			li_Row=ids_ReportObj.InsertRow(0)
			ids_ReportObj.Object.Name[li_Row]=ls_Objects[li]
			ids_ReportObj.Object.Band[li_Row]=ls_Band
			ids_ReportObj.Object.x[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".x"))
			ids_ReportObj.Object.Width[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Width"))
			ids_ReportObj.Object.y[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".y"))	
			ids_ReportObj.Object.Height[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Height"))
			ids_ReportObj.Object.RowInDetail[li_Row]=1
			
			//读取子数据窗口对象列表
			OF_GetObjects(ls_Objects[li])
			
			
			//2004-11-28   为了处理行高,可能在两个子数据窗口之间,有其它对象,如文本,计算字段等
			li_Row=ids_Objects.InsertRow(0)
		   ids_Objects.Object.ReportName[li_Row]=""
			ids_Objects.Object.Name[li_Row]=""
			ids_Objects.Object.Band[li_Row]=ls_Band
			ids_Objects.Object.x[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".x"))
			ids_Objects.Object.Width[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Width"))
			ids_Objects.Object.y[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".y"))	
			ids_Objects.Object.Height[li_Row]=Long(idw_Requestor.Describe(ls_Objects[li]+".Height"))
		   ids_Objects.Object.IsReport[li_Row]='1'
		
			
			Continue
	  END IF
	  
	  
       IF ls_Type="line" Then
			   
				//如果设置报表不是表格,则不处理线条   2004-11-15 
				IF Not ib_FormFlag Then
					 Continue
				END IF
				
				IF ls_Visible='0' OR ls_VisibleExp='0' Then
						Continue
				END IF
				
			IF idw_Requestor.Describe(ls_Objects[li]+".Tag")=is_LineTag  Then
			   Continue
			END IF
			
			li_Row=ids_Line.InsertRow(0)
			ids_Line.Object.ReportName[li_Row]=''
			ids_Line.Object.Name[li_Row]=ls_Objects[li]
			ids_Line.Object.Band[li_Row]=ls_Band 
			
			ls_Format=idw_Requestor.Describe(ls_Objects[li]+".x1")
			OF_Check_Property(ls_Format,ls_Exp)
			IF ls_Exp<>"" Then
					ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
			END IF
			ids_Line.Object.x1[li_Row]=Long(ls_Format)
			
			ls_Format=idw_Requestor.Describe(ls_Objects[li]+".x2")
			OF_Check_Property(ls_Format,ls_Exp)
			IF ls_Exp<>"" Then
					ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
			END IF
			ids_Line.Object.x2[li_Row]=Long(ls_Format)
	
	
			ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Y1")
			OF_Check_Property(ls_Format,ls_Exp)
			IF ls_Exp<>"" Then
					ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
			END IF
			ids_Line.Object.Y1[li_Row]=Long(ls_Format)
						
			ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Y2")
			OF_Check_Property(ls_Format,ls_Exp)
			IF ls_Exp<>"" Then
					ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
			END IF
			ids_Line.Object.Y2[li_Row]=Long(ls_Format)
	
			ls_Format= idw_Requestor.Describe(ls_Objects[li]+".Pen.Color")
			OF_Check_Property(ls_Format,ls_Exp)

			IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
			END IF
			ids_Line.Object.PenColor[li_Row]=invo_colors.of_get_custom_color_index( invo_colors.of_get_color(long(ls_format)) )  
			
			Choose Case idw_Requestor.Describe(ls_Objects[li]+".pen.style")
				Case "1"
					 ids_Line.Object.PenWidth[li_Row]=3
				Case "2"
					 ids_Line.Object.PenWidth[li_Row]=4
				Case Else
					  ids_Line.object.PenWidth[li_Row]=OF_Get_PenWidth(Long(idw_Requestor.Describe(ls_Objects[li]+".Pen.Width")))
			END Choose
				
					
	      Continue 
	  END IF
	
	  //其它对象,如果有边框属性为2,也输出边框  2004-11-15 
	  IF ls_Type<>"text" AND ls_Type<>"column" AND ls_Type<>"compute" AND idw_Requestor.Describe(ls_objects[li]+".border")<>"2" Then
		  Continue
	  END IF
	  
	  //加入检查表达式是否有效
	  IF ls_Type="compute" Then
	       ls_Expression=idw_Requestor.Describe(ls_Objects[li]+".Expression")
			  IF ls_Expression="?" OR ls_Expression="!" Then
				     Continue
				END IF
	  END IF
			
	           
	  
	  
	  IF ls_Objects[li]="sys_back" AND ls_OldBand="foreground" Then   //报表标题的背景文本框
		  Continue
	  END IF
	  
	   IF ls_Objects[li]="sys_lastcol" AND ls_OldBand="detail" Then  //用于标识Grid形式报表的最后一列
			 Continue
		END IF
		

		
	   //如果对象的Visible属性为False,不输出   //2006-5-31
	  IF ( ls_Visible='0' AND ls_VisibleExp='') OR ls_VisibleExp='0'  Then
		  //如果数据窗口是否表格,而且对象在细节区,则需要把该列的其它对象给屏蔽掉
		   IF ls_Processing="1" AND ls_Band="detail" Then
						li_x=Long( lds_Temp.Describe(ls_Objects[li]+".x"))
						li_x2=li_x+Long( lds_Temp.Describe(ls_Objects[li]+".width"))
						 For lj=1 To li_Count
							  IF idw_Requestor.Describe(ls_Objects[lj]+".Band")<>"detail" Then
									  IF Long(lds_Temp.Describe(ls_Objects[lj]+".x"))>=li_x AND &
										  (Long(lds_Temp.Describe(ls_Objects[lj]+".x"))+Long(lds_Temp.Describe(ls_Objects[lj]+".Width")))<=li_x2 Then
										  
										  idw_Requestor.Modify(ls_Objects[lj]+".visible='0' ")
											 
										  li_Row=ids_Objects.Find("reportname='' AND name='"+ls_Objects[lj]+"'",1,ids_Objects.RowCount())
										  IF li_Row>0 Then
												ids_Objects.DeleteRow(li_Row)
										  END IF
									END IF
							 END IF
								
						Next 
			END IF
			
			Continue
	  END IF
	
	
	   ls_ColType=idw_Requestor.Describe(ls_Objects[li]+".ColType")
		IF ls_ColType="?" OR ls_ColType="!" Then
			ls_ColType="S"  //当文本进行处理
		ELSE
			  IF Left(ls_ColType,4)="char" Then
					ls_ColType="S"
					
				ELSEIF ls_ColType="datetime" Then
				   ls_ColType='DT' 
				ELSEIF ls_ColType='date' Then
					 ls_ColType='D'
				ELSEIF ls_ColType='time' Then
					 ls_ColType='T'
				ELSE
					  ls_ColType='N' 
				END IF
		END IF
	 
	  
	  li_Row=ids_Objects.InsertRow(0)
	  ids_Objects.Object.ReportName[li_Row]=''
	  ids_Objects.Object.Name[li_Row]=ls_Objects[li]
	  ids_Objects.Object.Band[li_Row]=ls_Band
	  ids_Objects.Object.Stype[li_Row]=ls_Type
	  ids_Objects.Object.Coltype[li_Row]=ls_ColType
	  
			
		ls_Format=idw_Requestor.Describe(ls_Objects[li]+".x")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.X[li_Row]=Long(ls_Format)	 
		
   	ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Y")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Y[li_Row]=Long(ls_Format)	 

		ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Width")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Width[li_Row]=Long(ls_Format)	 

   	ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Height")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Height[li_Row]=Long(ls_Format)	 
       
		//如果对象的位置在报表上是看不见的,则不处理该对象  2004-11-15
		IF ids_Objects.Object.x2[li_Row]<=0 OR ids_Objects.Object.Y2[li_Row]<=0 Then
			 ids_Objects.DeleteRow(li_Row)
			 Continue
		END IF
		

		
	   ids_Objects.Object.Visible[li_Row]=ls_Visible
		ids_Objects.Object.VisibleExp[li_Row]=ls_VisibleExp 
		
		IF ls_Objects[li]<>"report_title" Then 
			IF Trim(idw_Requestor.Describe(ls_Objects[li]+".Tag"))<>"0" Then  //2004-12-2  某些对象虽然有边框,但输出会影响表格的输出效果
					ids_Objects.Object.Border[li_Row]=idw_Requestor.Describe(ls_Objects[li]+".Border")
			END IF
		END IF
		
		
		//判断对象是否只是用于设置单元的边框,而没有任何内容   2004-11-15
		IF ls_Type<>"text" AND ls_Type<>"column" AND ls_Type<>"compute" Then
		   ids_Objects.Object.isBorderOnly[li_Row]='1'
		   ids_Objects.Object.Border[li_Row]='2' 
		  Continue
	  ELSE
		   IF ls_Type="text" Then
				  IF idw_Requestor.Describe(ls_objects[li]+".Text")="" Then
					   IF idw_Requestor.Describe(ls_objects[li]+".Border")="2"  AND idw_Requestor.Describe(ls_objects[li]+".Tag")<>"0" Then //2004-12-2  如果Tag设置为0,则忽略该对象
					        ids_Objects.Object.isBorderOnly[li_Row]='1'
						     ids_Objects.Object.Border[li_Row]='2' 
							  Continue
					   ELSE
							 //忽略该文本对象
							 ids_Objects.DeleteRow(li_Row)
							 Continue 
						END IF
					   
					END IF
					
				END IF
	   END IF
		
		
		//如果定义了EditMask   2004-10-29 
		ls_Format = Trim(idw_Requestor.Describe(ls_Objects[li]+".EditMask.Mask"))
		ls_Exp=""
		IF ls_Format="!" OR ls_Format="?" OR ls_Format="" Then
			   ls_Format=Trim(idw_Requestor.Describe(ls_Objects[li]+".Format"))
		      OF_Get_Format(ls_Format,ls_Exp,ls_ColType) 
		END IF
	   ids_Objects.Object.Format[li_Row]= ls_Format
		ids_Objects.Object.FormatExp[li_Row]=ls_Exp
		
	   ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Color")
	   //if ls_objects[li]='item_name' then
		//messagebox('a',ls_format) 
	   //end if
	
	   OF_Check_Property(ls_Format,ls_Exp) 
	  
	   //if ls_objects[li]='item_name' then
		//messagebox('a',ls_format+"   "+ls_exp) 
  	   //end if
  	  ids_Objects.Object.FontColorExp[li_Row]= ls_Exp
	  IF ls_Exp="" Then
		    li_Color= invo_colors.of_get_Color(long(ls_Format)) 
		    ids_Objects.Object.FontColor[li_Row]=invo_colors.of_get_custom_color_index(li_color )  
      END IF
		
	  
	  ls_Format=idw_Requestor.Describe(ls_Objects[li]+".background.Color")
	  OF_Check_Property(ls_Format,ls_Exp) 
  	  ids_Objects.Object.bgColorExp[li_Row]= ls_Exp
	   IF ls_Exp=""  Then
			
			  li_color=invo_Colors.OF_Get_Color(Long(ls_Format))
			  IF li_color = 0 Then 
					li_color = 65 
				ELSE
					li_color = invo_colors.of_get_custom_color_index( li_color )  
				END IF
				
		     ids_Objects.Object.bgColor[li_Row]=li_color
      END IF
		
		
	  ls_Format= idw_Requestor.Describe(ls_Objects[li]+".Font.Weight")
	  OF_Check_Property(ls_Format,ls_Exp) 
	  ids_Objects.Object.FontWeight[li_Row]=Long(ls_Format)
	  ids_Objects.Object.FontWeightExp[li_Row]= ls_Exp
		
	  ls_Format=idw_Requestor.Describe(ls_Objects[li]+".Font.Height")
	  OF_Check_Property(ls_Format,ls_Exp) 
	  ids_Objects.Object.FontSize[li_Row]=ABS(Long(ls_Format))
	  ids_Objects.Object.FontSizeExp[li_Row]= ls_Exp	
	  
	 
	
	 IF ids_Objects.Object.FontSize[li_Row]<=0 Then
		  ids_Objects.Object.FontSize[li_Row]=9
	 END IF
	 
	  ls_Format=idw_Requestor.Describe(ls_Objects[li]+".font.italic")
	  OF_Check_Property(ls_Format,ls_Exp)
	  ids_Objects.Object.FontItalic[li_Row]=Long(ls_Format) 
	  ids_Objects.Object.FontItalicExp[li_Row]=ls_Exp
	  
	 
	  ls_Format = idw_Requestor.Describe(ls_Objects[li]+".font.face")
	  OF_Check_Property(ls_Format,ls_Exp)
	  ids_Objects.Object.FontName[li_Row]=ls_Format
	  ids_Objects.Object.FontNameExp[li_Row]= ls_Exp
		
     ls_Format= idw_Requestor.Describe(ls_Objects[li]+".Alignment")
	  OF_Check_Property(ls_Format,ls_Exp)
	   ids_Objects.Object.AlignmentExp[li_Row]=ls_Exp
		
	   Choose Case ls_Format   //左对齐
		      Case "1"   //右对齐
				     ids_Objects.Object.Alignment[li_Row]=3
		        Case "2"   //中对齐
				         ids_Objects.Object.Alignment[li_Row]=2
			      Case Else    //均匀对齐,调整为左对齐
				         ids_Objects.Object.Alignment[li_Row]=1
		END CHOOSE
		
		
		
		
		ls_format = idw_Requestor.Describe(ls_Objects[li]+".Edit.Style")
		IF ls_Format="dddw" OR ls_Format="ddlb" OR idw_Requestor.Describe(ls_Objects[li]+".Edit.CodeTable")='yes' Then
		    ids_Objects.Object.Displayvalue[li_Row]='1'
			 
			 //判断当然对象是数据窗口的原始列对象,还是列对象的一个拷贝,如果是列对象的拷贝,用LoopupDisplay函数时,会出错
	       //2004-10-29 
			 //IF  idw_Requestor.Describe("#"+idw_Requestor.Describe(ls_Objects[li]+".ID")+".Name")= ls_Objects[li] Then
			
			 //2005-1-2 
			 IF Right(idw_Requestor.Describe(ls_Objects[li]+".dbname"),Len(ls_Objects[li]))=ls_Objects[li] Then 
					ids_Objects.Object.ColumnFlag[li_Row]='1'
			  ELSE
				   ids_Objects.Object.ColumnFlag[li_Row]='0'
			 END IF 
		
		ELSE
			ids_Objects.Object.Displayvalue[li_Row]='0'
	   END IF
		
		
		
		
		//设置缺省的RowInDetail的值
		ids_Objects.Object.RowInDetail[li_Row]=1 
		
		
		//判断对象文本是否自动换行
		IF ls_ColType='S' Then
			 ids_Objects.Object.WrapText[li_Row] = OF_IsWrapText( ids_Objects.Object.FontName [li_Row],  &
			                                                      ids_Objects.Object.FontSize [li_Row] , &
																					ids_Objects.Object.FontWeight[li_Row] , &
																					ids_Objects.Object.Height [li_Row]) 
		END IF
		
		//判断对象的各位属性是否有表达式,目的是提高导出的速度   2004-11-15  
		IF ls_Band="detail" OR Pos(ls_Band,".")>0 	Then
				IF ids_Objects.Object.VisibleExp[li_Row]="" AND ids_Objects.Object.FormatExp[li_Row]="" AND &
					ids_Objects.Object.FontNameExp[li_Row]="" AND ids_Objects.Object.FontWeightExp[li_Row]="" AND &
					ids_Objects.Object.FontColorExp[li_Row]="" AND ids_Objects.Object.FontItalicExp[li_Row]="" AND &
					ids_Objects.Object.AlignmentExp[li_Row]="" AND ids_Objects.Object.bgColorExp[li_Row]="" Then
					
					ids_Objects.Object.ExpFlag[li_Row]='0'
				ELSE
					ids_Objects.Object.ExpFlag[li_Row]='1'
				END IF 
		 ELSE
			 ids_Objects.Object.ExpFlag[li_Row]='1'
		 END IF 
		 
		 
		 //2004-11-28   增加对象slipup属性的支持
		 IF idw_Requestor.Describe(ls_Objects[li]+".SlipUp")='no' Then
			 ids_Objects.Object.Slipup[li_Row]='0'
		 ELSE
			 ids_Objects.Object.Slipup[li_Row]='1'
		 END IF
		 
		 ids_Objects.Object.AboveRows[li_Row]= 0 
		 
Next 	


//如果数据窗口是N-UP类型,需要作以下处理
IF Long(idw_Requestor.Describe("datawindow.rows_per_detail"))>1 Then
	 //虽然Column对象的Attributes属性里面包括为Row_In_Detail,但Describe无法读出来,所以需要通过分析语法或获得
	 ls_Type=idw_Requestor.Describe("datawindow.syntax")
	 li=Pos(ls_Type,"column(")
	 Do While li>0 
		  lj=Pos(ls_Type,"column(",li+5)
		 IF lj=0 Then
	  		  li_Count=1024
   	  ELSE
				li_Count=lj - li -1 
   	  END IF
		
		  //读出该Column对象的语法
		  ls_Band=Mid(ls_Type,li,li_Count)
		  
		   //取得对象名称
		   li=Pos(ls_Band,"name=")+Len("name=")
			li_Count=Pos(ls_Band," ",li+1) -li 
			ls_Name=Mid(ls_Band,li,li_Count) 
        
			
			li_Row=ids_Objects.Find("reportname='' AND Name='"+ls_Name+"' ",1,ids_Objects.RowCount())
			IF li_Row>0 Then
				   li=Pos(ls_Band,"row_in_detail=")+Len("row_in_detail=")
					li_Count=Pos(ls_Band," ",li+1) -li 
					lk=Long(Mid(ls_Band,li,li_Count) )  //取得Row_In_Detail的值
		 		   IF lk>0 Then
						ids_Objects.Object.RowInDetail[li_Row]=lk
					END IF 
				else
			END IF 
			 li=lj
	 Loop
	 
	 ls_Type=""
	 ls_Band=""
END IF 


//如果报表是一个表格,检查表格的信息
OF_GridInfo("",ls_Bands)

//取得列信息
OF_GetColumnInfo()


//判断对象的那个单元输出
OF_ColRowInfo()

//取得行高
OF_GetRowHeight()

IF ib_MergeColumnHeader Then
	     
		  IF Trim(is_BeginRowObj)<>"" Then
			    li=ids_Objects.Find("reportName='' AND name='"+Trim(Lower(is_BeginRowObj))+"'",1,ids_Objects.RowCount())
				 IF li>0 Then
					 li_BeginRow=ids_Objects.Object.StartRow[li]

				  END IF
			END IF
		  
		  IF li_BeginRow=0 Then
				  ids_Objects.SetFilter("reportName='' AND band='header' AND Right(name,2)='_t' ")
				  ids_Objects.Filter()
				  li_BeginRow=Long(ids_Objects.Describe("Evaluate('Min(StartRow)',1)"))
			END IF
			
		  
		  IF li_BeginRow>0 Then
				  ids_Objects.SetFilter("reportName='' AND band='header' AND StartRow>="+String(li_BeginRow))
				  ids_Objects.Filter()
				  ids_Objects.SetSort(" X A ,Y A ,X2 A ")
				  ids_Objects.Sort()
				  li_EndRow=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',1)"))
				  For li_Row=1 To ids_Objects.RowCount()
						 IF ids_Objects.Object.StartRow[li_Row]>li_BeginRow Then
								 IF li_Row=1 Then   
										  ids_Objects.Object.StartRow[li_Row]=li_BeginRow
								 ELSE
										 lj=ids_Objects.Find("endrow<"+String(ids_Objects.Object.StartRow[li_Row])+" AND x<="+String(ids_Objects.Object.x2[li_Row])+" AND x2>="+String(ids_Objects.Object.x[li_Row]),ids_Objects.RowCount() ,1)
										 IF lj>1 Then
												ids_Objects.Object.StartRow[li_Row]=ids_Objects.Object.EndRow[lj]+1
										 ELSE
												ids_Objects.Object.StartRow[li_Row]=li_BeginRow
										 END IF
								 END IF
						 END IF
				 
						 IF ids_Objects.Object.EndRow[li_Row]<li_EndRow Then
								 IF li_Row=ids_Objects.RowCount() Then   
										ids_Objects.Object.EndRow[li_Row]=li_EndRow
								 ELSE
										 lj=ids_Objects.Find("startrow>"+String(ids_Objects.Object.EndRow[li_Row])+" AND x<="+String(ids_Objects.Object.x2[li_Row])+" AND x2>="+String(ids_Objects.Object.x[li_Row]),1 ,ids_Objects.RowCount())
										 IF lj>1 Then
												ids_Objects.Object.EndRow[li_Row]=ids_Objects.Object.StartRow[lj] -1
										 ELSE
												ids_Objects.Object.EndRow[li_Row]=li_EndRow
										 END IF
								 END IF
						 END IF
						 
				 
					 IF ids_Objects.Object.EndRow[li_Row]<ids_Objects.Object.StartRow[li_Row] Then
						  ids_Objects.Object.EndRow[li_Row]=ids_Objects.Object.StartRow[li_Row]
					 END IF
				
				  Next
				  
				  IF li_BeginRow>0 Then //ii_BorderBeginRow=0 AND 
						ii_BorderBeginRow=li_BeginRow
					END IF
		END IF
END IF

ls_Type=idw_Requestor.Describe("datawindow.sparse")
IF ls_Type<>"" Then
	li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)
	For li=1 To li_Count
		 li_Row=ids_Column.Find("reportName='' AND name='"+ls_Objects[li]+"'",1,ids_Column.RowCount())
		 IF li_Row>0 Then
			ids_Column.Object.Sparse[li_Row]="1"
		 END IF
	Next
	ib_SparseFlag=True
END IF 

IF ii_BorderBeginRow>0 Then
	li=ids_Objects.Find("reportName='' AND name='report_title'",1,ids_objects.rowcount())
	if li>0 then
		 if ids_objects.object.endrow[li]>=ii_BorderBeginRow then
				ii_BorderBeginRow=ids_objects.object.endrow[li]+1
			end if
	end if
end if
	
IF IsValid(ids_ReportObj) Then
	ids_ReportObj.SetSort(" y A ,X A ")
	ids_ReportObj.Sort() 
	For li=1 To ids_ReportObj.RowCount()
		//2001-11-28
		
		//		IF li>1 Then
		//			IF ids_ReportObj.Object.Y[li]>=ids_ReportObj.Object.Y2[li -1] Then
		//				 ids_ReportObj.Object.StartRow[li]= -1   //表示从上一报表开始
		//			    Continue 
		//			END IF 
		//		END IF 
		
		ids_Objects.SetFilter("reportname='' AND y2<="+idw_Requestor.Describe(ids_Reportobj.Object.Name[li]+".y"))
		ids_Objects.Filter() 
		li_Row=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',0)"))
		ids_ReportObj.Object.StartRow[li]=li_Row+1
		
	Next
END IF 

	

ids_Objects.SetFilter("reportname<>''")
ids_Objects.Filter()
IF ids_Objects.RowCount()>0 Then
	IF Not IsValid(ids_dwcObjects) Then
		ids_dwcObjects=Create Datastore
		ids_dwcObjects.DataObject=ids_Objects.DataObject
	END IF
	ids_Objects.RowsMove(1,ids_Objects.RowCount(),Primary!,ids_dwcObjects,1,Primary!)
END IF 

//ids_Objects.SetFilter("")
//ids_Objects.Filter()

ids_Line.SetFilter("")
ids_Line.Filter()
IF ids_Line.RowCount()=0 Then
	Destroy ids_Line
END IF


IF ls_Processing="4" OR ls_Processing="1" Then
	ib_GridBorder=True
END IF

Destroy lds_Temp 

//ids_Objects.SetFilter("")
//ids_Objects.Filter()
//openwithparm(w3,ids_Objects) 



end subroutine

protected function integer of_getobjects (string as_objname);String ls_Type,ls_Band
String ls_OldBand ,ls_Expression
String ls_Name 
String ls_Objects[]   
String ls_Processing
String ls_Format,ls_ColType
int    li,lj, lk,li_Row,li_Col, li_count
Long   li_x,li_Y,li_x2, li_Height
Long  li_x1,li_Y1 ,li_Width1 
Int    li_ColCount 
Boolean lb_ForeGroundFlag
String ls_Bands[]
String ls_Exp
String ls_Visible ,ls_VisibleExp 
uLong  li_Color 
Datastore lds, lds_Temp



lds=Create DataStore
lds.DataObject=idw_Requestor.Describe(as_ObjName+".DataObject ")
IF lds.Describe("datawindow.units")<>is_units Then
	MessageBox("错误提示","当前报表的子数据窗口或嵌套数据窗口的计量单位不一致!~r~n~r~n"+ &
	                      "对象名称：:"+as_objname+"~r~n"+ & 
								 "报表的计量类型："+is_Units+"~r~n"+ &
								 "对象的计量类型："+lds.Describe("datawindow.units")) 
	Return -1
END IF 


ls_Type=lds.Describe("datawindow.objects")
li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)


lds_Temp=Create DataStore
lds_Temp.DataObject=lds.DataObject 

ls_Processing=lds.Describe("datawindow.processing")
IF ls_Processing<>"1" and ls_Processing<>"0" and ls_Processing<>"4" Then
	Return -1
END IF

li_x1=Long(idw_Requestor.Describe(as_ObjName+".x"))
li_y1=Long(idw_Requestor.Describe(as_ObjName+".Y"))
li_Width1=Long(idw_Requestor.Describe(as_ObjName+".Width")) 


////带区信息
li_Count=OF_ParseToArray(lds.Describe("datawindow.bands"),"~t",ls_Bands)
For li=1 TO li_Count 
	 li_Row = ids_Bands.InsertRow(0) 
	 
	 ids_Bands.Object.Reportname[li_Row]=as_objname
	 ids_Bands.Object.Band[li_Row]= ls_bands[li]
	 ids_Bands.Object.Band[li_Row]= ls_bands[li]
	 ids_Bands.Object.OldBand[li_Row]= ls_bands[li]
	 lj=Pos(ls_bands[li],"[")
	 IF lj>0 Then
		 ids_Bands.Object.Band[li_Row]= Left(ls_bands[li],lj -1)
	 END IF
	 
	 ls_format= lds.Describe("datawindow."+ls_bands[li]+".color") 
    of_check_property(ls_format,ls_exp)
	 ids_Bands.Object.ColorExp[li_Row]=ls_Exp 
	 if ls_exp="" then
		 li_Color=invo_colors.of_get_color(long(ls_format))
		 IF li_Color<>0 then
		 		 ids_Bands.Object.Color[li_row]=invo_colors.of_get_custom_color_index( li_Color ) 
		  else
				ids_Bands.Object.Color[li_row]= 65 
		  end if
 	  END IF
	
	 //ids_Bands.Object.Height[li_Row]=Long(idw_Requestor.Describe("datawindow."+ls_Bands[li]+".height"))
	 //ids_Bands.Object.AutoHeight[li_Row]=idw_Requestor.Describe("datawindow."+ls_bands[li]+".height.autosize") 
Next 



ls_Type=lds.Describe("datawindow.objects")
li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)
ls_Type=""
For li=1 To li_Count
	  
	  IF ids_Objects.Find("ReportName='"+as_objname+"' AND Name='"+ls_Objects[li]+"'",1,li_Count)>0 Then
		   Continue
	  END IF
    
	  ls_Band=lds.Describe(ls_Objects[li]+".Band")
	  IF ls_Band="?" OR ls_Band="!" Then
		  Continue
	  END IF
	  
     ls_Type=lds.Describe(ls_Objects[li]+".Type")
	  ls_OldBand=ls_Band
	  
		IF ls_Band="foreground" OR ls_Band="background" Then
			IF ls_Type<>'line' Then
			    ls_Format=lds.Describe(ls_Objects[li]+".Y")
		   ELSE
				 ls_Format=lds.Describe(ls_Objects[li]+".Y1")	
			END IF
		    OF_Check_Property(ls_Format,ls_Exp)
		    IF ls_Exp<>"" Then
				  ls_Format=OF_Evaluate(lds,ls_Exp,lds.GetRow())
		    END IF
			 li_Y=Long(ls_Format)
			

			IF li_Y<=Long(lds.Describe("datawindow.header.height")) Then		
				 ls_Band="header"
			ELSE
				 //IF ls_Type<>"line" Then   //不特别处理线条
				 //	 li_Row = UpperBound(istr_Foregroundobj)+1
				 //	 istr_Foregroundobj[li_Row].Name = ls_Objects[li]
				 //	 istr_Foregroundobj[li_Row].y = li_Y 
				 //END IF
				 
				 Continue
			 END IF
			
	   END IF
		
		
		 //如果带区的高度为0,不读入对象
		  li_Height=Long(lds.Describe("datawindow."+ls_band+".height"))
		  IF li_Height<=10 Then
				COntinue
		  END IF
			
		 //如果对象的Y值大于带区高度,也不读入
		  IF ls_Type="line" Then
				  IF Long(lds.Describe(ls_Objects[li]+".Y1"))> li_Height Then
						Continue
				  END IF
			ELSE
		  
				  IF Long(lds.Describe(ls_Objects[li]+".Y"))> li_Height Then
						Continue
				  END IF
			END IF
	  
	    ls_Visible=Trim(lds.Describe(ls_Objects[li]+".Visible"))
       OF_Check_Property(ls_Visible,ls_VisibleExp) 

       IF ls_Type="line" Then
			
					  //如果设置报表不是表格,则不处理线条   2004-11-15 
						IF Not ib_FormFlag Then
							 Continue
						END IF
						
					IF ls_Visible='0' OR  ls_VisibleExp="0" Then
						 Continue
					 END IF
					
					IF lds.Describe(ls_Objects[li]+".Tag")=is_LineTag  Then
						Continue
					END IF
					
					li_Row=ids_Line.InsertRow(0)
					ids_Line.Object.ReportName[li_Row]=as_objname
					ids_Line.Object.Name[li_Row]=ls_Objects[li]
					ids_Line.Object.Band[li_Row]=ls_Band 
					
					ls_Format=lds.Describe(ls_Objects[li]+".x1")
					OF_Check_Property(ls_Format,ls_Exp)
					IF ls_Exp<>"" Then
							ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
					END IF
					ids_Line.Object.x1[li_Row]=Long(ls_Format)+li_X1
					
					ls_Format=lds.Describe(ls_Objects[li]+".x2")
					OF_Check_Property(ls_Format,ls_Exp)
					IF ls_Exp<>"" Then
							ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
					END IF
					ids_Line.Object.x2[li_Row]=Long(ls_Format)+li_X1
			
			
					ls_Format=lds.Describe(ls_Objects[li]+".Y1")
					OF_Check_Property(ls_Format,ls_Exp)
					IF ls_Exp<>"" Then
							ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
					END IF
					ids_Line.Object.Y1[li_Row]=Long(ls_Format)+li_Y1
								
					ls_Format=lds.Describe(ls_Objects[li]+".Y2")
					OF_Check_Property(ls_Format,ls_Exp)
					IF ls_Exp<>"" Then

							ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
					END IF
					ids_Line.Object.Y2[li_Row]=Long(ls_Format)+li_Y1
			
			
					ls_Format= lds.Describe(ls_Objects[li]+".Pen.Color")
					OF_Check_Property(ls_Format,ls_Exp)
					IF ls_Exp<>"" Then
						ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
					END IF
					
					ids_Line.Object.PenColor[li_Row]=invo_colors.of_get_custom_color_index( invo_colors.of_get_color(long(ls_format)) )  
					
					Choose Case lds.Describe(ls_Objects[li]+".pen.style")
						Case "1"
							 ids_Line.Object.PenWidth[li_Row]=3
						Case "2"
							 ids_Line.Object.PenWidth[li_Row]=4
						Case Else
							  ids_Line.object.PenWidth[li_Row]=OF_Get_PenWidth(Long(lds.Describe(ls_Objects[li]+".Pen.Width")))
						END Choose
					
					Continue 
			
	  END IF
	

		ls_Format=lds.Describe(ls_Objects[li]+".x")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
		END IF
	  IF Long(ls_Format)>li_Width1 Then  //+Long(lds.Describe(ls_Objects[li]+".Width"))
	     Continue
	  END IF
	  
	
	  IF ls_Type<>"text" AND ls_Type<>"column" AND ls_Type<>"compute" AND lds.Describe(ls_objects[li]+".Border")<>"2"   Then
		  Continue
	  END IF
	  
	  //加入检查表达式是否有效
	  IF ls_Type="compute" Then
	       ls_Expression=lds.Describe(ls_Objects[li]+".Expression")
			  IF ls_Expression="?" OR ls_Expression="!" Then
				     Continue
				END IF
	  END IF
			
	           
	  
	  
	  IF ls_Objects[li]="sys_back" AND ls_OldBand="foreground" Then   //报表标题的背景文本框
		  Continue
	  END IF
	  
	   IF ls_Objects[li]="sys_lastcol" AND ls_OldBand="detail" Then  //用于标识Grid形式报表的最后一列
			 Continue
		END IF
		
		
	   //如果对象的Visible属性为False,不输出
	   IF ( ls_Visible='0' AND ls_VisibleExp='') OR ls_VisibleExp='0'  Then
		  //如果数据窗口是否表格,而且对象在细节区,则需要把该列的其它对象给屏蔽掉
		   IF ls_Processing="1" AND ls_Band="detail" Then
						li_x=Long( lds_Temp.Describe(ls_Objects[li]+".x"))
						li_x2=li_x+Long( lds_Temp.Describe(ls_Objects[li]+".width"))
						 For lj=1 To li_Count
							  IF lds.Describe(ls_Objects[lj]+".Band")<>"detail" Then
									  IF Long(lds_Temp.Describe(ls_Objects[lj]+".x"))>=li_x AND &
										  (Long(lds_Temp.Describe(ls_Objects[lj]+".x"))+Long(lds_Temp.Describe(ls_Objects[lj]+".Width")))<=li_x2 Then
										  
										  lds.Modify(ls_Objects[lj]+".visible='0' ")
											 
										  li_Row=ids_Objects.Find("reportname='"+as_objname+"' AND name='"+ls_Objects[lj]+"'",1,ids_Objects.RowCount())
										  IF li_Row>0 Then
												ids_Objects.DeleteRow(li_Row)
										  END IF
									END IF
							 END IF
								
						Next 
			END IF
			
			
			Continue
	  END IF
	
	
	   ls_ColType=lds.Describe(ls_Objects[li]+".ColType")
		IF ls_ColType="?" OR ls_ColType="!" Then
			ls_ColType="S"  //当文本进行处理
		ELSE
			  IF Left(ls_ColType,4)="char" Then
					ls_ColType="S"
					
				ELSEIF ls_ColType="datetime" Then
				   ls_ColType='DT' 
				ELSEIF ls_ColType='date' Then
					 ls_ColType='D'
				ELSEIF ls_ColType='time' Then
					 ls_ColType='T'
				ELSE
					  ls_ColType='N' 
				END IF
		END IF
	 
	  
	  li_Row=ids_Objects.InsertRow(0)
	  ids_Objects.Object.ReportName[li_Row]=as_objname
	  ids_Objects.Object.Name[li_Row]=ls_Objects[li]
	  ids_Objects.Object.Band[li_Row]=ls_Band
	  ids_Objects.Object.Stype[li_Row]=ls_Type
	  ids_Objects.Object.Coltype[li_Row]=ls_ColType
	  
	  
     	    //超出宽度不读入
	  	ls_Format=lds.Describe(ls_Objects[li]+".x")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.X[li_Row]=Long(ls_Format)
		
		
   	ls_Format=lds.Describe(ls_Objects[li]+".Y")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Y[li_Row]=Long(ls_Format)	 //+li_Y1

		ls_Format=lds.Describe(ls_Objects[li]+".Width")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Width[li_Row]=Long(ls_Format)
		
		
		//如果对象的位置在报表上是看不见的,则不处理该对象  2004-11-15
		IF ids_Objects.Object.x2[li_Row]<=0 OR ids_Objects.Object.Y2[li_Row]<=0 Then
			 ids_Objects.DeleteRow(li_Row)
			 Continue
		END IF
		
		ids_Objects.Object.X[li_Row]=ids_Objects.Object.X[li_Row]+li_X1 
		ids_Objects.Object.Y[li_Row]=ids_Objects.Object.Y[li_Row] +li_Y1
		
		//2004-11-11
		if ids_Objects.Object.x2[li_Row]>(li_Width1+li_x1) Then
			ids_Objects.Object.Width[li_Row]=( li_Width1+li_x1 ) - ids_Objects.Object.x[li_Row]
		END IF
		

   	ls_Format=lds.Describe(ls_Objects[li]+".Height")
		OF_Check_Property(ls_Format,ls_Exp)
		IF ls_Exp<>"" Then
				ls_Format=OF_Evaluate(lds,ls_Exp,idw_Requestor.GetRow())
		END IF
		ids_Objects.Object.Height[li_Row]=Long(ls_Format)	 
   
	   ids_Objects.Object.Visible[li_Row]=ls_Visible
		ids_Objects.Object.VisibleExp[li_Row]=ls_VisibleExp
		
		IF ls_Objects[li]<>"report_title" Then 
			 IF Trim(lds.Describe(ls_Objects[li]+".Tag"))<>"0" Then
		      	ids_Objects.Object.Border[li_Row]=lds.Describe(ls_Objects[li]+".Border")
			 END IF
		END IF 
		
			//判断对象是否只是用于设置单元的边框,而没有任何内容   2004-11-15
		IF ls_Type<>"text" AND ls_Type<>"column" AND ls_Type<>"compute" Then
		   ids_Objects.Object.isBorderOnly[li_Row]='1'
		   ids_Objects.Object.Border[li_Row]='2' 
		  Continue
	  ELSE
		   IF ls_Type="text" Then
				  IF lds.Describe(ls_objects[li]+".Text")="" Then
					   IF lds.Describe(ls_objects[li]+".Border")="2" AND Trim(lds.Describe(ls_objects[li]+".Tag"))<>"0" Then
					        ids_Objects.Object.isBorderOnly[li_Row]='1'
						     ids_Objects.Object.Border[li_Row]='2' 
							  Continue
					   ELSE
							 //忽略该文本对象
							 ids_Objects.DeleteRow(li_Row)
							 Continue 
						END IF
					   
					END IF
				END IF
	   END IF
		
		
	   ls_Format=Trim(lds.Describe(ls_Objects[li]+".Format"))
      OF_Get_Format(ls_Format,ls_Exp,ls_ColType) 
	   ids_Objects.Object.Format[li_Row]= ls_Format
		ids_Objects.Object.FormatExp[li_Row]=ls_Exp
		
	  ls_Format=lds.Describe(ls_Objects[li]+".Color")
	  OF_Check_Property(ls_Format,ls_Exp) 
  	  ids_Objects.Object.FontColorExp[li_Row]= ls_Exp
	  IF ls_Exp="" Then
		    li_Color= invo_colors.of_get_Color(long(ls_Format)) 
		    ids_Objects.Object.FontColor[li_Row]=invo_colors.of_get_custom_color_index(li_color )  
      END IF
		
	  
	  ls_Format=lds.Describe(ls_Objects[li]+".background.Color")
	  OF_Check_Property(ls_Format,ls_Exp) 
  	  ids_Objects.Object.bgColorExp[li_Row]= ls_Exp
	   IF ls_Exp=""  Then
			
			  li_color=invo_Colors.OF_Get_Color(Long(ls_Format))
			  IF li_color = 0 Then 
					li_color = 65 
				ELSE
					li_color = invo_colors.of_get_custom_color_index( li_color )  
				END IF
				
		     ids_Objects.Object.bgColor[li_Row]=li_color
      END IF
		
		
	  ls_Format= lds.Describe(ls_Objects[li]+".Font.Weight")
	  OF_Check_Property(ls_Format,ls_Exp) 
	  ids_Objects.Object.FontWeight[li_Row]=Long(ls_Format)
	  ids_Objects.Object.FontWeightExp[li_Row]= ls_Exp
		
	  ls_Format=lds.Describe(ls_Objects[li]+".Font.Height")
	  OF_Check_Property(ls_Format,ls_Exp) 
	  ids_Objects.Object.FontSize[li_Row]=ABS(Long(ls_Format))
	  ids_Objects.Object.FontSizeExp[li_Row]= ls_Exp	
	  
	 
	
	 IF ids_Objects.Object.FontSize[li_Row]<=0 Then
		  ids_Objects.Object.FontSize[li_Row]=9
	 END IF
	 
	  ls_Format=lds.Describe(ls_Objects[li]+".font.italic")
	  OF_Check_Property(ls_Format,ls_Exp)
	  ids_Objects.Object.FontItalic[li_Row]=Long(ls_Format) 
	  ids_Objects.Object.FontItalicExp[li_Row]=ls_Exp
	  
	 
	  ls_Format = lds.Describe(ls_Objects[li]+".font.face")
	  OF_Check_Property(ls_Format,ls_Exp)
	  ids_Objects.Object.FontName[li_Row]=ls_Format
	  ids_Objects.Object.FontNameExp[li_Row]= ls_Exp
		
     ls_Format= lds.Describe(ls_Objects[li]+".Alignment")
	  OF_Check_Property(ls_Format,ls_Exp)
	   ids_Objects.Object.AlignmentExp[li_Row]=ls_Exp
		
	   Choose Case ls_Format   //左对齐
		      Case "1"   //右对齐
				     ids_Objects.Object.Alignment[li_Row]=3
		        Case "2"   //中对齐
				         ids_Objects.Object.Alignment[li_Row]=2
			      Case Else    //均匀对齐,调整为左对齐
				         ids_Objects.Object.Alignment[li_Row]=1
		END CHOOSE
		
		
	
			
			
		ls_format = lds.Describe(ls_Objects[li]+".Edit.Style")
		IF ls_Format="dddw" OR ls_Format="ddlb" OR lds.Describe(ls_Objects[li]+".Edit.CodeTable")='yes' Then
		    ids_Objects.Object.Displayvalue[li_Row]='1'
			 
			 //判断当然对象是数据窗口的原始列对象,还是列对象的一个拷贝,如果是列对象的拷贝,用LoopupDisplay函数时,会出错
	       //2004-10-29 
			 //IF  lds.Describe("#"+lds.Describe(ls_Objects[li]+".ID")+".Name")= ls_Objects[li] Then
			 
			 //2005-1-2
			 IF Right(lds.Describe(ls_Objects[li]+".dbname"),Len(ls_Objects[li]))=ls_Objects[li] Then 
				  ids_Objects.Object.ColumnFlag[li_Row]='1'
			  ELSE
				 ids_Objects.Object.ColumnFlag[li_Row]='0'
			 END IF 
			 
		ELSE
			ids_Objects.Object.Displayvalue[li_Row]='0'
	   END IF
		
		//设置缺省的RowInDetail的值
		ids_Objects.Object.RowInDetail[li_Row]=1 
		
		IF ls_ColType='S' Then
			 ids_Objects.Object.WrapText[li_Row] = OF_IsWrapText( ids_Objects.Object.FontName [li_Row],  &
			                                                      ids_Objects.Object.FontSize [li_Row] , &
																					ids_Objects.Object.FontWeight[li_Row] , &
																					ids_Objects.Object.Height [li_Row]) 
		END IF
		
		//判断对象的各位属性是否有表达式,目的是提高导出的速度   2004-11-15  
		IF ls_Band="detail" OR Pos(ls_Band,".")>0 	Then
				IF ids_Objects.Object.VisibleExp[li_Row]="" AND ids_Objects.Object.FormatExp[li_Row]="" AND &
					ids_Objects.Object.FontNameExp[li_Row]="" AND ids_Objects.Object.FontWeightExp[li_Row]="" AND &
					ids_Objects.Object.FontColorExp[li_Row]="" AND ids_Objects.Object.FontItalicExp[li_Row]="" AND &
					ids_Objects.Object.AlignmentExp[li_Row]="" AND ids_Objects.Object.bgColorExp[li_Row]="" Then
					
					ids_Objects.Object.ExpFlag[li_Row]='0'
				ELSE
					ids_Objects.Object.ExpFlag[li_Row]='1'
				END IF 
		 ELSE
			 ids_Objects.Object.ExpFlag[li_Row]='1'
		 END IF 
		 
		  //2004-11-28   增加对象slipup属性的支持
		 IF lds.Describe(ls_Objects[li]+".SlipUp")='no' Then
			 ids_Objects.Object.Slipup[li_Row]='0'
		 ELSE
			 ids_Objects.Object.Slipup[li_Row]='1'
		 END IF
		 ids_Objects.Object.AboveRows[li_Row]= 0 
Next 	



//如果数据窗口是N-UP类型,需要作以下处理
IF Long(lds.Describe("datawindow.rows_per_detail"))>1 Then
	 //虽然Column对象的Attributes属性里面包括为Row_In_Detail,但Describe无法读出来,所以需要通过分析语法或获得
	 ls_Type=lds.Describe("datawindow.syntax")
	 li=Pos(ls_Type,"column(")
	 Do While li>0 
		  lj=Pos(ls_Type,"column(",li+5)
		 IF lj=0 Then
	  		  li_Count=1024
   	  ELSE
				li_Count=lj - li -1 
   	  END IF
		
		  //读出该Column对象的语法
		  ls_Band=Mid(ls_Type,li,li_Count)
		  
		   //取得对象名称
		   li=Pos(ls_Band,"name=")+Len("name=")
			li_Count=Pos(ls_Band," ",li+1) -li 
			ls_Name=Mid(ls_Band,li,li_Count) 
        
			
			li_Row=ids_objects.Find("reportname='"+as_objname+"' AND Name='"+ls_Name+"' ",1,ids_Objects.RowCount())
			IF li_Row>0 Then
				   li=Pos(ls_Band,"row_in_detail=")+Len("row_in_detail=")
					li_Count=Pos(ls_Band," ",li+1) -li 
					lk=Long(Mid(ls_Band,li,li_Count) )  //取得Row_In_Detail的值
		 		   IF lk>0 Then
						ids_objects.Object.RowInDetail[li_Row]=lk
					END IF 
				else
			END IF 
			 li=lj
	 Loop
	 
	 ls_Type=""
	 ls_Band=""
	 
	 li_Row=ids_ReportObj.Find("name='"+as_objname+"'",1,ids_ReportObj.RowCount())
	 IF li_Row>0 Then
		 ids_ReportObj.Object.RowInDetail[li_Row]=Long(lds.Describe("datawindow.rows_per_detail"))
	END IF
END IF 




ls_Type=lds.Describe("datawindow.sparse")
IF ls_Type<>"" Then
	li_Count=OF_ParseToArray(ls_Type,"~t",ls_Objects)
	For li=1 To li_Count
		 li_Row=ids_Objects.Find("reportName='"+as_ObjName+"' AND name='"+ls_Objects[li]+"'",1,ids_Objects.RowCount())
		 IF li_Row>0 Then
			ids_Objects.Object.Sparse[li_Row]="1"
		 END IF
	Next
	ib_SparseFlag=True
END IF 

Return 1 
	
end function

protected function string of_getobjspace (long al_width);
Integer		li_Size, li_Len, li_Return, &
				li_WM_GETFONT = 49 	//  hex 0x0031
ULong			lul_Hdc, lul_Handle, lul_hFont


os_size 		lstr_Size


IF Not IsValid(invo_Cell ) Then Return "" 

if IsNull(iw_Parent) Or Not IsValid (iw_Parent) then
	OF_OpenUserObject()
end if

IF IsNull(iuo_Text) OR Not IsValid(iuo_Text) Then
	OF_OpenUserObject()
END IF



iuo_Text.FaceName = invo_Cell.invo_format.is_font
iuo_Text.TextSize = invo_Cell.invo_format.ii_size
IF invo_Cell.invo_format.ii_bold=1 Then
	iuo_Text.Weight =400
ELSE
	iuo_Text.Weight = 700 
END IF 

lul_Handle = Handle(iuo_Text)
lul_Hdc = GetDC(lul_Handle)

// Get the font in use on the Static Text
lul_hFont = Send(lul_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lul_Hdc, lul_hFont)

// Get the size of the text.
IF gettextextentpoint32W(lul_Hdc, ' ', 1, lstr_Size )  Then
	IF lstr_size.l_cx>0 Then
		lstr_Size.l_cx=PixelsToUnits(lstr_Size.l_cx, XPixelsToUnits!)
		li_Len=Truncate(al_width / lstr_Size.l_cx ,0 ) 
		li_Len=li_Len - Ceiling(li_Len / 5 ) 
		
	END IF
END IF

ReleaseDC(lul_Handle, lul_Hdc)

Return Space(li_Len)
return "" 
end function

protected subroutine of_getrowheight ();Long li,lk
String ls_ReportName,ls_Band 
String ls_Processing 
String ls_Prior_Band 
Long li_COunt 
Int  li_RowCount  
Long li_Row,li_BeginRow,li_EndRow
Long li_BandRow
Long li_DetailRows 
Long li_Row2 
Long li_Height
Long li_Y,li_Y2
Datastore  lds_Temp 
Boolean  lb_Border 

IF Not IsValid(ids_RowHeight) THen
	ids_RowHeight=Create DataStore
	ids_RowHeight.DataObject="d_dw2xls_rowheight"
END IF


 //取得行高
ids_Objects.SetFilter("")
ids_Objects.Filter() 
ids_Objects.SetSort("ReportName A ,Band A, y A   ")
ids_Objects.Sort()

ids_Line.SetFilter("")
ids_Line.Filter() 

IF ids_Line.RowCount()>0 Then
	lb_Border=True
	ids_Line.SetSort("ReportName A ,Band A, Y1 A")
	ids_Line.Sort() 
END IF


lds_Temp=Create datastore 
ls_Processing=idw_Requestor.Describe("datawindow.processing")
ids_RowHeight.SetSort("Row A")
li_Count=ids_Objects.RowCount()

//2004-11-27
IF isValid(ids_ReportObj) Then
	ids_ReportObj.SetSort("Y A")
	ids_ReportObj.Sort()
END IF

For li=1 TO li_Count
	  
	  //2004-11-28
	   IF ids_Objects.Object.ReportName[li]<>ls_ReportName OR ids_Objects.Object.Band[li]<>ls_Band or ( ls_processing='4' and ls_band<>ls_prior_band) Then
			   
				IF ids_Objects.Object.ReportName[li]<>ls_ReportName OR ids_Objects.Object.Band[li]<>ls_Band Then 
				 		ls_ReportName=ids_Objects.Object.ReportName[li]
						ls_Band=ids_Objects.Object.Band[li]
				 		li_BandRow= 0 
						
						//2004-11-27
						IF ids_Objects.Object.ReportName[li]="" Then
							li_Y = 0 
						ELSE
							li_Y=Long(idw_Requestor.Describe(ids_Objects.Object.ReportName[li]+".Y"))
						END IF 
				END IF 
				
				IF ls_Processing='4'Then 
					 li_Row2=ids_Bands.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND OldBand='"+idw_Requestor.Describe(ids_Objects.Object.name[li]+".band")+"' ",1,ids_Bands.RowCount())
				 ELSE
					 li_Row2=ids_Bands.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ls_Band +"' ",1,ids_Bands.RowCount())
				 END IF
				 
				 IF li_Row2>0 Then 
						 ids_Bands.Object.StartRow[li_Row2]= ids_Objects.Object.StartRow[li] 
						 ids_Bands.Object.EndRow[li_Row2]= ids_Objects.Object.EndRow[li] 
				END IF

		ELSE
			
				 IF li_Row2>0 Then 
						 IF ids_Objects.Object.StartRow[li]< ids_Bands.Object.StartRow[li_Row2] Then
							  ids_Bands.Object.StartRow[li_Row2]= ids_Objects.Object.StartRow[li] 
						 END IF
						
						  IF  ids_Objects.Object.EndRow[li] > ids_Bands.Object.EndRow[li_Row2] Then
								ids_Bands.Object.EndRow[li_Row2]= ids_Objects.Object.EndRow[li] 
						  END IF
				 END IF
					 
				IF  ids_Objects.Object.StartRow[li]=li_BandRow Then
						Continue 
				END IF
				
		END IF 
		
	  IF ids_Objects.Object.IsReport[li]='1' THEN
		   li_Y = ids_Objects.Object.Y2[li] 
			//li_y2=ids_Objects.Object.Y2[li]
			Continue
		END IF
	  
	  IF ids_Objects.Object.StartRow[li]=ids_Objects.Object.EndRow[li] Then
		      	
		 		 li_Row=ids_RowHeight.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND Row="+String(ids_Objects.Object.StartRow[li]),1,ids_RowHeight.RowCount())
				 IF li_Row<=0 Then
							 lk=ids_RowHeight.InsertRow(0)
							 ids_RowHeight.Object.ReportName[lk]=ids_Objects.Object.ReportName[li]
							 ids_RowHeight.Object.Band[lk]=ids_Objects.Object.Band[li]
							 ids_RowHeight.Object.Row[lk]=ids_Objects.Object.StartRow[li]
							 
							 
							 //2004-11-28
							 ids_RowHeight.Object.AboveRows[lk]=0
							 ids_RowHeight.Object.Y[lk] = ids_Objects.Object.Y[li]
							 
							 
							 //用于设置缺省行高   2004-11-11 
							 IF ids_Objects.Object.Band[li]="detail" Then 
								IF ids_Objects.Object.StartRow[li]>li_DetailRows Then  
									 li_DetailRows = Ids_Objects.Object.StartRow[li]
								END IF
							 END IF
							
							 
				           li_Row=ids_Objects.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND Y>"+String(ids_Objects.Object.Y2[li] - ii_RowSpace),li+1,ids_Objects.RowCount()) 
					        IF li_Row>0 Then
						          li_Y2= ids_Objects.Object.Y[li_Row]  //- ( ids_Objects.Object.Y[li_Row] - ids_Objects.Object.Y2[li] )/2
							   ELSE
									 IF ls_Processing='4' AND ls_Band="header" Then
										  IF idw_Requestor.Describe(ids_Objects.Object.Name[li]+".band")<>ls_prior_band Then
												li_Y=0
												ls_prior_band= idw_Requestor.Describe(ids_Objects.Object.Name[li]+".band")
												
										  END IF 
										  li_Y2= Long(idw_Requestor.Describe("datawindow."+ls_prior_band+".Height"))
											
									 ELSE 
										   IF ids_Objects.Object.ReportName[li]="" Then
														 //下面有没子数据窗口象   2004-11-27 
														 li_Row=0
														 IF IsValid(ids_ReportObj) Then
															 li_Row= ids_ReportObj.Find("Band='"+ls_Band+"' AND Y>"+String(ids_Objects.Object.Y[li]),1,ids_ReportObj.RowCount())
                                           END IF
														
														 IF li_Row>0 Then
														 	 li_Y2= ids_ReportObj.Object.Y[li_Row] 
													    ELSE
														     li_Y2= Long(idw_Requestor.Describe("datawindow."+ls_Band+".Height"))
														 END IF
														
											ELSE
											   lds_Temp.DataObject=idw_Requestor.Describe(ids_Objects.Object.ReportName[li]+".dataobject")
                   						li_Y2= Long(lds_Temp.Describe("datawindow."+ls_Band+".Height"))+Long(idw_Requestor.Describe(ids_Objects.Object.ReportName[li]+".Y"))   // 2004-11-28
									      END IF  
													
									 END IF
												
									 
					         END IF 
								
						     ids_RowHeight.Object.Height[lk]= li_Y2 - li_Y  
					    	  li_Height=0
							  IF lb_Border  Then
								        //上边线 ,如果没有上边线,而且是第一行,则认为从0开始
										  IF ids_Objects.Object.StartRow[li]>1 Then
										  		li_BeginRow=ids_Line.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND linetype='h' and startrow="+String(ids_Objects.Object.StartRow[li] -1 ),ids_Line.RowCount(),1)
											ELSE
												li_BeginRow=ids_Line.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND linetype='h' and startrow="+String(ids_Objects.Object.StartRow[li]  ),1,ids_Line.RowCount())
											END IF
											
										  IF li_BeginRow>0 Then
												 li_Y= ids_Line.Object.Y1[li_BeginRow]
											ELSE
													 IF ids_Objects.Object.StartRow[li]=1 Then
															li_Y=0
													 ELSE
															li_Y= ids_Objects.Object.Y[li]
													 END IF
											 END IF
											 
											  IF ids_Objects.Object.StartRow[li]>1 Then
											 		 li_EndRow=ids_Line.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND linetype='h' and startrow="+String(ids_Objects.Object.StartRow[li] ),1,ids_Line.RowCount())
												ELSE
													 li_EndRow=ids_Line.Find("ReportName='"+ids_Objects.Object.ReportName[li]+"' AND Band='"+ids_Objects.Object.Band[li]+"' AND linetype='h' and startrow="+String(ids_Objects.Object.StartRow[li] ),ids_Line.RowCount(), 1)
											   END IF
												
											  IF li_EndRow>0   Then		
													  li_Height=ids_Line.Object.Y1[li_EndRow]  - li_Y
											  END IF
							  END IF 
										
						     
				       
								IF li_Height> 0 Then  //ids_RowHeight.Object.Height[lk] 
									 ids_RowHeight.Object.Height[lk]=li_Height
								END IF
								
								li_BandRow=ids_Objects.Object.StartRow[li] 
								li_Y=li_Y2
						END IF
				
			END IF
 Next


For li=ids_RowHeight.RowCount() TO 1 Step -1 

	Choose Case is_Units
			
		Case '0'
			li_Height=ids_RowHeight.Object.Height[li]
		Case '1'
			 li_Height=PixelsToUnits(ids_RowHeight.Object.Height[li],YPixelsToUnits!)
			 
		Case '2'
			 li_Height=PixelsToUnits(ids_RowHeight.Object.Height[li] * 96 / 1000 ,YPixelsToUnits!)
		Case '3'
			 li_Height=PixelsToUnits(ids_RowHeight.Object.Height[li] * 37.8 / 1000,YPixelsToUnits!)

	END CHOOSE
			
	IF li_Height<60 Then
		li_Height=60
	END IF
	ids_RowHeight.Object.Height[li]= li_Height/ 4.9  //如果字体是12,则除以5  
	
	
	IF ids_RowHeight.Object.Band[li]='detail' Then 
	  IF li_DetailRows=1 AND lb_NestedFlag=False AND IsValid(ids_ReportObj)=False Then 
		  invo_worksheet.of_set_default_rowheight( ids_RowHeight.Object.Height[li])
		  ids_RowHeight.DeleteRow(li) 
	  END IF
 END IF

	
Next

Destroy lds_Temp

//openwithparm(w3,ids_line)

end subroutine

protected function unsignedlong of_getsyscolor (unsignedlong al_pbcolor);
ULong ll_Index
IF al_PBColor=67108864 Then
	 ll_Index=15
ELSEIF al_PBColor=268435456 Then
	 ll_Index=12
ELSE 
    ll_Index=al_PBColor - 134217728
END IF

Return GetSysColor(ll_Index ) 

end function

protected function integer of_outdata (datastore a_ds, string as_reportname, long ai_currow, string as_band, long ai_row);/*-------------------------------------------------
    在EXCEL表中写入数据
	 
	 ai_CurRow      数据要写入到EXCEL中的行号
	 as_band        要转出那个带区的对象
	 aai_CurRow     要转出的数据窗口中那个行的记录
	 
	 
返回值：   在EXCEL中写入多少行数据
----------------------------------------------------------------------*/
Long   li_outlines
Long    li_Height
String ls_Value, ls_Name,ls_Type
Int li,lj, lk, li_Count
Int li_Row
String ls_Format 
String ls_Visible 
Int li_StartRow,li_StartCol,li_EndRow,li_EndCol
uLong li_Color 
String ls_ColType
Int li_CurRow
n_xls_cell   lnv_cell1, lnv_cell2 
Boolean lb_overlap
Boolean lb_flag 


IF Not IsValid(ids_dwcObjects) Then
	is_dwcOldBand=as_Band
	Return 0
END IF 



IF is_dwcOldBand<>as_Band Then
	ids_dwcObjects.SetFilter("band='"+as_Band+"' AND ReportName='"+as_ReportName+"' AND Name<>'' ")
   ids_dwcObjects.Filter()
	ids_dwcObjects.Sort() 
	
	IF ib_SparseFlag Then
			IF ai_Row<a_ds.RowCount() AND  ids_dwcObjects.RowCount()>0 AND ( Left(as_band,7)="header."  OR Left(as_band,8)="trailer." ) Then
				  For li=1 TO ids_Column.RowCount()
					  IF ids_Column.Object.Sparse[li]="1" Then
										IF ai_currow>ids_Column.Object.BeginRow[li]  AND ids_Column.Object.BeginRow[li]>0 Then
												li_Row=ids_MergeCells.InsertRow(0)
												ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[li]
												ids_MergeCells.Object.StartCol[li_Row]=ids_Column.Object.StartCol[li]
												ids_MergeCells.Object.EndRow[li_Row]=ai_currow 
												ids_MergeCells.Object.EndCol[li_Row]=ids_Column.Object.EndCol[li]
										END IF
										ids_Column.Object.PriorValue[li]=""
										ids_Column.Object.BeginRow[li]=ai_CurRow+li_EndRow +1
						END IF
				  Next
			END IF
		
	 END IF
END IF

IF ids_dwcObjects.RowCount()=0 Then
	is_dwcOldBand=as_Band
   Return 0
END IF


//li_StartCol=Long(ids_dwcObjects.Describe("Evaluate('Min(StartCol)',0)"))
//li_EndCol=Long(ids_dwcObjects.Describe("Evaluate('Max(EndCol)',0)"))

IF is_dwcOldBand<>as_Band Then 
		ids_Bands.SetFilter("band='"+as_Band+"' AND ReportName='"+as_reportname+"'")
		ids_Bands.Filter()
END IF 
	
For li=1 To ids_Bands.RowCount()
	   li_color=0
		IF ids_Bands.Object.ColorExp[li]<>"" Then 
				li_Color=Long(OF_Evaluate(a_ds, ids_Bands.Object.ColorExp[li],ai_Row))
				li_Color=invo_Colors.of_get_color(li_color) 
				IF li_color<>0 then
					 li_color= invo_colors.of_get_custom_color_index(li_color) 
				END IF 
				
		  ELSE
				li_Color= ids_Bands.Object.Color[li]
		  END IF
		  
		  IF li_color<>0 AND li_color <> 65 Then
			   li_Row=ids_ReportObj.Find("name='"+as_reportname+"'",1,ids_ReportObj.RowCount())
				IF li_Row>0 Then
							 For  lj=ids_Bands.Object.StartRow[li] To ids_Bands.Object.EndRow[li] 
							 		//For lk=ids_Bands.Object.StartCol[li] TO ids_Bands.Object.EndCol[li]
									For lk = ids_ReportObj.Object.StartCol[li_Row] To ids_ReportObj.Object.EndCol[li_Row]  
								 	 	invo_cell=invo_worksheet.of_getcell(lj+ai_currow,lk)
								  		invo_cell.invo_format.of_set_bg_color(li_color)
									 Next
							Next
				 END IF
						
			END IF
Next

//设置行高
IF is_dwcOldBand<>as_Band Then 
	ids_RowHeight.SetFilter("band='"+as_Band+"' AND ReportName='"+as_reportname+"'")
	ids_RowHeight.Filter()
	ids_RowHeight.Sort() 
END IF
	
For li=1 To ids_RowHeight.RowCount()
	 IF ids_RowHeight.Object.Height[li]>0 Then
		 invo_worksheet.of_Set_Row_Height(ai_Currow+ids_RowHeight.Object.Row[li] + ids_RowHeight.Object.AboveRows[li] -1 ,double(ids_RowHeight.Object.Height[li])  ) 
	 END IF
Next

IF IsValid(ids_Line) Then
	
		ids_Line.SetFilter("band='"+as_Band+"' AND ReportName='"+as_reportname+"' ")	
		ids_Line.Filter()
         
			For li=1 To ids_Line.RowCount()
				 For lj=ids_Line.Object.StartCol[li] To ids_Line.Object.EndCol[li] 
						li_Count=ids_Line.Object.EndRow[li] 
				 	    For lk=ids_Line.Object.StartRow[li] To li_Count		//ids_Line.Object.EndRow[li]
							 IF lk>0 AND lj>0 Then
									 
									 IF ids_Line.Object.LineType[li]='h' Then
										   invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj) 
											
											IF lk=1   Then
													  //判断线是在对象下面,还是在对象上面
													  li_Row=ids_dwcObjects.Find("Y2<="+String(ids_Line.Object.Y1[li] +ii_RowSpace),1,ids_dwcObjects.RowCount())
													  IF li_Row>0 Then		  
																 invo_cell.invo_format.ii_bottom= ids_Line.Object.PenWidth[li] 
																 invo_cell.invo_format.ii_bottom_color = ids_Line.Object.pencolor[li]
														ELSE
																invo_cell.invo_format.ii_top= ids_Line.Object.PenWidth[li] 
																invo_cell.invo_format.ii_top_color = ids_Line.Object.pencolor[li]
														END IF
											ELSE
												 invo_cell.invo_format.ii_bottom= ids_Line.Object.PenWidth[li] 
												 invo_cell.invo_format.ii_bottom_color = ids_Line.Object.pencolor[li]
											END IF
										
								   ELSE
											  IF lj= ii_MaxCol AND lj>1 Then
												  invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj -1) 
												  invo_cell.invo_format.ii_Right= ids_Line.Object.PenWidth[li] 
												  invo_cell.invo_format.ii_Right_color = ids_Line.Object.pencolor[li] 
											  ELSE
													invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj ) 
												  invo_cell.invo_format.ii_Left= ids_Line.Object.PenWidth[li] 
												  invo_cell.invo_format.ii_Left_color = ids_Line.Object.pencolor[li] 
											  END IF
							      END IF 
							 END IF
					 Next
				Next
			Next
END IF

	
	
li_EndRow=0
li_Count=ids_dwcObjects.RowCount()
FOR li=1 To li_Count   
	
	   IF (ids_dwcObjects.Object.RowInDetail[li]+ai_Row -1)>a_ds.RowCount() Then
			  Continue
		END IF
		
		
	   ls_Name=ids_dwcObjects.Object.Name[li]
		ls_Type=ids_dwcObjects.Object.Stype[li]
		ls_ColType= ids_dwcObjects.Object.Coltype[li]
    	li_StartRow=ids_dwcObjects.Object.StartRow[li]
		li_StartCol=ids_dwcObjects.Object.StartCol[li]
		li_EndRow=ids_dwcObjects.Object.EndRow[li]
		li_EndCol=ids_dwcObjects.Object.EndCol[li]
		ls_Value=""
		lb_overlap=False
		
		IF li_StartRow<=0  OR li_StartCol<=0   OR li_StartCol>256 Then Continue   //行列没定义不输出 ,如果列大于256,也不输出,因为F1最多只支持256列
 		IF ids_dwcObjects.Object.VisibleExp[li]<>"" Then
			 ls_Visible=OF_Evaluate(a_ds,ids_dwcObjects.Object.VisibleExp[li],ai_Row )
		ELSE
			 ls_Visible = ids_dwcObjects.Object.Visible[li]
		END IF 
		
		
		//输出多少行数据
		IF li_EndRow >li_outlines THEN
			li_outlines=li_EndRow
		END IF
	   
		 li_CurRow=li_StartRow+ai_CurRow
	    //如果对象前一单元有内容,则设置前一单元自动换行
		 //invo_worksheet.OF_PriorCell_wrapText(li_CurRow,li_StartCol)   //2004-11-05 
	  	 invo_cell=invo_worksheet.of_getcell(li_CurRow,li_StartCol) //,invo_pre_cell
		
		 IF ids_dwcObjects.Object.isBorderOnly[li]='1' Then 
				IF li_StartRow<>li_EndRow OR li_StartCol<>li_EndCol  Then  //合并单元
						 For lj=li_StartRow To   li_EndRow
								  For lk = li_StartCol To  li_EndCol
												IF lj<>li_StartRow AND lj<>li_EndRow AND lk<>li_StartCol AND lk<>li_EndCol Then
													Continue
												END IF
												
												invo_cell=invo_worksheet.of_getcell(lj+ai_CurRow,lk)
												IF lj=li_StartRow Then 
													invo_cell.invo_format.ii_top=1
												END IF
												
												IF lj=li_EndRow Then 
													invo_cell.invo_format.ii_bottom=1
												END IF	
												
												IF lk=li_StartCol Then 
													invo_cell.invo_format.ii_left=1
												END IF
												
												IF lk=li_EndCol Then 
													invo_cell.invo_format.ii_right=1
												END IF	
										
								  Next
						 Next
				ELSE
					 invo_cell.invo_format.ii_left=1
				    invo_cell.invo_format.ii_right=1
				    invo_cell.invo_format.ii_top=1
				    invo_cell.invo_format.ii_bottom=1
			   END IF
				  
				Continue
			END IF
			
		 //对象是否自动换行  2004-11-11 	
		 invo_cell.invo_format.ii_text_wrap=ids_dwcObjects.Object.WrapText[li]
		
		//判断是否有多个对象重复输出到同一单元
		IF invo_Cell.is_Value<>"" OR ids_dwcObjects.Object.MergeFlag[li]='1' Then
			 lb_overlap=True
		END IF
		
		 IF ids_dwcObjects.Object.FormatExp[li]="" Then	
			 invo_cell.invo_format.is_num_format = ids_dwcObjects.Object.Format[li] 
	  ELSE
			invo_cell.invo_format.is_num_format = OF_Evaluate(a_ds,ids_dwcObjects.Object.FormatExp[li],ai_Row)
	  END IF 
	  
	  IF ids_dwcObjects.object.border[li]='2' then
				  invo_cell.invo_format.ii_left=1
				  invo_cell.invo_format.ii_right=1
				  invo_cell.invo_format.ii_top=1
				  invo_cell.invo_format.ii_bottom=1
				  
		ELSEIF ids_dwcObjects.object.border[li]='4' then
			     invo_cell.invo_format.ii_bottom=1
			 
		END IF
			 
		 IF  ls_Type="compute" OR ls_Type="column"  Then   //{b}
					//IF ids_dwcObjects.Object.RowInDetail[li]>0 Then 
							 ls_value=Of_GetData(a_ds,ai_row+ids_dwcObjects.Object.RowInDetail[li] -1 ,ls_Name, ls_coltype,invo_cell.invo_format.is_num_format, ids_dwcObjects.Object.displayvalue[li] , ids_dwcObjects.Object.columnflag[li], lb_overlap)
					// ELSE
					//	    ls_value=Of_GetData(a_ds,ai_row,ls_Name, ls_coltype,invo_cell.invo_format.is_num_format, ids_dwcObjects.Object.displayvalue[li] , lb_overlap)
					//END IF
				
				 
				    IF ib_SparseFlag AND as_Band="detail"  Then
									 lj=ids_Column.Find("reportname='"+as_reportname+"' AND name='"+ls_Name+"'",1,ids_Column.RowCount())
									 IF lj>0 Then
											 IF ids_Column.Object.Sparse[lj]="1" Then
													
													  IF ai_row=1 Then
																  ids_Column.Object.BeginRow[lj]=li_currow
																  ids_Column.Object.PriorValue[lj]=ls_Value
															ELSE
																
																 IF ids_Column.Object.BeginRow[lj]>=li_CurRow AND ai_Row<a_ds.RowCount() Then
																	 ids_Column.Object.PriorValue[lj]=ls_Value
																 ELSE
																			IF ls_Value= ids_Column.Object.PriorValue[lj]  AND ai_Row<a_ds.RowCount() Then
																				Continue
																			 ELSE
																				  IF ai_Row=idw_Requestor.RowCount() AND ls_Value= ids_Column.Object.PriorValue[lj]  Then
																							lk=li_currow+li_EndRow -1
																					 ELSE
																							 For lk=ids_Column.Object.BeginRow[lj]+1 To  ai_Currow
																								
																								  lnv_cell1= invo_WorkSheet.OF_GetCell(lk,li_StartCol)
																								  lnv_Cell2= invo_WorkSheet.OF_GetCell(ids_Column.Object.BeginRow[lj]+1,li_StartCol)
																								  //IF xlApp.TextRC[lk,li_StartCol]<>xlApp.TextRC[ids_Column.Object.BeginRow[lj]+1,li_StartCol] Then
																								  IF lnv_Cell1.is_Value<>lnv_Cell2.is_Value Then  
																										Exit
																								  END IF
																							Next
																							
																							lk=lk -1
																					 END IF
																						
																							 
																						IF lk>ids_Column.Object.BeginRow[lj] Then
																							 
																										li_Row=ids_MergeCells.InsertRow(0)
																										ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[lj]
																										ids_MergeCells.Object.StartCol[li_Row]=li_StartCol
																										ids_MergeCells.Object.EndRow[li_Row]=lk 
																										ids_MergeCells.Object.EndCol[li_Row]=li_EndCol
																						END IF
																						
																						
																						
																						IF  ai_Row<idw_Requestor.RowCount()  Then
																								 ids_Column.Object.BeginRow[lj]=li_CurRow
																								 ids_Column.Object.PriorValue[lj]=ls_Value
																								 
																									// 处理后面的列
																									For lj=1 To ids_Column.RowCount()
																										  IF ids_Column.Object.StartCol[lj]>li_StartCol AND ids_Column.Object.Sparse[lj]="1"  Then
																												IF lk>ids_Column.Object.BeginRow[lj] Then
																													 li_Row=ids_MergeCells.InsertRow(0)
																													 ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[lj]
																													 ids_MergeCells.Object.StartCol[li_Row]=ids_Column.Object.StartCol[lj]
																													 ids_MergeCells.Object.EndRow[li_Row]=lk 
																													 ids_MergeCells.Object.EndCol[li_Row]=ids_Column.Object.EndCol[lj]
																												 END IF
																												
																												 //由于排序方式一样
																												 ids_Column.Object.BeginRow[lj]=lk+1
																												 ids_Column.Object.PriorValue[lj]=ls_Value
																												  
																												 
																										  END IF
																									Next
																						 ELSE
																							
																							 //如果最后一行是被合并的，则不输出
																							 IF lk>=li_CurRow Then
																								  Continue
																							 END IF
																							
																						 END IF
																				END IF
																	 END IF
														 END IF
											  END IF
									  END IF
							END IF
							
		ELSE
			  IF ls_Visible="1" Then
				         ls_Value= a_ds.Describe(ls_Name+".text")
							 IF Left(ls_Value,1)='"' OR Left(ls_Value,1)="'" Then
								 ls_Value =Mid(ls_Value,2, Len(ls_Value) -2)
							  END IF
							
							 lj=Pos(ls_Value,"~t")
							  //PB新版本支持Text对象的Text是一个表达式  2004-10-29
							 IF lj>0 Then
							      ls_Value=OF_Evaluate(a_ds, Mid(ls_Value,lj+1),ai_Row) 
							 END IF
				END IF 
		END IF                                                            
				
       IF li_StartRow<>li_EndRow OR li_StartCol<>li_EndCol  Then  //合并单元
		      invo_cell.EndRow= li_EndRow+ai_CurRow
				invo_cell.EndCol= li_EndCol
				IF li_StartRow<>li_EndRow Then
				 	  invo_cell.invo_format.ii_text_wrap=1  
				 END IF
				invo_worksheet.of_mergecells(li_CurRow,li_StartCol,li_EndRow+ai_CurRow,li_EndCol)
		  END IF
				
		  IF  ls_Visible="1" Then  
			
			     //如果单元在细节区,而且对象与前输出行与细节区第一行时输出的单元格式相同
				  //则直接取第一次输出时的单元格式,从而可以减少单元格式判断的次数
			     lb_flag=False 
				  IF ib_GridBorder=False AND (as_Band="detail" OR Pos(as_Band,".")>0 )  AND ids_dwcObjects.Object.ExpFlag[li]='0' Then
				       IF ids_dwcObjects.Object.xfIndex[li]>0 Then
							 IF ids_dwcObjects.Object.BorderKey[li] = String(invo_cell.invo_Format.ii_top,"00")+ String(invo_cell.invo_Format.ii_bottom,"00")+String(invo_cell.invo_Format.ii_left,"00")+String(invo_cell.invo_Format.ii_right,"00") Then
								  invo_Cell.ii_xf= ids_dwcObjects.Object.xfIndex[li]
								  lb_flag=True
							 END IF
						END IF
						
					END IF
					
		 		 IF lb_flag=False AND ( invo_cell.is_value="" or Not lb_overlap ) Then   //如果多个对象重复输出到同一单元,则以第一次取的格式为准
							  
	
							  IF ids_dwcObjects.Object.FontSizeExp[li]="" Then
									 invo_cell.invo_format.ii_size = ids_dwcObjects.Object.FontSize[li]
							  ELSE
									 invo_cell.invo_format.ii_size =ABS(Long(OF_Evaluate(a_ds,ids_dwcObjects.Object.FontSizeExp[li],ai_Row)))
							  END IF
							
							  IF ids_dwcObjects.Object.FontNameExp[li]="" Then
									invo_cell.invo_format.is_font = ids_dwcObjects.Object.FontName[li]
							  ELSE
									invo_cell.invo_format.is_font = OF_Evaluate(a_ds,ids_dwcObjects.Object.FontNameExp[li],ai_Row)
							  END IF 
								
								IF ids_dwcObjects.Object.fontweightexp[li]="" Then
									 invo_cell.invo_format.ii_bold = ids_dwcObjects.Object.Fontweight[li]
								ELSE
									 invo_cell.invo_format.ii_bold =Long(OF_Evaluate(a_ds,ids_dwcObjects.Object.fontweightexp[li],ai_Row))
								END IF
								
							 IF ids_dwcObjects.Object.Fontitalicexp[li]="" Then	
									invo_cell.invo_format.ii_italic = Long(ids_dwcObjects.Object.Fontitalic[li]) 
							  ELSE
									invo_cell.invo_format.ii_italic = Long(OF_Evaluate(a_ds,ids_dwcObjects.Object.Fontitalicexp[li],ai_Row))
							  END IF
								
								IF ids_dwcObjects.Object.Alignmentexp[li]="" Then	
										 invo_cell.invo_format.ii_text_h_align=ids_dwcObjects.Object.Alignment[li]
								 ELSE
											Choose Case OF_Evaluate(a_ds,ids_dwcObjects.Object.Alignmentexp[li],ai_Row)   
												 Case "1"   //右对齐
															 invo_cell.invo_format.ii_text_h_align=3
												Case "2"   //中对齐
														 invo_cell.invo_format.ii_text_h_align=2
												Case Else    //均匀对齐,调整为左对齐
														 invo_cell.invo_format.ii_text_h_align=1
										 END CHOOSE
								END IF
									
							  
							  IF ids_dwcObjects.Object.FontColorexp[li]="" Then	
									invo_cell.invo_format.ii_color=ids_dwcObjects.Object.FontColor[li]
							  ELSE
									 li_color=long(OF_Evaluate(a_ds,ids_dwcObjects.Object.FontColorexp[li],ai_Row))
									 li_color = invo_colors.of_get_color(li_color )
									 invo_cell.invo_format.ii_color= invo_colors.of_get_custom_color_index(li_color)  
							  END IF
							  
							 
								  IF ids_dwcObjects.Object.bgColorexp[li]="" Then	
									   if ids_dwcObjects.Object.bgColor[li]<>65 and ids_dwcObjects.Object.bgColor[li]<>0  then  //以免破坏按带区设置了颜色的情况
												invo_cell.invo_format.of_set_bg_color(Long(ids_dwcObjects.Object.bgColor[li]))
										end if
								  ELSE
										 li_color=long(OF_Evaluate(a_ds,ids_dwcObjects.Object.bgColorexp[li],ai_Row))
										 li_color = invo_colors.of_get_color(li_color )
										 if li_color<>0 then 
											 li_color= invo_colors.of_get_custom_color_index(li_color)
										 end if
										
										 if li_color<>65 and li_color<>0  then
											 invo_cell.invo_format.of_set_bg_color(li_color)
										 end if 
								  END IF
				 END IF
				 
						
		      
				 
				  IF ls_Value="!" or ls_Value="?" Then
						ls_Value=""
				  END IF 
				  
				   IF ls_Value<>"" or ids_dwcObjects.Object.ObjSpace[li]>0 OR  ids_dwcObjects.Object.MergeFlag[li]="1" Then
						 IF ids_dwcObjects.Object.ObjSpace[li]>0 Then
							  ls_Value=OF_GetObjSpace(ids_dwcObjects.Object.ObjSpace[li])+ls_Value
						ELSE
							IF ids_dwcObjects.Object.MergeFlag[li]="1" Then
								 ls_Value=ls_Value+Mid(OF_GetObjSpace(ids_dwcObjects.Object.Width[li]),Len(ls_Value)+1)
							END IF
						 END IF
					END IF
				
		
               
					IF lb_overlap Then
					      invo_Cell.is_CellType='S'
						   invo_Cell.invo_format.is_num_format="General"  //设为常规
					ELSE
						  
						   IF ids_dwcObjects.Object.DisplayValue[li]='1' Then 
								invo_Cell.is_CellType='S'
							ELSE
								 invo_Cell.is_CellType=ls_ColType
							END IF
							
				   END IF
					invo_cell.is_value+=ls_value
					
					
					//同一列的同一对象,格式可能是一样的,避免重复注册单元格式,提高处理速度
				  IF ib_GridBorder=False AND (as_Band="detail" OR Pos(as_Band,".")>0 )  AND ids_dwcObjects.Object.ExpFlag[li]='0' Then
					  IF ids_dwcObjects.Object.xfIndex[li]=0 Then
							invo_cell.ii_xf =invo_cell.invo_WorkSheet.invo_WorkBook.OF_Reg_Format(invo_cell.invo_Format) +14
							ids_dwcObjects.Object.xfIndex[li] = invo_cell.ii_xf
						   ids_dwcObjects.Object.BorderKey[li] = String(invo_cell.invo_Format.ii_top,"00")+ String(invo_cell.invo_Format.ii_bottom,"00")+String(invo_cell.invo_Format.ii_left,"00")+String(invo_cell.invo_Format.ii_right,"00")
	
						END IF
				  
				  END IF 
				  
		END IF     
		
Next     




is_dwcOldBand=as_Band
Return li_outlines


Return 0 
end function

protected function integer of_groupcount ();/*
   计算数据窗口有多少个分组
	
*/

string ls_Temp
int li,li_pos,li_Pos2,li_groupcount

ls_Temp=idw_Requestor.Describe("datawindow.bands")
li_pos=1
Do While li_pos>0 
	li_pos=Pos(ls_Temp,"header.",li_pos)
	IF li_pos>0 Then
		  li_groupcount++
		  li_pos++
   END IF
Loop

IF li_GroupCount >0 Then
	ls_Temp=idw_Requestor.Describe("datawindow.syntax")
	 li_Pos=Pos(ls_Temp,"group(level=1 ")
	 ls_Temp=Mid(ls_Temp,li_Pos) 
	 li=1
	 Do While li_Pos>0
		 li_Pos2=Pos(ls_Temp,"group(level="+String(li) )
		 IF li_Pos2>0 Then
			 li_Pos= pos(Mid(ls_Temp,li_Pos2 - li_Pos),"newpage=yes")
		 ELSE
			  li_Pos= pos(ls_Temp,"newpage=yes",li_Pos)
		 END IF
		
		 IF li_Pos>0 Then
		    ib_GroupNewPage[li]=True
		 ELSE
		 	ib_GroupNewPage[li]=False
		 END IF
		 
		 li_Pos=li_Pos2
		 li++
	Loop
END IF

//如果报表只有一个分组,而且设置了分组分页打印,被设置不需要每个分组都输出

IF li_groupcount=1 Then
	IF ib_GroupNewPage[1] Then
		 ib_GroupOutFlag=False
	END IF
END IF
	


Return li_groupcount
end function

protected subroutine of_gridinfo (string as_reportname, string as_bands[]);Int li ,lj ,li_Row 
Long li_x ,li_Y

Long li_Width= 20
Long li_Space = 50 



IF Not IsValid(ids_Line) Then Return
IF ids_Line.RowCount()<=0 Then   Return 

Choose Case is_units 
	Case '1'
		  li_Width=UnitsToPixels(li_Width,xUnitsToPixels!)
		  li_Space=UnitsToPixels(li_Space,YUnitsToPixels!)
		  
	Case '2'
		   li_Width = UnitsToPixels(li_Width, XUnitsToPixels!)* 0.1041
			li_Space= UnitsToPixels(li_Space, YUnitsToPixels!)* 0.1041
			
	Case '3'
		   li_Width = UnitsToPixels(li_Width, XUnitsToPixels!) *2.646
			li_Space= UnitsToPixels(li_Space, YUnitsToPixels!) *2.646
	
END CHOOSE 

			
		  
ids_Line.SetFilter("")
ids_Line.Filter()
For li=ids_Line.RowCount() To 1 Step -1	
	
	//处理线条    有客户提交的测试数据窗口,有些线条x和y值竟然都是为0 :) 
	IF ids_Line.Object.X2[li]=ids_Line.Object.x1[li] and ids_Line.Object.Y2[li]=ids_Line.Object.Y1[li] Then
		ids_Line.DeleteRow(li)
		Continue
	END IF
	
	IF (ids_Line.Object.X2[li]<0 AND ids_Line.Object.x1[li]<0) or  (ids_Line.Object.Y2[li]<0 AND ids_Line.Object.Y1[li]<0 )  Then
		ids_Line.DeleteRow(li)
		Continue
	END IF
	
	
	IF ids_Line.Object.X2[li]<ids_Line.Object.x1[li] Then
		  li_x=ids_Line.Object.x1[li]
		  ids_Line.Object.x1[li]=ids_Line.Object.x2[li]
		  ids_Line.Object.x2[li]=li_x
	  END IF
	
		IF ids_Line.Object.Y2[li]<ids_Line.Object.Y1[li] Then
		  li_Y=ids_Line.Object.Y1[li]
		  ids_Line.Object.Y1[li]=ids_Line.Object.Y2[li]
		  ids_Line.Object.Y2[li]=li_Y
	  END IF  
	  
	  //判断线型
	  IF (ids_Line.Object.X2[li] - ids_Line.Object.x1[li])>li_Width Then
		   ids_Line.Object.LineType[li]="h"
		else
			ids_Line.Object.LineType[li]="v"
		END IF
Next


	


ids_Line.SetFilter("lineType='h'")
ids_Line.Filter()
ids_Line.SetSort("ReportName A, Band A ,Y1 A")
ids_Line.Sort()

ids_Objects.SetFilter("")
ids_Objects.SetSort(" Y A")
ids_Objects.Filter()
ids_Objects.Sort() 
For li=ids_Line.RowCount() To 2 Step -1
      IF ids_Line.Object.ReportName[li]<>ids_Line.Object.ReportName[li -1] OR ids_Line.Object.Band[li]<>ids_Line.Object.Band[li -1] Then
			 Continue
		END IF
		
		li_Row=ids_Objects.Find("ReportName='"+ids_Line.Object.ReportName[li]+"' AND Band='"+ids_Line.Object.Band[li]+"' AND y> "+String(ids_Line.Object.y1[li -1] - ii_RowSpace )+" AND Y2< "+String(ids_Line.Object.y1[li] +ii_RowSpace) ,1,ids_Objects.RowCount())
		IF li_Row<=0 Then
				IF ( ids_Line.Object.Y1[li] - ids_Line.Object.Y1[li -1] )>li_Space Then
						 li_Row=ids_Objects.InsertRow(0)
						 ids_Objects.Object.x[li_Row]=ids_Line.Object.x1[li -1]+ii_ColSpace
						 ids_Objects.Object.Y[li_Row]=ids_Line.Object.Y1[li -1]+ii_RowSpace
						 ids_Objects.Object.Width[li_Row]=li_Space
						 ids_Objects.Object.Height[li_Row]=li_Space
						 ids_Objects.Object.Band[li_Row]=ids_Line.Object.Band[li]
						 ids_Objects.Object.ReportName[li_Row]=as_ReportName 
						 ids_Objects.Object.Name[li_Row]=''
						 
				END IF
			 
		END IF
Next

end subroutine

public subroutine of_mergecolumnheader (boolean ab_flag, string as_objname);ib_MergeColumnHeader=ab_Flag
is_BeginRowObj=as_ObjName
end subroutine

protected function boolean of_openuserobject ();powerobject	lpo_parent

OF_CloseUserObject()

lpo_parent = idw_Requestor.GetParent()
do while IsValid (lpo_parent) 
	if lpo_parent.TypeOf() <> window! then
		lpo_parent = lpo_parent.GetParent()
	else
		exit
	end if
loop

if IsNull(lpo_parent) Or not IsValid (lpo_parent) then
	setnull(iw_parent)	
	return False 
end If
iw_parent = lpo_parent

IF iw_parent.OpenUserObject(iuo_Text)=1 Then
	iuo_Text.Visible=False
	iuo_Text.Text=' ' 
	Return True
END IF 

Return False 

end function

protected function string of_replaceall (string as_string1, string as_string2, string as_string3);long ll_Pos,ll_F,ll_R

ll_F=Len(as_String2)
ll_R=Len(as_String3)

ll_Pos=Pos(as_String1,as_String2)
DO WHILE ll_Pos<>0
	as_String1=Replace(as_String1,ll_Pos,ll_F,as_String3)
	ll_Pos=Pos(as_String1,as_String2,ll_Pos+ll_R)
LOOP

RETURN as_String1
end function

protected function integer of_outdata (long ai_currow, string as_band, long ai_row);/*-------------------------------------------------
    在EXCEL表中写入数据
	 
	 ai_CurRow      数据要写入到EXCEL中的行号
	 as_band        要转出那个带区的对象
	 aai_CurRow     要转出的数据窗口中那个行的记录
	 
	 
返回值：   在EXCEL中写入多少行数据
----------------------------------------------------------------------*/
Long   li_outlines
Long    li_Height
String ls_Value, ls_Name,ls_Type
Int  li,lj, lk, li_Count
Int  li_GroupCount
Int li_Row
String ls_Format 
String ls_ColType 
String ls_Visible
Int li_StartRow,li_StartCol,li_EndRow,li_EndCol
uLong li_Color 
Int li_CurRow
Datastore   lds
DataWindowChild  dwc 
n_xls_Cell	lnv_cell1,lnv_Cell2 
boolean  lb_overlap
boolean lb_flag
Boolean lb_TrailerFlag

IF is_OldBand<>as_Band Then
	ids_Objects.SetFilter("band='"+as_Band+"' AND Name<>'' ")
   ids_Objects.Filter()
	ids_Objects.Sort() 

	
	is_dwcOldBand="" 
	
	IF ib_SparseFlag Then
			IF ai_Row<idw_Requestor.RowCount() AND   ( Left(as_band,7)="header."  OR Left(as_band,8)="trailer." ) Then
				  For li=1 TO ids_Column.RowCount()
					  IF ids_Column.Object.Sparse[li]="1" Then
										IF ai_currow>=ids_Column.Object.BeginRow[li]  AND ids_Column.Object.BeginRow[li]>0 Then
										li_Row=ids_MergeCells.InsertRow(0)
												ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[li]
												ids_MergeCells.Object.StartCol[li_Row]=ids_Column.Object.StartCol[li]
												ids_MergeCells.Object.EndRow[li_Row]=ai_currow 
												ids_MergeCells.Object.EndCol[li_Row]=ids_Column.Object.EndCol[li]
										END IF
										ids_Column.Object.PriorValue[li]=""
										ids_Column.Object.BeginRow[li]=ai_CurRow+li_EndRow +1
						END IF
				  Next
			END IF
	 END IF
	

END IF

IF IsValid(ids_ReportObj) Then
	IF is_OldBand<>as_Band  Then 
			ids_ReportObj.SetFilter("Band='"+as_Band+"'")
			ids_ReportObj.Filter()
	END IF
	
	IF ids_ReportObj.RowCount()>0 Then
		 
		 li_Currow=ai_Currow
		 lds=Create DataStore
		 	 
		 For li=1 To ids_ReportObj.RowCount()
			    ls_Name=ids_ReportObj.Object.Name[li]
			    ids_Column.SetFilter("reportname='"+ls_Name+"'")
				 ids_Column.Filter()
				 ids_Column.Sort()
				 is_dwcOldBand=""
		       
				 
			    lds.DataObject=idw_Requestor.Describe(ls_Name+".DataObject")
				
			    IF idw_Requestor.Describe("DataWindow.Nested")="yes" AND ai_Row>0 Then
				     Choose Case ls_Name
						    Case  "dw_1"
									 IF Len(String(idw_Requestor.Object.dw_1[ai_Row].Object.DataWindow.Syntax.Data))>10 Then
						       	  		lds.Object.Data=idw_Requestor.Object.dw_1[ai_Row].Object.Data  //否则如果没有记录,会出错
									 END IF
					
							 Case "dw_2"
				 	  		   	 IF Len(String(idw_Requestor.Object.dw_2[ai_Row].Object.DataWindow.Syntax.Data))>10 Then
				        	  	      	lds.Object.Data=idw_Requestor.Object.dw_2[ai_Row].Object.Data  //否则如果没有记录,会出错
									 END IF
				
							 CASE "dw_3"
				 	  		   	 IF Len(String(idw_Requestor.Object.dw_3[ai_Row].Object.DataWindow.Syntax.Data))>10 Then
				    	  	      	  lds.Object.Data=idw_Requestor.Object.dw_3[ai_Row].Object.Data  //否则如果没有记录,会出错
									 END IF
									 
							Case "dw_4"
				 	  		   	 IF Len(String(idw_Requestor.Object.dw_4[ai_Row].Object.DataWindow.Syntax.Data))>10 Then
				        	  	      	lds.Object.Data=idw_Requestor.Object.dw_4[ai_Row].Object.Data  //否则如果没有记录,会出错
									 END IF
				
							Case "dw_5"
			 	  		   	 IF Len(String(idw_Requestor.Object.dw_5[ai_Row].Object.DataWindow.Syntax.Data))>10 Then
				        	  	      	lds.Object.Data=idw_Requestor.Object.dw_5[ai_Row].Object.Data  //否则如果没有记录,会出错
								 END IF
									 
						END CHOOSE
		      ELSE
				    idw_Requestor.GetChild(ls_Name,dwc)
			       dwc.RowsCopy(1,dwc.RowCount(),Primary!,lds,1,Primary!)
			   END IF
				
				//2004-11-28 
				//IF ids_ReportObj.Object.StartRow[li]>0 Then
					 li_Currow=ai_Currow+ids_ReportObj.Object.StartRow[li] +ids_ReportObj.Object.AboveRows[li] -1
				//END IF
					 
				IF lds.RowCount()>0 Then
 				    li_Currow+=OF_OutData(lds,ls_Name,li_Currow,"header",1)
				ELSE
					 li_Currow+=OF_OutData(lds,ls_Name,li_Currow,"header",0)
				 END IF
	          
				 //计算分组数
	          ls_Value=lds.Describe("datawindow.bands")
				 li_Row=1
				 Do While li_Row>0 
						li_Row=Pos(ls_Value,"header.",li_Row)
						IF li_Row>0 Then
							  li_groupcount++
							 li_Row++
						END IF
				Loop
				
				
				For li_Row=1 To lds.RowCount()
					   
						lb_TrailerFlag=False
						FOR lj=1 To li_GroupCount
								 IF lds.FindGroupChange(li_Row,lj)=li_Row Then    //分组的开始
										IF li_Row<>1 AND Not lb_TrailerFlag Then      //第一次,不用输出组的尾区
												  lb_TrailerFlag=True 
												  For lk=li_GroupCount To lj Step -1
														  IF Long(lds.Describe("datawindow.trailer."+String(lk)+".height"))>0 Then
																li_CurRow+=Of_OutData(lds,ls_Name,li_CurRow,"trailer."+string(lk),li_Row -1)
															END IF
													Next
										 END IF
											 
										 IF Long(lds.Describe("datawindow.header."+String(lj)+".height"))>0 Then
														li_CurRow+=Of_OutData(lds,ls_Name,li_CurRow,"header."+string(lj),li_Row )
										 END IF
											
								END IF 
		            NEXT
									
	    			 //输出当前记录
	 				 li_CurRow+=Of_OutData(lds,ls_Name,li_CurRow,"detail",li_Row)
					 li_Row=li_Row+ids_ReportObj.Object.RowInDetail[li] -1
						
				NEXT 

				//输出所有组的最后一组脚尾区
				FOR lj=li_GroupCount To 1 Step -1 
					li_CurRow+=Of_OutData(lds,ls_Name,li_CurRow,"trailer."+string(lj),lds.RowCount())
				NEXT 	
				li_CurRow+=Of_OutData(lds,ls_Name,li_CurRow,"summary",lds.RowCount())
				
				li_Row=ids_ReportObj.Find("Y>"+string(ids_ReportObj.Object.Y2[li]),li+1,ids_ReportObj.RowCount())
            Do While li_Row>0 
					ids_ReportObj.Object.AboveRows[li_Row]= li_Currow - ai_Currow - ids_ReportObj.Object.StartRow[li] +1
					IF li_Row>=ids_ReportObj.RowCount() Then
						Exit
					END IF
					li_Row=ids_ReportObj.Find("Y>"+string(ids_ReportObj.Object.Y2[li]),li_Row+1,ids_ReportObj.RowCount())
			   Loop 
				
				li_Row=ids_Objects.Find("Y>"+string(ids_ReportObj.Object.Y2[li])+" AND Slipup='1' ",1,ids_Objects.RowCount())
            Do While li_Row>0 
					ids_Objects.Object.AboveRows[li_Row]= li_Currow - ai_Currow  - ids_ReportObj.Object.StartRow[li]+1
					IF li_Row>=ids_Objects.RowCount() Then
						Exit
					END IF 
					li_Row=ids_Objects.Find("Y>"+string(ids_ReportObj.Object.Y2[li]),li_Row+1,ids_Objects.RowCount())
			   Loop 
				
				
				//更新行高   2004-11-28 
				ids_RowHeight.SetFilter("band='"+as_Band+"' AND ReportName='' ")
		      ids_RowHeight.Filter()
				ids_RowHeight.Sort()
				
				li_Row=ids_RowHeight.Find("Y>"+string(ids_ReportObj.Object.Y2[li]),1,ids_RowHeight.RowCount())
            Do While li_Row>0 
					ids_RowHeight.Object.AboveRows[li_Row]= li_Currow - ai_Currow  - ids_ReportObj.Object.StartRow[li]+1
					IF li_Row>=ids_RowHeight.RowCount() Then
						Exit
					END IF 
					li_Row=ids_RowHeight.Find("Y>"+string(ids_ReportObj.Object.Y2[li]),li_Row+1,ids_RowHeight.RowCount())
			   Loop 
				
  	    Next
	END IF 

	 li_outlines=li_Currow - ai_Currow
	 IF li_OutLines<0 Then
		  li_OutLines=0
	 END IF
	
	ids_Column.SetFilter("reportname=''")
	ids_Column.Filter()
	ids_Column.Sort()
END IF

IF IsValid(lds) Then
	Destroy lds 
END IF

IF ids_Objects.RowCount()=0 Then
	is_OldBand=as_Band
   Return li_outlines
END IF

//用于设置行高和颜色
//li_StartRow=Long(ids_Objects.Describe("Evaluate('Min(StartRow)',0)"))
//li_EndRow=Long(ids_Objects.Describe("Evaluate('Max(EndRow)',0)"))


IF is_OldBand<>as_Band OR lb_NestedFlag Then 
		ids_Bands.SetFilter("band='"+as_Band+"' AND ReportName='' ")
		ids_Bands.Filter()
END IF 
	
For li=1 To ids_Bands.RowCount()
	   li_color=0
		IF ids_Bands.Object.ColorExp[li]<>"" Then 
				li_Color=Long(OF_Evaluate(ids_Bands.Object.ColorExp[li],ai_Row))
				li_Color=invo_Colors.of_get_color(li_color) 
				IF li_color<>0 then
					 li_color= invo_colors.of_get_custom_color_index(li_color) 
				END IF 
				
		  ELSE
				li_Color= ids_Bands.Object.Color[li]
		  END IF
		  
		  IF li_color<>0 AND li_color <> 65 Then
				For  lj=ids_Bands.Object.StartRow[li] To ids_Bands.Object.EndRow[li] 
					 //For lk=ids_Bands.Object.StartCol[li] TO ids_Bands.Object.EndCol[li]
						FOR lk= ii_FirstColumn TO ii_MaxCol
						  invo_cell=invo_worksheet.of_getcell(lj+ai_currow,lk)
						  invo_cell.invo_format.of_set_bg_color(li_color)
					 Next
				Next
			END IF
Next

//设置行高
IF is_OldBand<>as_Band OR lb_NestedFlag Then 
		ids_RowHeight.SetFilter("band='"+as_Band+"' AND ReportName='' ")
		ids_RowHeight.Filter()
		ids_RowHeight.Sort() 
END IF
	
For li=1 To ids_RowHeight.RowCount()
	 IF ids_RowHeight.Object.Height[li]>0 Then
		 invo_worksheet.of_Set_Row_Height(ai_Currow+ids_RowHeight.Object.Row[li] + ids_RowHeight.Object.AboveRows[li]  -1 ,double(ids_RowHeight.Object.Height[li])  ) 
	 END IF
Next



//在输出单元数据之前,先输出表格线,目的是能够取得单元的完整的单元格式, 以提高报表的导出速度
IF IsValid(ids_Line) Then
	   IF is_OldBand<>as_Band OR lb_NestedFlag Then 
			ids_Line.SetFilter("band='"+as_Band+"' AND ReportName='' ")	
			ids_Line.Filter()
		END IF 
         
			For li=1 To ids_Line.RowCount()
				 For lj=ids_Line.Object.StartCol[li] To ids_Line.Object.EndCol[li] 
						li_Count=ids_Line.Object.EndRow[li] 
				 	    For lk=ids_Line.Object.StartRow[li] To li_Count		//ids_Line.Object.EndRow[li]
							 IF lk>0 AND lj>0 Then
									 IF ids_Line.Object.LineType[li]='h' Then
										
										   invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj) 
											IF lk=1   Then
													  //判断线是在对象下面,还是在对象上面
													  li_Row=ids_Objects.Find("Y2<="+String(ids_Line.Object.Y1[li] +ii_RowSpace),1,ids_Objects.RowCount())
													  IF li_Row>0 Then		  
																 invo_cell.invo_format.ii_bottom= ids_Line.Object.PenWidth[li] 
																 invo_cell.invo_format.ii_bottom_color = ids_Line.Object.pencolor[li]
														ELSE
																invo_cell.invo_format.ii_top= ids_Line.Object.PenWidth[li] 
																invo_cell.invo_format.ii_top_color = ids_Line.Object.pencolor[li]
														END IF
											ELSE
												 invo_cell.invo_format.ii_bottom= ids_Line.Object.PenWidth[li] 
												 invo_cell.invo_format.ii_bottom_color = ids_Line.Object.pencolor[li]
											END IF
										
								   ELSE
										  IF lj= ii_MaxCol AND lj>1 Then
											  invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj -1) 
											  invo_cell.invo_format.ii_Right= ids_Line.Object.PenWidth[li] 
										     invo_cell.invo_format.ii_Right_color = ids_Line.Object.pencolor[li] 
											  
											  //如果有边线,则设置对象自动换行
											  //invo_Cell.invo_Format.ii_Text_Wrap=1
											  
										ELSE
											  	invo_cell=invo_worksheet.of_getcell(lk+ai_currow,lj ) 
											  invo_cell.invo_format.ii_Left= ids_Line.Object.PenWidth[li] 
										     invo_cell.invo_format.ii_Left_color = ids_Line.Object.pencolor[li] 
											  
											   //如果有边线,则设置对象自动换行
											   //invo_WorkSheet.OF_PriorCell_WrapText(lk+ai_currow,lj) 
											  
										END IF

							      END IF 
							 END IF
					 Next
				Next
			Next
END IF





li_EndRow=0
li_Count=ids_Objects.RowCount()
FOR li=1 To li_Count   //{a}
	
	   IF (ids_Objects.Object.RowInDetail[li]+ai_Row -1) >idw_Requestor.RowCount() Then
			  Continue
		END IF
		
		
	   ls_Name=ids_Objects.Object.Name[li]
		ls_Type=ids_Objects.Object.Stype[li]
		ls_ColType= ids_Objects.Object.Coltype[li]
	   li_StartRow=ids_Objects.Object.StartRow[li]+ids_Objects.Object.AboveRows[li] 
		li_StartCol=ids_Objects.Object.StartCol[li]
		li_EndRow=ids_Objects.Object.EndRow[li]+ids_Objects.Object.AboveRows[li] 
		li_EndCol=ids_Objects.Object.EndCol[li]
      ls_Value=""
		lb_overlap=False
		
		IF ids_Objects.Object.VisibleExp[li]<>"" Then
			 ls_Visible=OF_Evaluate(ids_Objects.Object.VisibleExp[li],ai_Row )
		ELSE
			 ls_Visible = ids_Objects.Object.Visible[li]
		END IF 
			
		
		IF li_StartRow<=0  OR li_StartCol<=0   OR li_StartCol>256 Then Continue   //行列没定义不输出 ,如果列大于256,也不输出,因为F1最多只支持256列
	     
		// 需要检查参数,避免超出F1的范围
		  
	   li_CurRow=li_StartRow+ai_CurRow
		
		//输出多少行数据
		IF li_EndRow >li_outlines THEN
			li_outlines=li_EndRow
		END IF
		
		IF ii_BorderBeginRow<=0 Then
				  IF as_Band="header" AND Right(ls_Name,2)="_t"  Then
					  ii_BorderBeginRow=li_CurRow
				  END IF
		 END IF
		 IF as_Band="detail" AND ii_DetailRow<=0  Then
			   ii_DetailRow=li_CurRow
		 END IF
		  
		  IF ls_Name=is_BorderBeginObj Then
				ii_BorderBeginRow=li_CurRow 
		  END IF
			
		  IF ls_Name=is_BorderEndObj Then
				ii_BorderEndRow=li_CurRow 
		   END IF
		 
		   //如果对象前一单元有内容,则设置前一单元自动换行
			//invo_worksheet.OF_PriorCell_wrapText(li_CurRow,li_StartCol)   //2004-11-05 
		   invo_cell=invo_worksheet.of_getcell(li_CurRow,li_StartCol) //,invo_pre_cell
			
			IF ids_Objects.Object.isBorderOnly[li]='1' Then 
				IF li_StartRow<>li_EndRow OR li_StartCol<>li_EndCol  Then  //合并单元
						 For lj=li_StartRow To   li_EndRow
								  For lk = li_StartCol To  li_EndCol
												IF lj<>li_StartRow AND lj<>li_EndRow AND lk<>li_StartCol AND lk<>li_EndCol Then
													Continue
												END IF
												
												invo_cell=invo_worksheet.of_getcell(lj+ai_CurRow,lk)
												IF lj=li_StartRow Then 
													invo_cell.invo_format.ii_top=1
												END IF
												
												IF lj=li_EndRow Then 
													invo_cell.invo_format.ii_bottom=1
												END IF	
												
												IF lk=li_StartCol Then 
													invo_cell.invo_format.ii_left=1
												END IF
												
												IF lk=li_EndCol Then 
													invo_cell.invo_format.ii_right=1
												END IF	
										
								  Next
						 Next
				ELSE
					 invo_cell.invo_format.ii_left=1
				    invo_cell.invo_format.ii_right=1
				    invo_cell.invo_format.ii_top=1
				    invo_cell.invo_format.ii_bottom=1
			   END IF
				  
				Continue
			END IF
			
			
			IF ids_objects.object.border[li]='2' then
				  invo_cell.invo_format.ii_left=1
				  invo_cell.invo_format.ii_right=1
				  invo_cell.invo_format.ii_top=1
				  invo_cell.invo_format.ii_bottom=1
				  
			 ELSEIF  ids_objects.object.border[li]='4' then
				  invo_cell.invo_format.ii_bottom=1
			 END IF
			
			//对象是否自动换行  2004-11-11 	
		   invo_cell.invo_format.ii_text_wrap=ids_Objects.Object.WrapText[li]

			//判断是否有多个对象重复输出到同一单元
			IF invo_Cell.is_Value<>"" OR ids_Objects.Object.MergeFlag[li]='1'Then
				 lb_overlap=True
			END IF
			
			 IF ids_Objects.Object.FormatExp[li]="" Then	
					invo_cell.invo_format.is_num_format = ids_Objects.Object.Format[li] 
			 ELSE
				   invo_cell.invo_format.is_num_format = OF_Evaluate(ids_Objects.Object.FormatExp[li],ai_Row)
			 END IF
			 
			 
			
			
			IF  ls_Type="compute" OR ls_Type="column"  Then   
				
							//IF ids_Objects.Object.RowInDetail[li]>0 Then 
								 ls_value=Of_GetData(ai_row+ids_Objects.Object.RowInDetail[li] -1 ,ls_Name,ls_ColType,invo_cell.invo_format.is_num_format, ids_objects.object.displayvalue[li],ids_objects.object.ColumnFlag[li], lb_overlap)
							//ELSE
							//	 ls_value=Of_GetData(ai_row,ls_Name,ls_ColType,invo_cell.invo_format.is_num_format, ids_objects.object.displayvalue[li],lb_overlap)
							//END IF
							
							IF ib_SparseFlag AND as_Band="detail"  Then
								
									 lj=ids_Column.Find("name='"+ls_Name+"'",1,ids_Column.RowCount())
									 IF lj>0 Then
											 IF ids_Column.Object.Sparse[lj]="1" Then
													
													  IF ai_row=1 Then
																  ids_Column.Object.BeginRow[lj]=li_currow
																  ids_Column.Object.PriorValue[lj]=ls_Value
															ELSE
																
																 IF ids_Column.Object.BeginRow[lj]>=li_CurRow  AND ai_Row<idw_Requestor.RowCount() Then
																	 ids_Column.Object.PriorValue[lj]=ls_Value
																 ELSE
																			IF ls_Value= ids_Column.Object.PriorValue[lj]  AND ai_Row<idw_Requestor.RowCount() Then
																				Continue
																			 ELSE
																				  IF ai_Row=idw_Requestor.RowCount() AND ls_Value= ids_Column.Object.PriorValue[lj]  Then
																							lk=li_currow+li_EndRow -1
																					 ELSE
																							 For lk=ids_Column.Object.BeginRow[lj]+1 To  ai_Currow
																								
																								  lnv_cell1= invo_WorkSheet.OF_GetCell(lk,li_StartCol)
																								  lnv_Cell2= invo_WorkSheet.OF_GetCell(ids_Column.Object.BeginRow[lj]+1,li_StartCol)
																								  //IF xlApp.TextRC[lk,li_StartCol]<>xlApp.TextRC[ids_Column.Object.BeginRow[lj]+1,li_StartCol] Then
																								  IF lnv_Cell1.is_Value<>lnv_Cell2.is_Value Then  
																										Exit
																								  END IF
																							Next
																							
																							lk=lk -1
																					 END IF
																						
																							 
																						IF lk>ids_Column.Object.BeginRow[lj] Then
																							 
																										li_Row=ids_MergeCells.InsertRow(0)
																										ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[lj]
																										ids_MergeCells.Object.StartCol[li_Row]=li_StartCol
																										ids_MergeCells.Object.EndRow[li_Row]=lk 
																										ids_MergeCells.Object.EndCol[li_Row]=li_EndCol
																						END IF
																						
																						
																						
																						IF  ai_Row<idw_Requestor.RowCount()  Then
																								 ids_Column.Object.BeginRow[lj]=li_CurRow
																								 ids_Column.Object.PriorValue[lj]=ls_Value
																								 
																									// 处理后面的列
																									For lj=1 To ids_Column.RowCount()
																										  IF ids_Column.Object.StartCol[lj]>li_StartCol AND ids_Column.Object.Sparse[lj]="1"  Then
																												IF lk>ids_Column.Object.BeginRow[lj] Then
																													 li_Row=ids_MergeCells.InsertRow(0)
																													 ids_MergeCells.Object.StartRow[li_Row]=ids_Column.Object.BeginRow[lj]
																													 ids_MergeCells.Object.StartCol[li_Row]=ids_Column.Object.StartCol[lj]
																													 ids_MergeCells.Object.EndRow[li_Row]=lk 
																													 ids_MergeCells.Object.EndCol[li_Row]=ids_Column.Object.EndCol[lj]
																												 END IF
																												
																												 //由于排序方式一样
																												 ids_Column.Object.BeginRow[lj]=lk+1
																												 ids_Column.Object.PriorValue[lj]=ls_Value
																												  
																												 
																										  END IF
																									Next
																						 ELSE
																							
																							 //如果最后一行是被合并的，则不输出
																							 IF lk>=li_CurRow Then
																								  Continue
																							 END IF
																							
																						 END IF
																				END IF
																	 END IF
														 END IF
											  END IF
									  END IF
								END IF
		   ELSE
					IF ls_Visible="1" Then
						    
							 ls_Value= idw_Requestor.Describe(ls_Name+".text")
							 IF Left(ls_Value,1)='"' OR Left(ls_Value,1)="'" Then
								 ls_Value =Mid(ls_Value,2, Len(ls_Value) -2)
							  END IF
							
							 lj=Pos(ls_Value,"~t")
							  //PB新版本支持Text对象的Text是一个表达式  2004-10-29
							 IF lj>0 Then
							      ls_Value=OF_Evaluate(Mid(ls_Value,lj+1),ai_Row) 
							 END IF
					
					  END IF
			END IF                                                            //{b}
		
		 

		 IF li_StartRow<>li_EndRow OR li_StartCol<>li_EndCol  Then  //合并单元
		      invo_cell.EndRow= li_EndRow+ai_CurRow
				invo_cell.EndCol= li_EndCol
				IF li_StartRow<>li_EndRow Then
				 	  invo_cell.invo_format.ii_text_wrap=1  
				 END IF
				 
				 invo_worksheet.of_mergecells(li_CurRow,li_StartCol,li_EndRow+ai_CurRow,li_EndCol)
		  END IF
		  
		
		IF  ls_Visible="1" Then 
			
			     //如果单元在细节区,而且对象与前输出行与细节区第一行时输出的单元格式相同
				  //则直接取第一次输出时的单元格式,从而可以减少单元格式判断的次数
			     lb_flag=False 
				  IF ib_GridBorder=False AND (as_Band="detail" OR Pos(as_Band,".")>0 )  AND ids_Objects.Object.ExpFlag[li]='0' Then
				       IF ids_Objects.Object.xfIndex[li]>0 Then
							 IF ids_Objects.Object.BorderKey[li] = String(invo_cell.invo_Format.ii_top,"00")+ String(invo_cell.invo_Format.ii_bottom,"00")+String(invo_cell.invo_Format.ii_left,"00")+String(invo_cell.invo_Format.ii_right,"00") Then
								  invo_Cell.ii_xf= ids_objects.Object.xfIndex[li]
								  lb_flag=True
							 END IF
						END IF
						
					END IF
					
				  IF lb_flag=False AND ( invo_cell.is_value="" OR Not lb_overlap )  Then   //如果多个对象重复输出到同一单元,则以第一次取的格式为准
							  IF ids_Objects.Object.FontSizeExp[li]="" Then
									 invo_cell.invo_format.ii_size = ids_Objects.Object.FontSize[li]
							  ELSE
									 invo_cell.invo_format.ii_size =ABS(Long(OF_Evaluate(ids_Objects.Object.FontSizeExp[li],ai_Row)))
							  END IF
							
							  IF ids_Objects.Object.FontNameExp[li]="" Then
									invo_cell.invo_format.is_font = ids_Objects.Object.FontName[li]
							  ELSE
									invo_cell.invo_format.is_font = OF_Evaluate(ids_Objects.Object.FontNameExp[li],ai_Row)
							  END IF 
								
								IF ids_Objects.Object.fontweightexp[li]="" Then
									 invo_cell.invo_format.ii_bold = ids_Objects.Object.Fontweight[li]
								ELSE
									 invo_cell.invo_format.ii_bold =Long(OF_Evaluate(ids_Objects.Object.fontweightexp[li],ai_Row))
								END IF
								
							 IF ids_Objects.Object.Fontitalicexp[li]="" Then	
									invo_cell.invo_format.ii_italic = Long(ids_Objects.Object.Fontitalic[li]) 
							  ELSE
									invo_cell.invo_format.ii_italic = Long(OF_Evaluate(ids_Objects.Object.Fontitalicexp[li],ai_Row))
							  END IF
								
								IF ids_Objects.Object.Alignmentexp[li]="" Then	
										 invo_cell.invo_format.ii_text_h_align=ids_Objects.Object.Alignment[li]
								 ELSE
											Choose Case OF_Evaluate(ids_Objects.Object.Alignmentexp[li],ai_Row)   
												 Case "1"   //右对齐
															 invo_cell.invo_format.ii_text_h_align=3
												Case "2"   //中对齐
														 invo_cell.invo_format.ii_text_h_align=2
												Case Else    //均匀对齐,调整为左对齐
														 invo_cell.invo_format.ii_text_h_align=1
										 END CHOOSE
								END IF
									
							  
							  IF ids_Objects.Object.FontColorexp[li]="" Then	
									invo_cell.invo_format.ii_color=ids_Objects.Object.FontColor[li]
							  ELSE
									 li_color=long(OF_Evaluate(ids_Objects.Object.FontColorexp[li],ai_Row))
									 li_color = invo_colors.of_get_color(li_color )
									 invo_cell.invo_format.ii_color= invo_colors.of_get_custom_color_index(li_color)  
							  END IF
							  
							 
								  IF ids_Objects.Object.bgColorexp[li]="" Then	
									   if ids_Objects.Object.bgColor[li]<>65 and ids_Objects.Object.bgColor[li]<>0  then  //以免破坏按带区设置了颜色的情况
												invo_cell.invo_format.of_set_bg_color(Long(ids_Objects.Object.bgColor[li]))
										end if
								  ELSE
										 li_color=long(OF_Evaluate(ids_Objects.Object.bgColorexp[li],ai_Row))
										 li_color = invo_colors.of_get_color(li_color )
										 if li_color<>0 then 
											 li_color= invo_colors.of_get_custom_color_index(li_color)
										 end if
										
										 if li_color<>65 and li_color<>0  then
											 invo_cell.invo_format.of_set_bg_color(li_color)
										 end if 
								  END IF
						 END IF
				 
						
		    
				 
				     IF ls_Value="!" or ls_Value="?" Then
						   ls_Value=""
					  END IF 
					  IF   ls_Value<>"" or ids_Objects.Object.ObjSpace[li]>0 OR  ids_Objects.Object.MergeFlag[li]="1" Then
						   IF ids_Objects.Object.ObjSpace[li]>0 Then
								ls_Value=OF_GetObjSpace(ids_Objects.Object.ObjSpace[li])+ls_Value
							ELSE
								IF ids_Objects.Object.MergeFlag[li]="1" Then
									ls_Value=ls_Value+Mid(OF_GetObjSpace(ids_Objects.Object.Width[li]),Len(ls_Value)+1)
								END IF
							END IF
		     		   END IF
					
					
					IF lb_overlap Then
						invo_Cell.is_CellType='S'
						invo_Cell.invo_format.is_num_format="General"  //设为常规
					ELSE
						
						   //如果列输出的是显示值,则设置为常规,否则可能会导出输出错误   2004 -11 -11
							
						   IF ids_Objects.Object.DisplayValue[li]='1' Then 
								invo_Cell.is_CellType='S'
							ELSE
								 invo_Cell.is_CellType=ls_ColType
							END IF

								 
				   END IF
					invo_cell.is_value+=ls_value
					
					
					//同一列的同一对象,格式可能是一样的,避免重复注册单元格式,提高处理速度
				 IF ib_GridBorder=False AND (as_Band="detail" OR Pos(as_Band,".")>0 )  AND ids_Objects.Object.ExpFlag[li]='0' Then
					  IF ids_Objects.Object.xfIndex[li]=0 Then
							invo_cell.ii_xf =invo_cell.invo_WorkSheet.invo_WorkBook.OF_Reg_Format(invo_cell.invo_Format) +14
							ids_objects.Object.xfIndex[li] = invo_cell.ii_xf
						  ids_Objects.Object.BorderKey[li] = String(invo_cell.invo_Format.ii_top,"00")+ String(invo_cell.invo_Format.ii_bottom,"00")+String(invo_cell.invo_Format.ii_left,"00")+String(invo_cell.invo_Format.ii_right,"00")
	
						END IF
				  
				  END IF 
		
		END IF
Next    



is_OldBand=as_Band
Return li_outlines

end function

protected function long of_parsetoarray (string as_source, string as_delimiter, ref string as_array[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ParseToArray
//
//	Access:  public
//
//	Arguments:
//	as_Source   The string to parse.
//	as_Delimiter   The delimeter string.
//	as_Array[]   The array to be filled with the parsed strings, passed by reference.
//
//	Returns:  long
//	The number of elements in the array.
//	If as_Source or as_Delimeter is NULL, function returns NULL.
//
//	Description:  Parse a string into array elements using a delimeter string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.02   Fixed problem when delimiter is last character of string.

//	   Ref array and return code gave incorrect results.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright ?1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long		ll_DelLen, ll_Pos, ll_Count, ll_Start, ll_Length
string 	ls_holder

//Check for NULL
IF IsNull(as_source) or IsNull(as_delimiter) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If


//Check for at leat one entry
If Trim (as_source) = '' Then
	Return 0
End If

//Get the length of the delimeter
ll_DelLen = Len(as_Delimiter)

ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter))

//Only one entry was found
if ll_Pos = 0 then
	as_Array[1] = as_source
	return 1
end if

//More than one entry was found - loop to get all of them
ll_Count = 0
ll_Start = 1
Do While ll_Pos > 0
	
	//Set current entry
	ll_Length = ll_Pos - ll_Start
	ls_holder = Mid (as_source, ll_start, ll_length)

	// Update array and counter
	ll_Count ++
	as_Array[ll_Count] = ls_holder
	
	//Set the new starting position
	ll_Start = ll_Pos + ll_DelLen

	ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter), ll_Start)
Loop

//Set last entry
ls_holder = Mid (as_source, ll_start, Len (as_source))

// Update array and counter if necessary
if Len (ls_holder) > 0 then
	ll_count++
	as_Array[ll_Count] = ls_holder
end if

//Return the number of entries found
Return ll_Count

end function

public subroutine of_setgroupoutflag (boolean as_flag);ib_GroupOutFlag=as_Flag
end subroutine

protected function string of_getdata (readonly long ai_row, readonly string as_objectname, readonly string as_coltype, string as_format, string as_displayvalue, string as_columnflag, boolean ab_overlap);String ls_Ret 

//如果同一单元没有多个对象输出
IF as_displayvalue="1" OR  ab_overlap=False  Then
	as_Format=""
END IF 

IF ai_Row<=0 Then
	ls_ret=idw_Requestor.Describe("Evaluate('"+as_objectname+"',0)")
	IF ls_ret="!" OR  ls_Ret="?" Then
   	ls_ret =""
	END IF 
	 
	
	 IF as_Format<>"" Then
			 IF as_colType="DT" Then
				  // ls_ret=String(DateTime(Blob(ls_ret)),as_format)   //在PB6版本不能正常计算
					Int li_Pos
					Time lt_Time
					li_Pos=Pos(ls_ret," ") 
				   IF li_Pos>0 Then
					    lt_Time=Time(Mid(ls_ret ,li_Pos+1))
					    ls_ret = Left(ls_ret  ,li_Pos -1) 
				   ELSE
					   lt_Time=Time("00:00:00")
				   END IF
				
				  IF Not IsDate(ls_ret) Then
					   ls_ret="1900-01-01"
				  END IF
					
				  ls_Ret=String(DateTime(Date(ls_Ret),lt_Time),as_Format) 
				
			 ELSEIF as_colType="D" Then 
				   ls_ret=String(Date(ls_ret),as_format)
			 END IF
	 END IF
		
	 
	 Return ls_Ret 
END IF

IF as_displayvalue='1'  AND as_ColumnFlag='1' Then    
	ls_ret= idw_Requestor.Describe("Evaluate('LookUpDisplay("+as_objectname+") ', "	+string(ai_row)+ ")")

	IF ls_ret<>"!" AND ls_Ret<>"?" Then
   	Return ls_ret
	END IF
END IF

Choose Case as_colType
	Case "S"	    
		    ls_ret=idw_Requestor.GetItemString(ai_row,as_objectname)
	Case "N"
		    ls_ret=String(idw_Requestor.GetItemNumber(ai_row,as_objectname))
		    
	Case "DT"
			 ls_ret= String(idw_Requestor.GetItemDateTime(ai_row,as_objectname),as_format)
	CASE "D"
		   ls_ret=String(idw_Requestor.GetItemDate(ai_row,as_objectname),as_format)
	Case "T"
	     ls_ret=String(idw_Requestor.GetItemTime(ai_row,as_objectname),as_format)
END CHOOSE

IF IsNull(ls_ret) OR Trim(ls_ret)="" OR ls_Ret="!" OR ls_Ret="?" Then
	ls_ret=  ""
END IF
IF as_displayvalue='1' AND as_ColumnFlag='0' AND ls_Ret<>"" Then
   String ls_Values
	String ls_ColType 
	String ls_DataColumn
	Long    li ,lj 
	DataWindowChild  dwc
	

   
	IF idw_Requestor.Describe(as_objectname+".Edit.Style")="dddw" Then
				idw_Requestor.GetChild(as_objectname,dwc)
				IF isValid(dwc) Then
					 ls_DataColumn=idw_Requestor.Describe(as_objectname+".DDDW.DataColumn")
					 ls_ColType = dwc.Describe(ls_DataColumn+".ColType") 
					 Choose Case Left(ls_ColType,4)
									Case "char",'date'
										  li=dwc.Find(ls_DataColumn+"='"+ls_ret+"'",1,dwc.RowCount())
									Case Else
										  li=dwc.Find(ls_DataColumn+"="+ls_ret,1,dwc.RowCount())
					 END CHOOSE
					 
					  IF li>0 Then 
							 ls_ret=dwc.Describe("Evaluate('"+idw_Requestor.Describe(as_objectname+".DDDW.DisplayColumn")+"',"+String(li)+" )")
						END IF
					
				END IF
	 ELSE
		   ls_Values = idw_Requestor.Describe(as_objectname+".Values")
			li= Pos( ls_Values, "~t"+ls_Ret)
			IF li>0 Then 
				 lj = of_LastPos( Left(ls_Values ,li) ,"/")
				 ls_Ret = Mid ( ls_Values ,lj+1 , li - lj -1)
			END IF 
		
	END IF
	
	IF IsNull(ls_ret) OR Trim(ls_ret)="" OR ls_Ret="!" OR ls_Ret="?" Then
  		 ls_ret=  ""
	END IF

END IF


Return ls_ret
end function

protected function string of_getdata (datastore a_ds, long ai_row, string as_objectname, string as_coltype, string as_format, string as_displayvalue, string as_columnflag, boolean ab_overlap);String ls_Ret 

//如果同一单元没有多个对象输出
IF as_displayvalue="1" OR  ab_overlap=False  Then
	as_Format=""
END IF 

IF ai_Row<=0 Then
	ls_ret=a_ds.Describe("Evaluate('"+as_objectname+"',0)")
	IF ls_ret="!" OR  ls_Ret="?" Then
   	ls_ret =""
	END IF 
	
	IF as_Format<>"" Then
			 IF as_colType="DT" Then
				  // ls_ret=String(DateTime(Blob(ls_ret)),as_format)   //在PB6版本不能正常计算
					Int li_Pos
					Time lt_Time
					li_Pos=Pos(ls_ret," ") 
				   IF li_Pos>0 Then
					    lt_Time=Time(Mid(ls_ret ,li_Pos+1))
					    ls_ret = Left(ls_ret  ,li_Pos -1) 
				   ELSE
					   lt_Time=Time("00:00:00")
				   END IF
				
				  IF Not IsDate(ls_ret) Then
					   ls_ret="1900-01-01"
				  END IF
					
				  ls_Ret=String(DateTime(Date(ls_Ret),lt_Time),as_Format) 
				
			 ELSEIF as_colType="D" Then 
				   ls_ret=String(Date(ls_ret),as_format)
			 END IF
	 END IF
	 
	 Return ls_Ret
END IF

IF as_displayvalue='1'  AND as_ColumnFlag='1' Then    
	ls_ret= a_ds.Describe("Evaluate('LookUpDisplay("+as_objectname+") ', "	+string(ai_row)+ ")")

	IF ls_ret<>"!" AND ls_Ret<>"?" Then
   	Return ls_ret
	END IF
END IF

Choose Case as_colType
	Case "S"	    
		    ls_ret=a_ds.GetItemString(ai_row,as_objectname)
	Case "N"
		    ls_ret=String(a_ds.GetItemNumber(ai_row,as_objectname))
		    
	Case "DT"
			 ls_ret= String(a_ds.GetItemDateTime(ai_row,as_objectname),as_format)
	CASE "D"
		   ls_ret=String(a_ds.GetItemDate(ai_row,as_objectname),as_format)
	Case "T"
	     ls_ret=String(a_ds.GetItemTime(ai_row,as_objectname),as_format)
END CHOOSE

IF IsNull(ls_ret) OR Trim(ls_ret)="" OR ls_Ret="!" OR ls_Ret="?" Then
	ls_ret=  ""
END IF
IF as_displayvalue='1' AND as_ColumnFlag='0' AND ls_Ret<>"" Then
   String ls_Values
	String ls_ColType 
	String ls_DataColumn
	Long    li ,lj 
	DataWindowChild  dwc
	

   
	IF a_ds.Describe(as_objectname+".Edit.Style")="dddw" Then
				a_ds.GetChild(as_objectname,dwc)
				IF isValid(dwc) Then
					 ls_DataColumn=a_ds.Describe(as_objectname+".DDDW.DataColumn")
					 ls_ColType = dwc.Describe(ls_DataColumn+".ColType") 
					 Choose Case Left(ls_ColType,4)
									Case "char",'date'
										  li=dwc.Find(ls_DataColumn+"='"+ls_ret+"'",1,dwc.RowCount())
									Case Else
										  li=dwc.Find(ls_DataColumn+"="+ls_ret,1,dwc.RowCount())
					 END CHOOSE
					 
					  IF li>0 Then 
							 ls_ret=dwc.Describe("Evaluate('"+a_ds.Describe(as_objectname+".DDDW.DisplayColumn")+"',"+String(li)+" )")
						END IF
					
				END IF
	 ELSE
		   ls_Values = a_ds.Describe(as_objectname+".Values")
			li= Pos( ls_Values, "~t"+ls_Ret)
			IF li>0 Then 
				 lj = of_LastPos( Left(ls_Values ,li) ,"/")
				 ls_Ret = Mid ( ls_Values ,lj+1 , li - lj -1)
			END IF 
		
	END IF
	
	IF IsNull(ls_ret) OR Trim(ls_ret)="" OR ls_Ret="!" OR ls_Ret="?" Then
  		 ls_ret=  ""
	END IF

END IF


Return ls_ret
end function

public function long of_lastpos (string as_source, string as_target);//不直接使用LastPos,是因为PB6.5版本不支持LastPos函数
Return of_LastPos (as_source, as_target, Len(as_Source))

end function

public function long of_lastpos (string as_source, string as_target, long al_start);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_LastPos	
//
//	Access:  		public
//
//	Arguments:
//	as_Source		The string being searched.
//	as_Target		The being searched for.
//	al_start			The starting position, 0 means start at the end.
//
//	Returns:  		Long	
//						The position of as_Target.
//						If as_Target is not found, function returns a 0.
//						If any argument's value is NULL, function returns NULL.
//
//	Description: 	Search backwards through a string to find the last occurrence 
//						of another string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright ?1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Long	ll_Cnt, ll_Pos

//Check for Null Parameters.
IF IsNull(as_source) or IsNull(as_target) or IsNull(al_start) Then
	SetNull(ll_Cnt)
	Return ll_Cnt
End If

//Check for an empty string
If Len(as_Source) = 0 Then
	Return 0
End If

// Check for the starting position, 0 means start at the end.
If al_start=0 Then  
	al_start=Len(as_Source)
End If

//Perform find
For ll_Cnt = al_start to 1 Step -1
	ll_Pos = Pos(as_Source, as_Target, ll_Cnt)
	If ll_Pos = ll_Cnt Then 
		//String was found
		Return ll_Cnt
	End If
Next

//String was not found
Return 0

end function

public function integer of_iswraptext (string as_fontname, integer ai_fontsize, integer ai_fontweight, integer ai_height);
Integer		li 
Integer		li_WM_GETFONT = 49 	//  hex 0x0031
ULong			lul_Hdc, lul_Handle, lul_hFont
os_size 		lstr_Size


For li = 1 To UpperBound( istr_FontList)
	IF istr_FontList[li].FontName= as_fontname AND istr_FontList[li].FontSize = ai_FontSize  AND istr_FontList[li].FontWeight=ai_fontweight Then
		 
		 IF (ai_Height / istr_FontList[li].FontHeight)>=2 Then
			  Return 1
		 ELSE
			  Return 0
		  END IF
	END IF 
Next 

if IsNull(iw_Parent) Or Not IsValid (iw_Parent) then
	OF_OpenUserObject()
end if

IF IsNull(iuo_Text) OR Not IsValid(iuo_Text) Then
	OF_OpenUserObject()
END IF



iuo_Text.FaceName = as_FontName
iuo_Text.TextSize = ai_FontSize
iuo_Text.Weight = ai_fontweight

// Get the handle of the StaticText Object and create a Device Context
lul_Handle = Handle(iuo_Text)
lul_Hdc = GetDC(lul_Handle)

// Get the font in use on the Static Textd
lul_hFont = Send(lul_Handle, li_WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lul_Hdc, lul_hFont)

// Get the size of the text.
gettextextentpoint32W(lul_Hdc, ' ', 1, lstr_Size )
ReleaseDC(lul_Handle, lul_Hdc)


IF lstr_size.l_cy >0 Then 
	   li= UpperBound( istr_FontList) +1
		istr_FontList[li].FontName= as_fontname 
		istr_FontList[li].FontSize = ai_FontSize  
		istr_FontList[li].FontWeight=ai_fontweight 
		istr_FontList[li].FontHeight = PixelsToUnits(lstr_size.l_cy,YPixelsToUnits!) 
	
	    IF (ai_Height / istr_FontList[li].FontHeight)>=2 Then
			  Return 1
		 ELSE
			  Return 0
		 END IF
END IF
	
Return 0


	


end function

on n_cst_dw2excel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_dw2excel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

