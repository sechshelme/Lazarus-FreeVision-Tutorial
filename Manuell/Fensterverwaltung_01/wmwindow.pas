unit WMWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView;

type

  { TWindow }

  TWindow = class(TView)
  protected
    isMoveable, isResize: boolean;
  public
    constructor Create; override;
    function MouseDown(x, y: integer): boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure Draw; override;
  end;

implementation

{ TWindow }

constructor TWindow.Create;
begin
  inherited Create;
  FColor := clBlue;
  isMoveable := False;
  isResize := False;
end;

function TWindow.MouseDown(x, y: integer): boolean;
var
  p: TPoint;
begin
  Result := inherited MouseDown(x, y);
  p := calcOfs;
  if Result then begin
    isMoveable := y < p.Y + TitelBarSize;
    isResize := (x > p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + ViewRect.Height - TitelBarSize);
  end;
end;

procedure TWindow.MouseMove(Shift: TShiftState; X, Y: integer);
var
  ev: TEvent;
begin
  if ssLeft in Shift then begin
    if isMouseDown then begin
      if isMoveable then begin
        Self.Move(X - MousePos.X, Y - MousePos.Y);
      end;
      if isResize then begin
        Self.Resize(X - MousePos.X, Y - MousePos.Y);
      end;
      ev.State := Repaint;
      //      Panel.Refresh;
      EventHandle(ev);
      MousePos.X := x;
      MousePos.Y := y;
    end;
  end else begin
    isMouseDown := False;
    isMoveable := False;
    isResize := False;
  end;

  if Length(View) > 0 then begin
    //    View[0].MouseMove(Shift, X, Y);
  end;
end;

procedure TWindow.Draw;
var
  w, h: integer;
begin
  inherited Draw;

  Bitmap.Canvas.Brush.Color := clGray;
  Bitmap.Canvas.Rectangle(0, 0, ViewRect.Width, TitelBarSize);
  Bitmap.Canvas.GetTextSize(Caption, w, h);

  with ViewRect do begin
    Bitmap.Canvas.TextOut(Width div 2 - w div 2, 2, Caption);
  end;

  Bitmap.Canvas.Rectangle(ViewRect.Width - TitelBarSize, ViewRect.Height - TitelBarSize,
    ViewRect.Width, ViewRect.Height);

  Bitmap.Canvas.TextOut(ViewRect.Width - TitelBarSize + 4,
    ViewRect.Height - TitelBarSize + 1, '⤡');
end;

end.


