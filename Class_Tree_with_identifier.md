```mermaid
classDiagram
direction RL
TTimedDialog<..TDialog
TTimedDialog:Secs longint
TTimedDialog:TRect()
TTimedDialog:TStream)()
TTimedDialog:TEvent)()
TTimedDialog:TStream)()
TTimedDialog:Secs0 longint
TTimedDialog:Secs2 longint
TTimedDialog:DayWrap boolean
TTimedDialog:end 
TTimedDialogText<..TStaticText
TTimedDialogText:TRect)()
TTimedDialogText:Sw_String)()
TTimedDialogText:end 
TInputLong<..TInputLine
TInputLong:ILOptions Word
TInputLong:LLim,ULim LongInt
TInputLong:TRect()
TInputLong:LowerLim,UpperLim LongInt
TInputLong:TStream)()
TInputLong:TStream)()
TInputLong:Sw_Word()
TInputLong:virtual()
TInputLong:virtual()
TInputLong:Boolean()
TInputLong:virtual()
TInputLong:TEvent)()
TInputLong:Word)()
TInputLong:end 
TInputLine<..TView
TInputLine:MaxLen Sw_Integer
TInputLine:CurPos Sw_Integer
TInputLine:FirstPos Sw_Integer
TInputLine:SelStart Sw_Integer
TInputLine:SelEnd Sw_Integer
TInputLine:Data Sw_PString
TInputLine:Validator PValidator
TInputLine:TRect()
TInputLine:TStream)()
TInputLine:Virtual()
TInputLine:Sw_Word()
TInputLine:PPalette()
TInputLine:Word)()
TInputLine:Virtual()
TInputLine:Virtual()
TInputLine:Boolean)()
TInputLine:PValidator)()
TInputLine:Word()
TInputLine:Virtual()
TInputLine:Virtual()
TInputLine:TStream)()
TInputLine:TEvent)()
TInputLine:Sw_Integer)()
TInputLine:Sw_Integer()
TInputLine:END 
TButton<..TView
TButton:AmDefault Boolean
TButton:Flags Byte
TButton:Command Word
TButton:Title Sw_PString
TButton:TRect()
TButton:AFlags Word)
TButton:TStream)()
TButton:Virtual()
TButton:PPalette()
TButton:Virtual()
TButton:Virtual()
TButton:Boolean)()
TButton:Boolean)()
TButton:Word()
TButton:TStream)()
TButton:TEvent)()
TButton:DownFlag Boolean
TButton:END 
TCluster<..TView
TCluster:Id Sw_Integer
TCluster:Sel Sw_Integer
TCluster:Value LongInt
TCluster:EnableMask LongInt
TCluster:Strings TUnicodeStringCollection
TCluster:Strings TStringCollection
TCluster:TRect()
TCluster:TStream)()
TCluster:Virtual()
TCluster:Sw_Word()
TCluster:Word()
TCluster:PPalette()
TCluster:Sw_Integer)()
TCluster:Sw_Integer)()
TCluster:Sw_Integer)()
TCluster:Virtual()
TCluster:Sw_Integer)()
TCluster:Sw_Integer)()
TCluster:Word()
TCluster:Sw_String)()
TCluster:String()
TCluster:Longint()
TCluster:Virtual()
TCluster:Virtual()
TCluster:TStream)()
TCluster:TEvent)()
TCluster:TPoint)()
TCluster:Sw_Integer)()
TCluster:Sw_Integer)()
TCluster:END 
TRadioButtons<..TCluster
TRadioButtons:Sw_Integer)()
TRadioButtons:Virtual()
TRadioButtons:Sw_Integer)()
TRadioButtons:Sw_Integer)()
TRadioButtons:Virtual()
TRadioButtons:END 
TCheckBoxes<..TCluster
TCheckBoxes:Sw_Integer)()
TCheckBoxes:Virtual()
TCheckBoxes:Sw_Integer)()
TCheckBoxes:END 
TMultiCheckBoxes<..TCluster
TMultiCheckBoxes:SelRange Byte
TMultiCheckBoxes:Flags Word
TMultiCheckBoxes:States Sw_PString
TMultiCheckBoxes:TRect()
TMultiCheckBoxes:ASelRange Byte
TMultiCheckBoxes:TStream)()
TMultiCheckBoxes:Virtual()
TMultiCheckBoxes:Sw_Word()
TMultiCheckBoxes:Sw_Integer)()
TMultiCheckBoxes:Virtual()
TMultiCheckBoxes:Sw_Integer)()
TMultiCheckBoxes:Virtual()
TMultiCheckBoxes:Virtual()
TMultiCheckBoxes:TStream)()
TMultiCheckBoxes:END 
TListBox<..TListViewer
TListBox:List PCollection
TListBox:TRect()
TListBox:AScrollBar PScrollBar)
TListBox:TStream)()
TListBox:Sw_Word()
TListBox:Sw_Integer()
TListBox:PCollection)()
TListBox:Virtual()
TListBox:Virtual()
TListBox:TStream)()
TListBox:virtual()
TListBox:Sw_Integer)()
TListBox:virtual()
TListBox:virtual()
TListBox:Sw_Integer)()
TListBox:Pointer()
TListBox:itemfromthelistbox.Itishoweverslightlyslowerthan }
TListBox:Item =ListBox^.List^.At(ListBox^.Focused)
TListBox:Pointer)()
TListBox:Pointer)()
TListBox:END 
TStaticText<..TView
TStaticText:Text Sw_PString
TStaticText:TRect()
TStaticText:TStream)()
TStaticText:Virtual()
TStaticText:PPalette()
TStaticText:Virtual()
TStaticText:TStream)()
TStaticText:Sw_String)()
TStaticText:END 
TParamText<..TStaticText
TParamText:ParamCount Sw_Integer
TParamText:ParamList Pointer
TParamText:TRect()
TParamText:AParamCount Sw_Integer)
TParamText:TStream)()
TParamText:Sw_Word()
TParamText:Virtual()
TParamText:Virtual()
TParamText:TStream)()
TParamText:Sw_String)()
TParamText:END 
TLabel<..TStaticText
TLabel:Light Boolean
TLabel:Link PView
TLabel:TRect()
TLabel:TStream)()
TLabel:PPalette()
TLabel:Virtual()
TLabel:TStream)()
TLabel:TEvent)()
TLabel:END 
THistoryViewer<..TListViewer
THistoryViewer:HistoryId Word
THistoryViewer:TRect()
THistoryViewer:AHistoryId Word)
THistoryViewer:Sw_Integer()
THistoryViewer:PPalette()
THistoryViewer:Sw_Integer()
THistoryViewer:TEvent)()
THistoryViewer:END 
THistoryWindow<..TWindow
THistoryWindow:Viewer PListViewer
THistoryWindow:TRect()
THistoryWindow:Sw_String()
THistoryWindow:PPalette()
THistoryWindow:Word)()
THistoryWindow:END 
THistory<..TView
THistory:HistoryId Word
THistory:Link PInputLine
THistory:TRect()
THistory:TStream)()
THistory:PPalette()
THistory:TRect)()
THistory:Virtual()
THistory:Sw_String)()
THistory:TStream)()
THistory:TEvent)()
THistory:END 
TBrowseInputLine<..TInputLine
TBrowseInputLine:History Sw_Word
TBrowseInputLine:TRect()
TBrowseInputLine:TStream)()
TBrowseInputLine:Sw_Word()
TBrowseInputLine:virtual()
TBrowseInputLine:virtual()
TBrowseInputLine:TStream)()
TBrowseInputLine:end {ofTBrowseInputLine}
TBrowseButton<..TButton
TBrowseButton:Link PBrowseInputLine
TBrowseButton:TRect()
TBrowseButton:AFlags Byte
TBrowseButton:TStream)()
TBrowseButton:virtual()
TBrowseButton:TStream)()
TBrowseButton:end {ofTBrowseButton}
TCommandIcon<..TStaticText
TCommandIcon:TRect()
TCommandIcon:TEvent)()
TCommandIcon:Command Word
TCommandIcon:end {ofTCommandIcon}
TCommandCheckBoxes<..TCheckBoxes
TCommandCheckBoxes:CommandList TCommandArray
TCommandCheckBoxes:TRect()
TCommandCheckBoxes:TStream)()
TCommandCheckBoxes:Sw_Integer)()
TCommandCheckBoxes:TStream)()
TCommandCheckBoxes:end {ofTCommandCheckBoxes}
TCommandRadioButtons<..TRadioButtons
TCommandRadioButtons:CommandList TCommandArray
TCommandRadioButtons:TRect()
TCommandRadioButtons:TStream)()
TCommandRadioButtons:Sw_Integer)()
TCommandRadioButtons:Sw_Integer)()
TCommandRadioButtons:TStream)()
TCommandRadioButtons:end {ofTCommandRadioButtons}
TEditListBox<..TListBox
TEditListBox:CurrentField SmallInt
TEditListBox:TRect()
TEditListBox:AVScrollBar PScrollBar)
TEditListBox:TStream)()
TEditListBox:PValidator()
TEditListBox:SmallInt()
TEditListBox:PInputLine)()
TEditListBox:PPalette()
TEditListBox:TEvent)()
TEditListBox:PInputLine)()
TEditListBox:SmallInt()
TEditListBox:TEvent)()
TEditListBox:end {ofTEditListBox}
TModalInputLine<..TInputLine
TModalInputLine:Word()
TModalInputLine:TEvent)()
TModalInputLine:Word()
TModalInputLine:EndState Word
TModalInputLine:end {ofTModalInputLine}
TDialog<..TWindow
TDialog:TRect()
TDialog:TStream)()
TDialog:Word)()
TDialog:TTitleStr)()
TDialog:PView)()
TDialog:virtual()
TDialog:PPalette()
TDialog:TEvent)()
TDialog:PView)()
TDialog:Sw_Integer()
TDialog:ACommand,AHelpCtx Word
TDialog:AFlags Byte)
TDialog:Sw_Integer()
TDialog:ALink PView)
TDialog:Sw_Integer()
TDialog: AValidator
TDialog:Word)()
TDialog:end 
TListDlg<..TDialog
TListDlg:NewCommand Word
TListDlg:EditCommand Word
TListDlg:ListBox PListBox
TListDlg:ldOptions Word
TListDlg:TTitleStr()
TListDlg:AListBox PListBox
TListDlg:TStream)()
TListDlg:TEvent)()
TListDlg:TStream)()
TListDlg:end {ofTListDlg}
TTable<..TView
TTable:virtual()
TTable:TEvent)()
TTable:boolean)()
TTable:end 
TReport<..TView
TReport:ASCIIChar LongInt
TReport:TStream)()
TReport:virtual()
TReport:TEvent)()
TReport:TStream)()
TReport:end 
TASCIIChart<..TWindow
TASCIIChart:Report PReport
TASCIIChart:Table PTable
TASCIIChart:()
TASCIIChart:TStream)()
TASCIIChart:TStream)()
TASCIIChart:TEvent)()
TASCIIChart:end 
TValidator<..TObject
TValidator:Status Word
TValidator:Options Word
TValidator:TStream)()
TValidator:Sw_String)()
TValidator:Sw_String)()
TValidator:Sw_String()
TValidator:SuppressFill Boolean)
TValidator:Sw_String()
TValidator:Flag TVTransfer)
TValidator:Virtual()
TValidator:TStream)()
TValidator:END 
TPXPictureValidator<..TValidator
TPXPictureValidator:Pic Sw_PString
TPXPictureValidator:Sw_String()
TPXPictureValidator:TStream)()
TPXPictureValidator:Virtual()
TPXPictureValidator:Sw_String)()
TPXPictureValidator:Sw_String()
TPXPictureValidator:SuppressFill Boolean)
TPXPictureValidator:Sw_String()
TPXPictureValidator:AutoFill Boolean)
TPXPictureValidator:Virtual()
TPXPictureValidator:TStream)()
TPXPictureValidator:END 
TFilterValidator<..TValidator
TFilterValidator:ValidChars CharSet
TFilterValidator:CharSet)()
TFilterValidator:TStream)()
TFilterValidator:Sw_String)()
TFilterValidator:Sw_String()
TFilterValidator:SuppressFill Boolean)
TFilterValidator:Virtual()
TFilterValidator:TStream)()
TFilterValidator:END 
TRangeValidator<..TFilterValidator
TRangeValidator:Min LongInt
TRangeValidator:Max LongInt
TRangeValidator:LongInt)()
TRangeValidator:TStream)()
TRangeValidator:Sw_String)()
TRangeValidator:Sw_String()
TRangeValidator:Flag TVTransfer)
TRangeValidator:Virtual()
TRangeValidator:TStream)()
TRangeValidator:END 
TLookupValidator<..TValidator
TLookupValidator:Sw_String)()
TLookupValidator:Sw_String)()
TLookupValidator:END 
TStringLookupValidator<..TLookupValidator
TStringLookupValidator:Strings PStringCollection
TStringLookupValidator:PStringCollection)()
TStringLookupValidator:TStream)()
TStringLookupValidator:Virtual()
TStringLookupValidator:Sw_String)()
TStringLookupValidator:Virtual()
TStringLookupValidator:PStringCollection)()
TStringLookupValidator:TStream)()
TStringLookupValidator:END 
TConstant<..TObject
TConstant:Value Word
TConstant:Word()
TConstant:virtual()
TConstant:string)()
TConstant:string)()
TConstant:string()
TConstant:string()
TConstant:FText PString
TConstant:end {ofTConstant}
TMemStringList<..TSortedCollection
TMemStringList:()
TMemStringList:TStream)()
TMemStringList:virtual()
TMemStringList:Pointer)()
TMemStringList:{CompareassumesKey1andKey2areWordvaluesandreturns 
TMemStringList:Word)()
TMemStringList:Pointer)()
TMemStringList:Pointer)()
TMemStringList:Sw_Integer()
TMemStringList:oraDOSerrorcode.PossibleDOSerrorcodesinclude 
TMemStringList:2 noassociatedresourcefile
TMemStringList:8 outofmemory}
TMemStringList:Word()
TMemStringList:Word()
TMemStringList:TStream)()
TMemStringList:StringList PStringList
TMemStringList:end {ofTMemStringList)}
TFileInputLine<..TInputLine
TFileInputLine:TRect()
TFileInputLine:TEvent)()
TFileInputLine:end 
TFileCollection<..TSortedCollection
TFileCollection:Pointer)()
TFileCollection:Pointer)()
TFileCollection:TStream)()
TFileCollection:TStream()
TFileCollection:end 
TFileValidator<..TValidator
TFileValidator:end {ofTFileValidator}
TSortedListBox<..TListBox
TSortedListBox:SearchPos Byte
TSortedListBox:{ShiftState Byte
TSortedListBox:HandleDir boolean
TSortedListBox:TRect()
TSortedListBox:AScrollBar PScrollBar)
TSortedListBox:TEvent)()
TSortedListBox:String)()
TSortedListBox:PCollection)()
TSortedListBox:end 
TFileList<..TSortedListBox
TFileList:TRect()
TFileList:virtual()
TFileList:Sw_Word()
TFileList:Sw_Integer)()
TFileList:virtual()
TFileList:Sw_Integer)()
TFileList:String)()
TFileList:TEvent)()
TFileList:PathStr)()
TFileList:virtual()
TFileList:end 
TFileInfoPane<..TView
TFileInfoPane:S TSearchRec
TFileInfoPane:TRect)()
TFileInfoPane:virtual()
TFileInfoPane:PPalette()
TFileInfoPane:TEvent)()
TFileInfoPane:end 
TFileHistory<..THistory
TFileHistory:CurDir PString
TFileHistory:TEvent)()
TFileHistory:virtual()
TFileHistory:string)()
TFileHistory:end 
TFileDialog<..TDialog
TFileDialog:FileName PFileInputLine
TFileDialog:FileList PFileList
TFileDialog:FileHistory PFileHistory
TFileDialog:WildCard TWildStr
TFileDialog:Directory PString
TFileDialog:TWildStr()
TFileDialog:InputName String
TFileDialog:TStream)()
TFileDialog:virtual()
TFileDialog:virtual()
TFileDialog:PathStr)()
TFileDialog:TEvent)()
TFileDialog:virtual()
TFileDialog:TStream)()
TFileDialog:Word)()
TFileDialog:()
TFileDialog:end 
TDirCollection<..TCollection
TDirCollection:TStream)()
TDirCollection:Pointer)()
TDirCollection:TStream()
TDirCollection:end 
TDirListBox<..TListBox
TDirListBox:Dir DirStr
TDirListBox:Cur Word
TDirListBox:TRect()
TDirListBox:virtual()
TDirListBox:Sw_Integer)()
TDirListBox:TEvent)()
TDirListBox:Sw_Integer)()
TDirListBox:DirStr)()
TDirListBox:Word()
TDirListBox:end 
TChDirDialog<..TDialog
TChDirDialog:DirInput PInputLine
TChDirDialog:DirList PDirListBox
TChDirDialog:OkButton PButton
TChDirDialog:ChDirButton PButton
TChDirDialog:Word()
TChDirDialog:TStream)()
TChDirDialog:Sw_Word()
TChDirDialog:virtual()
TChDirDialog:TEvent)()
TChDirDialog:virtual()
TChDirDialog:TStream)()
TChDirDialog:Word)()
TChDirDialog:()
TChDirDialog:end 
TEditChDirDialog<..TChDirDialog
TEditChDirDialog:Sw_Word()
TEditChDirDialog:virtual()
TEditChDirDialog:virtual()
TEditChDirDialog:end {ofTEditChDirDialog}
TDirValidator<..TFilterValidator
TDirValidator:()
TDirValidator:string)()
TDirValidator:string()
TDirValidator:virtual 
TDirValidator:end {ofTDirValidator}
TView<..TObject
TView:GrowMode Byte
TView:DragMode Byte
TView:TabMask Byte
TView:ColourOfs Sw_Integer
TView:HelpCtx Word
TView:State Word
TView:Options Word
TView:EventMask Word
TView:Origin TPoint
TView:Size TPoint
TView:Cursor TPoint
TView:Next PView
TView:Owner PGroup
TView:HoldLimit PComplexArea
TView:RevCol Boolean
TView:BackgroundChar Char
TView:TRect)()
TView:TStream)()
TView:Virtual()
TView:PView()
TView:Word()
TView:Boolean()
TView:Sw_Word()
TView:PView()
TView:PView()
TView:PView()
TView:Word()
TView:Boolean()
TView:PPalette()
TView:byte)()
TView:Word)()
TView:Word)()
TView:Word)()
TView:Sw_String)()
TView:Sw_String)()
TView:TPoint)()
TView:Word)()
TView:Sw_Integer)()
TView:TEvent()
TView:()
TView:()
TView:Virtual()
TView:Virtual()
TView:()
TView:Virtual()
TView:()
TView:()
TView:Virtual()
TView:()
TView:()
TView:()
TView:()
TView:Virtual()
TView:Sw_Integer)()
TView:Sw_Integer)()
TView:Word)()
TView:Sw_Integer)()
TView:PView)()
TView:TCommandSet)()
TView:TCommandSet)()
TView:TCommandSet)()
TView:Word()
TView:TCommandSet()
TView:Virtual()
TView:Virtual()
TView:TStream)()
TView:TRect)()
TView:TEvent)()
TView:TEvent)()
TView:TEvent)()
TView:TRect)()
TView:TRect)()
TView:TRect)()
TView:TRect)()
TView:TEvent)()
TView:TEvent)()
TView:TRect)()
TView:TPoint)()
TView:TCommandSet)()
TView:TStream()
TView:TStream()
TView:TRect()
TView:Boolean()
TView:Sw_Integer()
TView:Sw_Integer()
TView:TPoint()
TView:TPoint()
TView:Sw_Integer()
TView:Sw_Integer()
TView:Count Sw_Integer)
TView:Sw_Integer()
TView:Count Sw_Integer)
TView:TEvent()
TView:MinSize,MaxSize TPoint)
TView:()
TView:PView)()
TView:PView)()
TView:TRect()
TView:Boolean()
TView:Sw_Integer()
TView:Sw_integer()
TView:Sw_integer()
TView:Sw_integer()
TView:Sw_integer()
TView:END 
TGroup<..TView
TGroup:Phase (phFocused,phPreProcess,phPostProcess)
TGroup:EndState Word
TGroup:Current PView
TGroup:Last PView
TGroup:Buffer PVideoBuf
TGroup:TRect)()
TGroup:TStream)()
TGroup:Virtual()
TGroup:PView()
TGroup:Word()
TGroup:Word()
TGroup:Sw_Word()
TGroup:PView)()
TGroup:TGroupFirstThatCallback)()
TGroup:Word)()
TGroup:Boolean)()
TGroup:Virtual()
TGroup:()
TGroup:()
TGroup:Virtual()
TGroup:Virtual()
TGroup:()
TGroup:()
TGroup:PView)()
TGroup:PView)()
TGroup:TCallbackProcParam)()
TGroup:Word)()
TGroup:Boolean)()
TGroup:PView)()
TGroup:Word()
TGroup:Virtual()
TGroup:Virtual()
TGroup:TStream)()
TGroup:TEvent)()
TGroup:TEvent)()
TGroup:TRect)()
TGroup:TStream()
TGroup:TStream()
TGroup:boolean()
TGroup:PView)()
TGroup:PView)()
TGroup:PView)()
TGroup:PView)()
TGroup:LockFlag Byte
TGroup:Clip TRect
TGroup:PView)()
TGroup:Boolean)()
TGroup:Word()
TGroup:()
TGroup:PView)()
TGroup:PView)()
TGroup:PView()
TGroup:PView)()
TGroup:END 
TFrame<..TView
TFrame:TRect)()
TFrame:PPalette()
TFrame:virtual()
TFrame:TEvent)()
TFrame:Word()
TFrame:FrameMode Word
TFrame:Y,N()
TFrame:END 
TScrollBar<..TView
TScrollBar:Value Sw_Integer
TScrollBar:Min Sw_Integer
TScrollBar:Max Sw_Integer
TScrollBar:PgStep Sw_Integer
TScrollBar:ArStep Sw_Integer
TScrollBar:Id Sw_Integer
TScrollBar:TRect)()
TScrollBar:TStream)()
TScrollBar:PPalette()
TScrollBar:Sw_Integer)()
TScrollBar:Virtual()
TScrollBar:Virtual()
TScrollBar:Sw_Integer)()
TScrollBar:Sw_Integer)()
TScrollBar:Sw_Integer)()
TScrollBar:Sw_Integer)()
TScrollBar:TStream)()
TScrollBar:TEvent)()
TScrollBar:Chars TScrollChars
TScrollBar:Sw_Integer()
TScrollBar:Sw_Integer()
TScrollBar:Sw_Integer)()
TScrollBar:END 
TScroller<..TView
TScroller:Delta TPoint
TScroller:Limit TPoint
TScroller:HScrollBar PScrollBar
TScroller:VScrollBar PScrollBar
TScroller:TRect()
TScroller:TStream)()
TScroller:PPalette()
TScroller:Virtual()
TScroller:Sw_Integer)()
TScroller:Sw_Integer)()
TScroller:Word()
TScroller:TStream)()
TScroller:TEvent)()
TScroller:TRect)()
TScroller:DrawFlag Boolean
TScroller:DrawLock Byte
TScroller:()
TScroller:END 
TListViewer<..TView
TListViewer:NumCols Sw_Integer
TListViewer:TopItem Sw_Integer
TListViewer:Focused Sw_Integer
TListViewer:Range Sw_Integer
TListViewer:HScrollBar PScrollBar
TListViewer:VScrollBar PScrollBar
TListViewer:TRect()
TListViewer:AVScrollBar PScrollBar)
TListViewer:TStream)()
TListViewer:PPalette()
TListViewer:Sw_Integer)()
TListViewer:Sw_Integer()
TListViewer:Virtual()
TListViewer:Sw_Integer)()
TListViewer:Sw_Integer)()
TListViewer:Sw_Integer)()
TListViewer:Sw_Integer)()
TListViewer:Word()
TListViewer:TStream)()
TListViewer:TEvent)()
TListViewer:TRect)()
TListViewer:Sw_Integer)()
TListViewer:END 
TWindow<..TGroup
TWindow:Flags Byte
TWindow:Number Sw_Integer
TWindow:Palette Sw_Integer
TWindow:ZoomRect TRect
TWindow:Frame PFrame
TWindow:Title UnicodeString
TWindow:Title PString
TWindow:TRect()
TWindow:TStream)()
TWindow:Virtual()
TWindow:PPalette()
TWindow:Sw_Integer)()
TWindow:Word)()
TWindow:Virtual()
TWindow:Virtual()
TWindow:Virtual()
TWindow:Word()
TWindow:TStream)()
TWindow:TEvent)()
TWindow:TPoint)()
TWindow:END 
Toutlineviewer<..Tscroller
Toutlineviewer:foc sw_integer
Toutlineviewer:Trect()
Toutlineviewer:AHscrollbar,AVscrollbar Pscrollbar)
Toutlineviewer:pointer()
Toutlineviewer:SmallInt()
Toutlineviewer:flags word
Toutlineviewer:constchars UnicodeString)
Toutlineviewer:SmallInt()
Toutlineviewer:flags word
Toutlineviewer:constchars string)
Toutlineviewer:virtual()
Toutlineviewer:pointer)()
Toutlineviewer:codepointer)()
Toutlineviewer:sw_integer)()
Toutlineviewer:codepointer)()
Toutlineviewer:pointer()
Toutlineviewer:SmallInt()
Toutlineviewer:SmallInt()
Toutlineviewer:sw_integer)()
Toutlineviewer:pointer)()
Toutlineviewer:Ppalette()
Toutlineviewer:pointer()
Toutlineviewer:pointer)()
Toutlineviewer:pointer)()
Toutlineviewer:Tevent)()
Toutlineviewer:pointer)()
Toutlineviewer:pointer)()
Toutlineviewer:sw_integer)()
Toutlineviewer:sw_integer)()
Toutlineviewer:word()
Toutlineviewer:()
Toutlineviewer:sw_integer)()
Toutlineviewer:codepointer()
Toutlineviewer:stop_if_found boolean)
Toutlineviewer:end 
Toutline<..Toutlineviewer
Toutline:root Pnode
Toutline:Trect()
Toutline:AHscrollbar,AVscrollbar Pscrollbar
Toutline:Aroot Pnode)
Toutline:pointer()
Toutline:pointer()
Toutline:pointer)()
Toutline:pointer()
Toutline:pointer)()
Toutline:pointer)()
Toutline:pointer)()
Toutline:pointer)()
Toutline:virtual()
Toutline:end 
TIndicator<..TView
TIndicator:Location Objects.TPoint
TIndicator:Modified Boolean
TIndicator:AutoIndent Boolean
TIndicator:WordWrap Boolean
TIndicator:TRect)()
TIndicator:virtual()
TIndicator:PPalette()
TIndicator:Word()
TIndicator:Objects.TPoint()
TIndicator:IsModified Boolean
TIndicator:IsWordWrap Boolean)
TIndicator:end 
TEditor<..TView
TEditor:HScrollBar PScrollBar
TEditor:VScrollBar PScrollBar
TEditor:Indicator PIndicator
TEditor:Buffer PEditBuffer
TEditor:BufSize Sw_Word
TEditor:BufLen Sw_Word
TEditor:GapLen Sw_Word
TEditor:SelStart Sw_Word
TEditor:SelEnd Sw_Word
TEditor:CurPtr Sw_Word
TEditor:CurPos Objects.TPoint
TEditor:Delta Objects.TPoint
TEditor:Limit Objects.TPoint
TEditor:DrawLine Sw_Integer
TEditor:DrawPtr Sw_Word
TEditor:DelCount Sw_Word
TEditor:InsCount Sw_Word
TEditor:Flags Longint
TEditor:IsReadOnly Boolean
TEditor:IsValid Boolean
TEditor:CanUndo Boolean
TEditor:Modified Boolean
TEditor:Selecting Boolean
TEditor:Overwrite Boolean
TEditor:AutoIndent Boolean
TEditor:NoSelect Boolean
TEditor:TabSize Sw_Word
TEditor:BlankLine Sw_Word
TEditor:Word_Wrap Boolean
TEditor:Line_Number string[8]
TEditor:Right_Margin Sw_Integer
TEditor:Tab_Settings String[Tab_Stop_Length]
TEditor:TRect()
TEditor:AIndicator PIndicator
TEditor:Objects.TStream)()
TEditor:virtual()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:TRect)()
TEditor:Drivers.TEvent)()
TEditor:Boolean()
TEditor:()
TEditor:virtual()
TEditor:virtual()
TEditor:LinePtr()
TEditor:PPalette()
TEditor:Drivers.TEvent)()
TEditor:virtual()
TEditor:PEditBuffer()
TEditor:PEditor)()
TEditor:Pointer()
TEditor:Sw_Integer)()
TEditor:String()
TEditor:Sw_Word)()
TEditor:Word()
TEditor:Sw_Word()
TEditor:Sw_Word()
TEditor:Word()
TEditor:Objects.TStream)()
TEditor:Boolean)()
TEditor:()
TEditor:virtual()
TEditor:Word)()
TEditor:KeyState SmallInt
TEditor:LockCount Byte
TEditor:UpdateFlags Byte
TEditor:Place_Marker Array[1..10]ofSw_Word
TEditor:Search_Replace Boolean
TEditor:Byte)()
TEditor:Sw_Word)()
TEditor:Sw_Word()
TEditor:Byte()
TEditor:Boolean()
TEditor:()
TEditor:()
TEditor:Sw_Word()
TEditor:()
TEditor:()
TEditor:Byte()
TEditor:Sw_Integer()
TEditor:()
TEditor:Objects.TPoint)()
TEditor:Boolean()
TEditor:()
TEditor:Byte)()
TEditor:Boolean()
TEditor:Byte()
TEditor:Byte)()
TEditor:Sw_Word)()
TEditor:Sw_Word()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:()
TEditor:Byte)()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:Sw_Word)()
TEditor:Byte()
TEditor:Byte()
TEditor:Byte)()
TEditor:()
TEditor:()
TEditor:()
TEditor:()
TEditor:Sw_Word)()
TEditor:Byte)()
TEditor:()
TEditor:()
TEditor:()
TEditor:Byte)()
TEditor:()
TEditor:()
TEditor:Byte)()
TEditor:Word()
TEditor:end 
TMemo<..TEditor
TMemo:Objects.TStream)()
TMemo:Sw_Word()
TMemo:virtual()
TMemo:PPalette()
TMemo:Drivers.TEvent)()
TMemo:virtual()
TMemo:Objects.TStream)()
TMemo:end 
TFileEditor<..TEditor
TFileEditor:FileName FNameStr
TFileEditor:TRect()
TFileEditor:AIndicator PIndicator
TFileEditor:Objects.TStream)()
TFileEditor:virtual()
TFileEditor:Drivers.TEvent)()
TFileEditor:virtual()
TFileEditor:Boolean()
TFileEditor:Boolean()
TFileEditor:Boolean()
TFileEditor:Boolean()
TFileEditor:Sw_Word)()
TFileEditor:Objects.TStream)()
TFileEditor:virtual()
TFileEditor:Word)()
TFileEditor:end 
TEditWindow<..TWindow
TEditWindow:Editor PFileEditor
TEditWindow:TRect()
TEditWindow:Objects.TStream)()
TEditWindow:virtual()
TEditWindow:Sw_Integer)()
TEditWindow:Drivers.TEvent)()
TEditWindow:TPoint)()
TEditWindow:Objects.TStream)()
TEditWindow:end 
TMenuView<..TView
TMenuView:ParentMenu PMenuView
TMenuView:Menu PMenu
TMenuView:Current PMenuItem
TMenuView:OldItem PMenuItem
TMenuView:TRect)()
TMenuView:TStream)()
TMenuView:Word()
TMenuView:Word()
TMenuView:PPalette()
TMenuView:Char)()
TMenuView:Word)()
TMenuView:TRect()
TMenuView:AParentMenu PMenuView)
TMenuView:TStream)()
TMenuView:TEvent)()
TMenuView:PMenuItem()
TMenuView:PMenuItem()
TMenuView:END 
TMenuBar<..TMenuView
TMenuBar:TRect()
TMenuBar:Virtual()
TMenuBar:Virtual()
TMenuBar:PMenuItem()
TMenuBar:END 
TMenuBox<..TMenuView
TMenuBox:TRect()
TMenuBox:AParentMenu PMenuView)
TMenuBox:Virtual()
TMenuBox:PMenuItem()
TMenuBox:END 
TMenuPopup<..TMenuBox
TMenuPopup:TRect()
TMenuPopup:Virtual()
TMenuPopup:TEvent)()
TMenuPopup:END 
TStatusLine<..TView
TStatusLine:Items PStatusItem
TStatusLine:Defs PStatusDef
TStatusLine:TRect()
TStatusLine:TStream)()
TStatusLine:Virtual()
TStatusLine:PPalette()
TStatusLine:Word)()
TStatusLine:Virtual()
TStatusLine:Virtual()
TStatusLine:TStream)()
TStatusLine:TEvent)()
TStatusLine:()
TStatusLine:PStatusItem)()
TStatusLine:END 
TColorGroupList<..TListViewer
TColorGroupList:Groups PColorGroup
TColorGroupList:TRect()
TColorGroupList:end 
TColorDialog<..TDialog
TColorDialog:Groups PColorGroupList
TColorDialog:Pal TPalette
TColorDialog:TPalette()
TColorDialog:TStream)()
TColorDialog:TStream)()
TColorDialog:end 
TBackGround<..TView
TBackGround:Pattern Sw_ExtendedGraphemeCluster
TBackGround:TRect()
TBackGround:TStream)()
TBackGround:PPalette()
TBackGround:Virtual()
TBackGround:TStream)()
TBackGround:END 
TDeskTop<..TGroup
TDeskTop:Background PBackground
TDeskTop:TileColumnsFirst Boolean
TDeskTop:TRect)()
TDeskTop:TStream)()
TDeskTop:Virtual()
TDeskTop:Virtual()
TDeskTop:TRect)()
TDeskTop:TStream)()
TDeskTop:TRect)()
TDeskTop:TEvent)()
TDeskTop:END 
TProgram<..TGroup
TProgram:()
TProgram:Virtual()
TProgram:PPalette()
TProgram:Boolean()
TProgram:PView)()
TProgram:PWindow)()
TProgram:PDialog()
TProgram:Virtual()
TProgram:Virtual()
TProgram:Virtual()
TProgram:virtual()
TProgram:Virtual()
TProgram:Virtual()
TProgram:Virtual()
TProgram:Virtual()
TProgram:Word)()
TProgram:TVideoMode)()
TProgram:TEvent)()
TProgram:TEvent)()
TProgram:TEvent)()
TProgram:END 
TApplication<..TProgram
TApplication:()
TApplication:Virtual()
TApplication:()
TApplication:()
TApplication:()
TApplication:TRect)()
TApplication:TEvent)()
TApplication:virtual()
TApplication:END 
TColoredText<..TStaticText
TColoredText:Attr Byte
TColoredText:TRect()
TColoredText:TStream)()
TColoredText:byte()
TColoredText:virtual()
TColoredText:TStream)()
TColoredText:end 
THeapView<..TView
THeapView:Mode THeapViewMode
THeapView:OldMem LongInt
THeapView:TRect)()
THeapView:TRect)()
THeapView:TRect)()
THeapView:TRect)()
THeapView:()
THeapView:Virtual()
THeapView:LongInt)()
THeapView:END 
TClockView<..TView
TClockView:am Char
TClockView:Refresh Byte
TClockView:LastTime Longint
TClockView:TimeStr String[10]
TClockView:TRect)()
TClockView:Word)()
TClockView:Virtual()
TClockView:Virtual()
TClockView:END 
TStatus<..TParamText
TStatus:Command Word
TStatus:TRect()
TStatus:AParamCount SmallInt)
TStatus:TStream)()
TStatus:Boolean()
TStatus:PPalette()
TStatus:TEvent)()
TStatus:virtual()
TStatus:virtual()
TStatus:virtual()
TStatus:TStream)()
TStatus:Pointer)()
TStatus:end {ofTStatus}
TStatusDlg<..TDialog
TStatusDlg:Status PStatus
TStatusDlg:TTitleStr()
TStatusDlg:TStream)()
TStatusDlg:Word)()
TStatusDlg:TEvent)()
TStatusDlg:Word)()
TStatusDlg:TStream)()
TStatusDlg:end {ofTStatusDlg}
TStatusMessageDlg<..TStatusDlg
TStatusMessageDlg:TTitleStr()
TStatusMessageDlg:AMessage String)
TStatusMessageDlg:end {ofTStatusMessageDlg}
TGauge<..TStatus
TGauge:Min LongInt
TGauge:Max LongInt
TGauge:Current LongInt
TGauge:TRect()
TGauge:TStream)()
TGauge:virtual()
TGauge:{Drawwritesthefollowingtothescreen }
TGauge:virtual()
TGauge:virtual()
TGauge:virtual()
TGauge:TStream)()
TGauge:Pointer)()
TGauge:end {ofTGauge}
TArrowGauge<..TGauge
TArrowGauge:Right Boolean
TArrowGauge:TRect()
TArrowGauge:RightArrow Boolean)
TArrowGauge:TStream)()
TArrowGauge:virtual()
TArrowGauge:virtual()
TArrowGauge:virtual()
TArrowGauge:TStream)()
TArrowGauge:end {ofTArrowGauge}
TPercentGauge<..TGauge
TPercentGauge:SmallInt()
TPercentGauge:virtual()
TPercentGauge:end {ofTPercentGauge}
TBarGauge<..TPercentGauge
TBarGauge:virtual()
TBarGauge:PPalette()
TBarGauge:end {ofTBarGauge}
TSpinnerGauge<..TGauge
TSpinnerGauge:SmallInt()
TSpinnerGauge:virtual()
TSpinnerGauge:TEvent)()
TSpinnerGauge:Pointer)()
TSpinnerGauge:end {ofTSpinnerGauge}
TAppStatus<..TStatus
TAppStatus:PPalette()
TAppStatus:end {ofTAppStatus}
THeapMaxAvail<..TAppStatus
THeapMaxAvail:SmallInt)()
THeapMaxAvail:{Initcreatestheviewwiththefollowingtext 
THeapMaxAvail:Pointer)()
THeapMaxAvail:Max LongInt
THeapMaxAvail:end {ofTHeapMaxAvail}
THeapMemAvail<..TAppStatus
THeapMemAvail:SmallInt)()
THeapMemAvail:{Initcreatestheviewwiththefollowingtext 
THeapMemAvail:Pointer)()
THeapMemAvail:Mem LongInt
THeapMemAvail:end {ofTHeapMemAvail}
TTab<..TGroup
TTab:TabDefs PTabDef
TTab:ActiveDef SmallInt
TTab:DefCount word
TTab:TRect()
TTab:TStream)()
TTab:SmallInt)()
TTab:SmallInt)()
TTab:TStream)()
TTab:SmallInt()
TTab:Word)()
TTab:TRect)()
TTab:TEvent)()
TTab:PPalette()
TTab:virtual()
TTab:sw_word()
TTab:virtual()
TTab:virtual()
TTab:Word()
TTab:virtual()
TTab:InDraw boolean
TTab:PView()
TTab:PView()
TTab:end 
```
