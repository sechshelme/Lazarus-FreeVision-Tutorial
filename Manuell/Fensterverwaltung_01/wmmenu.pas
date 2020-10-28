unit WMMenu;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
{$modeswitch arrayoperators}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  WMSystem, WMView, WMDesktop, WMButton;

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
    FIndex: integer;
    FMenuItem: TMenuItems;
    ItemHeight, ItemWidth: integer;
    arrowWidth: integer;
  const
    arrowch = '▶';

    procedure SetMenuItem(AValue: TMenuItems); virtual;
  public
    MenuCount: integer; static;
    Nesting: integer;
    property MenuItem: TMenuItems read FMenuItem write SetMenuItem;
    property Index: integer read FIndex;
    constructor Create; override;
    destructor Destroy; override;
    procedure HideCursor; virtual;
    procedure ShowCursor; virtual;
  end;

  { TMenuBar }

  TMenuBar = class(TMenuView)
  private
    procedure SetMenuItem(AValue: TMenuItems); override;
    procedure SendMenuCommand;
  public
    constructor Create; override;
    procedure Draw; override;
    procedure EventHandle(var Event: TEvent); override;
    procedure ShowCursor; override;
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
  if First >= 0 then begin
    for i := First to TMenuBox.MenuCount - 2 do begin
      DeleteView(MenuBox[i]);
    end;
    SetLength(MenuBox, First);
  end;

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
      if Event.MouseCommand = EvMouseDown then begin
        if not ClickInMenu(Event.x, Event.y) then begin
          KillSubMenu(0, True);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whKeyPress: begin
      case Event.PressKey of
        #27: begin
          l := Length(MenuBox);
          KillSubMenu(l - 1, False);

          if l = 0 then begin
            MenuBar.HideCursor;
            if Parent <> nil then begin
              Parent.LastView(Self);
            end;
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
        #0: begin
          if Event.DownKey in [37, 39] then begin
            KillSubMenu(0, False);
          end;
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
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
end;

destructor TMenuView.Destroy;
begin
  Dec(MenuCount);
  inherited Destroy;
end;

procedure TMenuView.SetMenuItem(AValue: TMenuItems);
var
  w: integer = 0;
  h: integer = 0;
  i: integer;
  isSub: boolean;
begin
  Bitmap.Canvas.GetTextSize(arrowch, w, h);
  arrowWidth := w;
  FMenuItem := AValue;
  ItemWidth := 0;
  isSub := False;
  for i := 0 to Length(FMenuItem.Items) - 1 do begin
    Bitmap.Canvas.GetTextSize(FMenuItem.Items[i].Caption, w, h);
    if Length(FMenuItem.Items[i].Items) > 0 then begin
      isSub := True;
    end;

    if w > ItemWidth then begin
      ItemWidth := w;
    end;
  end;
  ItemHeight := h + 4;
  Inc(ItemWidth, 4);
  if isSub then begin
    Inc(ItemWidth, 2 * arrowWidth);
  end;
end;

procedure TMenuView.HideCursor;
begin
  FIndex := -1;
end;

procedure TMenuView.ShowCursor;
begin
  FIndex := 0;
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

procedure TMenuBar.SendMenuCommand;
var
  x, y: integer;
  p: TPoint;
  ev: TEvent;

begin
  p := calcOfs;
  ev.What := whMenuCommand;
  ev.Sender := Self;
  ev.Index := Index;
  ev.Left := ItemWidth * Index + p.X;
  ev.Top := ItemHeight + p.Y;
  EventHandle(ev);
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
    if i = Index then begin
      Bitmap.Canvas.Brush.Color := clBlue;
      Bitmap.Canvas.Pen.Color := clBlue;
      Bitmap.Canvas.Rectangle(Index * ItemWidth, 0, (Index + 1) * ItemWidth, Height);
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
  x, y: PtrInt;
  p: TPoint;
  ev: TEvent;

