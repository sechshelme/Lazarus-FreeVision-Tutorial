//image image.png
(*
Einem Fenster/Dialog, kann man verschiedene FarbeSchema zuordnen.
Standardmässig wird folgendes verwendet:
//code+
Editor-Fenster : Blau
Dialog         : Grau
Hilfe-Fenster  : Cyan
//code-

Ohne Zutun, kommen die Fenster/Dialog immer in der richtigen Farbe.
Eine Modifizierung ist nur in speziellen Fällen von Sinnen.
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
  MyDialog;

const
  cmAbout = 1001;     // About anzeigen

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
      NewStatusKey('~F1~ About...', kbF1, cmAbout, nil))), nil)));
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
        NewItem('Dia~l~og...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(MyDialog);           // Dialog ausführen.
            Dispose(MyDialog, Done);               // Dialog und Speicher frei geben.
          end;
        end;
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
Mit den 3 oberen Button, kann man das Farb-Schema des Dialoges ändern.
*)
//includepascal mydialog.pas head

(*
Hier sind 3 Event-Konstante hinzugekommen.
*)
//includepascal mydialog.pas type

(*
Das Bauen des Dialoges ist nichts besonderes.
*)
//includepascal mydialog.pas init

(*
Hier werden die Farb-Schemas mit Hilfe von <b>Palette := dpxxx</b> geändert.
Auch hier ist wichtig, das man <b>Draw</b> aufruft, diemal nicht für eine Komponente, sonder für den ganzen Dialog.
*)
//includepascal mydialog.pas handleevent

end.
