program mb;

uses
  //Lib
  App, Objects, Drivers, Views, Menus, MsgBox, Dialogs, Editors, StdDlg, Gadgets,
  //Form
  FormTest;

const
  //None
  cmNone       = 1000;
  cmTest       = 1001;

type
  TMbApp = object(TApplication)
    Heap: PHeapView;
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
    procedure OutOfMemory; virtual;
    procedure Idle; Virtual;
    //procedure CloseWindow(var P : PGroup);
    procedure HandleEvent(var Event: TEvent); virtual;
    //Port
    procedure FormTestShow;
  private
    menuEng: PMenuView;
    StatusEng: PStatusLine;
  end;


  //StatusBar
  procedure TMbApp.InitStatusLine;
  var
    Rect: TRect;
    R: TRect;
  begin
    //StatusBar
    GetExtent(R);
    R.A.Y := R.B.Y - 1;
    R.B.X := R.B.X - 12;
    New(StatusLine,
      Init(R,
        NewStatusDef(0, $FFFF,
        NewStatusKey('~Alt+X~ Exit', kbAltX,  cmQuit,
        NewStatusKey('~F10~ Menu',   kbF10,   cmMenu,
        NewStatusKey('~F1~ Help',    kbF1,    cmHelp,
        StdStatusKeys(nil)))),nil)
      )
    );
    //Heap
    GetExtent(R);
    R.A.X := R.B.X - 12; R.A.Y := R.B.Y - 1;
    Heap := New(PHeapView, Init(R));
    Insert(Heap); 
  end;

  //MainMenu
  procedure TMbApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    menuEng := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~F~ile', hcNoContext, NewMenu(
           NewItem('~E~xit...',   '',   kbNoKey, cmQuit, hcNoContext, nil)),
      NewSubMenu('~T~est', hcNoContext, NewMenu(
           NewItem('~T~List...',      '',   kbNoKey, cmTest, hcNoContext, nil)), nil))
    )));
    MenuBar := menuEng;
  end;

  //Event
  procedure TMbApp.HandleEvent(var Event: TEvent);
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;
    inherited HandleEvent(Event);
    if (Event.What = evCommand) then begin
      case Event.Command of
        cmNone:       begin MessageBox('No Supported !', nil, mfError + mfOkButton);     end;
        cmTest:       begin FormTestShow;        end;
        else begin Exit; end;
      end;
    end;
    ClearEvent(Event);
  end;

  //ShowTestForm
  procedure TMbApp.FormTestShow;
  var
    TestDialog: PFormTest;
  begin
    TestDialog := New(PFormTest, Init());
    if ValidView(TestDialog) <> nil then
    begin
      Desktop^.ExecView(TestDialog);
      Dispose(TestDialog, Done);
    end;
  end;



  //Error: Out of Memory
  procedure TMbApp.OutOfMemory;
  begin
    MessageBox('Out of Memory!', nil, mfError + mfOkButton);
  end;

  //Idle 
  procedure TMbApp.Idle;
    function IsTileable(P: PView): Boolean; far;
    begin
      IsTileable := (P^.Options and ofTileable <> 0) and (P^.State and sfVisible <> 0);
    end;
  {$ifdef DEBUG}
  Var
     WasSet : boolean;
  {$endif DEBUG}
  begin
    inherited Idle;
  {$ifdef DEBUG}
     if WriteDebugInfo then
       begin
        WasSet:=true;
        WriteDebugInfo:=false;
       end
     else
        WasSet:=false;
     if WriteDebugInfo then
  {$endif DEBUG}
    //Clock^.Update;
    Heap^.Update;
  {$ifdef DEBUG}
     if WasSet then
       WriteDebugInfo:=true;
  {$endif DEBUG}
    if Desktop^.FirstThat(@IsTileable) <> nil then
      EnableCommands([cmTile, cmCascade])
    else
      DisableCommands([cmTile, cmCascade]);
  end;

var
  MbApp: TMbApp;

begin
  MbApp.Init;
  MbApp.Run;
  MbApp.Done;
end.



