//image image.png
(*
Es ist auch möglich auf ein Resize-Ereigniss vom terminal zu reagieren.
Dieses Beispiel funktioniert nur mit <b>Linux</b>
Technisch bedingt von Free-Vision ist bei <b>255</b> Zeichen pro Zeile Schluss.

Achtung !
Dies ist eine Eigenkreation, daher kann es Bugs haben.
Es kann zu Konflikten kommen, wen das Resize-Ereigniss aufgerufen wird,
während eine andere Ausgabe läuft.
*)
//lineal
program Project1;

//code+
uses
  BaseUnix, // Für Resize Signal und Auflösung
//code-
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

const
  cmNewWin = 1001;
  cmRefresh = 1002;
type
  TMyApp = object(TApplication)
    constructor Init;

    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;

    procedure HandleEvent(var Event: TEvent); virtual;
    procedure OutOfMemory; virtual;

    procedure NewWindows(FileName: ShortString);
    procedure OpenWindows;
    procedure SaveAll;
    procedure CloseAll;
  end;

var
  MyApp: TMyApp;

  function DECreateFindDialog: PDialog;
  var
    D: PDialog;
    Control: PView;
    R: TRect;
  begin
    R.Assign(0, 0, 38, 12);
    D := New(PDialog, Init(R, 'Suchen'));
    with D^ do begin
      Options := Options or ofCentered;

      R.Assign(3, 3, 32, 4);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      R.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(R, 'Zu ~s~uchenden Text', Control)));
      R.Assign(32, 3, 35, 4);
      Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

      R.Assign(3, 5, 35, 7);
      Control := New(PCheckBoxes, Init(R,
        NewSItem('~G~ross- und Kleinschreibung',
        NewSItem('~N~ur ganze W'#148'rter', nil))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      R.Assign(14, 9, 24, 11);
      Control := New(PButton, Init(R, slOK, cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      Inc(R.A.X, 12);
      Inc(R.B.X, 12);
      Control := New(PButton, Init(R, slCancel, cmCancel, bfNormal));
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
    R: TRect;
  begin
    R.Assign(0, 0, 40, 16);
    Dialog := New(PDialog, Init(R, 'Ersetzen'));
    with Dialog^ do begin
      Options := Options or ofCentered;

      R.Assign(3, 3, 34, 4);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDFindText;
      Insert(Control);
      R.Assign(2, 2, 20, 3);
      Insert(New(PLabel, Init(R, 'Zu ~s~uchenden Text', Control)));
      R.Assign(34, 3, 37, 4);
      Insert(New(PHistory, Init(R, PInputLine(Control), 10)));

      R.Assign(3, 6, 34, 7);
      Control := New(PInputLine, Init(R, 80));
      Control^.HelpCtx := hcDReplaceText;
      Insert(Control);
      R.Assign(2, 5, 20, 6);
      Insert(New(PLabel, Init(R, 'Neuer ~T~ext', Control)));
      R.Assign(34, 6, 37, 7);
      Insert(New(PHistory, Init(R, PInputLine(Control), 11)));

      R.Assign(3, 8, 37, 12);
      Control := New(Dialogs.PCheckBoxes, Init(R,
        NewSItem('~G~ross- und Kleinschreibung',
        NewSItem('~N~ur ganze W'#148'rter',
        NewSItem('~R~egul'#132're Ausdr'#129'cke',
        NewSItem('~A~lle ersetzen', nil))))));
      Control^.HelpCtx := hcCCaseSensitive;
      Insert(Control);

      R.Assign(8, 13, 18, 15);
      Control := New(PButton, Init(R, '~O~k', cmOk, bfDefault));
      Control^.HelpCtx := hcDOk;
      Insert(Control);

      R.Assign(22, 13, 32, 15);
      Control := New(PButton, Init(R, 'Ab~b~ruch', cmCancel, bfNormal));
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
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F2~ Speichern', kbF2, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil)))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~N~eu', 'F4', kbF4, cmNewWin, hcNoContext,
        NewItem('~O~effnen...', 'F3', kbF3, cmOpen, hcNoContext,
        NewItem('~S~peichern', 'F2', kbF2, cmSave, hcNoContext,
        NewItem('Speichern ~u~nter...', '', kbNoKey, cmSaveAs, hcNoContext,
        NewItem('~A~lle speichern', '', kbNoKey, cmSaveAll, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)))))))),
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
        NewItem('~S~chliessen', 'Alt+F3', kbAltF3, cmClose, hcNoContext, nil)))))))))))), nil))))));
  end;

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;

  procedure TMyApp.NewWindows(FileName: ShortString);
  var
    Win: PEditWindow;
    R: TRect;
  const
    WinCounter: integer = 0;      // Zählt Fenster
  begin
    R.Assign(0, 0, 60, 20);
    Inc(WinCounter);
    Win := New(PEditWindow, Init(R, FileName, WinCounter));

    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end else begin                // Fügt das Fenster ein.
      Dec(WinCounter);
    end;
  end;

  procedure TMyApp.OpenWindows;
  var
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    FileName := '*.*';
    New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
    if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
      NewWindows(FileName); // Neues Fenster mit der ausgewählten Datei.
    end;
  end;
  procedure TMyApp.SaveAll;

    procedure SendSave(P: PView);
    begin
      Message(P, evCommand, cmSave, nil); // Das Kommando speicherm mitgeben.
    end;

  begin
    Desktop^.ForEach(@SendSave);          // Auf alle Fenster anwenden.
  end;

  procedure TMyApp.CloseAll;

    procedure SendClose(P: PView);
    begin
      Message(P, evCommand, cmClose, nil);
    end;

  begin
    Desktop^.ForEach(@SendClose);
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmNewWin: begin
          NewWindows('');   // Leeres Fenster erzeugen.
        end;
        cmOpen: begin
          OpenWindows;      // Datei öffnen.
        end;
        cmSaveAll: begin
          SaveAll;          // Alle speichern.
        end;
        cmCloseAll: begin
          CloseAll;         // Schliesst alle Fenster.
        end;
        cmRefresh: begin
          ReDraw;           // Anwendung neu zeichnen.
        end;
        else begin
          Exit;
        end;
      end;
    end;
  end;

(*
Dies muss eingefügt werden, um auf ein Resize-Ereigniss zu reagieren
*)
//code+

const
  STDIN_FILENO = 0;   // Standard input
  STDOUT_FILENO = 1;  // Standard output
  STDERR_FILENO = 2;  // Standard error output

  TIOCGWINSZ = $5413;
  SIGWINCH = 28;      // Window size change

  procedure resize(signal: longint); cdecl;
  var
    w: record
      ws_row, ws_col, ws_xpixel, ws_ypixel: cshort;
    end;
    vm: TVideoMode;
  begin
    FpIOCtl(STDOUT_FILENO, TIOCGWINSZ, @w);  // Aktuelle Auflösung abfragen.
    if w.ws_col > 255 then begin  // Abfragen, ob mehr als 255 Zeichen pro Spalte,
      w.ws_col := 255;            // Wen ja auf 255 Zeichen begrenzen.
    end;                          // Mehr als 255 Zeichen liegt technisch bei FV nicht drin !

    vm.Col := w.ws_col;
    vm.Row := w.ws_row;
    MyApp.SetScreenVideoMode(vm); // Neue Koordinaten FV übergeben.

    MyApp.ReDraw;                 // Desktop neu zeichen.
  end;

begin
  MyApp.Init;

  FpSignal(SIGWINCH, @resize); // Resize abfangen

  MyApp.Run;
  MyApp.Done;
end.
//code-

