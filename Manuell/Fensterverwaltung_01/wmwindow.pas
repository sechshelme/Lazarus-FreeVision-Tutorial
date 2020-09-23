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
    isMoveable, isResize: boolean;
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
  isResize := False;

  FClient := TView.Create;
  FClient.Color := clBlue;
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
    case Event.Value0 of
      MouseDown: begin
        p := calcOfs;
        if CloseBtn.IsMousInView(x, y) then begin
          isMouseDown := False;
        end else begin
          isMoveable := y < p.Y + TitelBarSize;
          isResize := (x > p.X + ViewRect.Width - TitelBarSize) and (y > p.Y + ViewRect.Height - TitelBarSize);
        end;
      end;
      MouseUp: begin
        isMoveable := False;
        isResize := False;
      end;
      MouseMove: begin
        if isMouseDown then begin
          if isMoveable then begin
            Move(X - MousePos.X, Y - MousePos.Y);
          end;
          if isResize then begin
            Resize(X - MousePos.X, Y - MousePos.Y);
            //            Move(X - MousePos.X, 0);
            //            Resize(-(X - MousePos.X), Y - MousePos.Y);
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
  if FViewRect.Right - FViewRect.Left < minWinSize then begin
    FViewRect.Right := FViewRect.Left + minWinSize;
  end;
  if FViewRect.Bottom - FViewRect.Top < minWinSize then begin
    FViewRect.Bottom := FViewRect.Top + minWinSize;
  end;
  Client.Assign(BorderSize, TitelBarSize, ViewRect.Width - BorderSize, ViewRect.Height - BorderSize);
  CloseBtn.Assign(ViewRect.Width - TitelBarSize + BorderSize, BorderSize, ViewRect.Width - BorderSize, TitelBarSize - BorderSize);
  //  CloseBtn.ViewRect.Left := CloseBtn.ViewRect.Left + x;
//    ViewRect.Left := ViewRect.Left + x;
end;

procedure TWindow.Draw;
var
  w: integer = 0;
  h: integer = 0;
begin
  inherited Draw;

  Bitmap.Canvas.Brush.Style := bsClear;
  Bitmap.Canvas.Brush.Color := clLtGray;
  Bitmap.Canvas.GetTextSize(Caption, w, h);

  with ViewRect do begin
    Bitmap.Canvas.TextOut(Width div 2 - w div 2, 2, Caption);
  end;

  //Bitmap.Canvas.Rectangle(ViewRect.Width - TitelBarSize, ViewRect.Height - TitelBarSize,
  //  ViewRect.Width, ViewRect.Height);
  //
  //Bitmap.Canvas.TextOut(ViewRect.Width - TitelBarSize + 4,
  //  ViewRect.Height - TitelBarSize + 1, '⤡');
end;

end.
