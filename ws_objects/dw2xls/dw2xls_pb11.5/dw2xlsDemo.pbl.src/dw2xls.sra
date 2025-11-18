$PBExportHeader$dw2xls.sra
$PBExportComments$Generated Application Object
forward
global type dw2xls from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type dw2xls from application
string appname = "dw2xls"
end type
global dw2xls dw2xls

on dw2xls.create
appname="dw2xls"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on dw2xls.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;/*---------------------------------------------------------
   把数据窗口转存为Excel文件
	
	如果是Grid形式的数据窗口,转存的效果较好,对于Free形式的数据窗口,
   要求对象按输出到Excel工作表单元格的先后顺序和上下位置进行排序,对位置的要求比较严格
	
	
	
	特殊对象命名： 
	
	   列标题  ：  							 列名称+_t      
		报表标题：  							 report_title   (可以没有,但报表标题必须单独一行)
		Grid报表的背景文本框对象：			 sys_Back       (可以没有)
		用于标识Grid报表最后一列的对象：  sys_lastcol    (可以没有)
		
		
		如果报表记录较多，输出的时间较长，所以需要在应用程序中定义一个窗口 w_Tips，用于在
		执行另存为Excel文件的过程中，显示等待信息。
		
		对象函数 ，功能和使用可参考示例：
		           OF_dw2Xls(Datawindow  adw,String as_FileName)
					  把指定的数据窗口的报表另存为Excel文件，如果导出成功能，返回1，否则返回 -1 
					  
			        OF_SetGridBorder(Boolean ab_Flag) 
					  设置报表在另存为Excel文件时,是否需要自动加上单元的边框
					  
					  
					  OF_OpenExcelFile(Boolean ab_Flag) 
					  设置在完成导出后,是否提示用户打开该Excel文件
					  
					  
					  
			
		注意:		1.  如果程序出现 NumberFormatLocal属性错误的信息,请检查数据列和计算字段Format属性的设置
		             请使用一般的格式,不要使用Formula One不支持的数据格式
					
					2.  对于交叉报表,程序在导出数据的时候,会把报表的状态改变是"静态报表",此时如果需要
					    重新从数据库检索数据,应该要重新设置数据窗口控件的 DataObject 属性,或改变数据窗口
						 的状态为动态.
						
					3.  对于Free形式的报表,一定要注意对象的位置关系,否则会出现不同的对象,往同一个报表单元
					    输出数据的情况,导致先输出的数据被覆盖,如果出现这种情况,只要调整对象的位置就可以了.
						 或者在输出到Excel之前,先通过代码调置位置,输出完成后,再调整回来就可以了.
						 
						 新版本已增加代码,避免多个对象向同一个Excel单元输出数据的情况.
		
		
		
		  新增功能：
		  
		        1. OF_MergeColumnHeader(Boolean ab_Flag,  String as_ObjName)   
						设置列标题如果跨越多行，是否自动合并单元
					
						ab_Flag     列标题是否自动合并单元，如果为False，省略 as_ObjName 的值
						as_ObjName  如果列标题的第一行没有真正的列标题对象，而是列的分类等文本对象时，需要指定列标题从那个对象开始。
				  
				  2.	OF_SetFileType(String as_FileType)
				      设置报表导出的文件类型  
						as_FileType     Excel        Excel文件
											 vts			  Formula one 的文件
											 
				  3.  OF_SetShowTips(Boolean ab_Flag) 
				      设置在报表导出的过程中，是否显示指示信息
				      如果是把报表导出为VTS的文件，然后用Formula one打开，用不需要显示提示信息 
					  
		        4.  OF_SetTipsWindow( String as_WinName,String as_OpenParm)
				      设置报表在导出的过程中，显示数据处理信息的窗口名称
						原来的程序是规定为 w_Tips， 现在允许自定义信息提示窗口
						
						as_WinName     提示窗口的名称
						as_OpenParm    向提示窗口传递的参数
						
						
						如果不指定，系统缺省提示窗口的名称为  w_Tips 
						
					
					
				  5. OF_SetBandBackColor(Boolean ab_Flag) 
				     设置是否把数据窗口各带区设置的背景颜色和非细节区对象定义的背景颜色，输出到报表文件中。
					  缺省设置是不输出。
					  
					  
					  注意： 只输出带区的背景颜色和非细节区对象的背景颜色
					  
				    
				     增加输出对象背影颜色的功能，如果生成的Excel文件或F1文件，如果对象的背影颜色不正确，
				     请更改数据窗口的定义。
					  
					   由于数据窗口支持直接选择如："Butoon Face "，"Window BackGround"等系统颜色,
						程序会自动转换为相对应的SysColor的Index 值,然后调用GetSysColor函数取得实际的颜色值，
						但有些系统颜色值对于较低版本的Windows而言,可能是无效的,如 Link,ToolTip等。如果设置为这些颜色，
						将有可能不能正确输出到F1的文件中。
						
						由于系统颜色与当前用户使用的Windows版本和Windows系统参数设置有关系，开发时显示的报表颜色与用户实际的
						情况会有不同，建议仅使用常用的系统颜色，如Button Face，而不要使用其它不常用的系统颜色类型。
						
						
						
						如果报表需要输出带区颜色，在设置带区颜色的时候，请使用常用的系统颜色类型或数值。
						
						输出的颜色有可能与数据窗口的颜色不同，目前还没有找到什么原因，可能是F1对颜色的支持有问题。
						
						
						
						
						
						
					  
					  
					6.	数据窗口没有记录，也可以输出。
					
					
					7. 可以输出Footer区的内容。
										
					
					8.  对于使用PB8的情况,如果程序需要完全编译,你需要进行以下处理:
						 
						 (1)在开发环境下,为了测试报表的输出,把dw2xls.PBD加入应用的库文件列表。
						 (2)编译时,先备份dw2xls.pbd文件,然后把库文件列表中的dw2xls.pbd
						 	 改变dw2xls.pbl，再执行编译。
						 (3)编译完成后，把原来备份的dw2xls.pbd覆盖新生成的文件。
						 (4)重新把库文件列表改为 dw2xls.pbd
						 
						 
						 
						 
						 
						 
				新增或更正功能:     2004-7-17
					
					9. 原来在处理数据窗口的Sparse属性时,采用的把数据值相同的单元进行合并,并设置
					   其垂直对齐方式来向单元的顶端对齐,现更改为不合并单元,而是采用不设置边框线的方式
						使表格的输出格式更好.
						
						程序同时更正原合并范围不正确的Bug
						
					10.增加设置表头标题打印方式的选项.
					   of_setprintheader(Integer ai_Style)
						
						参数:  ai_Style     1  每页都打印表头,但组表头只在分组的时候才打印
						                    2  每页都打印表头和组表头,功能与数据窗口直接打印的功能一样,是缺省选项.
												  	  此时输出到文件的分组表头,只输出一次,下一分组时,不输出.
														 
														 
												  0  表头只在第一页打印,组表头只在分组的时候才打印
												  
					   可以通过修改报表的打印参数设置的"打印标题行"参数,可以改变打印的标题.
						
					11. 如果分组设置分页打印,可输出的文件,可以实现分页打印功能.
					    由于表格的单元是连继的,如果不通过预览,不知道报表在那分页,可以设置以下参数,以便在分页的地方
						 显示不同的单元边框颜色.
						 
						 不过该效果不是很好,对打印有影响,即使设置报表是"单色"打印,该边框的颜色仍打印为彩色.
						 程序缺省是不设置显示特殊颜色.
						 
						 OF_SetPageBreakLine(Integer ai_BreakLine,	Long al_Color)
						 
						 参数:  ai_BreakLine  设置分页线的宽度,如果为0,则不显示分页线
						        al_Color      线条颜色
								  
				  12.  程序增加F1的打印预览功能,该功能虽然效果还不是非常理想,但总比F1本身的打印预览好点,
				       如果需要使用,你需要在 dw2xls.PBL文件中增加一个 w_f1_Preview窗口,只需要定义窗口就可以了
						 不需要写代码,目的是让程序能顺序编译.
						 
				       调用方式:  Open(w_F1_Preview,  Ole_1.Object)   
						            其中,Ole_1是F1 对象的名称,
										
										程序没在Win98/Win95下测试,不知道是否有问题,如果有,请反馈.
										
						
							 
						 
						 
				新增或更正功能:   2004-7-20 
				
				   14、完全重写了数据导出功能,支持组合数据窗口,嵌套类型的数据窗口，对FreeForm格式的数据窗口，转出的格
					    式也比前一版本要好一些。由于增加很多代码，所以导出的速度比原来的版本要慢一些。
						
					15、增加设置边框的起止对象的功能。以便更好的输出边框线
					    OF_SetGridBorder(Boolean  ab_Flag ,String as_BeginObj,String as_EndObj) 
						 
					16、增加设置在转出为F1文件时，是否自动设置F1文件 MaxRow属性。
					     OF_SetMaxRow(Boolean  ab_Flag)
					
				   17、对于嵌套类型(Nested)的数据窗口，Report对象的名称只支持 dw_1到dw_5,不支持其它名字。
					    因为嵌套类型的数据窗口，其Report对象不能通过GetChild来获得它的引用，所以只能
						 通过名称直接读取。
					
					18、更正原来版本对象的Visible属性是一个表达式，不能正常处理是否输出的问题。
						 更正原来版本不能完全输出对象的问题。
						
			      19、组件主要还是针对表格式报表为主的，如果你需要转出其它格式的报表，导出效果不理想时，
					    可尝试更换一些参数，这些参数对报表导出是有影响的，或者调整一个数据窗口的定义，
						 重点是细节区对象。 
						 
						 重点提示：程序是通过对比细节区的对象的 X 值，以判断对象从那一列开始，到那一列结束。
						           同一带区的对象，通过比较 Y值，判断对象在该带区的那一行开始，到那一行结束。
									  
						           
					
					20、组件发布到今天，不少朋友提出好的意见，并及时把程序存在的Bug反馈给我，在此，对他们表达感谢。
						 他们的支持和鼓励，是我不断完善这个组件的动力。
					
					
						
	         如果有什么意见或建议,可跟我联系    HuangGuoChou@163.Net 
		----------------------------------------------------------------------------------------------*/

//PB8例程自带的数据库
// Profile EAS Demo DB V4
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = False
SQLCA.DBParm = "ConnectString='DSN=EAS Demo DB V9;UID=dba;PWD=sql'"
Connect ;
IF SQLCA.SQLCODE<>0 Then
	 MessageBox("提示","连接数据库失败!!")
	 Return
END IF


open(w_main) 
end event

