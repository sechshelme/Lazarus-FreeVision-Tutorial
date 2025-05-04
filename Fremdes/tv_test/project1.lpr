//{  $IFDEF DPMI}
    {  $A+,B-,E+,F-,G+,I+,N+,P-,T-,V-,X+}
//    {  $M 65520,0}

program DialEdit;  {&Use32+}

{$H-}


{*******************************************************}
{                                                       }
{   Released under GNU General Public License 3 as      }
{   given at https://www.gnu.org/copyleft/gpl.html      }
{                    April 29, 2014                     }
{                                                       }
{*******************************************************}

uses Dos, Objects, Drivers, Memory, Views, Menus, Dialogs, StdDlg,
    MsgBox, App, Validate, TVInput, Params, Gadgets, HistList;

const
    CopyNote = 'DialEdit 8-14-95 (C) J.M.Clark';

{*******************************************************}
{                                                       }
{               DialEdit - a dialog editor              }
{                                                       }
{   This provides for visual editing of TurboVision     }
{   dialog boxes (TDialog objects) with the follow-     }
{   ing component objects:                              }
{                                                       }
{       TStaticText                                     }
{       TParamText                                      }
{       TButton                                         }
{       TInputLine        \                             }
{       TRadioButtons     |                             }
{       TCheckBoxes       |- These may have a TLabel.   }
{       TMultiCheckBoxes  |                             }
{       TListBox          /                             }
{                                                       }
{   TInputLine may have one of these validators:        }
{            FilterValidator                            }
{            RangeValidator (value is longint)          }
{            StringLookupValidator                      }
{            PXPictureValidator                         }
{   and may have a History icon.                        }
{                                                       }
{   TListBox also has a vertical TScrollBar.            }
{                                                       }
{   'Trial' versions of these can be moved/sized by     }
{   dragging with left/right mouse buttons.  A double   }
{   click re-activates the initialing dialog to edit    }
{   features.  Dialogs can be saved to a file and       }
{   fetched later, and Pascal code and/or picture of    }
{   the dialog can be generated and written to a disk   }
{   file or to standard output.                         }
{                                                       }
{   For full documentation, see file DialEdit.doc.      }
{                                                       }
{*******************************************************}

(****************************************************=--

----------------------- TO DO --------------------------

provide FocusFirst option in create/edit dialogs for all controls.
    this would put a control^.Select call at the end of the dialog
    init code to make that control focused first.

COMPLETE conversion to dual string collections for Cluster objects.


read/write history should use Done to close BufStream ?

add generic validator to TrialInputLine
    in form of
        <xxx>InputLine  - need name of defining unit
        <xxx>Validator  - need name of defining unit, and -
    generate code as in TvInput unit -
        with IL^ do begin
            SetValidator(New(P<name>Validator, Init(<arg list>)));
            Validator^.Options:= <voXXX bit>;   {optional}
            Options:= Options or ofValidate;
        end;

provide a FileDialog for Select Files dialog

generate optional 'blank' HandleEvent method code

generate const definitions for -    - done, need to doc.
    History ID names
    CheckBox bit positions
    MultiCheckBox mask values
    RadioButton values

provide variants -
    MRadioButtons (from TvInput)
    BigCheckBoxes (add to TvInput; for Count >16, <=32)

Use of ValidView -
    is it included in ExecDialog?
    is it used consistently?
    is OutOfMemory involved? needed?

Discard Patterned option?  (Pattern indicates editable)

Put pictures in Picture file?  Allow PictFile = CodeFile?

Provide for translating trial objects to real dialogs; -- done
    ( but
        collections for ListBoxes,
        validators for InputLines, &
        commands for Buttons
      are not supported in 'real' dialogs.
    )
use real dialogs to -
    store dialogs in (real) ResourceFile
    execute -
        for test                        -- done
        to define default data          -- done

Provide backup for output file (except '').
Provide backup for collection file.

InputLine length parameter (dialog input) -
    default: if input is number,
        length is input and type is string[input].
    option: if input is type,
        length is SizeOf(input)-1 and type is input.

Provide 25-line mode (or version), compact-format dialogs.

Re-structuring -
    Use revised OOP form of Params unit (ParamsO).
    Look for repeated code that can be merged.

----------------------- NOTES --------------------------

Cluster value size
    Documentation and debugger say SizeOf(Value) is 4.
    Documentation says DataSize returns SizeOf(Value) --
    BUT source code and experimentation say SizeOf(word) !
    (However, Value is actually a longint.)
    CheckBoxes and RadioButtons do not override DataSize.
    MultiCheckBoxes.DataSize = 4 (longint).

ParamText.SetData
    The documenation says that ParamText.SetData "reads DataSize
    bytes into ParamList from Rec".  Actually, it does "ParamList:=
    @Rec", so no memory is allocated for ParamList.  There is no
    GetData method.  ParamList points to a FormatStr parameter list,
    making the list data available to ParamText.Draw indirectly.
    DataSize is the size of the list (4 bytes per item).

ListBox
    An item can be selected by double-clicking it with the mouse,
    or moving the highlight with the cursor keys and pressing space.
    When an item is selected, the ListBox executes:
        Message(Owner, evBroadcast, cmListItemSelected, @Self);
    But to use this, the Dialog needs code added to its EventHandler
    such as in FetchDialogDialog.

Collections - names for item methods -

    obvious name    Turbo Vision name
    ------------    -----------------
    FreeItem        Free
    DeleteItem      Delete
    DisposeItem     FreeItem
    LoadItem        GetItem
    StoreItem       PutItem

EMSStream cannot support ResourceFile
(as hoped for in CloseCollFile).

TDialog.HandleEvent -
    Borland documentation says that TDialog.HandleEvent
        "handles most events by calling the HandleEvent method
        inherited from TWindow .."
        and that TWindow.HandleEvent
        "handles events specific to windows"
        including command
        "cmResize (move or resize the window using DragView)".
    However, the debugger *seems* to reveal that TWindow does
        the move and resize functions without calling DragView.
        Not really -- DragView is not virtual!!  (and can't be)
        But SetState *is* virtual; use SetState(sfDragging, )
        to clear DialSaved.

--=****************************************************)

type
    String5 = string[5];

{ command codes }

const
    cmNewDialog         = 111;
    cmNewStaticText     = 112;
    cmNewParamText      = 113;
    cmNewButton         = 114;
    cmNewInputLine      = 115;
    cmNewRadioButtons   = 116;
    cmNewCheckBoxes     = 117;
    cmNewMultiCheckBoxes =118;
    cmNewListBox        = 119;

    cmDelete            = cmNo;
    cmPutOnTop          = cmYes;
    cmEditItem          = 120;
    cmNewItem           = 121;

    cmSaveDialog        = 122;
    cmDeleteDialog      = 123;
    cmFetchDialog       = 124;
    cmGenCode           = 125;
    cmSnapPicture       = 126;
    cmSetFiles          = 127;
    cmSetDefault        = 128;
    cmSetPaste          = 129;
    cmOutput            = 130;
    cmSwapDialogs       = 131;
    cmTestDialog        = 132;
{$IFDEF ScreenCapture}
    cmScreenCapture     = 150;  {Alt-Z}
{$ENDIF}

    cmsNewControls = [
        cmNewStaticText, cmNewParamText, cmNewButton, cmNewInputLine,
        cmNewRadioButtons, cmNewCheckBoxes, cmNewMultiCheckBoxes,
        cmNewListBox, cmSaveDialog, cmDeleteDialog, cmGenCode,
        cmSnapPicture, cmTestDialog
    ];

    TitleLen = SizeOf(TTitleStr)-1;

    IDChars = ['a'..'z', 'A'..'Z', '0'..'9', '_'];
    ShadeChars: String5 = ' \B0\B1\B2\DB';

{ history ID codes }

    hiDialogName = 102;
    hiStaticText = 103;
    hiDataName   = 104;
    hiCmdName    = 105;
    hiLabelText  = 106;
    hiValPars    = 107;
    hiStates     = 108;
    hiHistID     = 109;
    hiCollFile   = 110;
    hiHistFile   = 111;
    hiCodeFile   = 112;
    hiTestID     = 113;  {for 'real' history objects}

{ values for GenVars, indicating dialog variables needed: }

    gvInputLine     = $0001;  {IL}
    gvRadioButtons  = $0002;  {RB}
    gvCheckBoxes    = $0004;  {CB}
    gvMultiCheckBoxes=$0008;  {MB}
    gvScrollBar     = $0010;  {SB}
    gvListBox       = $0020;  {LB}

{ parts of generated code, in outline form: }
type
    TGenPart = (
        gpDisabled,  {others imply enabled}

        { for generating TV code output: }
        gpFileHeader,
        gpInterface,            {not used}
            gpDialogHeader,
                gpDataFields,
                gpDataConsts,
            gpDataHeader,
                gpDataValues,
        gpImplementation,       {not used}
            gpHistConsts,
            gpDialogInit,
                gpControls,
            gpDialogFooter,
        gpFileFooter,

        { for generating picture output: }
        gpPicture,              {not used}

        { for creating real dialog from trial dialog: }
        gpClone
    );

{*******************************************************}

{ Outline of global functions and procedures }
{ These are implemented below in the same sequence }

{
        RegisterTrialObjects
    shared by trial objects -
        DragIt
        DragBoth
        NewLabel
        CodeBounds
        InitBounds
        CopyStrings
        InitStrings
        EscQuot
        GenImplementation
    stream & file routines -
        OpenCollFile
        CloseCollFile
        OpenCodeFile
        CloseCodeFile
        RemDialog
        SaveDialog
        DeleteDialog
        GetDialog
        FetchDialog
        TestDialog
        ReadHistory
        WriteHistory
        ScreenCapture       * (optional)
}

{*******************************************************}

{ Trial objects, and associated data and dialog objects:  }
{ The objects are implemented below in the same sequence. }

{ The Execute method of trial objects is overridden and }
{ used to generate code, because it is generic and not  }
{ otherwise used (trial objects are never modal).       }

type

{ ControlEditDialog }

    PControlEditDialog = ^TControlEditDialog;
    TControlEditDialog = object(TDialog)
        constructor Init(var Bounds: TRect; ATitle: TTitleStr);
        destructor Done; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure MakeDialogNames(SX: integer);
        procedure MakeDialogButtons(X1, X2, SY: integer;
                            Change: boolean; OkMode: word);
    end;

{ TrialLabel }

    PTrialLabel = ^TTrialLabel;
    TTrialLabel = object(TLabel)
        constructor Init(var Bounds: TRect; AText: TTitleStr;
                    ALink: PView);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        procedure GenCode(const LinkName: string);
        procedure ChangeText(const ALabel: string);
        procedure TrackTarget(const OldR: TRect);
    end;
    { NOTE: No label is indicated EITHER by setting the label }
    { pointer to nil, OR by setting the label text to ''. }

{ TrialStaticText }

    PStaticTextDialog = ^TStaticTextDialog;
    TStaticTextDialog = object(TControlEditDialog)
        constructor Init(Change: boolean);
    end;

    PStaticTextData = ^TStaticTextData;
    TStaticTextData = record
        RText: TTitleStr;
    end;

    PTrialStaticText = ^TTrialStaticText;
    TTrialStaticText = object(TStaticText)
        constructor Init(AData: PStaticTextData);
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
    end;

{ TrialParamText }

    PParamTextDialog = ^TParamTextDialog;
    TParamTextDialog = object(TControlEditDialog)
        constructor Init(Change: boolean);
    end;

    PParamTextData = ^TParamTextData;
    TParamTextData = record
        RFormat: TTitleStr;
        RNames: TTitleStr;
    end;

    PTrialParamText = ^TTrialParamText;
    TTrialParamText = object(TParamText)
        Names: PString;
        constructor Init(AData: PParamTextData);
        constructor Load(var S: TStream);
        destructor Done; virtual;
        function Execute: word; virtual;
        { Changed GetText to GetText2 because VP gives error 131: }
        { "Header does not match previous definition" }
        { But it DOES! letter for letter! }
        procedure GetText2(var S: String); virtual;             {+}
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var Min, Max: TPoint); virtual;
        procedure Store(var S: TStream);
    end;

{ TrialButton }

    PButtonDialog = ^TButtonDialog;
    TButtonDialog = object(TControlEditDialog)
        constructor Init(Change: boolean);
    end;

    PButtonData = ^TButtonData;
    TButtonData = record
        RTitle: TTitleStr;
        RCmdName: TTitleStr;    {cmXXX name}
        RFlags: byte;           {bfXXX values}
    end;

    PTrialButton = ^TTrialButton;
    TTrialButton = object(TButton)
        CmdName: PString;
        constructor Init(AData: PButtonData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

{ TrialInputLine }

    PInputLineDialog = ^TInputLineDialog;
    TInputLineDialog = object(TControlEditDialog)
        MRButtons: PMRadioButtons;
        Advice: PStaticText;
        constructor Init(Change: boolean);
        procedure HandleEvent(var Event: TEvent); virtual;
    end;

    PInputLineData = ^TInputLineData;
    TInputLineData = record
        RLabel: TTitleStr;
        RDataName: TTitleStr;
        RMaxLen: longint;
        RHistStr: TTitleStr;
        RValidate: word;
        RValPars: TTitleStr;
    end;

    { TrialHistory }

    PTrialHistory = ^TTrialHistory;
    TTrialHistory = object(THistory)
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure TrackTarget(const OldR: TRect);
    end;

    PTrialInputLine = ^TTrialInputLine;
    TTrialInputLine = object(TInputLine)
        LabelP: PTrialLabel;
        DataName: PString;
        History: PTrialHistory;
        HistStr: PString;
        Validate: word;
        ValPars: PString;
        constructor Init(AData: PInputLineData);
        destructor Done; virtual;
        procedure MakeHistory(AHistStr: TTitleStr); virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load01(var S: TStream);
        constructor Load02(var S: TStream);
        procedure Convert02;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

{ TrialCluster }  { shared by 3 descendant trial objects }

    TShortName = string[2];

    PItemData = ^TItemData;
    TItemData = record
        Name: TTitleStr;    {optional name for item value}
        Strg: TTitleStr;    {dialog text for cluster item}
    end;


    PClusterData = ^TClusterData;
    TClusterData = record
        RLabel: TTitleStr;
        RDataName: TTitleStr;
        RStrings: PStringCollection;
        RFocused: integer;
        RItemNames: PStringCollection;
        RNFocused: integer;
        RStates: TTitleStr; {for MultiCheckBoxes only}
        RShortName: TShortName;
    end;

    PItemDialog = ^TItemDialog;
    TItemDialog = object(TDialog)
        constructor Init(T: TTitleStr; FocusName: boolean);
    end;

    PClusterDialog = ^TClusterDialog;
    TClusterDialog = object(TControlEditDialog)
        StrgList: PListBox;
        NameList: PListBox;
        FocusName: boolean;
        constructor Init(Change: boolean; ShortName: TShortName);
        procedure HandleEvent(var Event: TEvent); virtual;
    end;
    { ClusterDialog.StrgList^.List = @Cluster.Strings }
    { ClusterDialog.NameList^.List = names for item values }

    PTrialCluster = ^TTrialCluster;
    TTrialCluster = object(TObject)
        DataName: PString;
        ShortName: TShortName;
        ItemNames: TStringCollection;
        constructor Init(AData: PClusterData; var CL: TCluster);
        destructor Done; virtual;
        procedure Resize(var CL: TCluster; LabelP: PTrialLabel);
                            virtual;
        procedure GenCode(var CL: TCluster); virtual;
        procedure HandleEvent(var Event: TEvent; CL: PCluster;
                            LabelP: PTrialLabel); virtual;
        constructor Load01(var S: TStream);
        procedure Convert01(var CL: TCluster);
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

    PTrialRadioButtons = ^TTrialRadioButtons;
    TTrialRadioButtons = object(TRadioButtons)
        LabelP: PTrialLabel;
        TC: TTrialCluster;
        constructor Init(AData: PClusterData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

    PTrialCheckBoxes = ^TTrialCheckBoxes;
    TTrialCheckBoxes = object(TCheckBoxes)
        LabelP: PTrialLabel;
        TC: TTrialCluster;
        constructor Init(AData: PClusterData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

    PTrialMultiCheckBoxes = ^TTrialMultiCheckBoxes;
    TTrialMultiCheckBoxes = object(TMultiCheckBoxes)
        LabelP: PTrialLabel;
        TC: TTrialCluster;
        constructor Init(AData: PClusterData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

{ TrialListBox }

    PListBoxDialog = ^TListBoxDialog;
    TListBoxDialog = object(TControlEditDialog)
        constructor Init(Change: boolean);
    end;

    PListBoxData = ^TListBoxData;
    TListBoxData = record
        RLabel: TTitleStr;
        RListName: TTitleStr;
        RSelectName: TTitleStr;
        RNumCols: longint;
    end;

    PTrialScrollBar = ^TTrialScrollBar;
    TTrialScrollBar = object(TScrollBar)
        Link: PView;
        constructor Init(Bounds: TRect; ALink: PView);
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        procedure GenCode;
        procedure TrackTarget(const OldR: TRect);
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

    PTrialListBox = ^TTrialListBox;
    TTrialListBox = object(TListBox)
        LabelP: PTrialLabel;
        ListName: PString;
        SelectName: PString;
        constructor Init(AData: PListBoxData);
        destructor Done; virtual;
        function Execute: word; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure SizeLimits(var MinSz, MaxSz: TPoint); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

{ TrialDialog }

    PDialogDialog = ^TDialogDialog;
    TDialogDialog = object(TControlEditDialog)
        constructor Init(Change: boolean);
    end;

    PDialogData = ^TDialogData;
    TDialogData = record
        RTitle: TTitleStr;
        ROptions: word;
        RBaseName: TTitleStr;
        RTypeName: TTitleStr;
    end;
    { Base and Type names are used as in: }
    { TBaseType = object(TType)           }
    { TBaseData = record    (etc.)        }
    { Type is generally Window or Dialog. }

{ values for TDialogData.ROptions: }
const
    doGenDefaults   = $01;
    doCentered      = $02;
    doOkButton      = $04;
    doCancelButton  = $08;

type
    PTrialDialogBackground = ^TTrialDialogBackground;
    TTrialDialogBackground = object(TView)
        Patterned: boolean;
        constructor Init(Bounds: TRect);
        procedure Draw; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

    PTrialDialog = ^TTrialDialog;
    TTrialDialog = object(TDialog)
        BaseName: PString;
        TypeName: PString;
        Background: PTrialDialogBackground;
        Centered: boolean;
        GenDefaults: boolean;
        constructor Init(AData: PDialogData);
        destructor Done; virtual;
        procedure Close; virtual;
        procedure GenCode; virtual;
        procedure SnapPicture(AShow, APattern: word); virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
        constructor Load01(var S: TStream);
        constructor Load(var S: TStream);
        procedure Store(var S: TStream); virtual;
    end;

{ FetchDialogDialog }

    PFetchDialogDialog = ^TFetchDialogDialog;
    TFetchDialogDialog = object(TDialog)
        ListBox: PListBox;
        Plural: boolean;
        constructor Init(APlural: boolean);
        procedure HandleEvent(var Event: TEvent); virtual;
    end;

    PFetchDialogData = ^TFetchDialogData;
    TFetchDialogData = record
        RNames: PStringCollection;
        RSelection:  word;      {for single mode}
    end;

{ FileOptDialog }

    PFileOptDialog = ^TFileOptDialog;
    TFileOptDialog = object(TDialog)
        constructor Init;
    end;

    PFileOptData = ^TFileOptData;
    TFileOptData = record
        CodeFName: TTitleStr;
        CollFName: TTitleStr;
        HistFName: TTitleStr;
    end;

{ OutOptDialog }

    POutOptDialog = ^TOutOptDialog;
    TOutOptDialog = object(TDialog)
        constructor Init;
    end;

    POutOptData = ^TOutOptData;
    TOutOptData = record
        RSave: word;
        RInclude: word;
        RShow: word;
        RShades: longint;
        GenFormat: word;
        RIndent: longint;
    end;

{ Token }

const
    sfPaste = $4000;    {special}

type
    PToken = ^TToken;
    TToken = object(TView)
        Kind: char;  {m = mode; s = swap}
        constructor Init(Bounds: TRect; AKind: char);
        procedure Draw; virtual;
        procedure SetState(AState: word; Enable: boolean); virtual;
        procedure Update; virtual;
        procedure HandleEvent(var Event: TEvent); virtual;
    end;

{ TDialEditApp }

    { supporting routines linked to Params unit:
        ShowUsage
        SetOpt
        DoFile
        AppDone
    }

    PDialEditApp = ^TDialEditApp;
    TDialEditApp = object(TApplication)
        Clock: PClockView;
{$IFNDEF VPASCAL}
        Heap: PHeapView;
{$ENDIF}
        constructor Init;
        destructor Done; virtual;
        procedure InitScreen; virtual;
        procedure InitMenuBar; virtual;
        procedure InitStatusLine; virtual;
        { supporting local routines:
            NewDialog
            NewStaticText
            NewParamText
            NewButton
            NewInputLine
            NewRadioButtons
            NewCheckBoxes
            NewMultiChecfkBoxes
            NewListBox
            SnapIt
            SetFiles
        }
        procedure HandleEvent(var Event: TEvent); virtual;
        procedure Idle; virtual;
        procedure OutOfMemory; virtual;
        procedure GenCode(ATrialDialog: PTrialDialog); virtual;
    end;

{ Default / Paste object-edit data buffers }

    TEditBuffer = record
        DDialog:        TDialogData;
        DStaticText:    TStaticTextData;
        DParamText:     TParamTextData;
        DButton:        TButtonData;
        DInputLine:     TInputLineData;
        DRadioButtons:  TClusterData;
        DCheckBoxes:    TClusterData;
        DMultiCheckBoxes: TClusterData;
        DListBox:       TListBoxData;
        DOutOpt:        TOutOptData;
    end;

const
    Default: TEditBuffer = (
        DDialog: (
            RTitle: 'Test Dialog';
            ROptions: $0E;
            RBaseName: 'Test';
            RTypeName: 'Dialog'
        );
        DStaticText: (
            RText: ''
        );
        DParamText: (
            RFormat: '';
            RNames: ''
        );
        DButton: (
            RTitle: '~N~o';
            RCmdName: 'cmNo';
            RFlags: bfNormal
        );
        DInputLine: (
            RLabel: '~N~ame';
            RDataName: 'Name';
            RMaxLen: 80;
            RHistStr: '';
            RValidate: 0;
            RValPars: ''
        );
        DRadioButtons: (
            RLabel: '~M~ode';
            RDataName: 'Mode';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '';
            RShortName: 'RB'
        );
        DCheckBoxes: (
            RLabel: '~O~ptions';
            RDataName: 'Options';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '';
            RShortName: 'CB'
        );
        DMultiCheckBoxes: (
            RLabel: '~C~hoices';
            RDataName: 'Choices';
            RStrings: nil;
            RFocused: 0;
            RItemNames: nil;
            RNFocused: 0;
            RStates: '<=>';
            RShortName: 'MB'
        );
        DListBox: (
            RLabel: '~S~election';
            RListName: 'List';
            RSelectName: 'Selection';
            RNumCols: 1
        );
        DOutOpt: (
            RSave: 0;
            RInclude: 1;
            RShow: 0;
            RShades: $32;
            GenFormat: 1;
            RIndent: 0
        )
    );

{*******************************************************}
{                                                       }
{           Stream Registration Records                 }
{                                                       }
{*******************************************************}

const
    RTrialLabel: TStreamRec = (
        ObjType: 1100;
        VmtLink: Ofs(TypeOf(TTrialLabel)^);
        Load: @TLabel.Load;             {using ancestor's load}
        Store: @TLabel.Store            {using ancestor's store}
    );

    RTrialStaticText: TStreamRec = (
        ObjType: 1102;
        VmtLink: Ofs(TypeOf(TTrialStaticText)^);
        Load: @TStaticText.Load;        {using ancestor's load}
        Store: @TStaticText.Store       {using ancestor's store}
    );

    RTrialParamText: TStreamRec = (
        ObjType: 1112;
        VmtLink: Ofs(TypeOf(TTrialParamText)^);
        Load: @TTrialParamText.Load;
        Store: @TTrialParamText.Store
    );

    RTrialButton: TStreamRec = (
        ObjType: 1101;
        VmtLink: Ofs(TypeOf(TTrialButton)^);
        Load: @TTrialButton.Load;
        Store: @TTrialButton.Store
    );

    RTrialHistory: TStreamRec = (
        ObjType: 1113;
        VmtLink: Ofs(TypeOf(TTrialHistory)^);
        Load: @THistory.Load;           {using ancestor's load}
        Store: @THistory.Store          {using ancestor's store}
    );

    { old version; no History icon }
    RTrialInputLine01: TStreamRec = (
        ObjType: 1103;
        VmtLink: Ofs(TypeOf(TTrialInputLine)^);
        Load: @TTrialInputLine.Load01;  {convert old to new}
        Store: @Abstract                {can't use}
    );

    { newer version; has History ID # }
    RTrialInputLine02: TStreamRec = (
        ObjType: 1114;
        VmtLink: Ofs(TypeOf(TTrialInputLine)^);
        Load: @TTrialInputLine.Load02;  {convert old to new}
        Store: @Abstract                {can't use}
    );

    { newest version; has History ID string }
    RTrialInputLine: TStreamRec = (
        ObjType: 1115;
        VmtLink: Ofs(TypeOf(TTrialInputLine)^);
        Load: @TTrialInputLine.Load;
        Store: @TTrialInputLine.Store
    );

    { old version; no ItemNames }
    RTrialCluster01: TStreamRec = (
        ObjType: 1104;
        VmtLink: Ofs(TypeOf(TTrialCluster)^);
        Load: @TTrialCluster.Load01;    {convert old to new}
        Store: @Abstract                {can't use}
    );

    { new version; has ItemNames }
    RTrialCluster: TStreamRec = (
        ObjType: 1117;
        VmtLink: Ofs(TypeOf(TTrialCluster)^);
        Load: @TTrialCluster.Load;
        Store: @TTrialCluster.Store
    );

    RTrialRadioButtons: TStreamRec = (
        ObjType: 1106;
        VmtLink: Ofs(TypeOf(TTrialRadioButtons)^);
        Load: @TTrialRadioButtons.Load;
        Store: @TTrialRadioButtons.Store
    );

    RTrialCheckBoxes: TStreamRec = (
        ObjType: 1105;
        VmtLink: Ofs(TypeOf(TTrialCheckBoxes)^);
        Load: @TTrialCheckBoxes.Load;
        Store: @TTrialCheckBoxes.Store
    );

    RTrialMultiCheckBoxes: TStreamRec = (
        ObjType: 1111;
        VmtLink: Ofs(TypeOf(TTrialMultiCheckBoxes)^);
        Load: @TTrialMultiCheckBoxes.Load;
        Store: @TTrialMultiCheckBoxes.Store
    );

    RTrialScrollBar: TStreamRec = (
        ObjType: 1109;
        VmtLink: Ofs(TypeOf(TTrialScrollBar)^);
        Load: @TTrialScrollBar.Load;
        Store: @TTrialScrollBar.Store
    );

    RTrialListBox: TStreamRec = (
        ObjType: 1110;
        VmtLink: Ofs(TypeOf(TTrialListBox)^);
        Load: @TTrialListBox.Load;
        Store: @TTrialListBox.Store
    );

    RTrialDialogBackground: TStreamRec = (
        ObjType: 1107;
        VmtLink: Ofs(TypeOf(TTrialDialogBackground)^);
        Load: @TTrialDialogBackground.Load;
        Store: @TTrialDialogBackground.Store
    );

    { old version }
    RTrialDialog01: TStreamRec = (
        ObjType: 1108;
        VmtLink: Ofs(TypeOf(TTrialDialog)^);
        Load: @TTrialDialog.Load01; {convert to new}
        Store: @Abstract            {can't use}
    );

    { new version }
    RTrialDialog: TStreamRec = (
        ObjType: 1116;
        VmtLink: Ofs(TypeOf(TTrialDialog)^);
        Load: @TTrialDialog.Load;
        Store: @TTrialDialog.Store
    );

    { ObjType: 1100..1117 }

procedure RegisterTrialObjects;
begin
    RegisterType(RTrialLabel);
    RegisterType(RTrialStaticText);
    RegisterType(RTrialParamText);
    RegisterType(RTrialButton);
    RegisterType(RTrialHistory);
    RegisterType(RTrialInputLine01);
    RegisterType(RTrialInputLine02);
    RegisterType(RTrialInputLine);
    RegisterType(RTrialCluster01);
    RegisterType(RTrialCluster);
    RegisterType(RTrialRadioButtons);
    RegisterType(RTrialCheckBoxes);
    RegisterType(RTrialMultiCheckBoxes);
    RegisterType(RTrialScrollBar);
    RegisterType(RTrialListBox);
    RegisterType(RTrialDialogBackground);
    RegisterType(RTrialDialog01);
    RegisterType(RTrialDialog);
end; {RegisterTrialObjects}

{*******************************************************}

{ Global data and objects }

var
    GenPart:        TGenPart;   {code generation phase}
    DialSaved:      boolean;    {current dialog was saved}
    AutoSave:       boolean;    {save without asking}

    FileOptData:    TFileOptData;   {filename choices}
    OutOptData:     TOutOptData;    {output options}

    TrialDialog:    PTrialDialog;   {current trial dialog}
    RealDialog:     PDialog;        {current test dialog}
    CurrDialog:     TTitleStr;      {name of current dialog}
    PrevDialog:     TTitleStr;      {name of previous dialog}
    DialEditApp:    TDialEditApp;   {this TApplication}

    CollFile:       PResourceFile;  {collection of trial dialogs}
    CollFMode:      word;           {file mode of above}
    { also resource file for real dialogs ? }                       {++}

    Paste:          TEditBuffer;        {paste buffer for edits}
    PasteStrings:   PStringCollection;  {  "     "  for item strings}
    PasteNames:     PStringCollection;  {  "     "  for item names}
    ModeToken:      PToken;             {paste / default indicator}
    SwapToken:      PToken;             {'icon' for swap command}

    DLim:           TRect;      {for dialog placement}
    Tab:            string5;    {for indenting output code}

    { temporary variables for code generation: }
    GenVars: word;
    ValUsed: boolean;       {validator used}
    SBLink: PScrollBar;
    LLink: PView;
    Semicolon: boolean;
    ListHistConsts: boolean;    {history ID names used}
    HistIdVal: word;
    ListClustConsts: boolean;   {Cluster const names used}

{*******************************************************}

{ move / re-size trial object by dragging: }
{ also clear Event }
procedure DragIt(var View: TView; var Event: TEvent);
var
    Lims: TRect;
    MinSz, MaxSz: TPoint;
    D: byte;
begin
    with View do begin
        Owner^.GetExtent(Lims);
        Lims.Grow(-1,-1);
        SizeLimits(MinSz, MaxSz);
        case Event.Buttons of
         mbLeftButton: D:= dmDragMove;
         mbRightButton: D:= dmDragGrow;
        end;
        DragView(Event, D or DragMode, Lims, MinSz, MaxSz);
        DialSaved:= false;
        ClearEvent(Event);
    end;
end; {DragIt}

{ move / re-size trial object by dragging: }
{ also move its label and clear Event }
procedure DragBoth(var View: TView; LabelP: PTrialLabel;
                    var Event: TEvent);
var
    OldR: TRect;
begin
    View.GetBounds(OldR);  {save old bounds}
    DragIt(View, Event);
    if LabelP <> nil then LabelP^.TrackTarget(OldR);
end; {DragBoth}

function NewLabel(const Obj: TView; const ALabel: TTitleStr):
                    PTrialLabel;
var
    R: TRect;
    LP: PTrialLabel;
begin
    Obj.GetBounds(R);
    R.Move(0, -1);
    LP:= New(PTrialLabel, Init(R, ALabel, @Obj));
    LP^.GrowTo(CStrLen(ALabel)+2, 1);
    TrialDialog^.Insert(LP);
    NewLabel:= LP;
end; {NewLabel}

procedure CodeBounds(const View: TView);
begin
    with View do begin
        writeln(Tab+'R.Assign(',
            Origin.X, ', ',
            Origin.Y, ', ',
            Origin.X + Size.X, ', ',
            Origin.Y + Size.Y, ');'
        );
    end;
end; {CodeBounds}

procedure InitBounds(var R: TRect; SX, SY: integer);
var
    PX, PY: integer;
begin
    PX:= TrialDialog^.Size.X - 2;
    PY:= TrialDialog^.Size.Y - 2;
    R.Assign(PX-SX, PY-SY, PX, PY);
end; {InitBounds}

procedure CopyStrings(Dest, Src: PStringCollection);
var
    I: integer;
    S: ^string;
begin
    if Dest = nil then New(Dest, Init(16, 16));         {++}
    Dest^.FreeAll;
    if Src <> nil then begin
        for I:= 0 to Src^.Count-1 do begin
            S:= Src^.At(I);
            Dest^.AtInsert(I, NewStr(S^));
        end;
    end;
end; {CopyStrings}

procedure SplitStrings(DestL, DestR, Src: PStringCollection);
var
    I, J: integer;
    S: string;
begin
    if DestL = nil then exit;   {++ then error! ++}
    if DestR = nil then exit;
    DestL^.FreeAll;
    DestR^.FreeAll;
    if Src <> nil then begin
        for I:= 0 to Src^.Count-1 do begin
            S:= GetStr(Src^.At(I));
            J:= Pos('`', S);
            if J > 0 then begin
                DestL^.AtInsert(I, NewStr(Copy(S,1,J-1)));
                DestR^.AtInsert(I, NewStr(Copy(S,J+1,255)));
            end else begin
                DestL^.AtInsert(I, NewStr(S));
                DestR^.AtInsert(I, NewStr(''));
            end;
        end;
    end;
end; {SplitStrings}

procedure JoinStrings(Dest, SrcL, SrcR: PStringCollection);
var
    I, J: integer;
    SL, SR: string;
begin
    if Dest = nil then exit;    {++ then error! ++}
    Dest^.FreeAll;
    if (SrcL <> nil) and (SrcR <> nil) then begin
        for I:= 0 to SrcL^.Count-1 do begin
            SL:= GetStr(SrcL^.At(I));
            SR:= GetStr(SrcR^.At(I));
            if Length(SR) > 0 then begin
                Dest^.AtInsert(I, NewStr(SL+'`'+SR));
            end else begin
                Dest^.AtInsert(I, NewStr(SL));
            end;
        end;
    end;
end; {JoinStrings}

procedure InitStrings(var ClusterData: TClusterData);
begin
    with ClusterData do begin
        RStrings:= New(PStringCollection, Init(16, 16));
        RItemNames:= New(PStringCollection, Init(16, 16));
        if ModeToken^.State and sfPaste <> 0 then begin
            CopyStrings(RStrings, PasteStrings);
            CopyStrings(RItemNames, PasteNames);
        end else begin
            { insert edit position: }
            with RStrings^ do AtInsert(Count, NewStr(' '));
        end;
    end;
end; {InitStrings}

{ escape any single-quotes in a string: }
{ need to use this when putting literal }
{ strings into Pascal code output       }

function EscQuot(S: string): string;
var
    I: integer;
begin
    for I:= Length(S) downto 1 do begin
        if S[I] = ''''
        then System.Insert('''', S, I);
    end;
    EscQuot:= S;
end; {EscQuot}

procedure GenImplementation;
begin
    if OutOptData.GenFormat <> 0 then begin
        writeln('implementation');
        writeln;
        write('uses Menus');
        { TvInput needed for standard validators: }
        if ValUsed then write(', TvInput');
        writeln(';');
        writeln;
    end;
end; {GenImplementation}

{*******************************************************}

const
    StreamBufSize = 1024;

procedure OpenCollFile;
var
    F: file;
begin
    Assign(F, FileOptData.CollFName);
    {$I-}
    Reset(F);
    if IoResult = 0 then CollFMode:= stOpen else CollFMode:= stCreate;
    Close(F);
    {$I+}
    CollFile:= New(PResourceFile, Init(
              New(PBufStream, Init(FileOptData.CollFName, CollFMode,
                    StreamBufSize))));
end; {OpenCollFile}

procedure CloseCollFile;
var
    S: PStream;
begin
    if CollFile = nil then exit;
    CollFile^.Flush;
    if CollFile^.Modified then begin
        { copy & pack to temporary BufStream: }
        S:= CollFile^.SwitchTo(New(
            PBufStream, Init('DialColl.tmp', stCreate, StreamBufSize)
        ), true);
        S^.Free;
        { copy back to original BufStream: }
        S:= CollFile^.SwitchTo(New(
            PBufStream, Init(FileOptData.CollFName, stCreate,
                    StreamBufSize)
        ), false);
        S^.Free;
    end;
    CollFile^.Free;
    CollFile:= nil;
end; {CloseCollFile}

procedure OpenCodeFile;
var
    Dir:  DirStr;
    Name: NameStr;
    Ext:  ExtStr;
begin
    if GenPart = gpDisabled then begin
        Assign(Output, FileOptData.CodeFName);
        Rewrite(Output);
        GenPart:= gpFileHeader;
        if OutOptData.GenFormat <> 0 then begin
            FSplit(FileOptData.CodeFName, Dir, Name, Ext);
            writeln('unit ', Name, ';');
            writeln;
            writeln('interface');
            writeln;
            writeln('uses Objects, Views, Dialogs;');
            writeln;
        end;
    end;
end; {OpenCodeFile}

procedure CloseCodeFile;
begin
    if GenPart <> gpDisabled then begin
        if OutOptData.GenFormat <> 0 then begin
            GenPart:= gpFileFooter;
            writeln('begin end.');
            Close(Output);
        end;
        GenPart:= gpDisabled;
    end;
end; {CloseCodeFile}

{ remember current and previous dialog names: }
procedure RemDialog(Name: string);
begin
    if Name = '' then begin
        Application^.DisableCommands([cmSwapDialogs]);
    end else if Name <> CurrDialog then begin
        if CurrDialog <> '' then PrevDialog:= CurrDialog;
        if PrevDialog <> ''
        then Application^.EnableCommands([cmSwapDialogs])
        else Application^.DisableCommands([cmSwapDialogs]);
    end;
    CurrDialog:= Name;
    DialSaved:= true;
end; {RemDialog}

procedure SaveDialog;
var
    S: string;
begin
    if TrialDialog = nil then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    { open resource file also }                                     {++}
    with TrialDialog^ do begin
        S:= GetStr(BaseName) + GetStr(TypeName);
    end;
    if (S = '') or (S[1] = ' ') then begin
        MessageBox('Dialog has no name.', nil, mfError+mfOkButton);
        exit;
    end;
    CollFile^.Put(TrialDialog, S);
    { put RealDialog into resource file }                           {++}
    { if AutoSave, we must avoid calling RemDialog twice: }
    if not AutoSave then RemDialog(S);
end; {SaveDialog}

procedure DeleteDialog;
var
    S: string;
    P: ^string;
begin
    if TrialDialog = nil then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    with TrialDialog^ do begin
        S:= GetStr(BaseName) + GetStr(TypeName);
    end;
    if (S = '') or (S[1] = ' ') then begin
        MessageBox('Dialog has no name.', nil, mfError+mfOkButton);
        exit;
    end;
    P:= @S;
    if MessageBox('Delete "%s"?', @P,
        mfConfirmation + mfYesButton + mfNoButton) = cmYes
    then begin
        CollFile^.Delete(S);
        { also delete from resource file }                          {++}
        RemDialog('');
    end;
end; {DeleteDialog}

procedure GetDialog(const Name: TTitleStr);
var
    PV: PTrialDialog;
begin
    if Name = '' then exit;
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    { open resource file also ? }                                   {++}
    with CollFile^ do begin
        Flush;
        PV:= PTrialDialog(Get(Name));
        if PV <> nil then begin
            if TrialDialog <> nil then begin
                TrialDialog^.Close;
                { Close disables commands; re-enable them: }
                Application^.EnableCommands(cmsNewControls);
            end;
            DeskTop^.Insert(PView(PV));
            TrialDialog:= PTrialDialog(PV);
            { also fetch from resource file ? }                     {++}
            RemDialog(Name);
        end;
    end;
end; {GetDialog}

{*******************************************************}
{                                                       }
{                   FetchDialog                         }
{                                                       }
{       'Plural' mode fetches & generates code for      }
{       one or more dialogs.  'Single' mode fetches     }
{       one dialog from CollFile and inserts it as      }
{       new TrialDialog for editing.                    }
{                                                       }
{*******************************************************}

procedure FetchDialog(Plural: boolean);
var
    I, J: integer;
    DD: TFetchDialogData;
    PV: PTrialDialog;
    S: string;
    GV: array[0..99] of word;                               {+}

begin
    if CollFile = nil then OpenCollFile;
    if CollFile = nil then exit;
    with CollFile^ do begin
        Flush;
        { copy strings from CollFile to DD.RNames: }
        if Count = 0 then exit;
        DD.RNames:= New(PStringCollection, Init(16, 16));
        for I:= 0 to Count-1 do begin
            S:= ' ' + KeyAt(I);
            DD.RNames^.AtInsert(I, NewStr(S));
        end;
        DD.RSelection:= 0;

        { pick dialog(s) to do: }
        if DialEditApp.ExecuteDialog(New(PFetchDialogDialog,
                Init(Plural)), @DD) = cmCancel
        then begin
            Dispose(DD.RNames, Done);
            exit;
        end;

        if Plural then begin
            { check if any picked: }
            J:= 0;
            for I:= 0 to DD.RNames^.Count-1 do begin
                S:= GetStr(DD.RNames^.At(I));
                if S[1] <> ' ' then inc(J);
            end;
            if J = 0 then begin
                MessageBox('No output selected.',
                    nil, mfError+mfOkButton);
                Dispose(DD.RNames, Done);
                exit;
            end;

            OpenCodeFile;   {open file if closed}

            { do pictures before code generation: }
            if OutOptData.RInclude and 1 <> 0 then begin
                if OutOptData.RInclude and 2 <> 0 then writeln('(*');
                if TrialDialog <> nil then begin
                    TrialDialog^.Close;
                    { Close disables commands }
                end;
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            DeskTop^.Insert(PView(PV));
                            with OutOptData
                            do PV^.SnapPicture(RShow, RShades);
                            { or, PV^.Close; }                      {+}
                            DeskTop^.Delete(PView(PV));
                            PV^.Free;
                        end;
                    end;
                end;
                if OutOptData.RInclude and 2 <> 0 then writeln('*)');
                writeln;
            end;

            if OutOptData.RInclude and 2 <> 0 then begin
                { first pass of code generation: }
                ListHistConsts:= false;
                ValUsed:= false;
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            GenPart:= gpDialogHeader;
                            PV^.GenCode;
                            GV[I]:= GenVars;
                            PV^.Free;
                        end;
                    end;
                end;

                GenImplementation;

                { extra pass of code generation: }
                if ListHistConsts then begin
                    writeln('const');
                    HistIdVal:= 1;
                    for I:= 0 to DD.RNames^.Count-1 do begin
                        S:= GetStr(DD.RNames^.At(I));
                        if S[1] <> ' ' then begin
                            System.Delete(S, 1, 1);
                            PV:= PTrialDialog(Get(S));
                            if PV <> nil then begin
                                GenPart:= gpHistConsts;
                                GenVars:= GV[I];
                                PV^.GenCode;
                                PV^.Free;
                            end;
                        end;
                    end;
                    writeln;
                end;

                { second pass of code generation: }
                for I:= 0 to DD.RNames^.Count-1 do begin
                    S:= GetStr(DD.RNames^.At(I));
                    if S[1] <> ' ' then begin
                        System.Delete(S, 1, 1);
                        PV:= PTrialDialog(Get(S));
                        if PV <> nil then begin
                            GenPart:= gpDialogInit;
                            GenVars:= GV[I];
                            PV^.GenCode;
                            PV^.Free;
                        end;
                    end;
                end;
            end; {if}

            { optionally fetch & convert to real dialog resource? } {++}

        { else single mode - just fetch one dialog: }
        end else begin
            S:= GetStr(DD.RNames^.At(DD.RSelection));
            System.Delete(S, 1, 1);
            {PV:= PTrialDialog(Get(S));}                        {?} {+}
            GetDialog(S);
        end;
    end;
    Dispose(DD.RNames, Done);
end; {FetchDialog}

procedure TestDialog;   {++ can use to create default data ++}
var
    TrialData: pointer;
    DSz, Cmd: word;
    SavedGP: TGenPart;
begin
    if TrialDialog = nil then exit;
    SavedGP:= GenPart;
    GenPart:= gpClone;
    TrialDialog^.GenCode;
    GenPart:= SavedGP;
    if RealDialog = nil then exit;
    {TrialDialog^.Close;}

    DSz:= RealDialog^.DataSize;
    if DSz > 0 then begin
        GetMem(TrialData, DSz);
        FillChar(TrialData^, DSz, 0);
        TrialDialog^.GetData(TrialData^);
        { transfer data: TrialDialog -> RealDialog }
        Cmd:= DialEditApp.ExecuteDialog(RealDialog, TrialData);
        { transfer data: RealDialog -> TrialDialog }
        if Cmd <> cmCancel then TrialDialog^.SetData(TrialData^);
        FreeMem(TrialData, DSz);
    end else begin
        Cmd:= DialEditApp.ExecuteDialog(RealDialog, nil);
    end;
    RealDialog:= nil;
end; {TestDialog}

{ read History and Default data: }
procedure ReadHistory;
var
    S: PStream;
    F: file;
const
    M: string = 'Cannot read edit default data.';

begin
    Assign(F, FileOptData.HistFName);
    {$I-}
    Reset(F);
    if IoResult <> 0 then exit;
    Close(F);
    {$I+}
    S:= New(PBufStream, Init(FileOptData.HistFName, stOpen,
            StreamBufSize));
    if S <> nil then begin
        LoadHistory(S^);
        StreamErrMsg:= @M;
        S^.Read(Paste, SizeOf(Paste));
        if S^.Status = stOk
        then Default:= Paste
        else Paste:= Default;
        StreamErrMsg:= nil;
        S^.Free;  {Done ?}                              {+++}
    end;
end; {ReadHistory}

procedure WriteHistory;
var
    S: PStream;
begin
    S:= New(PBufStream, Init(FileOptData.HistFName, stCreate,
            StreamBufSize));
    if S <> nil then begin
        StoreHistory(S^);
        S^.Write(Default, SizeOf(Default));
        S^.Free;  {Done ?}                              {+++}
    end;
end; {WriteHistory}

{$IFDEF ScreenCapture}
procedure ScreenCapture(const Bounds: TRect);
type
    TScreen = array [0..49, 0..79, 0..1] of char;
var
    Screen: TScreen absolute $B800:0;
    X, Y: integer;
    S: string[80];
    Ch: char;
    Attr: byte;
const
    BackGrd = '\B1'{'\B0'};
    Shadow = ' '{'\B1'};
begin
    with Bounds do
    for Y:= A.Y to B.Y do begin
        S[0]:= Chr(B.X-A.X+1);
        for X:= A.X to B.X do begin
            Ch:= Screen[Y, X, 0];
            Attr:= Ord(Screen[Y, X, 1]);
            if (X=A.X) and (Y=B.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) and (Y=A.Y) then begin
                S[X-A.X+1]:= ' ';
            end else if (X=B.X) or (Y=B.Y) then begin
                S[X-A.X+1]:= Shadow;
            end else if (Ch = ' ') and
              ((Attr and $70) = $70) then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = '\B0' then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = '\F0' then begin
                S[X-A.X+1]:= BackGrd;
            end else if Ch = #7 then begin
                S[X-A.X+1]:= '\FE';
            end else begin
                S[X-A.X+1]:= Ch;
            end;
        end;
        writeln(S);
    end;
end; {ScreenCapture}
{$ENDIF}

{*******************************************************}

{ ControlEditDialog }

constructor TControlEditDialog.Init(var Bounds: TRect;
                                ATitle: TTitleStr);
begin
    Bounds.Move(DLim.B.X - Bounds.B.X, DLim.B.Y - Bounds.B.Y);
    if TrialDialog <> nil
    then TrialDialog^.SetState(sfActive, false);
    inherited Init(Bounds, ATitle);
{$IFDEF ScreenCapture}
    EnableCommands([cmScreenCapture]);
{$ENDIF}
end;

destructor TControlEditDialog.Done;
begin
    inherited Done;
    if TrialDialog <> nil
    then TrialDialog^.SetState(sfActive, true);
end;

procedure TControlEditDialog.HandleEvent(var Event: TEvent);
var
    R: TRect;
    C: word;
begin
{$IFDEF ScreenCapture}
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        GetExtent(R);
        MakeGlobal(R.A, R.A);
        MakeGlobal(R.B, R.B);
        ScreenCapture(R);
        ClearEvent(Event);
    end;
{$ENDIF}

    inherited HandleEvent(Event);

    case Event.What of
     evCommand:
        case Event.Command of
         cmSetDefault:          {Save}
            begin
                EndModal(cmSetDefault);
                ModeToken^.SetState(sfPaste, false);
            end;
         cmSetPaste:            {Copy}
            begin
                EndModal(cmSetPaste);
                ModeToken^.SetState(sfPaste, true);
            end;
         else
            exit;
        end; {case}

     else
        exit;
    end; {case}
    ModeToken^.Draw;
    ClearEvent(Event);
end; {TControlEditDialog.HandleEvent}

procedure TControlEditDialog.MakeDialogNames(SX: integer);
var
    R: TRect;
    IL: PInputLine;
begin
    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 10, 4);
    Insert(New(PLabel, Init(R, '~L~abel', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, '~D~ata Name', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDataName)));
end; {TControlEditDialog.MakeDialogNames}

{ Change is true for editing, false for init'zn. }
{ also centers dialog }
procedure TControlEditDialog.MakeDialogButtons(X1, X2, SY: integer;
                            Change: boolean; OkMode: word);
var
    R: TRect;
begin
    if Change then begin
        R.Assign(X1-5, SY-10, X1+5, SY-8);
        Insert(New(PButton, Init(R, 'D~e~lete', cmDelete, bfNormal)));
        R.Assign(X2-5, SY-10, X2+5, SY-8);
        Insert(New(PButton, Init(R, 'On ~T~op', cmPutOnTop, bfNormal)));
    end;

    R.Assign(X1-5, SY-7, X1+5, SY-5);
    Insert(New(PButton, Init(R, 'Sa~v~e', cmSetDefault, bfNormal)));
    R.Assign(X2-5, SY-7, X2+5, SY-5);
    Insert(New(PButton, Init(R, 'Cop~y~', cmSetPaste, bfNormal)));

    R.Assign(X1-5, SY-4, X1+5, SY-2);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));
    R.Assign(X2-5, SY-4, X2+5, SY-2);
    Insert(New(PButton, Init(R, '~O~k', cmOk, OkMode)));
end; {TControlEditDialog.MakeDialogButtons}

{*******************************************************}

{ TrialLabel }

constructor TTrialLabel.Init(var Bounds: TRect; AText: TTitleStr;
                            ALink: PView);
begin
    inherited Init(Bounds, AText, ALink);
    if AText = '' then Hide;                                {+}
    DragMode:= dmLimitAll;
end; {TTrialLabel.Init}

procedure TTrialLabel.HandleEvent(var Event: TEvent);
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then begin
            if Link <> nil then Link^.HandleEvent(Event);
        end else begin
            { move / re-size Label by dragging: }
            if Link <> nil then PutInFrontOf(Link);
            DragIt(Self, Event);
            DialSaved:= false;
        end;
    end;
end; {TTrialLabel.HandleEvent}

procedure TTrialLabel.SizeLimits(var MinSz, MaxSz: TPoint);
var
    L: word;
begin
    inherited SizeLimits(MinSz, MaxSz);
    L:= CStrLen(Text^);
    MinSz.X:= L+1;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  MaxSz.Y:= 1;
end; {TTrialLabel.SizeLimits}

procedure TTrialLabel.GenCode(const LinkName: string);
var
    R: TRect;
begin
    if Text <> nil then begin
        case GenPart of
         gpControls:
            begin
                CodeBounds(Self);
                writeln(Tab+'Insert(New(PLabel, Init(R, ''',
                    EscQuot(Text^), ''', ', LinkName, ')));'
                );
            end;

         gpClone:
            begin
                GetBounds(R);
                RealDialog^.Insert(New(PLabel, Init(R, Text^, LLink)));
            end;
        end; {case}
    end;
end; {TTrialLabel.GenCode}

procedure TTrialLabel.ChangeText(const ALabel: string);
var
    L: integer;
begin
    if ALabel <> '' then begin
        if Text = nil then begin        {add label}
            L:= 0;
            Origin.X:= Link^.Origin.X;
            Origin.Y:= Link^.Origin.Y-1;
            Text:= NewStr(ALabel);
            Show;
        end else begin                  {change label}
            L:= CStrLen(GetStr(Text));
            ChangeStr(Text, ALabel);
            Draw;
        end;
        Dec(L, CStrLen(ALabel));
        if L <> 0 then GrowTo(Size.X-L, 1);
    end else begin                      {"delete" label}
        DisposeStr(Text);
        Hide;
    end;
end; {TTrialLabel.ChangeText}

{ Move label after target (Link^) is dragged: }
{ (OldX,OldY is Link^.Origin before dragging) }
procedure TTrialLabel.TrackTarget(const OldR: TRect);
var
    SX, SY: integer;
begin
    { is Label at right of target? }
    if Origin.X + (Size.X div 2) > (OldR.A.X + OldR.B.X) div 2
    then SX:= Link^.Size.X + OldR.A.X - OldR.B.X else SX:= 0;
    { is Label below target? }
    if Origin.Y > (OldR.A.Y + OldR.B.Y) div 2
    then SY:= Link^.Size.Y + OldR.A.Y - OldR.B.Y else SY:= 0;
    MoveTo(Origin.X + Link^.Origin.X + SX - OldR.A.X,
           Origin.Y + Link^.Origin.Y + SY - OldR.A.Y);
end; {TTrialLabel.TrackTarget}

{*******************************************************}

{ StaticTextDialog }

constructor TStaticTextDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 27;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 17;  DT:= 'Change';
    end else begin
        SY:= 14;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' StaticText';
    inherited Init(R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, 'Te~x~t', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiStaticText)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
    IL^.Select;
end; {TStaticTextDialog.Init}

{ TrialStaticText }

constructor TTrialStaticText.Init(AData: PStaticTextData);
var
    R: TRect;
begin
    with AData^ do begin
        InitBounds(R, CStrLen(RText), 1);
        inherited Init(R, RText);
        DragMode:= dmLimitAll;
    end;
end; {TTrialStaticText.Init}

function TTrialStaticText.Execute: word;
var
    R: TRect;
begin
    case GenPart of
     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            writeln(Tab+'Insert(New(PStaticText, Init(R, ''',
                EscQuot(GetStr(Text)), ''')));'
            );
        end;

     gpClone:
        begin
            GetBounds(R);
            RealDialog^.Insert(New(PStaticText, Init(R, GetStr(Text))));
        end;
    end; {case}
end; {TTrialStaticText.Execute}

procedure TTrialStaticText.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
    PS: PTrialStaticText;
    StaticTextData: TStaticTextData;
    L: integer;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with StaticTextData do begin
            { edit StaticText with StaticTextDialog: }
            RText:= GetStr(Text);
            L:= Length(RText);

            PD:= PDialog(New(PStaticTextDialog, Init(true)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @StaticTextData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    if RText <> '' then begin
                        ChangeStr(Text, RText);
                        Dec(L, Length(RText));
                        if L <> 0 then GrowTo(Size.X-L, 1);
                        if Cmd = cmPutOnTop then MakeFirst;
                    end else begin
                        Free;
                    end;
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    Free;
                    DialSaved:= false;
                end;

             cmSetDefault: Default.DStaticText:= StaticTextData;

             cmSetPaste: Paste.DStaticText:= StaticTextData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size StaticText by dragging: }
            DragIt(Self, Event);
        end;
    end;
end; {TTrialStaticText.HandleEvent}

procedure TTrialStaticText.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 1;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialStaticText.SizeLimits}

{*******************************************************}

{ ParamTextDialog }

constructor TParamTextDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 39;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 20;  DT:= 'Change';
    end else begin
        SY:= 17;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' ParamText';
    inherited Init(R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, '~F~ormat', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiStaticText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, 'Parameter ~N~ames', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TParamTextDialog.Init}

{ TrialParamText }

constructor TTrialParamText.Init(AData: PParamTextData);
var
    R: TRect;
    I, N: integer;
begin
    with AData^ do begin
        InitBounds(R, Length(RFormat), 1);
        N:= 1;
        for I:= 1 to Length(RNames) do begin
            if RNames[I] = ',' then inc(N);
        end;
        inherited Init(R, RFormat, N);
        Names:= NewStr(RNames);
        DragMode:= dmLimitAll;
    end;
end; {TTrialParamText.Init}

destructor TTrialParamText.Done;
begin
    DisposeStr(Names);
    inherited Done;
end; {TTrialParamText.Done}

function TTrialParamText.Execute: word;
var
    SF, SN: string;
    I, J: integer;
    R: TRect;
begin
    case GenPart of
     gpDataFields:
        begin
            SN:= GetStr(Names) + ',';
            SF:= GetStr(Text);
            repeat
                J:= Pos(',', SN);
                if J > 0 then begin
                    write(Tab+Tab, Copy(SN, 1, J-1), ': ');
                    Delete(SN, 1, J);
                    while SN[1] = ' ' do Delete(SN, 1, 1);
                    J:= Pos('%', SF);
                    if J > 0 then begin
                        Delete(SF, 1, J);
                        while SF[1] in ['-', '0'..'9']
                        do Delete(SF, 1, 1);
                        case SF[1] of
                        's': write('^string');
                        'c': write('longint {lo char}');
                        'd', 'x': write('longint');
                        end;
                        Delete(SF, 1, 1);
                    end;
                    writeln(';');
                end;
            until J = 0;
        end;

     gpDataValues:      { similar to gpDataFields -- merge ? }      {++}
        begin
            SN:= GetStr(Names) + ',';
            SF:= GetStr(Text);
            repeat
                J:= Pos(',', SN);
                if J > 0 then begin
                    if Semicolon then writeln(';');
                    Semicolon:= true;
                    write(Tab+Tab, Copy(SN, 1, J-1), ': ');
                    Delete(SN, 1, J);
                    while SN[1] = ' ' do Delete(SN, 1, 1);
                    J:= Pos('%', SF);
                    if J > 0 then begin
                        Delete(SF, 1, J);
                        while SF[1] in ['-', '0'..'9']
                        do Delete(SF, 1, 1);
                        case SF[1] of
                        's': write('nil');
                        'c': write('$20');
                        'd': write('0');
                        'x': write('$0');
                        end;
                        Delete(SF, 1, 1);
                    end;
                end;
            until J = 0;
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            writeln(Tab+'Insert(New(PParamText, Init(R, ''',
                EscQuot(GetStr(Text)), ''', ', ParamCount, ')));'
            );
        end;

     gpClone:
        begin
            GetBounds(R);
            RealDialog^.Insert(New(PParamText, Init(R,
                GetStr(Text), ParamCount)));
        end;
    end; {case}
end; {TTrialParamText.Execute}

procedure TTrialParamText.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
    PS: PTrialParamText;
    ParamTextData: TParamTextData;
    L: integer;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ParamTextData do begin
            { edit ParamText with ParamTextDialog: }
            RFormat:= GetStr(Text);
            L:= Length(RFormat);
            RNames:= GetStr(Names);

            PD:= PDialog(New(PParamTextDialog, Init(true)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @ParamTextData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    if (RFormat <> '') and (RNames <> '') then begin
                        ChangeStr(Text, RFormat);
                        ChangeStr(Names, RNames);
                        Dec(L, Length(RFormat));
                        if L <> 0 then GrowTo(Size.X-L, 1);
                        if Cmd = cmPutOnTop then MakeFirst;
                    end else Free;
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    Free;
                    DialSaved:= false;
                end;

             cmSetDefault: Default.DParamText:= ParamTextData;

             cmSetPaste: Paste.DParamText:= ParamTextData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size ParamText by dragging: }
            DragIt(Self, Event);
        end;
    end;
end; {TTrialParamText.HandleEvent}

procedure TTrialParamText.SizeLimits(var Min, Max: TPoint);
begin
    inherited SizeLimits(Min, Max);
    Min.X:= 1;  Dec(Max.X,2);
    Min.Y:= 1;  Dec(Max.Y,2);
end; {TTrialParamText.SizeLimits}

procedure TTrialParamText.GetText2(var S: String);
begin
    { Since the trial ParamText has no real data, }
    { display the format text without data conversion: }
    TStaticText.GetText(S);
end; {TTrialParamText.GetText2}

constructor TTrialParamText.Load(var S: TStream);
begin
    inherited Load(S);
    Names:= S.ReadStr;
end; {TTrialParamText.Load}

procedure TTrialParamText.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(Names);
end; {TTrialParamText.Store}

{*******************************************************}

{ ButtonDialog }

constructor TButtonDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    V: PView;
    DT: TTitleStr;
    SY: integer;
const
    SX = 27;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 26;  DT:= 'Change';
    end else begin
        SY:= 23;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' Button';
    inherited Init(R, DT);

    R.Assign(3, 4, SX-6, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, 'Button ~T~ext', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(3, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, 'Command ~N~ame', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiCmdName)));

    R.Assign(3, 10, 22, 14);
    V:= New(PCheckBoxes, Init(R,
        NewSItem('bf~D~efault',
        NewSItem('bf~L~eftJustify',
        NewSItem('bf~B~roadcast',
        NewSItem('bf~G~rabFocus',
        nil))))
    ));  Insert(V);
    R.Assign(3,  9, 20, 10);
    Insert(New(PLabel, Init(R, 'Button ~F~lags', V)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TButtonDialog.Init}

{ TrialButton }

constructor TTrialButton.Init(AData: PButtonData);
var
    R: TRect;
    L: integer;
begin
    with AData^ do begin
        L:= CStrLen(RTitle) + 4;
        if L < 10 then L:= 10;
        InitBounds(R, L, 2);
        inherited Init(R, RTitle, cmNo, RFlags);
        CmdName:= NewStr(RCmdName);
        DragMode:= dmLimitAll;
    end;
end; {TTrialButton.Init}

destructor TTrialButton.Done;
begin
    DisposeStr(CmdName);
    inherited Done;
end; {TTrialButton.Done}

procedure UpStr(var S: string);
var
    I: integer;
begin
    for I:= 1 to Length(S) do S[I]:= UpCase(S[I]);
end;

function GetVal(SP: PString): word;
var
    S: string;
begin
    S:= GetStr(SP);
    UpStr(S);
    if      S = 'CMOK'      then GetVal:= cmOk
    else if S = 'CMCANCEL'  then GetVal:= cmCancel
    else if S = 'CMYES'     then GetVal:= cmYes
    else if S = 'CMNO'      then GetVal:= cmNo
    else GetVal:= cmError;
end; {GetVal}

function TTrialButton.Execute: word;
var
    S: string;
    R: TRect;
begin
    case GenPart of
     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            if Flags = 0 then begin
                S:= 'bfNormal';
            end else begin
                S:= '';
                if Flags and bfDefault   <> 0
                then S:= S + '+bfDefault';
                if Flags and bfLeftJust  <> 0
                then S:= S + '+bfLeftJust';
                if Flags and bfBroadcast <> 0
                then S:= S + '+bfBroadcast';
                if Flags and bfGrabFocus <> 0
                then S:= S + '+bfGrabFocus';
                Delete(S, 1,1);
            end;

            writeln(Tab+'Insert(New(PButton, Init(R, ''',
                EscQuot(GetStr(Title)), ''', ',
                GetStr(CmdName), ', ',
                S, ')));'
            );
        end;

     gpClone:
        begin
            GetBounds(R);
            RealDialog^.Insert(New(PButton, Init(R,
                GetStr(Title), GetVal(CmdName), Flags)));
        end;
    end; {case}
end; {TTrialButton.Execute}

procedure TTrialButton.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
    PS: PTrialButton;
    ButtonData: TButtonData;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ButtonData do begin
            { edit Button with ButtonDialog: }
            RFlags:= Flags;
            RCmdName:= GetStr(CmdName);
            RTitle:= GetStr(Title);

            PD:= PDialog(New(PButtonDialog, Init(true)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @ButtonData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    Flags:= RFlags;
                    AmDefault:= RFlags and bfDefault <> 0;
                    ChangeStr(CmdName, RCmdName);
                    ChangeStr(Title, RTitle);
                    if Cmd = cmPutOnTop then MakeFirst;
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    Free;
                    DialSaved:= false;
                end;

             cmSetDefault: Default.DButton:= ButtonData;

             cmSetPaste: Paste.DButton:= ButtonData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size Button by dragging: }
            DragIt(Self, Event);
        end;
    end;
end; {TTrialButton.HandleEvent}

procedure TTrialButton.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 5;  Dec(MaxSz.X,2);
    MinSz.Y:= 2;  Dec(MaxSz.Y,2);
end; {TTrialButton.SizeLimits}

constructor TTrialButton.Load(var S: TStream);
begin
    inherited Load(S);
    CmdName:= S.ReadStr;
end; {TTrialButton.Load}

procedure TTrialButton.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(CmdName);
end; {TTrialButton.Store}

{*******************************************************}

{ InputLineDialog }

constructor TInputLineDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 29;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 34;  DT:= 'Change';
    end else begin
        SY:= 31;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' InputLine';
    inherited Init(R, DT);

    MakeDialogNames(SX);

    R.Assign(3, 9, 9, 10);
    IL:= New(PRangeInputLine, Init(R, 4, 1, 255));  Insert(IL);
    R.Assign(9, 9, SX-3, 10);
    Insert(New(PLabel, Init(R, '~M~ax. Line Length', IL)));

    R.Assign(3, 11, 12, 12);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(15, 11, SX-3, 12);
    Insert(New(PLabel, Init(R, '~H~istory ID', IL)));
    R.Assign(12, 11, 15, 12);
    Insert(New(PHistory, Init(R, IL, hiHistID)));

    R.Assign(3, 14, SX-3, 19);
    MRButtons:= New(PMRadioButtons, Init(R,
        NewSItem('~N~one',
        NewSItem('~F~ilter',
        NewSItem('~R~ange (longint)',
        NewSItem('~S~tringLookup',
        NewSItem('P~X~Picture',
        nil)))))
    ));  Insert(MRButtons);
    R.Assign(3, 13, 14, 14);
    Insert(New(PLabel, Init(R, 'Val~i~dator', MRButtons)));

    R.Assign(3, 21, SX-6, 22);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 20, SX-3, 21);
    Insert(New(PLabel, Init(R, 'Validation ~P~arameters', IL)));
    R.Assign(SX-6, 21, SX-3, 22);
    Insert(New(PHistory, Init(R, IL, hiValPars)));

    R.Assign(3, 22, SX-2, 23);
    Advice:= New(PStaticText, Init(R, ''));
    Insert(Advice);

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TInputLineDialog.Init}

procedure TInputLineDialog.HandleEvent(var Event: TEvent);
var
    S: PString;

const
    S0: string = ' (no parameters needed)';
    S1: string = ' ValidChars: TCharSet';
    S2: string = ' Min, Max: longint';
    S3: string = ' S: PStringCollection';
    S4: string = 'Pic:String; Fill:Boolean';

begin
    inherited HandleEvent(Event);
    with Event do begin
        if (What = evBroadcast)
            and (InfoPtr = MRButtons)
            and ((Command = cmListItemSelected) or
                (Command = cmReceivedFocus))
        then begin
            case MRButtons^.Value of
             0: S:= @S0;
             1: S:= @S1;
             2: S:= @S2;
             3: S:= @S3;
             4: S:= @S4;
            end; {case}
            ChangeStr(Advice^.Text, S^);
            Advice^.DrawView;
        end;
    end;
end; {TInputLineDialog.HandleEvent}

{ TrialHistory }

procedure TTrialHistory.HandleEvent(var Event: TEvent);
var
    PS: PView;
begin
    { disable normal actions }
end; {TTrialHistory.HandleEvent}

{ Move History after target (Link^) is dragged: }
{ (OldR is bounds of Link^ before dragging) }
procedure TTrialHistory.TrackTarget(const OldR: TRect);
begin
    { track upper right corner of target: }
    MoveTo(Origin.X + Link^.Origin.X + Link^.Size.X - OldR.B.X,
           Origin.Y + Link^.Origin.Y - OldR.A.Y);
end; {TTrialHistory.TrackTarget}

{ TrialInputLine }

constructor TTrialInputLine.Init(AData: PInputLineData);
var
    R: TRect;
    M: integer;
begin
    with AData^ do begin
        M:= CStrLen(RLabel) + 2;
        if M < 10 then M:= 10;
        InitBounds(R, M, 1);
        inherited Init(R, RMaxLen);
        if (RHistStr <> '') and (RHistStr <> '0')
        and (RHistStr[1] <> ' ') then begin
            MoveTo(Origin.X-3, Origin.Y);
            MakeHistory(RHistStr);
        end else begin
            History:= nil;
            HistStr:= nil;
        end;
        DragMode:= dmLimitAll;
        LabelP:= NewLabel(Self, RLabel);
        DataName:= NewStr(RDataName);
        Validate:= RValidate;
        ValPars:= NewStr(RValPars);
    end;
end; {TTrialInputLine.Init}

destructor TTrialInputLine.Done;
begin
    DisposeStr(DataName);
    DisposeStr(HistStr);
    DisposeStr(ValPars);
    inherited Done;
end; {TTrialInputLine.Done}

procedure TTrialInputLine.MakeHistory(AHistStr: TTitleStr);
var
    R: TRect;
begin
    HistStr:= NewStr(AHistStr);
    R.Assign(
        Origin.X+Size.X,
        Origin.Y,
        Origin.X+Size.X+3,
        Origin.Y+1
    );
    History:= New(PTrialHistory, Init(R, @Self, hiTestID));
    TrialDialog^.Insert(History);
end; {TTrialInputLine.MakeHistory}

function TTrialInputLine.Execute: word;
var
    R: TRect;
    I: longint;
    E: integer;
    S: string;

    function HistName: boolean;
    begin
        HistName:= false;
        if History <> nil then begin
            S:= GetStr(HistStr);
            if (S <> '') and (S[1] in ['_','A'..'Z','a'..'z'])
            then HistName:= true;
        end;
    end; {HistName}

begin
    case GenPart of
     gpDataFields:
        begin
            if Validate = 2 {RangeValidator} then begin
                writeln(Tab+Tab, GetStr(DataName), ': longint;');
            end else begin
                writeln(Tab+Tab, GetStr(DataName), ': string[',
                        MaxLen, '];');
            end;
            GenVars:= GenVars or gvInputLine;
            ValUsed:= ValUsed or (Validate > 0);
            if HistName then ListHistConsts:= true;
        end;

     gpDataValues:
        begin
            if Semicolon then writeln(';');
            Semicolon:= true;
            if Validate = 2 {RangeValidator} then begin
                Val(Data^, I, E);
                if E > 0 then I:= 0;
                write(Tab+Tab, GetStr(DataName), ': ', I);
            end else begin
                write(Tab+Tab, GetStr(DataName), ': ''',
                        EscQuot(GetStr(Data)), '''');
            end;
        end;

     gpHistConsts:
        if HistName then begin
            writeln(Tab, S, ' ='+Tab, HistIdVal, ';');
            inc(HistIdVal);
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(Self);
            write(Tab+'IL:= New(P');
            case Validate of
             1: write('Filter');
             2: write('Range');
             3: write('StringLookup');
             4: write('PXPicture');
            end; {case}
            write('InputLine, Init(R, ', MaxLen);
            if Validate > 0 then begin
                write(', ', GetStr(ValPars));
            end;
            writeln('));  Insert(IL);');
            LabelP^.GenCode('IL');
            if History <> nil then begin
                Convert02;                                      {+}
                CodeBounds(History^);
                writeln(Tab+'Insert(New(PHistory, Init(R, IL, ',
                    GetStr(HistStr), ')));');
            end;
        end;

     gpClone:
        begin
            GetBounds(R);
            {doesn't do Validators}                             {++}
            LLink:= New(PInputLine, Init(R, MaxLen));
            RealDialog^.Insert(LLink);
            LabelP^.GenCode('IL');
            if History <> nil then begin
                History^.GetBounds(R);
                RealDialog^.Insert(New(PHistory, Init(R,
                    PInputLine(LLink), hiTestID)));
            end;
        end;
    end; {case}
end; {TTrialInputLine.Execute}

procedure TTrialInputLine.HandleEvent(var Event: TEvent);
var
    PD: PDialog;
    PS: PTrialInputLine;
    InputLineData: TInputLineData;
    OldR: TRect;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with InputLineData do begin
            { edit InputLine with InputLineDialog: }
            RMaxLen:= MaxLen;
            RDataName:= GetStr(DataName);
            RLabel:= GetStr(LabelP^.Text);
            if History <> nil then begin
                Convert02;                                      {+}
                RHistStr:= GetStr(HistStr);
            end else begin
                RHistStr:= '';
            end;
            RValPars:= GetStr(ValPars);
            RValidate:= Validate;

            PD:= PDialog(New(PInputLineDialog, Init(true)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @InputLineData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    MaxLen:= RMaxLen;
                    ChangeStr(DataName, RDataName);
                    LabelP^.ChangeText(RLabel);
                    if (RHistStr <> '') and (RHistStr <> '0')
                    and (RHistStr[1] <> ' ') then begin
                        if History <> nil then begin
                            ChangeStr(HistStr, RHistStr);   {changed}
                        end else begin
                            GrowTo(Size.X-3, Size.Y);       {added}
                            MakeHistory(RHistStr);
                        end;
                    end else begin
                        if History <> nil then begin
                            GrowTo(Size.X+3, Size.Y);       {deleted}
                            History^.Free;
                            History:= nil;
                            DisposeStr(HistStr);
                        end;
                    end;
                    Validate:= RValidate;
                    if Validate = 0 then RValPars:= '';
                    ChangeStr(ValPars, RValPars);
                    if Cmd = cmPutOnTop then begin
                        MakeFirst;
                        if LabelP <> nil then LabelP^.MakeFirst;
                        if History <> nil then History^.MakeFirst;
                    end;
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    if History <> nil then History^.Free;
                    Free;
                    DialSaved:= false;
                end;

             cmSetDefault: Default.DInputLine:= InputLineData;

             cmSetPaste: Paste.DInputLine:= InputLineData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size InputLine, moving also History & Label: }
            GetBounds(OldR);  {save old bounds}
            DragBoth(Self, LabelP, Event);
            if History <> nil then History^.TrackTarget(OldR);
        end;
    end;
end; {TTrialInputLine.HandleEvent}

procedure TTrialInputLine.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 3;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  MaxSz.Y:= 1;
end; {TTrialInputLine.SizeLimits}

constructor TTrialInputLine.Load01(var S: TStream);             {+}
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    DataName:= S.ReadStr;
    S.Read(Validate, SizeOf(Validate));
    ValPars:= S.ReadStr;
    { version 01 has no History: }
    History:= nil;
    HistStr:= nil;
end; {TTrialInputLine.Load01}

constructor TTrialInputLine.Load02(var S: TStream);             {+}
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    DataName:= S.ReadStr;
    S.Read(Validate, SizeOf(Validate));
    ValPars:= S.ReadStr;
    { version 02 has History pointer, but no ID string: }
    GetPeerViewPtr(S, History);
    HistStr:= nil;  {can't convert now}
    {.. do conversion later, in HandleEvent & Execute}
end; {TTrialInputLine.Load02}

{ convert version 02 InputLine: }
procedure TTrialInputLine.Convert02;                            {+}
var
    IDstr: TTitleStr;
begin
    { assume History <> nil is true: }
    if (HistStr = nil) and (History^.HistoryID <> 0)
    then begin
        Str(History^.HistoryID, IDstr);
        HistStr:= NewStr(IDstr);
        History^.HistoryID:= 0;
    end;
end; {TTrialInputLine.Convert02}

constructor TTrialInputLine.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    DataName:= S.ReadStr;
    S.Read(Validate, SizeOf(Validate));
    ValPars:= S.ReadStr;
    GetPeerViewPtr(S, History);
    HistStr:= S.ReadStr;
end; {TTrialInputLine.Load}

procedure TTrialInputLine.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    S.WriteStr(DataName);
    S.Write(Validate, SizeOf(Validate));
    S.WriteStr(ValPars);
    PutPeerViewPtr(S, History);
    S.WriteStr(HistStr);
end; {TTrialInputLine.Store}

{*******************************************************}

{ Cluster-related objects }

{ ItemDialog }

constructor TItemDialog.Init(T: TTitleStr; FocusName: boolean);
var
    R: TRect;
    ILN, ILT: PInputLine;
begin
    R.Assign(21, 24, 47, 38);
    inherited Init(R, T+' Item');

    R.Assign(3, 4, 20, 5);
    ILN:= New(PInputLine, Init(R, 80));  Insert(ILN);
    R.Assign(3, 3, 15, 4);
    Insert(New(PLabel, Init(R, 'Value ~N~ame', ILN)));
    R.Assign(20, 4, 23, 5);
    Insert(New(PHistory, Init(R, ILN, hiDataName)));

    R.Assign(3, 7, 20, 8);
    ILT:= New(PInputLine, Init(R, 80));  Insert(ILT);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, 'Item ~T~ext', ILT)));
    R.Assign(20, 7, 23, 8);
    Insert(New(PHistory, Init(R, ILT, hiLabelText)));

    R.Assign(2, 10, 12, 12);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(13, 10, 23, 12);
    Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));

    if FocusName then ILN^.Focus else ILT^.Focus;
end; {TItemDialog.Init}

{ ClusterDialog }

constructor TClusterDialog.Init(Change: boolean; ShortName: TShortName);
var
    R: TRect;
    SB: PScrollBar;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 36;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 32;  DT:= 'Change';
    end else begin
        SY:= 29;  DT:= 'New';
    end;

    if ShortName = 'CB' then begin
        DT:= DT + ' CheckBoxes';
    end else if ShortName = 'MB' then begin
        DT:= DT + ' MultiCheckBoxes';
        inc(SY, 3);
    end else begin  {= 'RB'}
        DT:= DT + ' RadioButtons';
    end;

    R.Assign(0, 0, SX, SY);
    inherited Init(R, DT);
    FocusName:= false;

    {MakeDialogNames(SX);}                                  {+++++}

    R.Assign(3, 4, 14, 5);
    IL:= New(PInputLine, Init(R, 80));  Insert(IL);
    R.Assign(3, 3, 10, 4);
    Insert(New(PLabel, Init(R, '~L~abel', IL)));
    R.Assign(14, 4, 17, 5);
    Insert(New(PHistory, Init(R, IL, hiLabelText)));

    R.Assign(19, 4, 30, 5);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(19, 3, 30, 4);
    Insert(New(PLabel, Init(R, 'Data ~N~ame', IL)));
    R.Assign(30, 4, 33, 5);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    R.Assign(18, 7, 19, 17);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(3, 7, 18, 17);
    StrgList:= New(PListBox, Init(R, 1, SB));  Insert(StrgList);
    R.Assign(3, 6, 14, 7);
    Insert(New(PLabel, Init(R, 'Item ~T~ext', StrgList)));

    R.Assign(32, 7, 33, 17);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(20, 7, 32, 17);
    NameList:= New(PListBox, Init(R, 1, SB));  Insert(NameList);
    R.Assign(20, 6, 33, 7);
    Insert(New(PLabel, Init(R, 'Value ~N~ames', NameList)));

    R.Assign(3, 18, 17, 20);
    Insert(New(PButton, Init(R, '~ ~Edit Item', cmEditItem, bfNormal)));

    R.Assign(19, 18, 33, 20);
    Insert(New(PButton, Init(R, '~N~ew Item', cmNewItem, bfDefault)));

    if ShortName = 'MB' then begin
        R.Assign(3, 26, 23, 27);
        IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
        R.Assign(3, 25, 16, 26);
        Insert(New(PLabel, Init(R, 'State ~C~odes', IL)));
        R.Assign(23, 26, 26, 27);
        Insert(New(PHistory, Init(R, IL, hiStates)));
    end;

    MakeDialogButtons(X1, X2, SY, Change, bfNormal);
    StrgList^.Focus;
end; {TClusterDialog.Init}

procedure TClusterDialog.HandleEvent(var Event: TEvent);
var
    ItemData: TItemData;
    Foc: integer;

    procedure NewName;
    begin
        with StrgList^ do begin
            if (ItemData.Strg <> '') and (ItemData.Strg[1] <> ' ') then
            List^.AtInsert(Focused, NewStr(ItemData.Strg));
            SetRange(List^.Count);
            Foc:= Focused;
            FocusItem(Succ(Focused));
            Draw;
        end;
        with NameList^ do begin
            if (ItemData.Strg <> '') and (ItemData.Strg[1] <> ' ') then
            List^.AtInsert(Foc, NewStr(ItemData.Name));
            SetRange(List^.Count);
            FocusItem(Succ(Foc));
            Draw;
        end;
    end; {NewName}

    procedure EditName;
    begin
        ItemData.Strg:= PString(StrgList^.List^.At(StrgList^.Focused))^;
        ItemData.Name:= GetStr(NameList^.List^.At(StrgList^.Focused));
        if ItemData.Strg <> ' ' then begin
            if DialEditApp.ExecuteDialog(New(PItemDialog,
                    Init('Change', FocusName)), @ItemData) = cmOK
            then begin
                Foc:= StrgList^.Focused;
                StrgList^.List^.AtFree(Foc);
                NameList^.List^.AtFree(Foc);
                NewName;
            end;
        end;
    end; {EditName}

begin
    inherited HandleEvent(Event);
    case Event.What of
     evCommand:
        case Event.Command of
         cmNewItem:
            begin
                ItemData.Strg:= '';
                ItemData.Name:= '';
                if DialEditApp.ExecuteDialog(New(PItemDialog,
                        Init('New', FocusName)), @ItemData) = cmOK
                then NewName;
            end;

         cmEditItem: EditName;

         else exit;
        end; {case}

     evBroadcast:
        case Event.Command of
         cmListItemSelected:
            if Event.InfoPtr = StrgList then begin
                FocusName:= false;
                EditName;
            end else if Event.InfoPtr = NameList then begin
                FocusName:= true;
                EditName;
            end else exit;

        end; {case}

     else exit;
    end; {case}
    ClearEvent(Event);
end; {TClusterDialog.HandleEvent}

{ TrialCluster }

constructor TTrialCluster.Init(AData: PClusterData; var CL: TCluster);
begin
    with AData^, CL do begin
        DragMode:= dmLimitAll;
        Value:= 1;  {for demo look}
        DataName:= NewStr(RDataName);
        ShortName:= RShortName;
        with Strings do begin
            Delta:= 16;
            SetLimit(16);
        end;
        ItemNames.Init(16, 16);
        with RStrings^ do AtFree(Count-1);  {delete edit position}
        CopyStrings(@Strings, RStrings);
        CopyStrings(@ItemNames, RItemNames);
    end;
end; {TTrialCluster.Init}

destructor TTrialCluster.Done;
begin
    DisposeStr(DataName);
    ItemNames.Done;
    inherited Done;
end; {TTrialCluster.Done}

procedure TTrialCluster.GenCode(var CL: TCluster);
var
    LN: string;
    I: integer;
    J: longint;
    MCB: PMultiCheckBoxes;
    TD: PTrialDialog;
    R: TRect;
    SI: PSItem;
    S: string;

type
    PLong = ^longint;
    PWord = ^word;

begin {TTrialCluster.GenCode}
    Convert01(CL);  {update old version if needed}
    case GenPart of
     gpDataFields:
        begin
            write(Tab+Tab, GetStr(DataName));
            TD:= PTrialDialog(CL.Owner);
            if ShortName = 'CB' then begin
                if CL.Strings.Count > 16 then begin
                    writeln(': longint;');
                    writeln(Tab+Tab+'{+ Need to override DataSize +}');
                                    {.. and GetData and SetData}    {++}
                end else begin
                    writeln(': word;');
                end;
                with TD^ do GenVars:= GenVars or gvCheckBoxes;
            end else if ShortName = 'MB' then begin
                writeln(': longint;');
                with TD^ do GenVars:= GenVars or gvMultiCheckBoxes;
            end else begin  {= 'RB'}
                writeln(': word;');
                with TD^ do GenVars:= GenVars or gvRadioButtons;
            end;

            with ItemNames do begin
                for I:= 0 to Count-1 do begin
                    if At(I) <> nil then ListClustConsts:= true;
                end;
            end;
        end;

     gpDataConsts:
        begin
            if ListClustConsts then
            with ItemNames do begin
                for I:= 0 to Count-1 do begin
                    S:= GetStr(At(I));
                    if S <> '' then begin
                        write(Tab, S, ' ='+Tab);
                        if ShortName = 'CB' then begin
                            J:= 1;  J:= J shl I;
                            FormatStr(S, '$%x;', J);
                        end else if ShortName = 'MB' then begin
                            MCB:= PMultiCheckBoxes(@CL);
                            case MCB^.Flags of
                             cfTwoBits:
                                begin
                                    J:= $3;  J:= J shl (2*I);
                                end;
                             cfFourBits:
                                begin
                                    J:= $F;  J:= J shl (4*I);
                                end;
                             cfEightBits:
                                begin
                                    J:= $FF;  J:= J shl (8*I);
                                end;
                             else
                                begin
                                    J:= $1;  J:= J shl I;
                                end;
                            end; {case}
                            FormatStr(S, '$%x;', J);
                        end else begin {RB}
                            J:= I;
                            FormatStr(S, '%d;', J);
                        end;
                        write(S);
                        if I = 0
                        then write('  {', GetStr(DataName), ' values}');
                        writeln;
                    end;
                end;
            end;
        end;

     gpDataValues:
        begin
            if Semicolon then writeln(';');
            Semicolon:= true;
            write(Tab+Tab, GetStr(DataName), ': ');
            TD:= PTrialDialog(CL.Owner);
            if ShortName = 'RB' then begin
                write(CL.Value);
            end else begin
                FormatStr(S, '$%x', CL.Value);
                write(S);
            end;
        end;

     gpControls:
        begin
            writeln;
            CodeBounds(CL);
            if ShortName = 'CB' then begin
                LN:= 'CheckBoxes';
            end else if ShortName = 'MB' then begin
                LN:= 'MultiCheckBoxes';
            end else begin  {= 'RB'}
                LN:= 'RadioButtons';
            end;
            writeln(Tab, ShortName, ':= New(P', LN, ', Init(R,');

            with CL.Strings do begin
                for I:= 0 to Count-1 do begin
                    S:= GetStr(At(I));
                    writeln(Tab+Tab+'NewSItem(''', EscQuot(S), ''',');
                end;

                write(Tab+Tab+'nil');
                for I:= 1 to Count do write(')');
                if ShortName = 'MB' then begin
                    MCB:= PMultiCheckBoxes(@CL);
                    write(', ', MCB^.SelRange);
                    case MCB^.Flags of
                     cfTwoBits:
                        begin
                            LN:= 'cfTwoBits';
                            I:= 2*Count;
                        end;
                     cfFourBits:
                        begin
                            LN:= 'cfFourBits';
                            I:= 4*Count;
                        end;
                     cfEightBits:
                        begin
                            LN:= 'cfEightBits';
                            I:= 8*Count;
                        end;
                     else
                        begin
                            LN:= 'cfOneBit';
                            I:= Count;
                        end;
                    end; {case}
                    write(', ', LN);
                    write(', ''', EscQuot(GetStr(MCB^.States)));
                    writeln('''));');
                    writeln(Tab+'Insert(', ShortName, ');');
                    if I > 32 then begin
                        writeln('{+ WARNING: ', I, ' bits needed! +}');
                    end;

                end else begin
                    writeln;
                    write(Tab+'));');
                    writeln('  Insert(', ShortName, ');');
                end;
            end;
        end;

     gpClone:
        begin
            CL.GetBounds(R);
            with CL.Strings do begin
                SI:= nil;
                for I:= Count-1 downto 0 do begin
                    S:= GetStr(At(I));
                    SI:= NewSItem(S, SI);
                end;
            end;
            if ShortName = 'CB' then begin
                LLink:= New(PCheckBoxes, Init(R, SI));
            end else if ShortName = 'MB' then begin
                MCB:= PMultiCheckBoxes(@CL);
                LLink:= New(PMultiCheckBoxes, Init(R, SI,
                    MCB^.SelRange, MCB^.Flags, GetStr(MCB^.States)));
            end else begin  {= 'RB'}
                LLink:= New(PRadioButtons, Init(R, SI));
            end;
            RealDialog^.Insert(LLink);
        end;
    end; {case}
end; {TTrialCluster.GenCode}

{ Set size to accomodate label and names: }
procedure TTrialCluster.ReSize(var CL: TCluster; LabelP: PTrialLabel);
var
    I, J, XS, YS: integer;
    P: PString;
begin
    with CL.Strings do begin
        XS:= CStrLen(GetStr(LabelP^.Text)) - 4;
        for I:= 0 to Count-1 do begin
            J:= CStrLen(GetStr(PString(At(I))));
            if J > XS then XS:= J;
        end;
        inc(XS, 6);
        YS:= Count;
        if YS = 0 then YS:= 1;
        CL.GrowTo(XS, YS);
        CL.Draw;
    end;
end; {TTrialCluster.ReSize}

procedure TTrialCluster.HandleEvent(var Event: TEvent; CL: PCluster;
                                LabelP: PTrialLabel);
var
    PD: PDialog;
    ClusterData: TClusterData;
    N: integer;
    MCB: PTrialMultiCheckBoxes;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        Convert01(CL^); {update old version if needed}
        if Event.Double then begin
            { save data before editing: }
            with ClusterData, CL^ do begin
                RDataName:= GetStr(DataName);
                RLabel:= GetStr(LabelP^.Text);
                RStrings:= New(PStringCollection, Init(16, 16));
                RItemNames:= New(PStringCollection, Init(16, 16));
                CopyStrings(RStrings, @Strings);
                CopyStrings(RItemNames, @ItemNames);
                RFocused:= Strings.Count;
                RNFocused:= Strings.Count;
                N:= RFocused;
                { insert edit position: }
                with RStrings^ do AtInsert(Count, NewStr(' '));
                if ShortName = 'MB' then begin
                    MCB:= PTrialMultiCheckBoxes(CL);
                    RStates:= GetStr(MCB^.States);
                end;
            end;

            { edit Cluster with ClusterDialog: }
            PD:= PDialog(New(PClusterDialog, Init(true, ShortName)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @ClusterData);

            case Cmd of
             cmOK, cmPutOnTop:
                with ClusterData, CL^ do begin
                    LabelP^.ChangeText(RLabel);
                    ChangeStr(DataName, RDataName);
                    if ShortName = 'MB' then with MCB^ do begin
                        ChangeStr(States, RStates);
                        SelRange:= Length(RStates);
                        case SelRange of
                          2:        Flags:= cfOneBit;
                          3..4:     Flags:= cfTwoBits;
                          5..16:    Flags:= cfFourBits;
                          17..255:  Flags:= cfEightBits;
                          else begin
                            ChangeStr(States, ' X');
                            SelRange:= 2;
                            Flags:= cfOneBit;
                          end;
                        end; {case}
                    end;
                    with RStrings^ do AtFree(Count-1);  {delete edit pos'n}
                    CopyStrings(@Strings, RStrings);
                    CopyStrings(@ItemNames, RItemNames);
                    if Cmd = cmPutOnTop then begin
                        CL^.MakeFirst;
                        LabelP^.MakeFirst;
                    end;
                    if Strings.Count <> N then Resize(CL^, LabelP);
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    CL^.Free;
                    DialSaved:= false;
                end;

             cmSetDefault:
                begin
                    ClusterData.RFocused:= 0;
                    ClusterData.RNFocused:= 0;
                    if ShortName = 'RB'
                    then Default.DRadioButtons:= ClusterData
                    else if ShortName = 'CB'
                    then Default.DCheckBoxes:= ClusterData
                    else if ShortName = 'MB'
                    then Default.DMultiCheckBoxes:= ClusterData;
                end;

             cmSetPaste:
                begin
                    ClusterData.RFocused:= 0;
                    ClusterData.RNFocused:= 0;
                    if ShortName = 'RB'
                    then Paste.DRadioButtons:= ClusterData
                    else if ShortName = 'CB'
                    then Paste.DCheckBoxes:= ClusterData
                    else if ShortName = 'MB'
                    then Paste.DMultiCheckBoxes:= ClusterData;
                    CopyStrings(PasteStrings, ClusterData.RStrings);
                    CopyStrings(PasteNames, ClusterData.RItemNames);
                end;

             {else cmCancel}
            end;

            ClusterData.RStrings^.Done;  Dispose(ClusterData.RStrings);
            ClusterData.RItemNames^.Done;  Dispose(ClusterData.RItemNames);
            CL^.ClearEvent(Event);
        end else begin
            { move / re-size Cluster & Label by dragging: }
            DragBoth(CL^, LabelP, Event);
        end;
    end;
end; {TTrialCluster.HandleEvent}

procedure TTrialCluster.Convert01(var CL: TCluster);
var
    I: integer;
begin
    with CL.Strings do begin
        if Count = ItemNames.Count then exit;
        if (Count = ItemNames.Count+1)
            and (GetStr(At(Count-1)) = ' ') then exit;
        for I:= 0 to Count-1 do begin
            ItemNames.AtInsert(I, NewStr(GetStr(At(I))));
        end;
    end;
end; {TTrialCluster.Convert01}

{ old version; set default ItemNames }
constructor TTrialCluster.Load01(var S: TStream);
begin
    DataName:= S.ReadStr;
    S.Read(ShortName, SizeOf(TShortName));
    ItemNames.Init(16, 16);
end; {TTrialCluster.Load}

constructor TTrialCluster.Load(var S: TStream);
begin
    DataName:= S.ReadStr;
    S.Read(ShortName, SizeOf(TShortName));
    ItemNames.Load(S);
end; {TTrialCluster.Load}

procedure TTrialCluster.Store(var S: TStream);
begin
    S.WriteStr(DataName);
    S.Write(ShortName, SizeOf(TShortName));
    ItemNames.Store(S);
end; {TTrialCluster.Store}

{*******************************************************}

{ TrialRadioButtons }

{ The radio buttons correspond to values 0..n-1 of the data. }

constructor TTrialRadioButtons.Init(AData: PClusterData);
var
    R: TRect;
begin
    InitBounds(R, 10, 3);
    inherited Init(R, nil);
    LabelP:= NewLabel(Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialRadioButtons.Init}

destructor TTrialRadioButtons.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialRadioButtons.Done}

function TTrialRadioButtons.Execute: word;
begin
    { these controlled by GenPart: }
    TC.GenCode(Self);
    LabelP^.GenCode(TC.ShortName);
end; {TTrialRadioButtons.Execute}

procedure TTrialRadioButtons.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialRadioButtons.HandleEvent}

procedure TTrialRadioButtons.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialRadioButtons.SizeLimits}

constructor TTrialRadioButtons.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'RB';
end; {TTrialRadioButtons.Load}

procedure TTrialRadioButtons.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialRadioButtons.Store}

{*******************************************************}

{ TrialCheckBoxes }

{ The check boxes correspond to bit positions 0..n of the data. }

constructor TTrialCheckBoxes.Init(AData: PClusterData);
var
    R: TRect;
begin
    InitBounds(R, 10, 3);
    inherited Init(R, nil);
    LabelP:= NewLabel(Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialCheckBoxes.Init}

destructor TTrialCheckBoxes.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialCheckBoxes.Done}

function TTrialCheckBoxes.Execute: word;
begin
    { these controlled by GenPart: }
    TC.GenCode(Self);
    LabelP^.GenCode(TC.ShortName);
end; {TTrialCheckBoxes.Execute}

procedure TTrialCheckBoxes.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialCheckBoxes.HandleEvent}

procedure TTrialCheckBoxes.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialCheckBoxes.SizeLimits}

constructor TTrialCheckBoxes.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'CB';
end; {TTrialCheckBoxes.Load}

procedure TTrialCheckBoxes.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialCheckBoxes.Store}

{*******************************************************}

{ TrialMultiCheckBoxes }

{ The multi-check boxes correspond to k-bit codes at bit }
{ positions 0*k..(n-1)*k of the data.  The states are scanned }
{ from end to start of States string, and State[i] has value i. }

constructor TTrialMultiCheckBoxes.Init(AData: PClusterData);
var
    R: TRect;
    ASelRange: byte;
    AFlags: word;
begin
    InitBounds(R, 10, 3);
    ASelRange:= Length(AData^.RStates);
    case ASelRange of
      2:        AFlags:= cfOneBit;
      3..4:     AFlags:= cfTwoBits;
      5..16:    AFlags:= cfFourBits;
      17..255:  AFlags:= cfEightBits;
      else begin
        AData^.RStates:= ' X';
        ASelRange:= 2;
        AFlags:= cfOneBit;
      end;
    end; {case}
    inherited Init(R, nil, ASelRange, AFlags, AData^.RStates);
    LabelP:= NewLabel(Self, AData^.RLabel);
    TC.Init(AData, Self);
end; {TTrialMultiCheckBoxes.Init}

destructor TTrialMultiCheckBoxes.Done;
begin
    TC.Done;
    inherited Done;
end; {TTrialMultiCheckBoxes.Done}

function TTrialMultiCheckBoxes.Execute: word;
begin
    { these controlled by GenPart: }
    TC.GenCode(Self);
    LabelP^.GenCode(TC.ShortName);
end; {TTrialMultiCheckBoxes.Execute}

procedure TTrialMultiCheckBoxes.HandleEvent(var Event: TEvent);
begin
    TC.HandleEvent(Event, @Self, LabelP);
end; {TTrialMultiCheckBoxes.HandleEvent}

procedure TTrialMultiCheckBoxes.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 7;  Dec(MaxSz.X,2);
    MinSz.Y:= 1;  Dec(MaxSz.Y,2);
end; {TTrialMultiCheckBoxes.SizeLimits}

constructor TTrialMultiCheckBoxes.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    TC.Load(S);
    TC.ShortName:= 'MB';
end; {TTrialMultiCheckBoxes.Load}

procedure TTrialMultiCheckBoxes.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    TC.Store(S);
end; {TTrialMultiCheckBoxes.Store}

{*******************************************************}

{ ListBoxDialog }

constructor TListBoxDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    DT: TTitleStr;
    SY: integer;
const
    SX = 29;
    X1 = 1*SX div 3 - 1;
    X2 = 2*SX div 3 + 1;
    X3 = SX div 2;
begin
    if Change then begin
        SY:= 25;  DT:= 'Change';
    end else begin
        SY:= 22;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    DT:= DT + ' ListBox';
    inherited Init(R, DT);

    MakeDialogNames(SX);

    R.Assign(3, 10, SX-6, 11);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(3,  9, 19, 10);
    Insert(New(PLabel, Init(R, '~S~elect Name', IL)));
    R.Assign(SX-6, 10, SX-3, 11);
    Insert(New(PHistory, Init(R, IL, hiDataName)));

    R.Assign(3, 12, 7, 13);
    IL:= New(PRangeInputLine, Init(R, 4, 1, 255));  Insert(IL);
    R.Assign(7, 12, 26, 13);
    Insert(New(PLabel, Init(R, 'Number of ~C~olumns', IL)));

    MakeDialogButtons(X1, X2, SY, Change, bfDefault);
end; {TListBoxDialog.Init}

{ TrialScrollBar }

constructor TTrialScrollBar.Init(Bounds: TRect; ALink: PView);
begin
    inherited Init(Bounds);
    Link:= ALink;
    DragMode:= dmLimitAll;                  {+}
    GrowMode:= 0;
end; {TTrialScrollBar.Init}

procedure TTrialScrollBar.HandleEvent(var Event: TEvent);
var
    Lims: TRect;
    MinSz, MaxSz: TPoint;
    D: byte;
begin
    if Event.What and evMouseDown <> 0 then begin
        { move / re-size ScrollBar by dragging: }
        if Link <> nil then PutInFrontOf(Link);
        DragIt(Self, Event);
        DialSaved:= false;
    end;
end; {TTrialScrollBar.HandleEvent}

procedure TTrialScrollBar.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    MinSz.X:= 1;  MaxSz.X:= 1;
    MinSz.Y:= 3;  MaxSz.Y:= Owner^.Size.Y - 2;
end; {TTrialScrollBar.SizeLimits}

procedure TTrialScrollBar.GenCode;
var
    R: TRect;
begin
    case GenPart of
     gpControls:
        begin
            CodeBounds(Self);
            writeln(Tab+'SB:= New(PScrollBar, Init(R));  Insert(SB);');
        end;

     gpClone:
        begin
            GetBounds(R);
            SBLink:= New(PScrollBar, Init(R));
            RealDialog^.Insert(SBLink);
        end;
    end; {case}
end; {TTrialScrollBar.GenCode}

{ Move ScrollBar after target (Link^) is dragged: }
{ (OldR is bounds of Link^ before dragging) }
procedure TTrialScrollBar.TrackTarget(const OldR: TRect);
var
    SX: integer;
begin
    { is ScrollBar on left side of target? }
    if Origin.X < (OldR.A.X + OldR.B.X) div 2
        {track upper left corner of target:}
    then SX:= 0
        {track upper right corner of target:}
    else SX:= Link^.Size.X + OldR.A.X - OldR.B.X;
    MoveTo(Origin.X + Link^.Origin.X + SX - OldR.A.X,
           Origin.Y + Link^.Origin.Y - OldR.A.Y);
    GrowTo(Size.X, Size.Y + Link^.Size.Y - (OldR.B.Y - OldR.A.Y));
end; {TTrialScrollBar.TrackTarget}

constructor TTrialScrollBar.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, Link);
end; {TTrialScrollBar.Load}

procedure TTrialScrollBar.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, Link);
end; {TTrialScrollBar.Store}

{ TrialListBox }

constructor TTrialListBox.Init(AData: PListBoxData);
var
    R: TRect;
    M: integer;
    SB: PTrialScrollBar;
begin
    with AData^ do begin
        { init'z the ScrollBar: }
        InitBounds(R, 11, 5);
        R.Assign(R.B.X-1, R.A.Y, R.B.X, R.B.Y);
        SB:= New(PTrialScrollBar, Init(R, @Self));
        TrialDialog^.Insert(SB);
        { init'z the ListBox: }
        InitBounds(R, 11, 5);
        R.Move(-1, 0);
        inherited Init(R, RNumCols, SB);
        DragMode:= dmLimitAll;
        ListName:= NewStr(RListName);
        SelectName:= NewStr(RSelectName);
        { init'z the Label: }
        LabelP:= NewLabel(Self, RLabel);
    end;
end; {TTrialListBox.Init}

destructor TTrialListBox.Done;
begin
    DisposeStr(ListName);
    DisposeStr(SelectName);
    inherited Done;
end; {TTrialListBox.Done}

function TTrialListBox.Execute: word;
var
    R: TRect;
begin
    case GenPart of
     gpDataFields:
        begin
            writeln(Tab+Tab, GetStr(ListName), ': PStringCollection;');
            writeln(Tab+Tab, GetStr(SelectName), ': integer;');
            with PTrialDialog(Owner)^
            do GenVars:= GenVars or gvListBox or gvScrollBar;
        end;

     gpDataValues:
        begin
            if Semicolon then writeln(';');
            Semicolon:= true;
            writeln(Tab+Tab, GetStr(ListName), ': nil;');
            write  (Tab+Tab, GetStr(SelectName), ': 0');
        end;

     gpControls:
        begin
            writeln;
            PTrialScrollBar(VScrollBar)^.GenCode;
            CodeBounds(Self);
            write(Tab+'LB:= New(PListBox, Init(R, ', NumCols, ', SB));');
            writeln('  Insert(LB);');
            LabelP^.GenCode('LB');
        end;

     gpClone:
        begin
            PTrialScrollBar(VScrollBar)^.GenCode;
            GetBounds(R);
            { List is set = nil: }                              {++}
            LLink:= New(PListBox, Init(R, NumCols, SBLink));
            RealDialog^.Insert(LLink);
            LabelP^.GenCode('LB');
        end;
    end; {case}
end; {TTrialListBox.Execute}

procedure TTrialListBox.HandleEvent(var Event: TEvent);
var
    OldR: TRect;
    PD: PDialog;
    PS: PTrialListBox;
    ListBoxData: TListBoxData;
    Cmd: word;
begin
    if Event.What and evMouseDown <> 0 then begin
        if Event.Double then with ListBoxData do begin
            { edit ListBox with ListBoxDialog: }
            RNumCols:= NumCols;
            RListName:= GetStr(ListName);
            RSelectName:= GetStr(SelectName);
            RLabel:= GetStr(LabelP^.Text);

            PD:= PDialog(New(PListBoxDialog, Init(true)));
            Cmd:= DialEditApp.ExecuteDialog(PD, @ListBoxData);

            case Cmd of
             cmOK, cmPutOnTop:
                begin
                    NumCols:= RNumCols;
                    ChangeStr(ListName, RListName);
                    ChangeStr(SelectName, RSelectName);
                    LabelP^.ChangeText(RLabel);
                    if Cmd = cmPutOnTop then begin
                        MakeFirst;
                        if LabelP <> nil then LabelP^.MakeFirst;
                    end;
                    Draw;
                    DialSaved:= false;
                end;

             cmDelete:
                begin
                    if LabelP <> nil then LabelP^.Free;
                    if VScrollBar <> nil then VScrollBar^.Free;
                    Free;
                    DialSaved:= false;
                end;

             cmSetDefault: Default.DListBox:= ListBoxData;

             cmSetPaste: Paste.DListBox:= ListBoxData;

             {else cmCancel}
            end;

            ClearEvent(Event);
        end else begin
            { move / re-size ListBox, moving also ScrollBar & Label: }
            GetBounds(OldR);  {save old bounds}
            DragBoth(Self, LabelP, Event);
            PTrialScrollBar(VScrollBar)^.TrackTarget(OldR);
        end;
    end;
end; {TTrialListBox.HandleEvent}

procedure TTrialListBox.SetState(AState: word; Enable: boolean);
begin
    { Bypass TListViewer.SetState so that VScrollBar will }
    { remain visible when the TrialListBox is not active; }
    { that is, when the TrialDialog is not active:        }
    TView.SetState(AState, Enable);
end; {TTrialListBox.SetState}

procedure TTrialListBox.SizeLimits(var MinSz, MaxSz: TPoint);
begin
    inherited SizeLimits(MinSz, MaxSz);
    MinSz.X:= 3;  Dec(MaxSz.X,2);
    MinSz.Y:= 3;  Dec(MaxSz.Y,2);
end; {TTrialListBox.SizeLimits}

constructor TTrialListBox.Load(var S: TStream);
begin
    inherited Load(S);
    GetPeerViewPtr(S, LabelP);
    ListName:= S.ReadStr;
    SelectName:= S.ReadStr;
end; {TTrialListBox.Load}

procedure TTrialListBox.Store(var S: TStream);
begin
    inherited Store(S);
    PutPeerViewPtr(S, LabelP);
    S.WriteStr(ListName);
    S.WriteStr(SelectName);
end; {TTrialListBox.Store}

{*******************************************************}

{ DialogDialog }

constructor TDialogDialog.Init(Change: boolean);
var
    R: TRect;
    IL: PInputLine;
    V: PView;
    SY, Y: integer;
    DT: TTitleStr;
const
    SX = 37;
    X1 = 1*SX div 3;
    X2 = 2*SX div 3;
begin
    if Change then begin
        SY:= 18;  DT:= 'Change';
    end else begin
        SY:= 20;  DT:= 'New';
    end;
    R.Assign(0, 0, SX, SY);
    R.Move(DLim.B.X - R.B.X, DLim.B.Y - R.B.Y);
    DT:= DT + ' Dialog';
    inherited Init(R, DT);
    if not Change then Options:= Options or ofCentered;

    R.Assign(3, 4, 19, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 22, 4);
    Insert(New(PLabel, Init(R, '~D~ialog Box Title', IL)));
    R.Assign(19, 4, 22, 5);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    if Change then Y:= 9 else Y:= 11;
    R.Assign(3, 7, 22, Y);
    V:= New(PCheckBoxes, Init(R,
        NewSItem('~G~en. Defaults',
        NewSItem('C~e~nter Dialog',
        NewSItem('O~k~ Button',
        NewSItem('~C~ancel Button',
        nil))))
    ));  Insert(V);
    R.Assign(3, 6, 22, 7);
    Insert(New(PLabel, Init(R, 'O~p~tions', V)));

    R.Assign(23, 4, SX-6, 5);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(23, 3, SX-3, 4);
    Insert(New(PLabel, Init(R, '~B~ase Name', IL)));
    R.Assign(SX-6, 4, SX-3, 5);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    R.Assign(23, 7, SX-6, 8);
    IL:= New(PFilterInputLine, Init(R, TitleLen, IDChars));  Insert(IL);
    R.Assign(23, 6, SX-3, 7);
    Insert(New(PLabel, Init(R, '~T~ype Name', IL)));
    R.Assign(SX-6, 7, SX-3, 8);
    Insert(New(PHistory, Init(R, IL, hiDialogName)));

    MakeDialogButtons(X1, X2, SY, false, bfDefault);
end; {TDialogDialog.Init}

{ TrialDialogBackground }

constructor TTrialDialogBackground.Init(Bounds: TRect);
begin
    inherited Init(Bounds);
    GrowMode:= gfGrowHiX + gfGrowHiY;
    Patterned:= true;
end; {TTrialDialogBackground.Init}

procedure TTrialDialogBackground.Draw;
var
    Bf1, Bf2: TDrawBuffer;      { #$B0 = light hatch \B0 }
    Ch1, Ch2: char;             { #$B1 = med.  hatch \B1 }
    I, J, Y: integer;           { #$F0 = triple bar  \F0 }
begin                           {  $78 = DkGray/LtGray }
    if Patterned then begin     {  $76 = Brown/LtGray  }
        Ch1:= #$B0;  Ch2:= #$B1;                              {++}
    end else begin
        Ch1:= ' ';  Ch2:= ' ';
    end;

    { MoveChar(Bufr, Char, Color, XSize);   }
    { In the DrawBuffer --                  }
    { Lo bytes are Char, Hi bytes are Color }
    MoveChar(Bf1, Ch1, $76, Size.X);
    for I:= 1 to (Size.X div 5) do begin
        J:= 5*I - 1;
        Bf1[J]:= (Bf1[J] and $FF00) or Ord(Ch2);
    end;

    MoveChar(Bf2, Ch2, $76, Size.X);
    for Y:= 0 to Size.Y do begin
        if (Y mod 5) = 4 then begin
            WriteLine(0, Y, Size.X, 1, Bf2);
        end else begin
            WriteLine(0, Y, Size.X, 1, Bf1);
        end;
    end;
end; {TTrialDialogBackground.Draw}

procedure TTrialDialogBackground.HandleEvent(var Event: TEvent);
begin
    inherited HandleEvent(Event);
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        Patterned:= not Patterned;  {toggle}
        Draw;
        DialSaved:= false;
        ClearEvent(Event);
    end;
end; {TTrialDialogBackground.HandleEvent}

constructor TTrialDialogBackground.Load(var S: TStream);
begin
    inherited Load(S);
    S.Read(Patterned, SizeOf(boolean));
    {Patterned:= true;}                                         {+}
end; {TTrialDialogBackground.Load}

procedure TTrialDialogBackground.Store(var S: TStream);
begin
    inherited Store(S);
    S.Write(Patterned, SizeOf(boolean));
end; {TTrialDialogBackground.Store}

{ TrialDialog }

constructor TTrialDialog.Init(AData: PDialogData);
var
    R: TRect;
    TB: PTrialButton;
    ButtonData: TButtonData;
begin
    with AData^ do begin
        R.Assign(0, 0, 36, 15);
        R.Move(DLim.A.X, DLim.A.Y);
        inherited Init(R, RTitle);
        R.Move(-DLim.A.X, -DLim.A.Y);
        R.Grow(-1, -1);
        Background:= New(PTrialDialogBackground, Init(R));
        Insert(Background);

        SetState(sfModal, false);
        DragMode:= dmLimitAll;
        Flags:= Flags or wfGrow;
        BaseName:= NewStr(RBaseName);
        TypeName:= NewStr(RTypeName);

        if ROptions and doOkButton <> 0 then begin
            with ButtonData do begin
                RTitle:= '~O~k';
                RCmdName:= 'cmOK';
                RFlags:= bfDefault;
            end;
            TB:= New(PTrialButton, Init(@ButtonData));
            TB^.MoveTo(19, 11);
            Insert(TB);
        end;

        if ROptions and doCancelButton <> 0 then begin
            with ButtonData do begin
                RTitle:= 'C~a~ncel';
                RCmdName:= 'cmCancel';
                RFlags:= bfNormal;
            end;
            TB:= New(PTrialButton, Init(@ButtonData));
            TB^.MoveTo(7, 11);
            Insert(TB);
        end;

        Centered:= ROptions and doCentered <> 0;
        GenDefaults:= ROptions and doGenDefaults <> 0;
        Application^.EnableCommands(cmsNewControls);
    end;
end; {TTrialDialog.Init}

destructor TTrialDialog.Done;
begin
    DisposeStr(BaseName);
    DisposeStr(TypeName);
    inherited Done;
end; {TTrialDialog.Done}

procedure TTrialDialog.Close;
begin
    if TrialDialog <> @Self then begin
        inherited Close;
        exit;
    end;
    if not DialSaved then begin
        if AutoSave or (MessageBox('Save current dialog?', nil,
            mfConfirmation + mfYesButton + mfNoButton) = cmYes)
        then SaveDialog;            { also RealDialog ? }           {++}
    end;

    inherited Close;                { also RealDialog ? }           {++}
    TrialDialog:= nil;
    Application^.DisableCommands(cmsNewControls);
end; {TTrialDialog.Close}

procedure TTrialDialog.GenCode;
var
    R: TRect;

    { scans subviews UPward (ForEach goes DOWNward): }
    procedure SubViewGenCode(P: PView);
    begin
        if P <> nil then begin
            if P^.Next <> First then begin
                SubViewGenCode(P^.Next);
            end;
            P^.Execute;
        end;
    end; {SubViewGenCode}

begin
    case GenPart of
     gpDialogHeader:
        begin
            writeln('{ ', GetStr(BaseName), GetStr(TypeName), ' }');
            writeln;
            writeln('type');
            writeln(Tab+'P', GetStr(BaseName), GetStr(TypeName), ' = ^T',
                            GetStr(BaseName), GetStr(TypeName), ';');
            writeln(Tab+'T', GetStr(BaseName), GetStr(TypeName),
                            ' = object(T', GetStr(TypeName), ')');
            writeln(Tab+Tab+'constructor Init;');
            writeln(Tab+'end;');
            writeln;
            writeln(Tab+'P', GetStr(BaseName), 'Data = ^T',
                            GetStr(BaseName), 'Data;');
            writeln(Tab+'T', GetStr(BaseName), 'Data = record');

            GenVars:= 0;    {subviews will set bits}
            ListClustConsts:= false;
            GenPart:= gpDataFields;
            if First <> nil then SubViewGenCode(First);

            writeln(Tab+'end;');
            writeln;

            if ListClustConsts then begin
                writeln('const');
                GenPart:= gpDataConsts;
                if First <> nil then SubViewGenCode(First);
                writeln;
            end;

            if GenDefaults then begin
                writeln('const');
                writeln(Tab, GetStr(BaseName), 'Defaults: T',
                        GetStr(BaseName), 'Data = (');

                GenPart:= gpDataValues;
                Semicolon:= false;
                if First <> nil then SubViewGenCode(First);

                writeln;
                writeln(Tab+');');
                writeln;
            end;
        end;

     gpHistConsts:
        begin
            if First <> nil then SubViewGenCode(First);
        end;

     gpDialogInit:
        begin
            writeln('{ ', GetStr(BaseName), GetStr(TypeName), ' }');
            writeln;
            writeln('constructor T', GetStr(BaseName),
                            GetStr(TypeName), '.Init;');
            writeln('var');
            writeln(Tab+'R: TRect;');

            if GenVars and gvInputLine <> 0
            then writeln(Tab+'IL: PInputLine;');
            if GenVars and gvRadioButtons <> 0
            then writeln(Tab+'RB: PRadioButtons;');
            if GenVars and gvCheckBoxes <> 0
            then writeln(Tab+'CB: PCheckBoxes;');
            if GenVars and gvMultiCheckBoxes <> 0
            then writeln(Tab+'MB: PMultiCheckBoxes;');
            if GenVars and gvScrollBar <> 0
            then writeln(Tab+'SB: PScrollBar;');
            if GenVars and gvListBox <> 0
            then writeln(Tab+'LB: PListBox;');
                {== other variables may be needed ==}

            writeln('begin');
            CodeBounds(Self);
            write(Tab+'inherited Init(R, ''', EscQuot(GetStr(Title)));
            if GetStr(TypeName) = 'Window' then begin
                writeln(''', 0);');     {zero window number}
            end else begin
                writeln(''');');
            end;
            if Centered
            then writeln(Tab+'Options:= Options or ofCentered;');

            GenPart:= gpControls;
            if First <> nil then SubViewGenCode(First);

            writeln('end; {T', GetStr(BaseName),
                               GetStr(TypeName), '.Init}');
            writeln;
            GenPart:= gpDialogFooter;   {done, but output still open}
        end;

     gpClone:
        begin
            if RealDialog <> nil then RealDialog^.Close;
            GetBounds(R);
            if GetStr(TypeName) = 'Window' then begin
                RealDialog:= PDialog(New(PWindow,
                    Init(R, GetStr(Title), 0)));
            end else begin
                RealDialog:= New(PDialog, Init(R, GetStr(Title)));
            end;
            if Centered
            then with RealDialog^ do Options:= Options or ofCentered;
            if First <> nil then SubViewGenCode(First);
        end;
    end; {case}

end; {TTrialDialog.GenCode}

{ The methodology here is not supported by Virtual Pascal. }
procedure TTrialDialog.SnapPicture(AShow, APattern: word);
type
    TScreen = array [0..49, 0..79, 0..1] of char;
var
//{$IFNDEF VPASCAL}
//    Screen: TScreen absolute $B800:0;
//{$ENDIF}
    R: TRect;
    X, Y, NoShadow: integer;
    S: string[80];
    Ch, SCh, BackGrd, Shadow: char;
    Attr: byte;
    NoResize: boolean;
begin
//{$IFNDEF VPASCAL}
//    NoResize:= ((AShow and $0001) = 0);
//    NoShadow:= Ord((AShow and $0002) = 0);
//    BackGrd:= ShadeChars[(APattern and $000F) + 1];
//    Shadow:= ShadeChars[(APattern shr 4) + 1];
//    if Background^.Patterned then SCh:= ' ' else SCh:= BackGrd;     {+}
//    GetExtent(R);
//    MakeGlobal(R.A, R.A);
//    MakeGlobal(R.B, R.B);
//    with R do for Y:= A.Y to B.Y-NoShadow do begin
//        S[0]:= Chr(B.X-A.X+1-NoShadow);
//        for X:= A.X to B.X-NoShadow do begin
//            Ch:= Screen[Y, X, 0];
//            Attr:= Ord(Screen[Y, X, 1]);
//            if (X=A.X) and (Y=B.Y) then begin
//                S[X-A.X+1]:= ' ';
//            end else if (X=B.X) and (Y=A.Y) then begin
//                S[X-A.X+1]:= ' ';
//            end else if (X=B.X) or (Y=B.Y) then begin
//                S[X-A.X+1]:= Shadow;
//            end else if (Ch = ' ') and
//              ((Attr and $70) = $70) then begin                     {+}
//                S[X-A.X+1]:= SCh;
//            end else if NoResize and (Y=B.Y-1) then begin
//                if (X=B.X-2) then begin
//                    S[X-A.X+1]:= '\CD';
//                end else if (X=B.X-1) then begin
//                    S[X-A.X+1]:= '\BC';
//                end else begin
//                    S[X-A.X+1]:= Ch;
//                end;
//            end else if Ch = '\B0' then begin
//                S[X-A.X+1]:= BackGrd;
//            end else if Ch = '\B1'{\F0} then begin
//                S[X-A.X+1]:= BackGrd;
//            end else if Ch = #7 then begin
//                S[X-A.X+1]:= '\FE';
//            end else begin
//                S[X-A.X+1]:= Ch;
//            end;
//        end;
//        writeln(Tab, S);
//    end;
//{$ENDIF}
    GenPart:= gpDialogFooter;   {done, but output file still open}
    writeln;
end; {TTrialDialog.SnapPicture}

procedure TTrialDialog.HandleEvent(var Event: TEvent);
var
    PV: PView;
    DialogData: TDialogData;
    Cmd: word;
begin
    inherited HandleEvent(Event);
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        with DialogData do begin
            RTitle:= GetStr(Title);
            RBaseName:= GetStr(BaseName);
            RTypeName:= GetStr(TypeName);
            if Centered then ROptions:= doCentered else ROptions:= 0;
            if GenDefaults then ROptions:= ROptions or doGenDefaults;
        end;

        Cmd:= DialEditApp.ExecuteDialog(New(PDialogDialog, Init(true)),
            @DialogData);
        case Cmd of
         cmOK:
            with DialogData do begin
                ChangeStr(Title, RTitle);
                ChangeStr(BaseName, RBaseName);
                ChangeStr(TypeName, RTypeName);
                Centered:= ROptions and doCentered <> 0;
                GenDefaults:= ROptions and doGenDefaults <> 0;
                Redraw;
                DialSaved:= false;
            end;

         cmSetDefault: Default.DDialog:= DialogData;

         cmSetPaste: Paste.DDialog:= DialogData;

         {else cmCancel}
        end; {case}
        ClearEvent(Event);
    end;
end; {TTrialDialog.HandleEvent}

procedure TTrialDialog.SetState(AState: word; Enable: boolean);
begin
    if AState = sfDragging then DialSaved:= false;
    inherited SetState(AState, Enable);
end; {TTrialDialog.SetState}

constructor TTrialDialog.Load01(var S: TStream);
begin
    inherited Load(S);
    BaseName:= S.ReadStr;
    TypeName:= S.ReadStr;
    GetSubViewPtr(S, BackGround);
    S.Read(Centered, SizeOf(boolean));
    GenDefaults:= false;                    {fix old}
    Application^.EnableCommands(cmsNewControls);
end; {TTrialDialog.Load01}

constructor TTrialDialog.Load(var S: TStream);
begin
    inherited Load(S);
    BaseName:= S.ReadStr;
    TypeName:= S.ReadStr;
    GetSubViewPtr(S, BackGround);
    S.Read(Centered, SizeOf(boolean));
    S.Read(GenDefaults, SizeOf(boolean));   {new}
    Application^.EnableCommands(cmsNewControls);
end; {TTrialDialog.Load}

procedure TTrialDialog.Store(var S: TStream);
begin
    inherited Store(S);
    S.WriteStr(BaseName);
    S.WriteStr(TypeName);
    PutSubViewPtr(S, BackGround);
    S.Write(Centered, SizeOf(boolean));
    S.Write(GenDefaults, SizeOf(boolean));  {new}
end; {TTrialDialog.Store}

{*******************************************************}

{ FetchDialogDialog }

constructor TFetchDialogDialog.Init(APlural: boolean);
var
    R: TRect;
    SB: PScrollBar;
    T: TTitleStr;
    Y, YY: integer;
begin
    if APlural then begin
        T:= 'Select Dialogs';
        Y:= 22;  YY:= 19;
    end else begin
        T:= 'Fetch Dialog';
        Y:= 20;  YY:= 18;
    end;
    R.Assign(0, 0, 30, Y);
    inherited Init(R, T);
    Options:= Options or ofCentered;
    Plural:= APlural;

    R.Assign(26, 4, 27, 15);
    SB:= New(PScrollBar, Init(R));  Insert(SB);
    R.Assign(3, 4, 26, 15);
    ListBox:= New(PListBox, Init(R, 1, SB));

    Insert(ListBox);
    R.Assign(3, 3, 23, 4);
    Insert(New(PLabel, Init(R, 'Dialog/Window ~N~ame', ListBox)));
    if Plural then begin
        R.Assign(7, 15, 29, 16);
        Insert(New(PStaticText, Init(R, 'space toggles \FB')));
        R.Assign(17, YY, 26, YY+1);
        Insert(New(PStaticText, Init(R, '(go gen.)')));
    end;

    R.Assign(4, YY-2, 14, YY);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(16, YY-2, 26, YY);
    Insert(New(PButton, Init(R, '~O~k', cmOK, bfDefault)));

    ListBox^.Select;
end; {TFetchDialogDialog.Init}

procedure TFetchDialogDialog.HandleEvent(var Event: TEvent);
var
    R: TRect;
    S: PString;
begin
    if (Event.What and evMessage <> 0)
    and (Event.Command = cmListItemSelected)
    and (Event.InfoPtr = ListBox) then begin
        if Plural then with ListBox^ do begin
            S:= List^.At(Focused);
            if S^[1] = ' ' then begin   {toggle selection}
                S^[1]:= #$FB;
            end else begin
                S^[1]:= ' ';
            end;
        end else begin
            EndModal(cmOk);
            ClearEvent(Event);
            exit;
        end;
    end;
{$IFDEF ScreenCapture}
    if (Event.What and evMouseDown <> 0) and Event.Double
    then begin
        GetExtent(R);
        MakeGlobal(R.A, R.A);
        MakeGlobal(R.B, R.B);
        ScreenCapture(R);
        ClearEvent(Event);
    end;
{$ENDIF}
    inherited HandleEvent(Event);
end; {TFetchDialogDialog.HandleEvent}

{*******************************************************}

{ FileOptDialog }

constructor TFileOptDialog.Init;
var
    R: TRect;
    IL: PInputLine;
    V: PView;
begin
    R.Assign(4, 4, 37, 22);
    inherited Init(R, 'File Options');
    Options:= Options or ofCentered;

    R.Assign(3, 8, 30, 9);
    Insert(New(PStaticText, Init(R, '(empty for standard output)')));

    R.Assign(3, 7, 27, 8);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 6, 21, 7);
    Insert(New(PLabel, Init(R, 'Code ~O~utput Name', IL)));
    R.Assign(27, 7, 30, 8);
    Insert(New(PHistory, Init(R, IL, hiCodeFile)));

    R.Assign(3, 4, 27, 5);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 3, 27, 4);
    Insert(New(PLabel, Init(R, '~C~ollection File Name', IL)));
    R.Assign(27, 4, 30, 5);
    Insert(New(PHistory, Init(R, IL, hiCollFile)));

    R.Assign(3, 11, 27, 12);
    IL:= New(PInputLine, Init(R, TitleLen));  Insert(IL);
    R.Assign(3, 10, 23, 11);
    Insert(New(PLabel, Init(R, '~H~istory File Name', IL)));
    R.Assign(27, 11, 30, 12);
    Insert(New(PHistory, Init(R, IL, hiHistFile)));

    R.Assign(5, 14, 15, 16);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(18, 14, 28, 16);
    Insert(New(PButton, Init(R, 'O~k~', cmOK, bfDefault)));
end; {TFileOptDialog.Init}

{*******************************************************}

{ OutOptDialog }

constructor TOutOptDialog.Init;
var
    R: TRect;
    RB: PRadioButtons;
    CB: PCheckBoxes;
    MB: PMultiCheckBoxes;
begin
    R.Assign(4, 4, 39, 22);
    inherited Init(R, 'Output Options');
    Options:= Options or ofCentered;

    R.Assign(3, 14, 12, 15);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('Sa~v~e',
        nil)
    ));  Insert(CB);

    R.Assign(3, 4, 32, 5);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('~P~ictures  ',
        NewSItem('~T~V Code',
        nil))
    ));  Insert(CB);
    R.Assign(3, 3, 22, 4);
    Insert(New(PLabel, Init(R, '~O~utput includes..', CB)));

    R.Assign(3, 7, 17, 9);
    CB:= New(PCheckBoxes, Init(R,
        NewSItem('~R~esize',
        NewSItem('S~h~adow',
        nil))
    ));  Insert(CB);
    R.Assign(3, 6, 11, 7);
    Insert(New(PLabel, Init(R, 'Sho~w~..', CB)));

    R.Assign(3, 11, 17, 13);
    MB:= New(PMultiCheckBoxes, Init(R,
        NewSItem('~B~ackgrnd',
        NewSItem('Shado~w~',
        nil)), 5, cfFourBits, ShadeChars));
    Insert(MB);
    R.Assign(3, 10, 16, 11);
    Insert(New(PLabel, Init(R, 'Patter~n~ of..', MB)));

    R.Assign(19, 7, 32, 9);
    RB:= New(PRadioButtons, Init(R,
        NewSItem('~B~are',
        NewSItem('~U~nit',
        nil))
    ));  Insert(RB);
    R.Assign(19, 6, 31, 7);
    Insert(New(PLabel, Init(R, 'Code ~F~ormat', RB)));

    R.Assign(19, 11, 32, 12);
    MB:= New(PMultiCheckBoxes, Init(R,
        NewSItem('spaces',
        nil), 5, cfFourBits, 'T4321'));
    Insert(MB);
    R.Assign(19, 10, 29, 11);
    Insert(New(PLabel, Init(R, '~I~ndent..', MB)));

    R.Assign(20, 12, 29, 13);
    Insert(New(PStaticText, Init(R, '(T = tab)')));

    R.Assign(12, 14, 22, 16);
    Insert(New(PButton, Init(R, 'C~a~ncel', cmCancel, bfNormal)));

    R.Assign(22, 14, 32, 16);
    Insert(New(PButton, Init(R, 'Pic~k~..', cmOK, bfDefault)));
end; {TOutOptDialog.Init}

{*******************************************************}

{ Token }

{ Kind = 's' for SwapToken, Kind = 'm' for ModeToken }

constructor TToken.Init(Bounds: TRect; AKind: char);
begin
    inherited Init(Bounds);
    Kind:= AKind;
    State:= State or sfActive;
    if Kind = 's' then State:= State or sfDisabled;
    EventMask:= evMouse + evBroadcast;
    Options := Options or ofPostProcess;
end; {TToken.Init}

procedure TToken.Draw;
var
    S: string[9]; {length = Size.X}
    B: TDrawBuffer;
    C: byte;
begin
    if Kind = 's' then S:= ' Swap '
    else if State and sfPaste <> 0
    then S:= '  Paste  '
    else S:= ' Default ';

    if State and sfDisabled <> 0
    then C:= GetColor(3)    {3 = 'disabled' color}
    else if State and sfSelected <> 0
    then C:= GetColor(5)    {5 = 'selected' color}
    else C:= GetColor(4);   {4 = 'shortcut' color}
    MoveStr(B, S, C);
    WriteLine(0, 0, Size.X, 1, B);
end; {TToken.Draw}

procedure TToken.SetState(AState: word; Enable: boolean);
begin
    inherited SetState(AState, Enable);
    Draw;
end; {TToken.SetState}

procedure TToken.Update;
var
    E1, E2: boolean;
begin
    if Kind = 'm' then exit;
    E1:= Application^.CommandEnabled(cmSwapDialogs);
    E2:= State and sfDisabled = 0;
    if E1 <> E2 then begin
        SetState(sfDisabled, not E1);
        Draw;
    end;
end; {TToken.Update}

procedure TToken.HandleEvent(var Event: TEvent);
var
    R: TRect;                                               {+}
begin
    inherited HandleEvent(Event);
    case Event.What of
     evMouseDown:
        if (State and sfDisabled = 0) then begin
{$IFDEF ScreenCapture}                                      {+}
            GetExtent(R);
            MakeGlobal(R.A, R.A);
            MakeGlobal(R.B, R.B);
            ScreenCapture(R);
{$ENDIF}
            SetState(sfSelected, true);
            Message(Application, evBroadcast, cmReceivedFocus, @Self);
            ClearEvent(Event);
        end;

     evMouseUp:
        if (State and sfDisabled = 0)
        and (State and sfSelected <> 0) then begin
            SetState(sfSelected, false);
            if Kind = 's' then begin    {swap}
                Message(Application, evCommand, cmSwapDialogs, nil);
            end else begin              {mode}
                SetState(sfPaste, (State and sfPaste = 0));  {toggle}
            end;
            Message(Application, evBroadcast, cmReleasedFocus, @Self);
            ClearEvent(Event);
        end;

     evBroadcast:
        case Event.Command of
         cmReceivedFocus, cmReleasedFocus:
            if Event.InfoPtr <> @Self then begin
                SetState(sfSelected, false);
                { don't clear event; let others receive it }
            end;
        end; {case}
    end; {case}
end; {TToken.HandleEvent}

{*******************************************************}

{ Program configuration & Command-line interpretation }

{configuration data; compatable with CONFIG program:}
type
    tConfig = record
        Magic: string[10];
        Data:  string[100]; {max length is 255}
    end;

const
    Config: tConfig = (
        Magic: '!)@(#*$&%^';    {must appear nowhere else in code!}

        {default options:}
        Data:   '/////////////////////////'+
                '/////////////////////////'+
                '/////////////////////////'+
                '/////////////////////////'
        {reserve space for reconfiguration with '/' padding}
    );

var
    LastOption: char;

{ ShowUsage, SetOpt, DoFile, and AppDone use Params unit: }

procedure ShowUsage; far;
var
    OS: string;
    CP: integer;
begin
    writeln(CopyNote);
    writeln('TurboVision Dialog Editor');
    writeln('Usage: DialEdit [ options ]');
    writeln('Options:');
    writeln('/hFileName   History file');
    writeln('             (Default filename is ',
                FileOptData.HistFName, '.)');
    writeln('/oFileName   Output for generated code');
    writeln('             (Uses standard output if none given.)');
    writeln('/dFileName   Dialog collection file');
    writeln('             (Default filename is ',
                FileOptData.CollFName, '.)');

    OS:= GetDefaults(Config.data);
    CP:= Pos('/_', OS)-1;
    if CP >= 0 then OS[0]:= char(CP);
    if OS <> '' then writeln('Default options are: ', OS);
end; {ShowUsage}

procedure SetOpt; far;
begin
    with FileOptData do
    case OptChr of
        'o': CodeFName:= OptStr;

        'h': HistFName:= OptStr;

        'd': CollFName:= OptStr;

        '?':
            begin
                DialEditApp.Done;
                ShowUsage;
                Halt;
            end;

        else RptError('Undefined option', Option, 'u');
    end;
    LastOption:= OptChr;
end; {SetOpt}

procedure DoFile(FName: PathStr; Expdd: boolean); far;
begin
    { in case file name is separate from option code: }
    with FileOptData do
    case LastOption of
        'o': CodeFName:= FName;

        'h': HistFName:= FName;

        'd': CollFName:= FName;
    end; {case}
end; {DoFile}

procedure AppDone; far; {in case setup fails}
begin
    DialEditApp.Done;
end; {AppDone}

{*******************************************************}

{ TDialEditApp }

constructor TDialEditApp.Init;
var
    R: TRect;

begin
    PShowUsage:= @ShowUsage;
    PSetOpt:= @SetOpt;
    PDoFile:= @DoFile;
    PAppDone:= @AppDone;

    FileOptData.CollFName:= 'Dialogs.res';
    FileOptData.CodeFName:= '';
    FileOptData.HistFName:= 'Dialogs.hst';
    OutOptData:= Default.DOutOpt;
    TrialDialog:= nil;
    RealDialog:= nil;
    GenPart:= gpDisabled;
    DialSaved:= true;
    CollFile:= nil;
    Tab:= #9;

    LastOption:= ' ';
    ParseOpts(Config.Data);     {set default options}

    inherited Init;

    DisableCommands(cmsNewControls +
        [cmSwapDialogs, cmTile, cmCascade, cmCloseAll]
    );

    LastOption:= ' ';
    if ParamCount > 0 then ScanPars;    {scan the command line}

    GetExtent(DLim);  DLim.Grow(-4, -4);

    GetExtent(R);
    dec(R.B.X);
    R.A.X:= R.B.X-9;  R.A.Y:= R.B.Y-1;
{$IFNDEF VPASCAL}
    Heap:= New(PHeapView, Init(R));
    Insert(Heap);
{$ENDIF}

    GetExtent(R);
    R.A.X:= R.B.X-9;  R.B.Y:= R.A.Y+1;
    Clock:= New(PClockView, Init(R));
    Insert(Clock);

    R.B.X:= R.A.X-1;  R.A.X:= R.B.X-9;
    ModeToken:= New(PToken, Init(R, 'm'));
    Insert(ModeToken);

    R.B.X:= R.A.X;  R.A.X:= R.B.X-6;
    SwapToken:= New(PToken, Init(R, 's'));
    Insert(SwapToken);

    PasteStrings:= New(PStringCollection, Init(16, 16));
    with PasteStrings^ do AtInsert(Count, NewStr(' '));
    PasteNames:= New(PStringCollection, Init(16, 16));

    RegisterObjects;
    RegisterViews;
    RegisterDialogs;
    {RegisterValidate}
    {RegisterStdDlg;}                                           {+}
    {RegisterMenus}
    {RegisterApp}
    RegisterTrialObjects;
    StreamError:= @StreamErrorMsg;
    CollFile:= nil; {open when first needed}
    CurrDialog:= '';
    PrevDialog:= '';
    AutoSave:= false;
    ReadHistory;
end; {TDialEditApp.Init}

destructor TDialEditApp.Done;
begin
    { if active, make code footer and close code output: }
    CloseCodeFile;

    if TrialDialog <> nil then TrialDialog^.Close;
    if RealDialog <> nil then RealDialog^.Close;
    CloseCollFile;
    WriteHistory;
    inherited Done;
end; {TDialEditApp.Done}

procedure TDialEditApp.InitScreen;
var
    R: TRect;
begin
    if HiResScreen then begin
        { This is basicly SetScreenMode(Mode), except  }
        { that Mode is "ScreenMode or smFont8x8" and   }
        { that inherited InitScreen is called (else we }
        { would have a recursive loop). }
        HideMouse;
//        SetVideoMode(ScreenMode or smFont8x8);
        DoneMemory;
        InitMemory;
        inherited InitScreen;
        Buffer:= ScreenBuffer;
        R.Assign(0, 0, ScreenWidth, ScreenHeight);
        ChangeBounds(R);
        ShowMouse;
    end else begin
        inherited InitScreen;
    end;
end; {TDialEditApp.InitScreen}

procedure TDialEditApp.InitMenuBar;
var
    R: TRect;
begin
    GetExtent(R);
    R.B.Y:= R.A.Y + 1;
    MenuBar:= New(PMenuBar, Init(R, NewMenu(
        NewSubMenu('Dialog_Editor ', hcNoContext, NewMenu(
            NewItem(CopyNote, '', kbNoKey, cmNo, hcNoContext,
            nil)),

        NewSubMenu('~F~ile', hcNoContext, NewMenu(
            NewItem('~O~utput options..', '', kbAltO, cmOutput,         {++}
                hcNoContext,
            NewItem('Se~l~ect files..', '', kbAltL, cmSetFiles,         {++}
                hcNoContext,
            NewItem('~C~hange dir..', '', kbNoKey, cmChangeDir,
                hcNoContext,
            NewItem('~D~OS shell', '', kbNoKey, cmDosShell, hcNoContext,
            NewItem('E~x~it', '', kbAltX, cmQuit, hcNoContext,
            nil)))))),

        NewSubMenu('Dial~o~g', hcNoContext, NewMenu(
            NewItem('~S~ave', '', kbAltS, cmSaveDialog,
                hcNoContext,
            NewItem('~D~elete', '', kbAltD, cmDeleteDialog,
                hcNoContext,
            NewItem('F~e~tch..', '', kbAltE, cmFetchDialog,
                hcNoContext,
            NewItem('~G~en code', '', kbAltG, cmGenCode,
                hcNoContext,
            NewItem('~P~icture', '', kbAltP, cmSnapPicture,
                hcNoContext,
            NewItem('~T~est', '', kbAltT, cmTestDialog,
                hcNoContext,
            nil))))))),

        NewSubMenu('~N~ew', hcNoContext, NewMenu(
            NewItem('~D~ialog', '', kbAltD, cmNewDialog, hcNoContext,
            NewItem('~S~taticText', '', kbAltS, cmNewStaticText,
                hcNoContext,
            NewItem('~P~aramText', '', kbAltP, cmNewParamText,
                hcNoContext,
            NewItem('~B~utton', '', kbAltB, cmNewButton, hcNoContext,
            NewItem('~I~nputLine', '', kbAltI, cmNewInputLine, hcNoContext,
            NewItem('~R~adioButtons', '', kbAltR, cmNewRadioButtons,
                hcNoContext,
            NewItem('~C~heckBoxes', '', kbAltC, cmNewCheckBoxes,
                hcNoContext,
            NewItem('~M~ultiCheckBoxes', '', kbAltM, cmNewMultiCheckBoxes,
                hcNoContext,
            NewItem('~L~istBox', '', kbAltL, cmNewListBox,
                hcNoContext,
            nil)))))))))),

        nil))))
    )));
end; {TDialEditApp.InitMenuBar}

procedure TDialEditApp.InitStatusLine;
var
    R: TRect;
begin
    GetExtent(R);
    R.A.Y:= R.B.Y - 1;
    New(StatusLine, Init(R,
        NewStatusDef(0, $FFFF,
            NewStatusKey('E~x~it', kbAltX, cmQuit,
            NewStatusKey('~D~ilg', kbAltD, cmNewDialog,
            NewStatusKey('~S~tTxt', kbAltS, cmNewStaticText,
            NewStatusKey('~P~arTxt', kbAltP, cmNewParamText,
            NewStatusKey('~B~utn', kbAltB, cmNewButton,
            NewStatusKey('~I~npLn', kbAltI, cmNewInputLine,
            NewStatusKey('~R~dBtns', kbAltR, cmNewRadioButtons,
            NewStatusKey('~C~hkBxs', kbAltC, cmNewCheckBoxes,
            NewStatusKey('~M~ltBxs', kbAltM, cmNewMultiCheckBoxes,
            NewStatusKey('~L~stBx', kbAltL, cmNewListBox,
{$IFDEF ScreenCapture}
            NewStatusKey('', kbAltZ, cmScreenCapture,
{$ENDIF}
            NewStatusKey('', kbF2, cmSwapDialogs,
            NewStatusKey('', kbF10, cmMenu,
            NewStatusKey('', kbCtrlF5, cmResize,
            nil)))))))))))))
{$IFDEF ScreenCapture}
            )
{$ENDIF}
        , nil)
    ));
end; {TDialEditApp.InitStatusLine}

procedure TDialEditApp.GenCode(ATrialDialog: PTrialDialog);
begin
    if ATrialDialog <> nil then begin
        { open code output if not already: }
        OpenCodeFile;
        { then generate code for current dialog: }
        ValUsed:= false;
        GenPart:= gpDialogHeader;
        ATrialDialog^.GenCode;
        GenImplementation;
        GenPart:= gpDialogInit;
        ATrialDialog^.GenCode;
    end;
end; {TDialEditApp.GenCode}

{   NOTE: TApplication handles cmTile, cmCascade, & cmDosShell,
    and its ancestor TProgram handles Alt-1 .. Alt-9 & cmQuit.
}
procedure TDialEditApp.HandleEvent(var Event: TEvent);

    procedure NewDialog;
    var
        PV: PView;
        DialogData: TDialogData;
    begin
        if ModeToken^.State and sfPaste <> 0
        then DialogData:= Paste.DDialog
        else DialogData:= Default.DDialog;

        case ExecuteDialog(New(PDialogDialog, Init(false)),
                @DialogData)
        of
         cmOk:
            begin
                if TrialDialog <> nil then TrialDialog^.Close;
                PV:= ValidView(New(PTrialDialog, Init(@DialogData)));
                DeskTop^.Insert(PV);
                TrialDialog:= PTrialDialog(PV);
                DialSaved:= false;
            end;

         cmSetDefault: Default.DDialog:= DialogData;

         cmSetPaste: Paste.DDialog:= DialogData;

         {else cmCancel}
        end; {case}
    end; {NewDialog}

    procedure NewStaticText;
    var
        StaticTextData: TStaticTextData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then StaticTextData:= Paste.DStaticText
        else StaticTextData:= Default.DStaticText;

        case ExecuteDialog(New(PStaticTextDialog, Init(false)),
                @StaticTextData)
        of
         cmOk:
            if StaticTextData.RText <> '' then begin
                TrialDialog^.Insert(ValidView(New(PTrialStaticText,
                    Init(@StaticTextData))));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DStaticText:= StaticTextData;

         cmSetPaste: Paste.DStaticText:= StaticTextData;

        end; {case}
    end; {NewStaticText}

    procedure NewParamText;
    var
        ParamTextData: TParamTextData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ParamTextData:= Paste.DParamText
        else ParamTextData:= Default.DParamText;

        case ExecuteDialog(New(PParamTextDialog, Init(false)),
                @ParamTextData)
        of
         cmOk:
            with ParamTextData do
            if (RFormat <> '') and (RNames <> '') then begin
                TrialDialog^.Insert(ValidView(New(PTrialParamText,
                    Init(@ParamTextData))));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DParamText:= ParamTextData;

         cmSetPaste: Paste.DParamText:= ParamTextData;

        end; {case}
    end; {NewParamText}

    procedure NewButton;
    var
        ButtonData: TButtonData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ButtonData:= Paste.DButton
        else ButtonData:= Default.DButton;

        case ExecuteDialog(New(PButtonDialog, Init(false)),
                @ButtonData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialButton,
                    Init(@ButtonData))));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DButton:= ButtonData;

         cmSetPaste: Paste.DButton:= ButtonData;

        end; {case}
    end; {NewButton}

    procedure NewInputLine;
    var
        InputLineData: TInputLineData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then InputLineData:= Paste.DInputLine
        else InputLineData:= Default.DInputLine;

        case ExecuteDialog(New(PInputLineDialog, Init(false)),
            @InputLineData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialInputLine,
                    Init(@InputLineData))));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DInputLine:= InputLineData;

         cmSetPaste: Paste.DInputLine:= InputLineData;

        end; {case}
    end; {NewInputLine}

    procedure NewRadioButtons;
    var
        I: integer;
        ClusterData: TClusterData;
        RB: PTrialRadioButtons;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DRadioButtons
        else ClusterData:= Default.DRadioButtons;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(false, 'RB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                RB:= New(PTrialRadioButtons, Init(@ClusterData));
                RB^.TC.Resize(RB^, RB^.LabelP);
                TrialDialog^.Insert(ValidView(RB));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DRadioButtons:= ClusterData;

         cmSetPaste:
            begin
                Paste.DRadioButtons:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
        ClusterData.RStrings^.Done;  Dispose(ClusterData.RStrings);
        ClusterData.RItemNames^.Done;  Dispose(ClusterData.RItemNames);
    end; {NewRadioButtons}

    procedure NewCheckBoxes;
    var
        I: integer;
        ClusterData: TClusterData;
        CB: PTrialCheckBoxes;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DCheckBoxes
        else ClusterData:= Default.DCheckBoxes;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(false, 'CB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                CB:= New(PTrialCheckBoxes, Init(@ClusterData));
                CB^.TC.Resize(CB^, CB^.LabelP);
                TrialDialog^.Insert(ValidView(CB));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DCheckBoxes:= ClusterData;

         cmSetPaste:
            begin
                Paste.DCheckBoxes:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
        ClusterData.RStrings^.Done;  Dispose(ClusterData.RStrings);
        ClusterData.RItemNames^.Done;  Dispose(ClusterData.RItemNames);
    end; {NewCheckBoxes}

    procedure NewMultiCheckBoxes;
    var
        I: integer;
        ClusterData: TClusterData;
        CB: PTrialMultiCheckBoxes;
        Cmd: word;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ClusterData:= Paste.DMultiCheckBoxes
        else ClusterData:= Default.DMultiCheckBoxes;
        InitStrings(ClusterData);

        Cmd:= ExecuteDialog(New(PClusterDialog, Init(false, 'MB')),
                @ClusterData);

        case Cmd of
         cmOk:
            with ClusterData do begin
                CB:= New(PTrialMultiCheckBoxes, Init(@ClusterData));
                CB^.TC.Resize(CB^, CB^.LabelP);
                TrialDialog^.Insert(ValidView(CB));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DMultiCheckBoxes:= ClusterData;

         cmSetPaste:
            begin
                Paste.DMultiCheckBoxes:= ClusterData;
                CopyStrings(PasteStrings, ClusterData.RStrings);
                CopyStrings(PasteNames, ClusterData.RItemNames);
            end;

         {else cmCancel}
        end; {case}
        ClusterData.RStrings^.Done;  Dispose(ClusterData.RStrings);
        ClusterData.RItemNames^.Done;  Dispose(ClusterData.RItemNames);
    end; {NewMultiCheckBoxes}

    procedure NewListBox;
    var
        ListBoxData: TListBoxData;
    begin
        if TrialDialog = nil then exit;
        if ModeToken^.State and sfPaste <> 0
        then ListBoxData:= Paste.DListBox
        else ListBoxData:= Default.DListBox;

        case ExecuteDialog(New(PListBoxDialog, Init(false)),
            @ListBoxData)
        of
         cmOk:
            begin
                TrialDialog^.Insert(ValidView(New(PTrialListBox,
                    Init(@ListBoxData))));
                DialSaved:= false;
            end;

         cmSetDefault: Default.DListBox:= ListBoxData;

         cmSetPaste: Paste.DListBox:= ListBoxData;

        end; {case}
    end; {NewListBox}

    procedure SnapIt;
    begin
        if TrialDialog <> nil then begin
            { open code output if not already: }
            OpenCodeFile;
            writeln('(*');
            with OutOptData do
            TrialDialog^.SnapPicture(RShow, RShades);
            writeln('*)');
        end;
    end; {SnapIt}

    procedure SetFiles;
    var
        TempOpts: TFileOptData;
        CollChg, CodeChg, HistChg: boolean;
    begin
        TempOpts:= FileOptData;
        ExecuteDialog(New(PFileOptDialog, Init), @TempOpts);
        CollChg:= FileOptData.CollFName <> TempOpts.CollFName;
        CodeChg:= FileOptData.CodeFName <> TempOpts.CodeFName;
        HistChg:= FileOptData.HistFName <> TempOpts.HistFName;
        if CollChg then CloseCollFile;
        if CodeChg then CloseCodeFile;
        if HistChg then WriteHistory;
        FileOptData:= TempOpts;
        { new Res, Out files opened when first needed }
        if HistChg then ReadHistory;
    end; {SetFiles}

    procedure SetOutput;
    begin
        with OutOptData do begin
            OutOptData:= Default.DOutOpt;
            OutOptData.RSave:= 0;
            { set up output options: }
            if ExecuteDialog(New(POutOptDialog, Init),
                @OutOptData) <> cmCancel
            then begin
                if OutOptData.RInclude = 0 then begin
                    MessageBox('No output selected.',
                        nil, mfError+mfOkButton);
                end else begin
                    case OutOptData.RIndent of
                     0: Tab:= #9;       {T}
                     1: Tab:= '    ';   {4}
                     2: Tab:= '   ';    {3}
                     3: Tab:= '  ';     {2}
                     4: Tab:= ' ';      {1}
                    end; {case}
                    { pick dialogs and output: }
                    FetchDialog(true);
                end;
                if OutOptData.RSave <> 0
                then Default.DOutOpt:= OutOptData;
            end;
        end;
    end; {SetOutput}

    var
        R: TRect;

begin {TDialEditApp.HandleEvent}
    inherited HandleEvent(Event);
    case Event.What of
     evCommand:
        case Event.Command of
         cmNewDialog: NewDialog;

         cmNewStaticText: NewStaticText;

         cmNewParamText: NewParamText;

         cmNewButton: NewButton;

         cmNewInputLine: NewInputLine;

         cmNewRadioButtons: NewRadioButtons;

         cmNewCheckBoxes: NewCheckBoxes;

         cmNewMultiCheckBoxes: NewMultiCheckBoxes;

         cmNewListBox: NewListBox;

         cmSaveDialog: SaveDialog;

         cmDeleteDialog: DeleteDialog;

         cmFetchDialog: FetchDialog(false);

         cmSwapDialogs:
            begin
                AutoSave:= true;
                GetDialog(PrevDialog);
                AutoSave:= false;
            end;

         cmTestDialog: TestDialog;

         cmGenCode: GenCode(TrialDialog);

         cmOutput: SetOutput;

         cmSnapPicture: SnapIt;

         cmSetFiles: SetFiles;

         cmChangeDir:
            ExecuteDialog(New(PChDirDialog, Init(cdNormal, 0)), nil);

{$IFDEF ScreenCapture}
         cmScreenCapture:
            begin
                GetExtent(R);
                ScreenCapture(R);
            end;
{$ENDIF}

         else exit;
        end;
     else exit;
    end;
    ClearEvent(Event);
end; {TDialEditApp.HandleEvent}

procedure TDialEditApp.Idle;
begin
    inherited Idle;
    Clock^.Update;
{$IFNDEF VPASCAL}
    Heap^.Update;
{$ENDIF}
    SwapToken^.Update;
end;

procedure TDialEditApp.OutOfMemory;
begin
    MessageBox('Not enough memory for this operation.',
        nil, mfError + mfOkButton);
end; {TDialEditApp.OutOfMemory}

{*******************************************************}

begin
    DialEditApp.Init;
    DialEditApp.Run;
    DialEditApp.Done;
end.
