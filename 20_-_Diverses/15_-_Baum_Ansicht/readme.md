# 20 - Diverses
## 15 - Baum Ansicht
<br>
<img src="image.png" alt="Selfhtml"><br><br>
Baumartige Darstellung.<br>
<hr><br>
Für die Baumartige Darstellung verwendet man die Komponente <b>POutline</b>.<br>
LineEnding+```pascal
  PTreeWindow = ^TTreeWindow;
  TTreeWindow = object(TWindow)
    constructor Init(R: TRect);
  end;
<br>

  constructor TTreeWindow.Init(R: TRect);
  var
    Outline: POutline;
  begin
    inherited Init(R, 'Computer', wnNoNumber);
    Options := Options or ofTileable;
    GetExtent(R);
    R.Grow(-1, -1);
    Outline := New(POutline, Init(R, StandardScrollBar(sbHorizontal), StandardScrollBar(sbVertical),
      NewNode('Computer',
        NewNode('IBM',
          NewNode('XT', nil,
          NewNode('AT', nil,
          NewNode('PS2', nil, nil))),
        NewNode('Mac',
          NewNode('Lisa', nil,
          NewNode('iMac', nil, nil)),
        NewNode('Amiga',
          NewNode('500', nil,
          NewNode('1000', nil, nil)), nil))), nil)));
    Insert(Outline);
  end;
```
<br>
Hier wird das Fenster erzeugt, welches die Outline enthält.<br>
LineEnding+```pascal
  procedure TMyApp.HandleEvent(var Event: TEvent);
  var
    R: TRect;
  begin
    inherited HandleEvent(Event);
<br>
    if Event.What = evCommand then begin
      case Event.Command of
        cmList: begin
          R.Assign(2, 2, 35, 17);
          InsertWindow(New(PTreeWindow, Init(R)));
        end
        else begin
          Exit;
        end;
      end;
    end;
    ClearEvent(Event);
  end;
```
<br>

