unit WMWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMButton;

type

  { TWindow }

  TWindow = class(TView)
  private
    FClient: TView;
    CloseBtn: TButton;
  protected
    isMoveable, isResizeLeft, isResizeTop, isResizeRight, isResizeBottom: boolean;
  public
    property Client: TView read FClient write FClient;
    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
    procedure Assign(AX, AY, BX, BY: integer); override;
    procedure Move(x, y: integer); override;
    procedure Resize(x, y: integer); override;
    procedure Draw; override;
  end;

implementation

{ TWindow }

constructor TWindow.Create;
begin
  inherited Create;
  FColor := clLtGray;
  isMoveable := False;
  isResizeLeft := False;
  isResizeTop := False;
  isResizeRight := False;
  isResizeBottom := False;

  FClient := TView.Create;
  FClient.Color := clWhite;
  Insert(FClient);

  CloseBtn := TButton.Create;
  CloseBtn.Caption := 'X';
  CloseBtn.Command := cmClose;
  Insert(CloseBtn);
end;

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
    p := calcOfs;
    case Event.Value0 of
      MouseDown: begin
        if CloseBtn.IsMousInView(x, y) then begin
          isMouseDown := False;
        end else begin
          isMoveable := (x > p.X + BorderSize) and (x < p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + BorderSize) and (y < p.Y + TitelBarSize - BorderSize);

          isResizeLeft := x < p.x + BorderSize;
          isResizeTop := y < p.y + BorderSize;
          isResizeRight := x > p.X + ViewRect.Width - BorderSize;
          isResizeBottom := y > p.Y + ViewRect.Height - BorderSize;
        end;
      end;
      MouseUp: begin
        isMoveable := False;
        isResizeLeft := False;
        isResizeTop := False;
        isResizeRight := False;
        isResizeBottom := False;
      end;
      MouseMove: begin
        if isMouseDown then begin
          if isMoveable then begin
            Move(X - MousePos.X, Y - MousePos.Y);
          end;

          if isResizeLeft then begin
            if x > p.X + ViewRect.Width - minWinSize then begin
              x := p.X + ViewRect.Width - minWinSize;
            end;
            Move(x - MousePos.X, 0);
            Resize(-(x - MousePos.X), 0);
          end;
          if isResizeTop then begin
            if y > p.Y + ViewRect.Height - minWinSize then begin
              y := p.Y + ViewRect.Height - minWinSize;
            end;
            Move(0, y - MousePos.Y);
            Resize(0, -(y - MousePos.Y));
          end;
          if isResizeRight then begin
            if x < p.X + minWinSize then begin
              x := p.X + minWinSize;
            end;
            Resize(x - MousePos.X, 0);
          end;
          if isResizeBottom then begin
            if y < p.Y + minWinSize then begin
              y := p.Y + minWinSize;
            end;
            Resize(0, y - MousePos.Y);
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

procedure TWindow.Assign(AX, AY, BX, BY: integer);
begin
  inherited Assign(AX, AY, BX, BY);
  Client.Assign(BorderSize, TitelBarSize, ViewRect.Width - BorderSize, ViewRect.Height - BorderSize);
  CloseBtn.Assign(ViewRect.Width - TitelBarSize + BorderSize, BorderSize, ViewRect.Width - BorderSize, TitelBarSize - BorderSize);
end;

procedure TWindow.Move(x, y: integer);
begin
  inherited Move(x, y);
end;

procedure TWindow.Resize(x, y: integer);
begin
  inherited Resize(x, y);
  Client.Assign(BorderSize, TitelBarSize, ViewRect.Width - BorderSize, ViewRect.Height - BorderSize);
  CloseBtn.Assign(ViewRect.Width - TitelBarSize + BorderSize, BorderSize, ViewRect.Width - BorderSize, TitelBarSize - BorderSize);
end;

procedure TWindow.Draw;
var
  w: integer = 0;
  h: integer = 0;
begin
  inherited Draw;

  Bitmap.Canvas.Brush.Style := bsClear;
  Bitmap.Canvas.Brush.Color := clSkyBlue;
  Bitmap.Canvas.Rectangle(BorderSize, BorderSize, ViewRect.Width - TitelBarSize, TitelBarSize - BorderSize);
  Bitmap.Canvas.GetTextSize(Caption, w, h);

  with ViewRect do begin
    Bitmap.Canvas.TextOut(Width div 2 - w div 2, BorderSize + 2, Caption);
  end;
end;

end.
