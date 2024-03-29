//image image.png
(*
In diesem Beispiel wird ein kleines Gadgets geladen, welches eine <b>Uhr</b> anzeigt.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  MsgBox,   // Messageboxen
  Dialogs,  // Dialoge
  StdDlg,   // Für Datei öffnen
  Gadgets,
  MyDialog;

const
  cmDialog   = 1001;     // Dialog anzeigen
  cmFileTest = 1002;

type
  TMyApp = object(TApplication)
    Heap: PClockView;
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.

    procedure NewWindows(Titel: ShortString);

    procedure Idle; Virtual;
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;    // Rechteck für die Statuszeilen Position.
  begin

    // StatusBar
    GetExtent(R);
    R.B.X := R.B.X - 9;
    R.A.Y := R.B.Y - 1;

    New(StatusLine,
      Init(R,
        NewStatusDef(0, $FFFF,
        NewStatusKey('~Alt+X~ Exit', kbAltX,  cmQuit,
        NewStatusKey('~F10~ Menu',   kbF10,   cmMenu,
        NewStatusKey('~F1~ Help',    kbF1,    cmHelp,
        StdStatusKeys(nil)))),nil)
      )
    );

    (*
    Erzeugt ein kleines Fenster rechts-unten, welches die Uhr anzeigt.
    *)
    //code+
    GetExtent(R);
    R.A.X := R.B.X - 9;
    R.A.Y := R.B.Y - 1;
    Heap := New(PClockView, Init(R));
    Insert(Heap); 
    //code-
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;    // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~F~ile open', '', kbNoKey, cmFileTest, hcNoContext,
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('Dia~l~og...', '', kbNoKey, cmDialog, hcNoContext, nil)), nil)))));
  end;

(*
Den Dialog mit dem Speicher Leak aufrufen.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        // Dialog mit der ListBox, welcher ein Speicher Leak hat.
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);   // Dialog ausführen.
            Dispose(MyDialog, Done);       // Dialog und Speicher frei geben.
          end;
        end;
        // Ein FileOpenDialog, bei dem alles in Ordnung ist.
        cmFileTest:begin
          FileName := '*.*';
          New(FileDialog, Init(FileName, 'Datei '#148'ffnen', '~D~ateiname', fdOpenButton, 1));
          if ExecuteDialog(FileDialog, @FileName) <> cmCancel then begin
            NewWindows(FileName); // Neues Fenster mit der ausgewählten Datei.
          end;
        end
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
//code-

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;


  procedure TMyApp.NewWindows(Titel: ShortString);
  var
    Win: PWindow;
    R: TRect;
  begin
    R.Assign(0, 0, 60, 20);
    Win := New(PWindow, Init(R, Titel, wnNoNumber));
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;

(*
Die Idle Routine, welche im Leerlauf den Heap prüft und anzeigt.
*)
//code+
  procedure TMyApp.Idle;

    function IsTileable(P: PView): Boolean;
    begin
      Result := (P^.Options and ofTileable <> 0) and (P^.State and sfVisible <> 0);
    end;

  begin
    inherited Idle;
    Heap^.Update;
    if Desktop^.FirstThat(@IsTileable) <> nil then begin
      EnableCommands([cmTile, cmCascade])
    end else begin
      DisableCommands([cmTile, cmCascade]);
    end;
  end;
//code-

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben

//lineal
(*
<b>Unit mit dem neuen Dialog.</b>
<br>
Der Dialog mit dem dem Speicher Leak
*)
//includepascal mydialog.pas head

(*
Den <b>Destructor</b> deklarieren, welcher das <b>Speicher Leak</b> behebt.
*)
//includepascal mydialog.pas type

(*
Komponenten für den Dialog generieren.
*)
//includepascal mydialog.pas init

(*
Manuell den Speicher frei geben.
Man kann hier versuchsweise das Dispose ausklammern, dann sieht man,
das man eine Speicherleak bekommt.
*)
//includepascal mydialog.pas done

(*
Der EventHandle
*)
//includepascal mydialog.pas handleevent

end.
