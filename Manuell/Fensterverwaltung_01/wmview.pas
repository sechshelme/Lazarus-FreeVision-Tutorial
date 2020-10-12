unit WMView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

const
  cmNone = 0;
  cmClose = 1;
  cmQuit = 2;

  cmTest0 = 100;
  cmTest1 = 101;
  cmTest2 = 102;
  cmTest3 = 103;
  cmopti0 = 104;
  cmopti1 = 105;
  cmopti2 = 106;

  MouseDown = 0;
  MouseUp = 1;
  MouseMove = 2;

const
  BorderSize = 7;
  TitelBarSize = BorderSize * 5;
  minWinSize = 50;

type

  TEvent = record
    What: (whNone, whMouse, whKeyPress, whcmCommand, whMenuCommand, whRepaint);
    case integer of
      whNone: (Value0, Value1, Value2, Value3: PtrInt);
      whMouse: (MouseCommand, x, y: PtrInt);
      whKeyPress: (PressKey: char;
        DownKey: byte;
        shift: TShiftState);
      whcmCommand: (Command: PtrInt);
      whMenuCommand: (Index, Left, Top: PtrInt;
        Sender: TObject);
      whRepaint: (was: (all, Windows));
  end;

  { TView }

  TView = class(TObject)
  private
    ViewCounter: integer; static;
    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
    procedure SetHeight(AValue: integer);
    procedure SetWidth(AValue: integer);
  protected
    FHeight: integer;
    FLeft: integer;
    FTop: integer;
    FWidth: integer;
    FCaption: string;
    FColor: TColor;
    FBitmap: TBitmap;

    MousePos: TPoint;
    isMouseDown: boolean;
    Parent: TView;
    View: array of TView;
    function calcOfs: TPoint;
  public
    Anchors: set of (akTop, akLeft, akRight, akBottom);
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Width: integer read FWidth write SetWidth;
    property Height: integer read FHeight write SetHeight;

    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure InsertView(AView: TView);
    procedure DeleteView(AIndex: integer);
    procedure DeleteView(AView: TView);
    procedure LastView(AView: TView);

    function IsMousInView(x, y: integer): boolean; virtual;
    procedure EventHandle(var Event: TEvent); virtual;

    procedure Draw; virtual;
    procedure DrawBitmap(Canvas: TCanvas); virtual;
  end;

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

procedure TView.SetWidth(AValue: integer);
var
  i, d: integer;
begin
  if FWidth <> AValue then begin
    d := AValue - FWidth;
    for i := 0 to Length(View) - 1 do begin
      if akRight in View[i].Anchors then begin
        if akLeft in View[i].Anchors then begin
          View[i].Width := View[i].Width + d;
        end else begin
          View[i].Left := View[i].Left + d;
        end;
      end;
    end;
    FWidth := AValue;
    Bitmap.Width := Width;
  end;
end;

procedure TView.SetHeight(AValue: integer);
var
  i, d: integer;
begin
  if FHeight <> AValue then begin
    d := AValue - FHeight;
    for i := 0 to Length(View) - 1 do begin
      if akBottom in View[i].Anchors then begin
        if akTop in View[i].Anchors then begin
          View[i].Height := View[i].Height + d;
        end else begin
          View[i].Top := View[i].Top + d;
        end;
      end;
    end;
    FHeight := AValue;
    Bitmap.Height := FHeight;
  end;
end;

constructor TView.Create;
begin
  inherited Create;
  Bitmap := TBitmap.Create;
  Bitmap.Canvas.Font.Style := [fsBold];
  Anchors := [akTop, akLeft];
  Width := 48;
  Height := 48;
  Parent := nil;
  isMouseDown := False;
  WriteLn('New View  ', ViewCounter);
  Inc(ViewCounter);
end;

destructor TView.Destroy;
var
  i: integer;
begin
  Dec(ViewCounter);
  WriteLn('Close View ', ViewCounter);
  for i := 0 to Length(View) - 1 do begin
    if View[i] <> nil then begin
      View[i].Free;
    end;
  end;
  Bitmap.Free;
  inherited Destroy;
end;

