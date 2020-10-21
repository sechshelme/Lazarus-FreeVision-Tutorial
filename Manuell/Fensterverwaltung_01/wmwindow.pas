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
    procedure EventHandle(var Event: TEvent); override;
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
  FClient.Anchors := [akLeft, akRight, akTop, akBottom];
  FClient.Width := Width - BorderSize * 2;
  FClient.Height := Height - TitelBarSize - BorderSize;
  FClient.Top := TitelBarSize;
  FClient.Left := BorderSize;
  FClient.Color := clWhite;
  InsertView(FClient);

  CloseBtn := TButton.Create;
  CloseBtn.Anchors := [akRight];
  CloseBtn.Top := BorderSize;
  CloseBtn.Left := Width - TitelBarSize + BorderSize;
  CloseBtn.Width := TitelBarSize - BorderSize * 2;
  CloseBtn.Height := TitelBarSize - BorderSize * 2;

  CloseBtn.Caption := 'X';
  CloseBtn.Command := cmClose;
  InsertView(CloseBtn);
end;

procedure TWindow.EventHandle(var Event: TEvent);
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;
begin
  x := Event.x;
  y := Event.y;
  if Event.What = whMouse then begin
    p := calcOfs;
    case Event.MouseCommand of
      MouseDown: begin
          isMoveable := (x > p.X + BorderSize) and (x < p.X + Width - TitelBarSize) and (y > p.Y + BorderSize) and (y < p.Y + TitelBarSize - BorderSize);

          isResizeLeft := x < p.x + BorderSize;
          isResizeTop := y < p.y + BorderSize;
          isResizeRight := x > p.X + Width - BorderSize;
          isResizeBottom := y > p.Y + Height - BorderSize;
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
            Left := Left + (x - MousePos.X);
            Top := Top + (y - MousePos.Y);
          end;

          if isResizeLeft then begin
            if x > p.X + Width - minWinSize then begin
              x := p.X + Width - minWinSize;
            end;
            Left := Left + (x - MousePos.X);
            Width := Width - (x - MousePos.X);
          end;
          if isResizeTop then begin
            if y > p.Y + Height - minWinSize then begin
              y := p.Y + Height - minWinSize;
            end;
            Top := Top + (y - MousePos.Y);
            Height := Height - (y - MousePos.Y);
          end;
          if isResizeRight then begin
            if x < p.X + minWinSize then begin
              x := p.X + minWinSize;
            end;
            Width := Width + (x - MousePos.X);
          end;
          if isResizeBottom then begin
            if y < p.Y + minWinSize then begin
              y := p.Y + minWinSize;
            end;
            Height := Height + (y - MousePos.Y);
          end;

          ev.What := whRepaint;
          EventHandle(ev);
          MousePos.X := x;
          MousePos.Y := y;
        end else begin
          isMouseDown := False;
        end;
      end;
    end;
  end;
  inherited EventHandle(Event);
end;

procedure TWindow.Draw;
var
  w: integer = 0;
  h: integer = 0;
begin
  inherited Draw;
  Bitmap.Canvas.Brush.Style := bsClear;
  Bitmap.Canvas.Brush.Color := clSkyBlue;
  Bitmap.Canvas.Rectangle(BorderSize, BorderSize, Width - TitelBarSize, TitelBarSize - BorderSize);
  Bitmap.Canvas.GetTextSize(Caption, w, h);
  Bitmap.Canvas.TextOut(Width div 2 - w div 2, BorderSize + 2, Caption);
end;

end.
