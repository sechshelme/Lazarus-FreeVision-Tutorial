unit WMMenu;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
{$modeswitch arrayoperators}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMView, WMDesktop, WMButton;

type
  TMenuItems = record
    Caption: string;
    Command: integer;
    Items: array of TMenuItems;
    //    procedure Add(ACaption: string; ACommand: integer; AItems: TMenuItems);
  end;

  { TMenuView }

  TMenuView = class(TView)
  private
    akMenuPos, ItemHeight, ItemWidth: integer;
    FMenuItem: TMenuItems;
    procedure SetMenuItem(AValue: TMenuItems); virtual;
  public
    MenuCount: integer; static;
    Nesting: integer;
    property MenuItem: TMenuItems read FMenuItem write SetMenuItem;
    constructor Create; override;
    destructor Destroy; override;
    procedure HideCursor;
    procedure EventHandle(var Event: TEvent); override;
  end;

  { TMenuBar }

  TMenuBar = class(TMenuView)
  private
    procedure SetMenuItem(AValue: TMenuItems); override;
  public
    constructor Create; override;
    procedure Draw; override;
    procedure EventHandle(var Event: TEvent); override;
  end;

  { TMenuBox }

  TMenuBox = class(TMenuView)
  private
    procedure SetMenuItem(AValue: TMenuItems); override;
  public
    procedure Draw; override;
    procedure EventHandle(var Event: TEvent); override;
  end;

  { TMenuWindow }

  TMenuWindow = class(TView)
  private
    function ClickInMenu(x, y: integer): boolean;
    procedure KillSubMenu(First: integer; BackMenu: boolean);
  public
    MenuBar: TMenuBar;
    MenuBox: array of TMenuBox;
    constructor Create; override;
    procedure EventHandle(var Event: TEvent); override;
    procedure Draw; override;
    procedure DrawBitmap(Canvas: TCanvas); override;
  end;


var
  MenuItems: TMenuItems;

implementation

{ TMenuWindow }

constructor TMenuWindow.Create;
begin
  inherited Create;
  FColor := $AAAAAA;
  MenuBar := TMenuBar.Create;
  Anchors := [akLeft, akRight, akTop, akBottom];
  InsertView(MenuBar);
end;

function TMenuWindow.ClickInMenu(x, y: integer): boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to TMenuBox.MenuCount - 2 do begin
    if MenuBox[i].IsMousInView(x, y) then begin
      Result := True;
      Exit;
    end;
  end;
  if MenuBar.IsMousInView(x, y) then begin
    Result := True;
  end;
end;

procedure TMenuWindow.KillSubMenu(First: integer; BackMenu: boolean);
var
  i: integer;
begin
  for i := First to TMenuBox.MenuCount - 2 do begin
    DeleteView(MenuBox[i]);
  end;
  SetLength(MenuBox, First);

  if BackMenu then begin
    if Parent <> nil then begin
      Parent.LastView(Self);
    end;
    MenuBar.HideCursor;
  end;
end;

procedure TMenuWindow.EventHandle(var Event: TEvent);
var
  ev: TEvent;
  mItem: TMenuItems;
  l: integer;
  menu: TMenuView;
begin
  case Event.What of
    whMouse: begin
      if Event.MouseCommand = MouseDown then begin
          if not ClickInMenu(Event.x, Event.y) then begin
          KillSubMenu(0,True);

          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      //case Event.PressKey of
      //  #0: begin
      //    case Event.DownKey of
      //      37, 39: begin
      //        MenuBar.EventHandle(Event);
      //      end;
      //    end;
      //  end;
      //end;
      //ev.What := whRepaint;
      //EventHandle(ev);
    end;

    whMenuCommand: begin
      if Event.Index >= 0 then begin
        menu := TMenuView(Event.Sender);
        mItem := menu.MenuItem.Items[Event.Index];
        if Length(mItem.Items) > 0 then begin  // Ist SubMenu Link ?
          KillSubMenu(menu.Nesting - 1, False);

          SetLength(MenuBox, menu.Nesting);
          l := Length(MenuBox) - 1;
          MenuBox[l] := TMenuBox.Create;
          MenuBox[l].MenuItem := mItem;
          MenuBox[l].Left := Event.Left;
          MenuBox[l].Top := Event.Top;
          InsertView(MenuBox[l]);
        end else begin
          ev.What := whcmCommand;
          ev.Command := mItem.Command;
          EventHandle(ev);
          KillSubMenu(0, True);
        end;
      end else begin
        KillSubMenu(0, True);
      end;
      ev.What := whRepaint;
      EventHandle(ev);
    end else begin
    end;
  end;

  inherited EventHandle(Event);
