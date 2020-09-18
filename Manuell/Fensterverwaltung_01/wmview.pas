unit WMView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  TEvent = record
    State: (Mouse, KeyPress, cm);
    Command: integer;
  end;

  { TView }

  TView = class(TObject)
  private
  protected
    Bitmap: TBitmap;
    ViewRect: TRect;
    FCaption: string;
    FColor: TColor;
    MousePos: TPoint;
    isDown: boolean;
    Parent: TView;
    View: array of TView;
    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
    function calcOfs: TPoint;
  public
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Insert(AView: TView);

    function MouseDown(x, y: integer): boolean; virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); virtual;

    procedure Assign(AX, AY, BX, BY: integer);
    procedure Move(x, y: integer); virtual;
    procedure Resize(x, y: integer); virtual;
    procedure Draw; virtual;
    procedure DrawBitmap(c: TCanvas); virtual;
    procedure EventHandle(Event: TEvent); virtual;
  end;

const
  TitelBarSize = 20;
  minWinSize = 50;

var
  Panel: TPanel;

implementation

{ TView }

procedure TView.SetCaption(AValue: string);
begin
  if FCaption = AValue then begin
    Exit;
  end;
  FCaption := AValue;
end;

procedure TView.SetColor(AValue: TColor);
begin
  if FColor = AValue then begin
    Exit;
  end;
  FColor := AValue;
end;

constructor TView.Create;
begin
  inherited Create;
  Parent := nil;
  isDown := False;
  Bitmap := TBitmap.Create;
end;

destructor TView.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(View) - 1 do begin
    View[i].Free;
  end;
  Bitmap.Free;
  inherited Destroy;
end;

procedure TView.Insert(AView: TView);
begin
  AView.Parent := Self;
  System.Insert(AView, View, 0);
end;

function TView.calcOfs: TPoint;
var
  v: TView;
begin
  Result := ViewRect.TopLeft;
  v := Parent;
  while v <> nil do begin
    Inc(Result.X, v.ViewRect.Left);
    Inc(Result.Y, v.ViewRect.Top);
    v := v.Parent;
  end;
end;

function TView.MouseDown(x, y: integer): boolean;
var
  i: integer;
  v: TView;
  p: TPoint;
begin
  p := calcOfs;

  with ViewRect do begin
    Result := (x >= p.X) and (y >= p.Y) and (x <= p.X + Width) and (y <= p.Y + Height);
  end;
  isDown := Result;
  MousePos.X := x;
  MousePos.Y := y;

  i := 0;
  while i < Length(View) do begin
    if View[i].MouseDown(X, Y) then begin
      if i <> 0 then begin
        v := View[i];
        Delete(View, i, 1);
        system.Insert(v, View, 0);
        Panel.Repaint;
      end;
      Exit;
    end else begin
      Inc(i);
    end;
  end;
end;

procedure TView.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  if Length(View) > 0 then begin
    View[0].MouseMove(Shift, X, Y);
  end;
end;

procedure TView.Assign(AX, AY, BX, BY: integer);
begin
  ViewRect.Left := AX;
  ViewRect.Right := BX;
  ViewRect.Top := AY;
  ViewRect.Bottom := BY;
  ViewRect.NormalizeRect;
  Bitmap.Width := ViewRect.Width;
  Bitmap.Height := ViewRect.Height;
end;

procedure TView.Move(x, y: integer);
begin
  Inc(ViewRect.Left, x);
  Inc(ViewRect.Right, x);
  Inc(ViewRect.Top, y);
  Inc(ViewRect.Bottom, y);
end;

procedure TView.Resize(x, y: integer);
begin
  Inc(ViewRect.Right, x);
  if ViewRect.Right - ViewRect.Left < minWinSize then begin
    ViewRect.Right := ViewRect.Left + minWinSize;
  end;
  Inc(ViewRect.Bottom, y);
  if ViewRect.Bottom - ViewRect.Top < minWinSize then begin
    ViewRect.Bottom := ViewRect.Top + minWinSize;
  end;
  Bitmap.Width := ViewRect.Width;
  Bitmap.Height := ViewRect.Height;
end;

procedure TView.Draw;
var
  i: integer;
begin
  Bitmap.Canvas.Brush.Color := FColor;
  Bitmap.Canvas.Rectangle(0, 0, ViewRect.Width, ViewRect.Height);
  for i := Length(View) - 1 downto 0 do begin
    View[i].Draw;
    View[i].DrawBitmap(Bitmap.Canvas);
  end;
end;

procedure TView.DrawBitmap(c: TCanvas);
begin
  c.Draw(ViewRect.Left, ViewRect.Top, Bitmap);
end;

procedure TView.EventHandle(Event: TEvent);
begin
  if Parent <> nil then begin
    Parent.EventHandle(Event);
  end;
end;

end.

