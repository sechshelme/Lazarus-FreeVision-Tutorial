# 04 - Dialoge als Komponente
## 20 - Event an Dialog uebergeben
<img src="image.png" alt="Selfhtml"><br><br>
In diesem Beispiel wird gezeigt, wie man ein Event an eine andere Komponente senden kann.<br>
In diesem Fall wird ein Event an die Dialoge gesendet. In den Dialogen wird dann ein Counter hochgezählt.<br>
Events für den Buttonklick.<br>
```pascal>const
  cmDia1   = 1001;</font>
  cmDia2   = 1002;</font>
  cmDiaAll = 1003;</font>```
Hier werden die 2 passiven Ausgabe-Dialoge erstellt, dies befinden sich in dem Object TMyDialog.<br>
Auserdem wird ein Dialog erstellt, welcher 3 Button erhält, welche dann die Kommandos an die anderen Dialoge sendet.<br>
```pascal>  constructor TMyApp.Init;
  var
    R: TRect;
    Dia: PDialog;
  begin
    inherited init;
<br>
    // erster passsiver Dialog
    R.Assign(45, 2, 70, 9);</font>
    Dialog1 := New(PMyDialog, Init(R, 'Dialog 1'));</font>
    Dialog1^.SetState(sfDisabled, True);    // Dialog auf ReadOnly.
    if ValidView(Dialog1) <> nil then begin // Prüfen ob genügend Speicher.
      Desktop^.Insert(Dialog1);
    end;
<br>
    // zweiter passsiver Dialog
    R.Assign(45, 12, 70, 19);</font>
    Dialog2 := New(PMyDialog, Init(R, 'Dialog 2'));</font>
    Dialog2^.SetState(sfDisabled, True);
    if ValidView(Dialog2) <> nil then begin
      Desktop^.Insert(Dialog2);
    end;
<br>
    // Steuerdialog
    R.Assign(5, 5, 30, 20);</font>
    Dia := New(PDialog, Init(R, 'Steuerung'));</font>
<br>
    with Dia^ do begin
      R.Assign(6, 2, 18, 4);</font>
      Insert(new(PButton, Init(R, 'Dialog ~1~', cmDia1, bfNormal)));</font>
<br>
      R.Move(0, 3);</font>
      Insert(new(PButton, Init(R, 'Dialog ~2~', cmDia2, bfNormal)));</font>
<br>
      R.Move(0, 3);</font>
      Insert(new(PButton, Init(R, '~A~lle', cmDiaAll, bfNormal)));</font>
<br>
      R.Move(0, 4);</font>
      Insert(new(PButton, Init(R, '~B~eenden', cmQuit, bfNormal)));</font>
    end;
<br>
    if ValidView(Dia) <> nil then begin
      Desktop^.Insert(Dia);
    end;
  end;```
Hier werden mit <b>Message</b>, die Kommandos an die Dialoge gesendet.<br>
Gibt man als ersten Parameter die View des Dialoges an, dann wird nur dieser Dialog angesprochen.<br>
Gibt man <b>@Self</b> an, dann werden die Kommandos an alle Dialoge gesendet.<br>
Beim 4. Paramter kann man noch einen Pointer auf einen Bezeichner übergeben,<br>
die kann zB. ein String oder ein Record, etc. sein.<br>
```pascal>  procedure TMyApp.HandleEvent(var Event: TEvent);
  begin
    inherited HandleEvent(Event);
<br>
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
  end;```
---
<b>Unit mit dem neuen Dialog.</b><br>
<br><br>
Der Dialog mit der Zähler-Ausgabe.<br>
<pre><code>unit MyDialog;
</code></pre>
Deklaration des Object der passiven Dialoge.<br>
<pre><code>type
  PMyDialog = ^TMyDialog;
  TMyDialog = object(TDialog)
  var
    CounterInputLine: PInputLine; // Ausgabe Zeile für den Counter.
<br>
    constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    procedure HandleEvent(var Event: TEvent); virtual;
  end;
</code></pre>
Im Konstructor wird eine Ausgabezeile erzeugt.<br>
<pre><code>constructor TMyDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
var
  R: TRect;
begin
  inherited Init(Bounds, ATitle);
<br>
  R.Assign(5, 2, 10, 3);</font>
  CounterInputLine := new(PInputLine, Init(R, 20));</font>
  CounterInputLine^.Data^ := '0';</font>
  Insert(CounterInputLine);
end;
</code></pre>
Im EventHandle wird das Kommando empfangen, welches mit <b>Message</b> gesendet wurde.<br>
Als Beweis dafür, wir die Zahl in der Ausgabezeile un eins erhöht.<br>
<pre><code>procedure TMyDialog.HandleEvent(var Event: TEvent);
var
  Counter: integer;
begin
  inherited HandleEvent(Event);
<br>
  case Event.What of
    evBroadcast: begin
      case Event.Command of
        cmCounterUp: begin                              // cmCounterUp wurde mit Message gesendet.
          Counter := StrToInt(CounterInputLine^.Data^); // Ausgabezeile auslesen.
          Inc(Counter);                                 // Counter erhöhen.
          CounterInputLine^.Data^ := IntToStr(Counter); // Neue Zahl ausgeben.
          CounterInputLine^.Draw;                       // Asugabezeile aktualisieren.
        end;
      end;
    end;
  end;
<br>
end;
</code></pre>
<br>
