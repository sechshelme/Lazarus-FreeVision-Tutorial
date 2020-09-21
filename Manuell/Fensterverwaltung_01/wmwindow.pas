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
    //procedure MouseDown(x, y: integer); override;
    //procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    //procedure MouseUp(x, y: integer); override;
    procedure EventHandle(Event: TEvent); override;
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

//procedure TWindow.MouseDown(x, y: integer);
//var
//  p: TPoint;
//begin
//  inherited MouseDown(x, y);
//
//  p := calcOfs;
//  isMoveable := y < p.Y + TitelBarSize;
//  isResize := (x > p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + ViewRect.Height - TitelBarSize);
//end;
//
//procedure TWindow.MouseMove(Shift: TShiftState; X, Y: integer);
//var
//  ev: TEvent;
//begin
//  if ssLeft in Shift then begin
//    if isMouseDown then begin
//      if isMoveable then begin
//        Self.Move(X - MousePos.X, Y - MousePos.Y);
//      end;
//      if isResize then begin
//        Self.Resize(X - MousePos.X, Y - MousePos.Y);
//      end;
//      ev.What := whRepaint;
//      EventHandle(ev);
//      MousePos.X := x;
//      MousePos.Y := y;
//    end;
//  end else begin
//    isMouseDown := False;
//  end;
//
//  if Length(View) > 0 then begin
//    //    View[0].MouseMove(Shift, X, Y);
//  end;
//end;
//
//procedure TWindow.MouseUp(x, y: integer);
//begin
//  inherited MouseUp(x, y);
//  isMoveable := False;
//  isResize := False;
//end;

procedure TWindow.EventHandle(Event: TEvent);
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;
begin
  inherited EventHandle(Event);
  x := Event.Value1;
  y := Event.Value2;
  if Event.What = whMouse then begin
    case Event.Value0 of
      MouseDown: begin
        p := calcOfs;
        isMoveable := y < p.Y + TitelBarSize;
        isResize := (x > p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + ViewRect.Height - TitelBarSize);
      end;
      MouseUp: begin
        isMoveable := False;
        isResize := False;
      end;
      MouseMove: begin
        if isMouseDown then begin
          if isMoveable then begin
            Self.Move(X - MousePos.X, Y - MousePos.Y);
          end;
          if isResize then begin
            Self.Resize(X - MousePos.X, Y - MousePos.Y);
          end;
          ev.What := whRepaint;
          EventHandle(ev);
          MousePos.X := x;
          MousePos.Y := y;

        end else begin
          isMouseDown := False;
        end;

        if Length(View) > 0 then begin
          //    View[0].MouseMove(Shift, X, Y);
        end;


      end;

    end;
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