end;

procedure TMenuWindow.Draw;
var
  i: integer;
begin
  for i := Length(View) - 1 downto 0 do begin
    View[i].Draw;
    View[i].DrawBitmap(Parent.Bitmap.Canvas);
  end;
end;

procedure TMenuWindow.DrawBitmap(Canvas: TCanvas);
begin
  // Achtung, Methode darf nicht gelöscht werden !!
end;

{ TMenuView }

constructor TMenuView.Create;
begin
  inherited Create;
  Inc(MenuCount);
  Nesting := MenuCount;
  FColor := clWhite;
  //  WriteLn('mcc ', MenuCount);
end;

destructor TMenuView.Destroy;
begin
  Dec(MenuCount);
  //  WriteLn('mcc ', MenuCount);
  inherited Destroy;
end;

procedure TMenuView.HideCursor;
begin
  akMenuPos := -1;
end;

procedure TMenuView.EventHandle(var Event: TEvent);
var
  ev: TEvent;
  p: TPoint;
begin
  case Event.What of
    whKeyPress: begin
      case Event.PressKey of
        #13: begin
          //p := calcOfs;
          //ev.What := whMenuCommand;
          //ev.Sender := Self;
          //ev.Index := akMenuPos;
          //if Self.ClassName = 'TMenuBox' then begin
          //  ev.Left := ItemWidth + p.X;
          //  ev.Top := ItemHeight * akMenuPos + p.Y;
          //end else begin
          //  ev.Left := ItemWidth * akMenuPos + p.X;
          //  ev.Top := ItemHeight + p.Y;
          //end;
          //EventHandle(ev);
        end;
      end;
    end;
    else begin
    end;
  end;

  inherited EventHandle(Event);
end;

procedure TMenuView.SetMenuItem(AValue: TMenuItems);
var
  w: integer = 0;
  h: integer = 0;
  i: integer;
begin
  FMenuItem := AValue;
  ItemWidth := 0;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    Bitmap.Canvas.GetTextSize(FMenuItem.Items[i].Caption, w, h);
    if w > ItemWidth then begin
      ItemWidth := w;
    end;
  end;
  ItemHeight := h + 4;
  Inc(ItemWidth, 4);
end;

{ TMenuBar }

procedure TMenuBar.SetMenuItem(AValue: TMenuItems);
begin
  inherited SetMenuItem(AValue);
  Height := ItemHeight;
  Width := ItemWidth * Length(FMenuItem.Items);

  if Parent <> nil then begin
    Width := Parent.Width;
  end;
end;

constructor TMenuBar.Create;
begin
  inherited Create;
  HideCursor;
  Anchors := [akLeft, akRight, akTop];
end;

procedure TMenuBar.Draw;
var
  i: integer;
begin
  inherited Draw;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    if i = akMenuPos then begin
      Bitmap.Canvas.Brush.Color := clBlue;
      Bitmap.Canvas.Pen.Color := clBlue;
      Bitmap.Canvas.Rectangle(akMenuPos * ItemWidth, 0, (akMenuPos + 1) * ItemWidth, Height);
      Bitmap.Canvas.Font.Color := clWhite;
    end else begin
      Bitmap.Canvas.Brush.Color := FColor;
      Bitmap.Canvas.Pen.Color := clBlack;
      Bitmap.Canvas.Font.Color := clBlack;
    end;
    Bitmap.Canvas.TextOut(i * ItemWidth + 1, 1, FMenuItem.Items[i].Caption);
  end;
end;

