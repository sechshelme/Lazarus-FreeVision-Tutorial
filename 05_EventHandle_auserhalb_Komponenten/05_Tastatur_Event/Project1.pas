//image image.png
(*
Man kann einen EventHandle im Dialog/Fenster abfangen, wen man die Maus bewegt/klickt.
Im Hauptprogramm hat es dafür nichts besonders, dies alles läuft lokal im Dialog/Fenster ab.
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
  MyDialog;

const
  cmKeyAktion = 1001;     // About anzeigen

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
  end;

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;              // Rechteck für die Statuszeilen Position.
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Tastenaktionen...', kbF1, cmKeyAktion, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;                       // Rechteck für die Menüzeilen-Position.

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~T~astenaktionen...', '', kbNoKey, cmKeyAktion, hcNoContext, nil)), nil)))));
  end;

(*
Im Hauptprogramm wird nur der Dialog gebaut, aufgerufe und geschlossen.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    KeyDialog: PMyKey;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmKeyAktion: begin
          KeyDialog := New(PMyKey, Init);
          if ValidView(KeyDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(KeyDialog);           // Dialog Mausaktion ausführen.
            Dispose(KeyDialog, Done);               // Dialog und Speicher frei geben.
          end;
        end;
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

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben

//lineal
(*
<b>Unit mit dem Keyboardaktions-Dialog.</b>
<br>
*)
//includepascal mydialog.pas head

(*
In dem Object sind die <b>PEditLine</b> globel deklariert, da diese später bei Mausaktionen modifiziert werden.
*)
//includepascal mydialog.pas type

(*
Es wird ein Dialog mit EditLine, Label und Button gebaut.
Einzig besonderes dort, die <b>Editlline</b> wird der Status auf <b>ReadOnly</b> gesetzt eigene Eingaben sind dort unerwünscht.
*)
//includepascal mydialog.pas init

(*
Im EventHandle sieht man, das die Tastatur abgefangen wird. Es wird der Zeichencode und der Scancode ausgegeben.
In der untersten Zeile erscheint ein 3, wen die Shift-Taste mit gewissen anderen Tasten zB. Pfeil-Tasten gedrückt wird.
Die Tastatur-Daten werden an die <b>EditLines</b> ausgegeben.
*)
//includepascal mydialog.pas handleevent

end.
