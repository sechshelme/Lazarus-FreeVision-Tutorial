//image image.png
(*
Hier wird eine Bereichsbegrenzung für <b>PInputLine</b> gezeigt.
Bei der ersten Zeile ist nur eine Zahl zwischen 0 und 99 erlaubt.
Bei der zweiten Zeile muss es ein Wochentag ( Montag - Freitag ) sein.
Für den zweiten Fall wäre eine ListBox idealer, mir geht zum zeigen wie es mit der <b>PInputLine</b> geht.
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
      NewStatusKey('~F4~ Validate Demo...', kbF4, cmOption, nil))), nil)));
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
        NewItem('~V~alidate Demo...', 'F4', kbF4, cmOption, hcNoContext, nil)), nil)))));
  end;

  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    MyDialog: PMyDialog;

  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of                   // About Dialog
        cmOption: begin
          MyDialog := New(PMyDialog, Init);
          if ValidView(MyDialog) <> nil then begin
            Desktop^.ExecView(MyDialog);
            Dispose(MyDialog, Done);
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
Ein Dialog mit <b>PInputLine</b> welche eine Prüfung bekommen.
Wen man <b>Ok</b> drückt, wird ein Validate-Prüfungen ausgeführt.
Bei <b>Abbruch</b> gibt es keine Prüfung.
*)
//includepascal mydialog.pas head

(*
Die Deklaration des Dialoges, hier wird nur das Init überschrieben, welches die Komponenten, für den Dialog erzeugt.
So nebenbei werden noch die beiden Validate überschrieben.
Dies wird nur gemacht, das eine deutsche Fehlermeldung bei falscher Eingabe kommt.
*)
//includepascal mydialog.pas type

(*
Die beiden neuen Fehlermeldungen.
*)
//includepascal mydialog.pas RV

(*
Hier sieht man, das eine Validate-Prüfung zu den <b>PInputLines</b> dazu kommt.
*)
//includepascal mydialog.pas init

end.
