//head+
unit MyWindow;
//head-

interface

uses
  App, Objects, Drivers, Views, MsgBox, Editors, Dialogs, Menus,
  SysUtils;

type
  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
    constructor Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
  end;

implementation

//init+
constructor TMyWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
var
  VScrollBar, HScrollBar : PScrollBar;  // Rollbalken
  Indicator  : PIndicator;              // Zeilen/Spalten-Anzeige
  Rect: TRect;
begin
  inherited Init(Bounds, ATitle, ANumber);
  Options := Options or ofTileable;     // Für Tile und Cascade

  Rect.Assign (18, Size.Y - 1, Size.X - 2, Size.Y);
  HScrollBar := New (PScrollBar, Init (Rect));
  HScrollBar^.Max := 100;
  HScrollBar^.Min := 0;
  HScrollBar^.Value := 50;
  Insert (HScrollBar);

  Rect.Assign (Size.X - 1, 1, Size.X, Size.Y - 1);
  VScrollBar := New (PScrollBar, Init (Rect));
  VScrollBar^.Max := 100;
  VScrollBar^.Min := 0;
  VScrollBar^.Value := 20;
  Insert (VScrollBar);

  Rect.Assign (2, Size.Y - 1, 16, Size.Y);
  Indicator := New (PIndicator, Init (Rect));
  Insert (Indicator);
end;
//init-

end.