procedure TView.InsertView(AView: TView);
begin
  AView.Parent := Self;
  Insert(AView, View, 0);
end;

procedure TView.DeleteView(AIndex: integer);   // nicht fertig
var
  i: integer = 0;
begin
  if Length(View) > AIndex then begin
    View[AIndex].Free;
    View[AIndex] := nil;
    Delete(View, AIndex, 1);
  end;
end;

procedure TView.DeleteView(AView: TView);
var
  i: integer;
begin
  for i := 0 to Length(View) - 1 do begin
    if View[i] = AView then begin
      View[i].Free;
      View[i] := nil;
      system.Delete(View, i, 1);
      Exit;
    end;
  end;
  //  WriteLn('Element gibt es nicht !');
end;

procedure TView.LastView(AView: TView);
var
  v: TView;
  l, i:Integer;
begin
  l:=Length(View);
  for i := 0 to l - 1 do begin
    if View[i] = AView then begin
      v:=View[i];

      Delete(View, i, 1);
      Insert(v, View, l-1);
    end;
  end;
end;

function TView.calcOfs: TPoint;
var
  v: TView;
begin
  Result.X := Left;
  Result.Y := Top;
  v := Parent;
  while v <> nil do begin
    Inc(Result.X, v.Left);
    Inc(Result.Y, v.Top);
    v := v.Parent;
  end;
end;

function TView.IsMousInView(x, y: integer): boolean;
var
  p: TPoint;
begin
  p := calcOfs;
  Result := (x >= p.X) and (y >= p.Y) and (x <= p.X + Width) and (y <= p.Y + Height);
end;

procedure TView.Draw;
var
  i: integer;
begin
  Bitmap.Canvas.Pen.Color := clBlack;
  Bitmap.Canvas.Brush.Color := FColor;
  Bitmap.Canvas.Rectangle(0, 0, Width, Height);
  for i := Length(View) - 1 downto 0 do begin
    View[i].Draw;
    View[i].DrawBitmap(Bitmap.Canvas);
  end;
end;

procedure TView.DrawBitmap(Canvas: TCanvas);
begin
  Canvas.Draw(Left, Top, Bitmap);
end;

procedure TView.EventHandle(var Event: TEvent);
var
  x, y, index: integer;
  v: TView;
  ev: TEvent;
begin
  case Event.What of
    whMouse: begin
      x := Event.x;
      y := Event.y;
      case Event.MouseCommand of
        MouseDown: begin
          isMouseDown := IsMousInView(x, y);
          MousePos.X := x;
          MousePos.Y := y;
          index := 0;
          while index < Length(View) do begin
            if View[index].IsMousInView(X, Y) then begin
              if index <> 0 then begin
                v := View[index];
                Delete(View, index, 1);
                Insert(v, View, 0);
                ev.What := whRepaint;
                EventHandle(ev);
              end;
              ev.What := whMouse;
              ev.MouseCommand := MouseDown;
              ev.x := x;
              ev.y := y;
              View[0].EventHandle(ev);
              //              View[0].EventHandle(getMouseCommand(MouseDown, x, y));
              Exit;
            end;
            Inc(index);
          end;
        end;
        MouseUp: begin
          isMouseDown := False;
          if Length(View) > 0 then begin
            ev.What := whMouse;
            ev.MouseCommand := MouseUp;
            ev.x := x;
            ev.y := y;
            View[0].EventHandle(ev);
            //            View[0].EventHandle(getMouseCommand(MouseUp, x, y));
          end;
        end;
        MouseMove: begin
          if Length(View) > 0 then begin
            ev.What := whMouse;
            ev.MouseCommand := MouseMove;
            ev.x := x;
            ev.y := y;
            View[0].EventHandle(ev);
            //            View[0].EventHandle(getMouseCommand(MouseMove, x, y));
          end;
        end;
      end;
    end;
    whKeyPress: begin
      if Length(View) > 0 then begin
        View[0].EventHandle(Event);
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
    whMenuCommand: begin
      if Parent <> nil then begin
        Parent.EventHandle(Event);
      end;
    end;
    else begin
    end;
  end;
end;

end.