procedure TMenuBar.EventHandle(var Event: TEvent);
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;
begin
  case Event.What of
    whMouse: begin
      p := calcOfs;
      x := Event.x;
      y := Event.y;
      case Event.MouseCommand of
        MouseDown: begin
          akMenuPos := (x - p.X) div ItemWidth;
          ev.What := whRepaint;
          EventHandle(ev);
          isMouseDown := True;
        end;
        MouseUp: begin
          ev.What := whMenuCommand;
          ev.Sender := Self;
          if isMouseDown and IsMousInView(x, y) and (akMenuPos < Length(FMenuItem.Items)) then begin
            ev.Index := akMenuPos;
            ev.Left := ItemWidth * akMenuPos + p.X;
            ev.Top := ItemHeight + p.Y;
          end else begin
            ev.Index := -1;
          end;
          EventHandle(ev);
        end;
        MouseMove: begin
          if isMouseDown and IsMousInView(x, y) then begin
            akMenuPos := (x - p.X) div ItemWidth;
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #0: begin
          case Event.DownKey of
            37: begin
              if akMenuPos > 0 then begin
                Dec(akMenuPos);
              end else begin
                akMenuPos := Length(FMenuItem.Items) - 1;
              end;
            end;
            39: begin
              if akMenuPos < Length(FMenuItem.Items) - 1 then begin
                Inc(akMenuPos);
              end else begin
                akMenuPos := 0;
              end;
            end;
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        #13: begin
          p := calcOfs;
          ev.What := whMenuCommand;
          ev.Sender := Self;
          ev.Index := akMenuPos;
          ev.Left := ItemWidth * akMenuPos + p.X;
          ev.Top := ItemHeight + p.Y;
          EventHandle(ev);
        end;
      end;
    end else begin
    end;
  end;
  inherited EventHandle(Event);
end;

{ TMenuBox }

procedure TMenuBox.SetMenuItem(AValue: TMenuItems);
begin
  inherited SetMenuItem(AValue);
  Height := ItemHeight * Length(FMenuItem.Items);
  Width := ItemWidth;
end;

procedure TMenuBox.Draw;
var
  i: integer;
begin
  inherited Draw;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    if (i = akMenuPos) and (FMenuItem.Items[i].Caption <> '-') then begin
      Bitmap.Canvas.Brush.Color := clBlue;
      Bitmap.Canvas.Pen.Color := clBlue;
      Bitmap.Canvas.Rectangle(0, akMenuPos * ItemHeight, Width, (akMenuPos + 1) * ItemHeight);
      Bitmap.Canvas.Font.Color := clWhite;
    end else begin
      Bitmap.Canvas.Brush.Color := FColor;
      Bitmap.Canvas.Pen.Color := clBlack;
      Bitmap.Canvas.Font.Color := clBlack;
    end;
    Bitmap.Canvas.TextOut(1, i * ItemHeight + 1, FMenuItem.Items[i].Caption);
  end;
end;

procedure TMenuBox.EventHandle(var Event: TEvent);
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;
begin
  case Event.What of
    whMouse: begin
      p := calcOfs;
      x := Event.x;
      y := Event.y;

      case Event.MouseCommand of
        MouseDown: begin
          akMenuPos := (y - p.Y) div ItemHeight;
          ev.What := whRepaint;
          EventHandle(ev);
          isMouseDown := True;
        end;
        MouseUp: begin
          ev.What := whMenuCommand;
          ev.Sender := Self;
          if isMouseDown and IsMousInView(x, y) then begin
            ev.Index := akMenuPos;
            ev.Left := ItemWidth + p.X;
            ev.Top := ItemHeight * akMenuPos + p.Y;
          end else begin
            ev.Index := -1;
          end;
          EventHandle(ev);
        end;
        MouseMove: begin
          if isMouseDown and IsMousInView(x, y) then begin
            akMenuPos := (y - p.Y) div ItemHeight;
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #0: begin
          case Event.DownKey of
            35: begin
              akMenuPos := Length(FMenuItem.Items) - 1;
            end;
            36: begin
              akMenuPos := 0;
            end;
            38: begin
              if akMenuPos > 0 then begin
                Dec(akMenuPos);
              end else begin
                akMenuPos := Length(FMenuItem.Items) - 1;
              end;
            end;
            40: begin
              if akMenuPos < Length(FMenuItem.Items) - 1 then begin
                Inc(akMenuPos);
              end else begin
                akMenuPos := 0;
              end;
            end;
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        #13: begin
          p := calcOfs;
          ev.What := whMenuCommand;
          ev.Sender := Self;
          ev.Index := akMenuPos;
          ev.Left := ItemWidth + p.X;
          ev.Top := ItemHeight * akMenuPos + p.Y;
          EventHandle(ev);
        end;
      end;
    end else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
