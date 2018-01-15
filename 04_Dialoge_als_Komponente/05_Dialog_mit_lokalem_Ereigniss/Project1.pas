//image image.png
(*
In den vererbten Dialogen ist es möglich Buttons einzubauen, welche lokal im Dialog eine Aktion ausführen.
Im Beispiel wir eine MessageBox aufgerufen.
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
      NewSubMenu('~H~ilfe', hcNoContext, NewMenu(
        NewItem('~A~bout...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));
  end;

(*
Im Hauptprogramm ändert sich nichts daran, dem ist egal, ob lokal noch etwas gemacht wird.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyAbout;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmAbout: begin
          AboutDialog := New(PMyAbout, Init);
          if ValidView(AboutDialog) <> nil then begin // Prüfen ob genügend Speicher.
            Desktop^.ExecView(AboutDialog);           // Dialog About ausführen.
            Dispose(AboutDialog, Done);               // Dialog und Speicher frei geben.
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
<b>Unit mit dem neuen Dialog.</b>
<br>
Dort sieht man gut, das es ein Button für lokale Ereignisse hat.
Wichtig ist, bei den Nummernvergabe, das sich dies nicht mit einem anderen Eventnummer überschneidet.
Vor allem dann, wen der Dialog nicht Modal geöffnet wird.
Ausser es ist gewünscht, wen man zB. über das Menü auf den Dialog zugreifen will.
*)
//includepascal mydialog.pas head

(*
Für den Dialog kommt noch ein HandleEvent hinzu.
*)
//includepascal mydialog.pas type

(*
Im Konstruktor wird der Dialog noch um den Button Msg-box ergänzt, welcher das lokale Ereigniss <b>cmMsg</b> abarbeitet.
*)
//includepascal mydialog.pas init

(*
Im neuen EventHandle, werden loake Ereigniss (cmMsg) abarbeitet.
Andere Ereignisse, zB. <b>cmOk</b> wird an das Hauptprogramm weiter gereicht, welches dann den Dialog auch schliesst.
*)
//includepascal mydialog.pas handleevent

end.
