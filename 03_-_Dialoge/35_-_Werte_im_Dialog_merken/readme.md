# 03 - Dialoge
## 35 - Werte im Dialog merken

![image.png](image.png)

Bis jetzt gingen die Werte im Dialog immer wieder verloren, wen man diesen schliesste und wieder öffnete.
Aus diesem Grund werden jetzt die Werte in einen Record gespeichert.

---
  In diesem Record werden die Werte des Dialoges gespeichert.
  Die Reihenfolge der Daten im Record **muss** genau gleich sein, wie bei der Erstellung der Komponenten, ansonten gibt es einen Kräsch.
  Bei Turbo-Pascal musste ein **Word** anstelle von **LongWord** genommen werden, dies ist wichtig beim Portieren alter Anwendungen.

```pascal
type
  TParameterData = record
    Druck,
    Schrift: longword;
    Hinweis: string[50];
  end;
```

Hier wird noch der Constructor vererbt, diesen Nachkomme wird gebraucht um die Dialogdaten mit Standard Werte zu laden.

```pascal
type
  TMyApp = object(TApplication)
    ParameterData: TParameterData;                     // Daten für Parameter-Dialog
    constructor Init;                                  // Neuer Constructor

    procedure InitStatusLine; virtual;                 // Statuszeile
    procedure InitMenuBar; virtual;                    // Menü
    procedure HandleEvent(var Event: TEvent); virtual; // Eventhandler

    procedure MyParameter;                             // neue Funktion für einen Dialog.
  end;
```

Der Constructoer welcher die Werte für den Dialog ladet.
Die Datenstruktur für die RadioButtons ist einfach. 0 ist der erste Button, 1 der Zweite, 2 der Dritte, usw.
Bei den Checkboxen macht man es am besten Binär. Im Beispiel werden der erste und dritte CheckBox gesetzt.

```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;     // Vorfahre aufrufen
    with ParameterData do begin
      Druck := %0101;
      Schrift := 2;
      Hinweis := 'Hello world';
    end;
  end;
```

Der Dialog wird jetzt mit Werten geladen.
Dies macht man, sobald man fertig ist mit Komponenten ertstellen.

```pascal
  procedure TMyApp.MyParameter;
  var
    Dlg: PDialog;
    R: TRect;
    dummy: word;
    View: PView;
  begin
    R.Assign(0, 0, 35, 15);
    R.Move(23, 3);
    Dlg := New(PDialog, Init(R, 'Parameter'));
    with Dlg^ do begin

      // CheckBoxen
      R.Assign(2, 3, 18, 7);
      View := New(PCheckBoxes, Init(R,
        NewSItem('~D~atei',
        NewSItem('~Z~eile',
        NewSItem('D~a~tum',
        NewSItem('~Z~eit',
        nil))))));
      Insert(View);
      // Label für CheckGroup.
      R.Assign(2, 2, 10, 3);
      Insert(New(PLabel, Init(R, 'Dr~u~cken', View)));

      // RadioButton
      R.Assign(21, 3, 33, 6);
      View := New(PRadioButtons, Init(R,
        NewSItem('~G~ross',
        NewSItem('~M~ittel',
        NewSItem('~K~lein',
        nil)))));
      Insert(View);
      // Label für RadioGroup.
      R.Assign(20, 2, 31, 3);
      Insert(New(PLabel, Init(R, '~S~chrift', View)));

      // Edit Zeile
      R.Assign(3, 10, 32, 11);
      View := New(PInputLine, Init(R, 50));
      Insert(View);
      // Label für Edit Zeile
      R.Assign(2, 9, 10, 10);
      Insert(New(PLabel, Init(R, '~H~inweis', View)));

      // Ok-Button
      R.Assign(7, 12, 17, 14);
      Insert(new(PButton, Init(R, '~O~K', cmOK, bfDefault)));

      // Schliessen-Button
      R.Assign(19, 12, 32, 14);
      Insert(new(PButton, Init(R, '~A~bbruch', cmCancel, bfNormal)));
    end;
    Dlg^.SetData(ParameterData);      // Dialog mit den Werten laden.
    dummy := Desktop^.ExecView(Dlg);  // Dialog ausführen.
    if dummy = cmOK then begin        // Wen Dialog mit Ok beenden, dann Daten vom Dialog in Record laden.
      Dlg^.GetData(ParameterData);
    end;

    Dispose(Dlg, Done);               // Dialog und Speicher frei geben.
  end;
```