begin
  if Length(FMenuItem.Items) > 0 then begin
    case Event.What of
      whMouse: begin
        p := calcOfs;
        x := Event.x;
        y := Event.y;
        case Event.MouseCommand of
          EvMouseDown: begin
            FIndex := (x - p.X) div ItemWidth;
            ev.What := whRepaint;
            EventHandle(ev);
            isMouseDown := True;
          end;
          EvMouseUp: begin
            ev.What := whMenuCommand;
            ev.Sender := Self;
            if isMouseDown and IsMousInView(x, y) and (Index < Length(FMenuItem.Items)) then begin
              ev.Index := Index;
              ev.Left := ItemWidth * Index + p.X;
              ev.Top := ItemHeight + p.Y;
            end else begin
              ev.Index := -1;
            end;
            EventHandle(ev);
          end;
          EvMouseMove: begin
            if isMouseDown and IsMousInView(x, y) then begin
              FIndex := (x - p.X) div ItemWidth;
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
                if Index > 0 then begin
                  Dec(FIndex);
                end else begin
                  FIndex := Length(FMenuItem.Items) - 1;
                end;
                if Length(FMenuItem.Items[FIndex].Items) > 0 then begin
                  SendMenuCommand;
                end;
              end;
              39: begin
                if FIndex < Length(FMenuItem.Items) - 1 then begin
                  Inc(FIndex);
                end else begin
                  FIndex := 0;
                end;
                if Length(FMenuItem.Items[FIndex].Items) > 0 then begin
                  SendMenuCommand;
                end;
              end;
            end;
            ev.What := whRepaint;
            EventHandle(ev);
          end;
          #13: begin
            SendMenuCommand;
          end;
        end;
      end else begin
      end;
    end;
  end;
  inherited EventHandle(Event);
end;

procedure TMenuBar.ShowCursor;
begin
  inherited ShowCursor;
  if Length(FMenuItem.Items) > 0 then begin
    if Length(FMenuItem.Items[FIndex].Items) > 0 then begin
      SendMenuCommand;
    end;
  end;
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
    if (i = Index) and (FMenuItem.Items[i].Caption <> '-') then begin
      Bitmap.Canvas.Brush.Color := clBlue;
      Bitmap.Canvas.Pen.Color := clBlue;
      Bitmap.Canvas.Rectangle(0, Index * ItemHeight, Width, (Index + 1) * ItemHeight);
      Bitmap.Canvas.Font.Color := clWhite;
    end else begin
      Bitmap.Canvas.Brush.Color := FColor;
      Bitmap.Canvas.Pen.Color := clBlack;
      Bitmap.Canvas.Font.Color := clBlack;
    end;
    Bitmap.Canvas.TextOut(1, i * ItemHeight + 1, FMenuItem.Items[i].Caption);
    if Length(FMenuItem.Items[i].Items) > 0 then begin
      Bitmap.Canvas.TextOut(ItemWidth - arrowWidth-1, i * ItemHeight + 1, arrowch);
    end;
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
        EvMouseDown: begin
          FIndex := (y - p.Y) div ItemHeight;
          ev.What := whRepaint;
          EventHandle(ev);
          isMouseDown := True;
        end;
        EvMouseUp: begin
          ev.What := whMenuCommand;
          ev.Sender := Self;
          if isMouseDown and IsMousInView(x, y) then begin
            if FIndex >= Length(FMenuItem.Items) - 1 then begin
              FIndex := Length(FMenuItem.Items) - 1;
            end;
            ev.Index := FIndex;
            ev.Left := ItemWidth + p.X;
            ev.Top := ItemHeight * FIndex + p.Y;
          end else begin
            ev.Index := -1;
          end;
          EventHandle(ev);
        end;
        EvMouseMove: begin
          if isMouseDown and IsMousInView(x, y) then begin
            FIndex := (y - p.Y) div ItemHeight;
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
              FIndex := Length(FMenuItem.Items) - 1;
            end;
            36: begin
              FIndex := 0;
            end;
            38: begin
              if FIndex > 0 then begin
                Dec(FIndex);
              end else begin
                FIndex := Length(FMenuItem.Items) - 1;
              end;
            end;
            40: begin
              if FIndex < Length(FMenuItem.Items) - 1 then begin
                Inc(FIndex);
              end else begin
                FIndex := 0;
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
          ev.Index := FIndex;
          ev.Left := ItemWidth + p.X;
          ev.Top := ItemHeight * FIndex + p.Y;
          EventHandle(ev);
        end;
      end;
    end else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.
