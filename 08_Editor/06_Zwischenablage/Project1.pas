//image image.png
(*
Hier wurde ein Zwischenablage hinzugefügt, somit ist auch kopieren und einfügen im Editor möglich.
Die Zwischeablage ist nicht anderes als ein Editor-Fenster welches die Daten bekommt, wen man kopieren wählt.
Somit kann man dieses sogar sichbar machen.
*)
//lineal
program Project1;

uses
  App,
  Objects,
  Drivers,
  Views,
  MsgBox,
  Editors,
  Dialogs,
  StdDlg,
  Menus,
  FVConsts;

(*
Ein Kommando für das öffnen des Zwischenablagefenster.
*)
//code+
const
  cmNewWin = 1001;
  cmRefresh = 1002;
  cmShowClip = 1003;
//code-

(*
Hier wird das Fenster für die Zwischenablage deklariert.
Auch kann man bei <b>NewWindows</b> sagen, ob das Fenster nicht sichtbar ezeigt werden soll.
*)
//code+
type
  TMyApp = object(TApplication)
    ClipWindow: PEditWindow;

    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    function NewWindows(FileName: ShortString; Visible: Boolean = False): PEditWindow;
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;
//code-

var
  MyApp: TMyApp;

  function DECreateFindDialog: PDialog;
  var
    D: PDialog;
    Control: PView;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 38, 12);
    D := New(PDialog, Init(Rect, 'Suchen'));
    with D^ do begin
      Options := Options or ofCentered;

      Rect.Assign(3, 3, 32, 4);
      Control := New(PInputLine, Init(Rect, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      Rect.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(Rect, 'Zu ~s~uchenden Text', Control)));
      Rect.Assign(32, 3, 35, 4);
      Insert(New(PHistory, Init(Rect, PInputLine(Control), 10)));

      Rect.Assign(3, 5, 35, 7);
      Control := New(PCheckBoxes, Init(Rect,
        NewSItem('~G~ross- und Kleinschreibung',
        NewSItem('~N~ur ganze W'#148'rter', nil))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      Rect.Assign(14, 9, 24, 11);
      Control := New(PButton, Init(Rect, slOK, cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      Inc(Rect.A.X, 12);
      Inc(Rect.B.X, 12);
      Control := New(PButton, Init(Rect, slCancel, cmCancel, bfNormal));
      Control^.HelpCtx := hcDCancel;
      Insert(Control);

      SelectNext(False);
    end;
    Result := D;
  end;

  function DECreateReplaceDialog: PDialog;
  var
    Dialog: PDialog;
    Control: PView;
    Rect: TRect;
  begin
    Rect.Assign(0, 0, 40, 16);
    Dialog := New(PDialog, Init(Rect, 'Ersetzen'));
    with Dialog^ do begin
      Options := Options or ofCentered;

      Rect.Assign(3, 3, 34, 4);
      Control := New(PInputLine, Init(Rect, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      Rect.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(Rect, 'Zu ~s~uchenden Text', Control)));
      Rect.Assign(34, 3, 37, 4);
      Insert(New(PHistory, Init(Rect, PInputLine(Control), 10)));

      Rect.Assign(3, 6, 34, 7);
      Control := New(PInputLine, Init(Rect, 80));
      Control^.HelpCtx := hcDReplaceText;
      Insert(Control);
      Rect.Assign(2, 5, 20, 6);
      Insert(New(PLabel, Init(Rect, 'Neuer ~T~ext', Control)));
      Rect.Assign(34, 6, 37, 7);
      Insert(New(PHistory, Init(Rect, PInputLine(Control), 11)));

      Rect.Assign(3, 8, 37, 12);
      Control := New(Dialogs.PCheckBoxes, Init(Rect,
        NewSItem('~G~ross- und Kleinschreibung',
        NewSItem('~N~ur ganze W'#148'rter',
        NewSItem('~R~egul'#132're Ausdr'#129'cke',
        NewSItem('~A~lle ersetzen', nil))))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      Rect.Assign(8, 13, 18, 15);
      Control := New(PButton, Init(Rect, '~O~k', cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      Rect.Assign(22, 13, 32, 15);
      Control := New(PButton, Init(Rect, 'Ab~b~ruch', cmCancel, bfNormal));
      Control^.HelpCtx := hcDCancel;
      Insert(Control);

      SelectNext(False);
    end;
    Result := Dialog;
  end;

  function MyStdEditorDialog(Dialog: Int16; Info: Pointer): word;
  begin
    case Dialog of
      edSaveAs: begin                           // Neuer Dialog in Deutsch.
        Result := MyApp.ExecuteDialog(New(PFileDialog, Init('*.txt',
          'Datei speichern unter', '~D~atei-Name', fdOkButton, 101)), Info);
      end;
      edFind:                                   // Der kommplet neue Suchen-Dialog.
        Result := Application^.ExecuteDialog(DECreateFindDialog, Info);
      edReplace:                                // Der kommplet neue Ersetzen-Dialog.
      begin
        Result := MyApp.ExecuteDialog(DECreateReplaceDialog, Info);
      end;
      else begin
        Result := StdEditorDialog(Dialog, Info);
      end;                                      // Original Dialoge aufrufen.
    end;
  end;

  constructor TMyApp.Init;
  begin
    inherited Init;
    EditorDialog := @MyStdEditorDialog; // Die neue Dialog-Routine.
    DisableCommands([cmSave, cmSaveAs, cmCut, cmCopy, cmPaste, cmClear, cmUndo]);
    NewWindows('');                     // Leeres Fenster erzeugen.

    ClipWindow := NewWindows('', True);
    if ClipWindow <> nil then begin
      Clipboard := ClipWindow^.Editor;
      Clipboard^.CanUndo := False;
    end;
  end;

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Speichern', kbF2, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil)))), nil)));
  end;

(*
Im Menü sind die neuen Bearbeiten-Funktionen dazugekommen.
*)
  //code+
  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewItem('~O~effnen...', 'F3', kbF3, cmOpen, hcNoContext,
        NewItem('~S~peichern', 'F2', kbF2, cmSave, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('~A~lle speichern', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
      NewSubMenu('~B~earbeiten', hcNoContext, NewMenu(
        NewItem('~R~'#129'ckg'#132'ngig', '', kbAltBack, cmUndo, hcUndo,
        NewLine(
        NewItem('Aus~s~chneiden', 'Shift+Del', kbShiftDel, cmCut, hcCut,
        NewItem('~K~opieren', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
        NewItem('~E~inf'#129'gen', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
        NewItem('~L~'#148'schen', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
        NewLine(
        NewItem('~Z~wischenablage', '', kbNoKey, cmShowClip, hcCut, nil))))))))),
      NewSubMenu('~S~uchen', hcNoContext, NewMenu(
        NewItem('~S~uchen...', 'Ctrl+F', kbCtrlF, cmFind, hcNoContext,
        NewItem('~E~rsetzten...', 'Ctrl+H', kbCtrlH, cmReplace, hcNoContext,
        NewItem('Suche ~n~'#132'chstes', 'Ctrl+N', kbCtrlN, cmSearchAgain, hcNoContext, nil)))),
      NewSubMenu('~F~enster', hcNoContext, NewMenu(
        NewItem('~N~ebeneinander', '', kbNoKey, cmTile, hcNoContext,
        NewItem(#154'ber~l~append', '', kbNoKey, cmCascade, hcNoContext,
        NewItem('~A~lle schliessen', '', kbNoKey, cmCloseAll, hcNoContext,
        NewItem('Anzeige ~e~rneuern', '', kbNoKey, cmRefresh, hcNoContext,
        NewLine(
        NewItem('Gr'#148'sse/~P~osition', 'Ctrl+F5', kbCtrlF5, cmResize, hcNoContext,
        NewItem('Ver~g~'#148'ssern', 'F5', kbF5, cmZoom, hcNoContext,
        NewItem('~N~'#132'chstes', 'F6', kbF6, cmNext, hcNoContext,
        NewItem('~V~orheriges', 'Shift+F6', kbShiftF6, cmPrev, hcNoContext,
        NewLine(
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, nil)))))))))))), nil)))))));
  end;
  //code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

(*
Hier sieht man, wie man ein Fenster unsichbar erzeugen kann.
*)
//code+
  function TMyApp.NewWindows(FileName: ShortString; Visible: Boolean = False) : PEditWindow;
  var
    Win: PEditWindow;
    Rect: TRect;
  const
    WinCounter: integer = 0;
  begin
    Rect.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(Rect, FileName, WinCounter));
    if ValidView(Win) <> nil then begin
      if Visible then begin
        win^.Hide;        // Fenster verstecken.
      end;
      Result := PEditWindow(MyApp.InsertWindow(win));
    end else begin
      Dec(WinCounter);
    end;
  end;
//code-

  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';
    New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName);
    end;
  end;
  procedure TMyApp.SaveAll;

    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil);
    end;

  begin
    Desktop^.ForEach(@SendSave);
  end;

  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;

(*
Hier sieht man, wie man das verborgene Zwischenablagefenster sichbar macht.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');
        end;
        cmOpen: begin
          OpenWindows;
        end;
        cmSaveAll: begin
          SaveAll;
        end;
        cmCloseAll: begin
          CloseAll;
        end;
        cmRefresh: begin
          ReDraw;
        end;
        cmShowClip: begin     // Clipboard anzeigen.
          ClipWindow^.Select;
          ClipWindow^.Show;
        end;
        else begin
          Exit;
        end;
      end;
    end;
  end;
//code-

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
