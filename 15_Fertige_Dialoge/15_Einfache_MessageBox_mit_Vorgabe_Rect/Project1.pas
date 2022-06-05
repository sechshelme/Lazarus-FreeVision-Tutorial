//image image.png
(*
Bei der MessageBox, kann man die Grösse auch manuell festlegen.
Dazu muss man <b>MeassgeBoxRect(...)</b> verwenden.
*)
//lineal
program Project1;

uses
  App,      // TApplication
  Objects,  // Fensterbereich (TRect)
  Drivers,  // Hotkey
  Views,    // Ereigniss (cmQuit)
  MsgBox,   // MessageBox
  Menus;    // Statuszeile

const
  cmAbout = 1001;     // About anzeigen
  cmWarning = 1002;
  cmError = 1003;
  cmInfo = 1004;
  cmConformation = 1005;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
  end;

  procedure TMyApp.InitStatusLine;
  var
    R: TRect;     // Rechteck für die Statuszeilen Position.

  begin
    GetExtent(R);
    R.A.Y := R.B.Y - 1;

    StatusLine := New(PStatusLine, Init(R, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu,
      NewStatusKey('~F1~ Hilfe', kbF1, cmHelp, nil))), nil)));

  end;

  procedure TMyApp.InitMenuBar;
  var
    R: TRect;     // Rechteck für die Menüzeilen-Position.
  begin
    GetExtent(R);
    R.B.Y := R.A.Y + 1;

    MenuBar := New(PMenuBar, Init(R, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~K~onformation...', 'F5', kbF2, cmConformation, hcNoContext,
        NewItem('~I~nfo...', 'F4', kbF2, cmInfo, hcNoContext,
        NewItem('~F~ehler...', 'F3', kbF2, cmError, hcNoContext,
        NewItem('~W~arnung...', 'F2', kbF2, cmWarning, hcNoContext,
        NewLine(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))))))),
      NewSubMenu('D~i~alog', hcNoContext, NewMenu(
        NewItem('~M~anuelle Box...', '', kbNoKey, cmAbout, hcNoContext, nil)), nil)))));

  end;

(*
Hier wird mir <b>R.Assign</b> die grösse der Box selbst festgelegt.
*)
  //code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmAbout: begin
          R.Assign(10, 3, 28, 20);  // Grösse der Box
          MessageBoxRect(R, 'Ich bin eine vorgegebene Box', nil, mfInformation + mfOkButton);
        end;
        //code-
        cmWarning: begin
          MessageBox('Ich bin eine Warnung-Box', nil, mfWarning + mfOkButton);
        end;
        cmError: begin
          MessageBox('Ich bin eine Fehlermeldung', nil, mfError + mfOkButton);
        end;
        cmInfo: begin
          MessageBox('Ich bin eine Info-Box', nil, mfInformation + mfOkButton);
        end;
        cmConformation: begin
          MessageBox('Ich bin eine Info-Box', nil, mfConfirmation + mfOkButton);
        end;
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;

var
  MyApp: TMyApp;

begin
  MyApp.Init;   // Inizialisieren
  MyApp.Run;    // Abarbeiten
  MyApp.Done;   // Freigeben
end.
