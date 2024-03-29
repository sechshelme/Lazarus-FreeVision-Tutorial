//image image.png
(*
In diesem Beispiel wird gezeigt, wie man Komponenten zu Laufzeit ändern kann.
Dafür wird ein Button verwendet, bei dem sich die Bezeichnung bei jedem Klick erhöht.
*)
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  Menus,    // Statuszeile
  MsgBox,   // Messageboxen
  Dialogs,  // Dialoge
  StdDlg,
  Gadgets,
  MyDialog;

const
  cmDialog   = 1001;     // About anzeigen
  cmFileTest = 1002;

type
  TMyApp = object(TApplication)
    Heap: PHeapView;
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.

    procedure NewWindows(Titel: ShortString);

    procedure Idle; Virtual;
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;                 // Rechteck für die Statuszeilen Position.
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
    Heap := New(PHeapView, InitComma(R));
    Insert(Heap); 
  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;                          // Rechteck für die Menüzeilen-Position.
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

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
    FileDialog: PFileDialog;
    FileName: ShortString;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                        // About Dialog
        cmDialog: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(MyDialog);           // Dialog About ausführen.
            Dispose(MyDialog, Done);               // Dialog und Speicher frei geben.
          end;
        end;
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

  procedure TMyApp.OutOfMemory;
  begin
    MessageBox('Zu wenig Arbeitsspeicher !', nil, mfError + mfOkButton);
  end;


(*
Neues Fenster erzeugen. Fenster werden in der Regel nicht modal geöffnet, da man meistens mehrere davon öffnen will.
*)
  //code+
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
  //code-


  //Idle
  procedure TMyApp.Idle;
    function IsTileable(P: PView): Boolean;
    begin
      IsTileable := (P^.Options and ofTileable <> 0) and (P^.State and sfVisible <> 0);
    end;
  begin
    inherited Idle;
    //Clock^.Update;
    Heap^.Update;
    if Desktop^.FirstThat(@IsTileable) <> nil then
      EnableCommands([cmTile, cmCascade])
    else
      DisableCommands([cmTile, cmCascade]);
  end;

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
Der Dialog mit dem Zähler-Button.
*)
//includepascal mydialog.pas head

(*
Will man eine Komponente zur Laufzeit modifizieren, dann muss man sie deklarieren, ansonsten kann man nicht mehr auf sie zugreifen.
Direkt mit <b>Insert(New(...</b> geht nicht mehr.
*)
//includepascal mydialog.pas type

(*
Im Konstruktor sieht man, das man den Umweg über der <b>CounterButton</b> macht.
<b>CounterButton</b> wird für die Modifikation gebraucht.
*)
//includepascal mydialog.pas init

(*
Im EventHandle, wird die Zahl im Button beim Drücken erhöht.
Das sieht man, warum man den <b>CounterButton</b> braucht, ohne dem hätte man keinen Zugriff auf <b>Titel</b>.
Wichtig, wen man eine Komponente ändert, muss man mit <b>Draw</b> die Komponente neu zeichnen, ansonsten sieht man den geänderten Wert nicht.
*)
//includepascal mydialog.pas handleevent

end.
