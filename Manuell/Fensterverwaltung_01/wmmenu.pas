unit WMMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMDesktop, WMButton;

type
  TMenuItems = record
    Caption: string;
    Command: integer;
    Items: array of TMenuItems;
  end;

  { TMenuBox }

  TMenuBox = class(TView)
  private
    FMenuItem: TMenuItems;
    akMenuPos, ItemHeight: integer;
    procedure SetMenuItem(AValue: TMenuItems);
  public
    property MenuItem: TMenuItems read FMenuItem write SetMenuItem;
    constructor Create; override;
    procedure Draw; override;
    procedure EventHandle(Event: TEvent); override;
  end;


var
  MenuItems: TMenuItems;

procedure TestAusgabe(m: TMenuItems; nesting: integer = 0);

implementation

procedure TestAusgabe(m: TMenuItems; nesting: integer = 0);
var
  i: integer;
begin
  for i := 0 to Length(m.Items) - 1 do begin
    WriteLn(StringOfChar(' ', nesting * 2), m.Items[i].Caption);
    TestAusgabe(m.Items[i], nesting + 1);
  end;
end;

{ TMenuBox }

procedure TMenuBox.SetMenuItem(AValue: TMenuItems);
var
  w: integer = 0;
  h: integer = 0;
  i: integer;
begin
  FMenuItem := AValue;
  FColor := clWhite;

  Width := 0;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    Bitmap.Canvas.GetTextSize(FMenuItem.Items[i].Caption, w, h);
    if w > Width then begin
      Width := w;
    end;
  end;
  ItemHeight := h;
  Height := ItemHeight * Length(FMenuItem.Items);
end;

constructor TMenuBox.Create;
begin
  inherited Create;
end;

procedure TMenuBox.Draw;
var
  i: integer;
begin
  inherited Draw;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    if i = akMenuPos then begin
      Bitmap.Canvas.Font.Color := clRed;
    end else begin
      Bitmap.Canvas.Font.Color := clBlack;
    end;
    Bitmap.Canvas.TextOut(0, i * ItemHeight, FMenuItem.Items[i].Caption);
  end;
end;

procedure TMenuBox.EventHandle(Event: TEvent);
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;
begin
  if Event.What = whMouse then begin
    p := calcOfs;
    x := Event.Value1 - p.X;
    y := Event.Value2 - p.Y;


    WriteLn(x, '    ', y);

    case Event.Value0 of
      MouseDown: begin
        akMenuPos := y div ItemHeight;
        Color := clGray;
        ev.What := whRepaint;
        EventHandle(ev);
        isMouseDown := True;
      end;
      MouseUp: begin
        Color := clYellow;
        ev.What := whRepaint;
        EventHandle(ev);
        if isMouseDown and IsMousInView(x, y) then begin
          ev.What := whcmCommand;
          //          ev.Value0 := FCommand;
          EventHandle(ev);
        end;
      end;
      MouseMove: begin
        if isMouseDown and IsMousInView(x, y) then begin
          Color := clGray;
        end else begin
          Color := clYellow;
        end;
        ev.What := whRepaint;
        EventHandle(ev);
      end;
    end;
  end;
  inherited EventHandle(Event);
end;

end.
