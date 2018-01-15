//image image.png
(*
In diesem Beispiel wird gezeigt, wie man ein Event an eine andere Komponente senden kann.
In diesem Fall wird ein Event an die Dialoge gesendet. In den Dialogen wird dann ein Counter hochgezählt.
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

(*
Events für den Buttonklick.
*)
//code+
const
  cmDia1 = 1001;
  cmDia2 = 1002;
  cmDiaAll = 1003;
//code-

type

  { TMyApp }

  TMyApp = object(TApplication)
    Dialog1, Dialog2: PMyDialog;
    constructor Init;

    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler
    procedure OutOfMemory; virtual;                    // Wird aufgerufen, wen Speicher überläuft.
  end;

(*
Hier werden die 2 passiven Ausgabe-Dialoge erstellt, dies befinden sich in dem Object TMyDialog.
Auserdem wird ein Dialog erstellt, welcher 3 Button erhält, welche dann die Kommandos an die anderen Dialoge sendet.
*)
//code+
  constructor TMyApp.Init;
  var
    Rect: TRect;
    Dia: PDialog;
  begin
    inherited init;

    // erster passsiver Dialog
    Rect.Assign(45, 2, 70, 9);
    Dialog1 := New(PMyDialog, Init(Rect, 'Dialog 1'));
    Dialog1^.SetState(sfDisabled, True);    // Dialog auf ReadOnly.
    if ValidView(Dialog1) <> nil then begin // Prüfen ob genügend Speicher.
      Desktop^.Insert(Dialog1);
    end;

    // zweiter passsiver Dialog
    Rect.Assign(45, 12, 70, 19);
    Dialog2 := New(PMyDialog, Init(Rect, 'Dialog 2'));
    Dialog2^.SetState(sfDisabled, True);
    if ValidView(Dialog2) <> nil then begin
      Desktop^.Insert(Dialog2);
    end;

    // Steuerdialog
    Rect.Assign(5, 5, 30, 20);
    Dia := New(PDialog, Init(Rect, 'Steuerung'));

    with Dia^ do begin
      Rect.Assign(6, 2, 18, 4);
      Insert(new(PButton, Init(Rect, 'Dialog ~1~', cmDia1, bfNormal)));

      Rect.Assign(6, 5, 18, 7);
      Insert(new(PButton, Init(Rect, 'Dialog ~2~', cmDia2, bfNormal)));

      Rect.Assign(6, 8, 18, 10);
      Insert(new(PButton, Init(Rect, '~A~lle', cmDiaAll, bfNormal)));

      Rect.Assign(6, 12, 18, 14);
      Insert(new(PButton, Init(Rect, '~B~eenden', cmQuit, bfNormal)));
    end;

    if ValidView(Dia) <> nil then begin
      Desktop^.Insert(Dia);
    end;
  end;
//code-

  procedure TMyApp.InitStatusLine;
  var
    Rect: TRect;
  begin
    GetExtent(Rect);
    Rect.A.Y := Rect.B.Y - 1;

    StatusLine := New(PStatusLine, Init(Rect, NewStatusDef(0, $FFFF,
      NewStatusKey('~Alt+X~ Programm beenden', kbAltX, cmQuit,
      NewStatusKey('~F10~ Menu', kbF10, cmMenu, nil)), nil)));
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
        NewItem('Dialog ~1~', '', kbNoKey, cmDia1, hcNoContext,
        NewItem('Dialog ~2~', '', kbNoKey, cmDia2, hcNoContext,
        NewItem('~A~lle', '', kbNoKey, cmDiaAll, hcNoContext, nil)))), nil)))));
  end;

(*
Hier werden mit <b>Message</b>, die Kommandos an die Dialoge gesendet.
Gibt man als ersten Parameter die View des Dialoges an, dann wird nur dieser Dialog angesprochen.
Gibt man <b>@Self</b> an, dann werden die Kommandos an alle Dialoge gesendet.
Beim 4. Paramter kann man noch einen Pointer auf einen Bezeichner übergeben,
die kann zB. ein String oder ein Record, etc. sein.
*)
//code+
  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);

    if Event.What = evCommand then begin
      case Event.Command of
        cmDia1: begin
          Message(Dialog1, evBroadcast, cmCounterUp, nil); // Kommando Dialog 1
        end;
        cmDia2: begin
          Message(Dialog2, evBroadcast, cmCounterUp, nil); // Kommando Dialog 2
        end;
        cmDiaAll: begin
          Message(@Self, evBroadcast, cmCounterUp, nil);   // Kommando an alle Dialoge
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
Der Dialog mit der Zähler-Ausgabe.
*)
//includepascal mydialog.pas head

(*
Deklaration des Object der passiven Dialoge.
*)
//includepascal mydialog.pas type

(*
Im Konstructor wird eine Ausgabezeile erzeugt.
*)
//includepascal mydialog.pas init

(*
Im EventHandle wird das Kommando empfangen, welches mit <b>Message</b> gesendet wurde.
Als Beweis dafür, wir die Zahl in der Ausgabezeile un eins erhöht.
*)
//includepascal mydialog.pas handleevent

end.
