//image image.png
(*
Mit <b>FormatStr</b> können Strings formatiert werden.
Dabei sind filgende Formatierungen möglich:
%c: Char
%s: String
%d: Ganzzahlen
%x: Hexadezimal
%#: Formatierungen
Bei Realzahlen muss man sich folgendermassen behelfen:
//code+
procedure Str(var X: TNumericType[:NumPlaces[:Decimals]];var S: String);
//code-
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
  cmOption = 1001;

type
  TMyApp = object(TApplication)
    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
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
      NewStatusKey('~F4~ String Format Demo...', kbF4, cmOption, nil))), nil)));
  end;

  procedure TMyApp.InitMenuBar;
  var
    Rect: TRect;

  begin
    GetExtent(Rect);
    Rect.B.Y := Rect.A.Y + 1;

    MenuBar := New(PMenuBar, Init(Rect, NewMenu(
      NewSubMenu('~D~atei', hcNoContext, NewMenu(
        NewItem('~B~eenden', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil)),
      NewSubMenu('~O~ption', hcNoContext, NewMenu(
        NewItem('~S~tring Format Demo...', 'F4', kbF4, cmOption, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    AboutDialog: PMyDialog;

  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmOption: begin
          AboutDialog := New(PMyDialog, Init);
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
*)
//includepascal mydialog.pas head

(*
Deklaration des Dialogs.
*)
//includepascal mydialog.pas type

(*
Bei Integern ist es wichtig, das man diese als <b>PtrInt</b> deklariert.
*)
//includepascal mydialog.pas init

(*
Hier sieht man, die Formatierung mit <b>FormatStr</b>.
*)
//includepascal mydialog.pas draw

end.
