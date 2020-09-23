unit WMView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

const
  cmNone = 0;
  cmClose = 1;

  MouseDown = 0;
  MouseUp = 1;
  MouseMove = 2;

type

  TEvent = record
    What: (whMouse, whKeyPress, whcmCommand, whRepaint);
    Value0, Value1, Value2, Value3: PtrInt;
  end;

  { TView }

  TView = class(TObject)
  private
    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
  protected
    Bitmap: TBitmap;
    FViewRect: TRect;
    FCaption: string;
    FColor: TColor;
    MousePos: TPoint;
    isMouseDown: boolean;
    Parent: TView;
    View: array of TView;
    function calcOfs: TPoint;
  public
    property ViewRect: TRect read FViewRect write FViewRect;
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Insert(AView: TView);
    procedure Delete(AView: TView);

    function IsMousInView(x, y: integer): boolean; virtual;
    procedure EventHandle(Event: TEvent); virtual;

    procedure Assign(AX, AY, BX, BY: integer); virtual;
    procedure Move(x, y: integer); virtual;
    procedure Resize(x, y: integer); virtual;
    procedure Draw; virtual;
    procedure DrawBitmap(Canvas: TCanvas); virtual;
  end;

const
  BorderSize = 7;
  TitelBarSize = BorderSize*5;
  minWinSize = 50;

function getMouseCommand(Command, x, y: PtrInt): TEvent;

implementation

function getMouseCommand(Command, x, y: PtrInt): TEvent;
begin
  Result.What := whMouse;
  Result.Value0 := Command;
  Result.Value1 := x;
  Result.Value2 := y;
  Result.Value3 := 0;
end;

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
  isMouseDown := False;
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

procedure TView.Delete(AView: TView);   // nicht fertig
var
  i: integer = 0;
begin
  if Length(View) > 0 then begin
    View[0].Free;
    View[0] := nil;
    system.Delete(View, 0, 1);
  end;
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

function TView.IsMousInView(x, y: integer): boolean;
var
  p: TPoint;
begin
  p := calcOfs;

  with ViewRect do begin
    Result := (x >= p.X) and (y >= p.Y) and (x <= p.X + Width) and (y <= p.Y + Height);
  end;
end;

procedure TView.Assign(AX, AY, BX, BY: integer);
begin
  FViewRect.Left := AX;
  FViewRect.Right := BX;
  FViewRect.Top := AY;
  FViewRect.Bottom := BY;
  ViewRect.NormalizeRect;
  Bitmap.Width := ViewRect.Width;
  Bitmap.Height := ViewRect.Height;
end;

procedure TView.Move(x, y: integer);
begin
  Inc(FViewRect.Left, x);
  Inc(FViewRect.Right, x);
  Inc(FViewRect.Top, y);
  Inc(FViewRect.Bottom, y);
end;

procedure TView.Resize(x, y: integer);
begin
  Inc(FViewRect.Right, x);
  Inc(FViewRect.Bottom, y);
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

procedure TView.DrawBitmap(Canvas: TCanvas);
begin
  Canvas.Draw(ViewRect.Left, ViewRect.Top, Bitmap);
end;

procedure TView.EventHandle(Event: TEvent);
var
  x, y, index: integer;
  v: TView;
  ev: TEvent;
begin
  case Event.What of
    whMouse: begin
      x := Event.Value1;
      y := Event.Value2;
      case Event.Value0 of
        MouseDown: begin
          isMouseDown := IsMousInView(x, y);
          MousePos.X := x;
          MousePos.Y := y;
          index := 0;
          while index < Length(View) do begin
            if View[index].IsMousInView(X, Y) then begin
              if index <> 0 then begin
                v := View[index];
                system.Delete(View, index, 1);
                system.Insert(v, View, 0);
                ev.What := whRepaint;
                EventHandle(ev);
              end;
              View[0].EventHandle(getMouseCommand(MouseDown, x, y));
              Exit;
            end;
            Inc(index);
          end;
        end;
        MouseUp: begin
          isMouseDown := False;
          if Length(View) > 0 then begin
            View[0].EventHandle(getMouseCommand(MouseUp, x, y));
          end;
        end;
        MouseMove: begin
          if Length(View) > 0 then begin
            View[0].EventHandle(getMouseCommand(MouseMove, x, y));
          end;
        end;
      end;
    end;
    whRepaint: begin
      if Parent <> nil then begin
        Parent.EventHandle(Event);
      end;
    end;
    whcmCommand: begin
      if Parent <> nil then begin
        Parent.EventHandle(Event);
      end;
    end;
  end;
end;

end.
