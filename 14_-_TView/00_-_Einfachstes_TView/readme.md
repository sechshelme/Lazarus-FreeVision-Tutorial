# 14 - TView
## 00 - Einfachstes TView
<br>
<img src="image.png" alt="Selfhtml"><br><br>
<b>TView</b>, ist die unterste Ebene von allen Fenster, Dialog, Button, etc.<br>
Au diesem Grund habe ich dieses kleine Beispiel von <b>TView</b> gemacht.<br>
An diesem View sind keinerlei Änderungen möglich, da noch keine Event, Steurerelemente vorhanden sind.<br>
<hr><br>
Im Konstructor wird das View erzeugt.<br>
LineEnding+```pascal
  constructor TMyApp.Init;
  begin
    inherited Init;   // Der Vorfahre aufrufen.
    NewView;          // View erzeugen.
  end;
```
<br>
Es wird ein einfaches View erzeugt, wie erwarte sieht man nicht viel, ausser eines grauen Rechteckes.<br>
LineEnding+```pascal
  procedure TMyApp.NewView;
  var
    Win: PView;
    R: TRect;
  begin
    R.Assign(10, 5, 60, 20);
    Win := New(PView, Init(R));
<br>
    if ValidView(Win) <> nil then begin
      Desktop^.Insert(Win);
    end;
  end;
```
<br>

