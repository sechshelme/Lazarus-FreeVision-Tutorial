unit TVInput;       { 9-7-95 }
{&Use32+}

{$H-}

{#F ****************************************************}
{                                                       }
{           Utilities in this unit:                     }
{                                                       }
{-------------------------------------------------------}
{                                                       }
{   InputLine objects with standard Validators          }
{                                                       }
{   The data record for RangeInputLine is a longint,    }
{   but for Filter, StringLookup, and PXPicture         }
{   -InputLines, the data record is String[AMaxLen].    }
{   The validator Init parameters are appended to the   }
{   InputLine Init parameters.  The ofValidate bit of   }
{   TInputLine.Options is set in each case.             }
{                                                       }
{-------------------------------------------------------}
{                                                       }
{   RadioButtons with cmListItemSelected broadcast      }
{                                                       }
{-------------------------------------------------------}
{                                                       }
{   PString primitives: Dispose, Change, Get -String    }
{                                                       }
{-------------------------------------------------------}
{                                                       }
{               Messages for Stream Errors              }
{                                                       }
{   To enable stream error reporting, include this:     }
{                                                       }
{       StreamError:= @StreamErrorMsg;                  }
{                                                       }
{   Use StreamErrMsg to define your own message         }
{   (generally temporarily for special situations).     }
{                                                       }
{-------------------------------------------------------}
{                                                       }
{           Stream Registration Records                 }
{                                                       }
{#F ****************************************************}

interface

uses Objects, Views, Dialogs, Validate;

type
    PFilterInputLine = ^TFilterInputLine;
    TFilterInputLine = object(TInputLine)
    { InputLine with a FilterValidator }
        constructor Init(
            var Bounds: TRect;
            AMaxLen: integer;       {max length of input text}
            AValidChars: TCharSet   {set of valid characters}
        );
    end;

    PRangeInputLine = ^TRangeInputLine;
    TRangeInputLine = object(TInputLine)
    { InputLine with a RangeValidator }
        constructor Init(
            var Bounds: TRect;
            AMaxLen: integer;       {max length of input text}
            AMin, AMax: longint  {min & max limits of value}
        );
    end;

    PStringLookupInputLine = ^TStringLookupInputLine;
    TStringLookupInputLine = object(TInputLine)
    { InputLine with a #StringLookupValidator# }
        constructor Init(
            var Bounds: TRect;
            AMaxLen: integer;       {max length of input text}
            AStrings: PStringCollection  {list of valid strings}
        );
    end;

    PPXPictureInputLine = ^TPXPictureInputLine;
    TPXPictureInputLine = object(TInputLine)
    { InputLine with a #PXPictureValidator# }
        constructor Init(
            var Bounds: TRect;
            AMaxLen: integer;       {max length of input text}
            const APic: string; {defines #Pic# field}
                                {of #TPXPictureValidator#}
            AutoFill: boolean   {set #voFill# bit in Options field}
                                {of #TPXPictureValidator#}
        );
    end;

{*******************************************************}

type
    PMRadioButtons = ^TMRadioButtons;
    TMRadioButtons = object(TRadioButtons)
        procedure MovedTo(Item: Integer); virtual;
    {   This variant of the Radio Buttons object
        broadcasts a cmListItemSelected message
        when the selection is changed.
    }
        { used to respond to up, down arrow keys }
        { Item is index of selected button }

        procedure Press(
        { used to respond to mouse clicks and shortcut keys }
            Item: integer   { index of selected button }
        ); virtual;
    end;

{*******************************************************}

procedure DisposeStr(var P: PString);
{   Disposes of P^ and sets P:= nil:            }
{   (Objects.DisposeStr doesn't set P:= nil.)   }
{   Replaces Objects.DisposeStr *if*            }
{   TvInput comes after Objects in "uses" list. }

procedure ChangeStr(var Targ: PString; const Src: string);
{   Replaces Targ^ with Src:    }
{   Disposes of old string, and }
{   allocates new string copy.  }

function GetStr(S: PString): string;
{   Gets string S^, or '' if S = nil:           }
{   (S:= NewStr(A) sets S:= nil if A = ''.)     }

const
    StreamErrMsg: ^string = nil;

procedure StreamErrorMsg(var S: TStream);
{#F ****************************************************}
{                                                       }
{   To enable stream error reporting, include this:     }
{                                                       }
{       StreamError:= @StreamErrorMsg;                  }
{                                                       }
{   Use StreamErrMsg to define your own message         }
{   (generally temporarily for special situations).     }
{                                                       }
{#F ****************************************************}

procedure RegisterTVinput;  {registers all objects in this unit}

const
    RFilterInputLine: TStreamRec = (
        ObjType: 1200;
        VmtLink: Ofs(TypeOf(TFilterInputLine)^);
        Load: @TInputLine.Load;
        Store: @TInputLine.Store
    );

    RRangeInputLine: TStreamRec = (
        ObjType: 1201;
        VmtLink: Ofs(TypeOf(TRangeInputLine)^);
        Load: @TInputLine.Load;
        Store: @TInputLine.Store
    );

    RStringLookupInputLine: TStreamRec = (
        ObjType: 1202;
        VmtLink: Ofs(TypeOf(TStringLookupInputLine)^);
        Load: @TInputLine.Load;
        Store: @TInputLine.Store
    );

    RPXPictureInputLine: TStreamRec = (
        ObjType: 1203;
        VmtLink: Ofs(TypeOf(TPXPictureInputLine)^);
        Load: @TInputLine.Load;
        Store: @TInputLine.Store
    );

    RMRadioButtons: TStreamRec = (
        ObjType: 1204;
        VmtLink: Ofs(TypeOf(TMRadioButtons)^);
        Load: @TRadioButtons.Load;
        Store: @TRadioButtons.Store
    );

{*******************************************************}

implementation

uses Drivers, App, MsgBox;

{ TFilterValidator2 (bug fixed) }

type
    PFilterValidator2 = ^TFilterValidator2;
    TFilterValidator2 = object(TFilterValidator)
        function IsValid(const S: string): boolean; virtual;
        function IsValidInput(var S: string;
                SuppressFill: boolean): boolean; virtual;
    end;

function TFilterValidator2.IsValid(const S: string): boolean;
var
    I: integer;
begin
    I:= 1;
    { needs "(I <= Length(S)) and" ! }
    while (I <= Length(S)) and (S[I] in ValidChars) do Inc(I);
    IsValid:= I > Length(S);
end;

function TFilterValidator2.IsValidInput(var S: string;
        SuppressFill: boolean): boolean;
var
    I: integer;
begin
    I:= 1;
    { needs "(I <= Length(S)) and" ! }
    while (I <= Length(S)) and (S[I] in ValidChars) do Inc(I);
    IsValidInput:= I > Length(S);
end;

{*******************************************************}
{                                                       }
{   InputLine objects with standard Validators          }
{                                                       }
{*******************************************************}

{ InputLine with a FilterValidator }

constructor TFilterInputLine.Init(var Bounds: TRect; AMaxLen: integer;
                AValidChars: TCharSet);
begin
    inherited Init(Bounds, AMaxLen);
    SetValidator(New(PFilterValidator2, Init(AValidChars)));
    Options:= Options or ofValidate;    {+ needed ? +}
end; {TFilterInputLine.Init}

{ InputLine with a RangeValidator }

constructor TRangeInputLine.Init(var Bounds: TRect; AMaxLen: integer;
                AMin, AMax: longint);
begin
    inherited Init(Bounds, AMaxLen);
    SetValidator(New(PRangeValidator, Init(AMin, AMax)));
    Validator^.Options:= voTransfer;    {needed for longint transfer}
    Options:= Options or ofValidate;
end; {TRangeInputLine.Init}

{ InputLine with a StringLookupValidator }

constructor TStringLookupInputLine.Init(var Bounds: TRect; AMaxLen:
                integer; AStrings: PStringCollection);
begin
    inherited Init(Bounds, AMaxLen);
    SetValidator(New(PStringLookupValidator, Init(AStrings)));
    Options:= Options or ofValidate;
end; {TStringLookupInputLine.Init}

{ InputLine with a PXPictureValidator }

constructor TPXPictureInputLine.Init(var Bounds: TRect; AMaxLen:
                integer; const APic: string; AutoFill: boolean);
begin
    inherited Init(Bounds, AMaxLen);
    SetValidator(New(PPXPictureValidator, Init(APic, AutoFill)));
    Options:= Options or ofValidate;
end; {TPXPictureInputLine.Init}

procedure RegisterTVinput;
begin
    RegisterType(RFilterInputLine);
    RegisterType(RRangeInputLine);
    RegisterType(RStringLookupInputLine);
    RegisterType(RPXPictureInputLine);
    RegisterType(RMRadioButtons);
end; {RegisterTVinput}

{*******************************************************}
{                                                       }
{   RadioButtons with cmListItemSelected broadcast      }
{                                                       }
{*******************************************************}

{ used to respond to up, down arrow keys: }
procedure TMRadioButtons.MovedTo(Item: integer);
begin
    inherited MovedTo(Item);
    Message(TopView, evBroadcast, cmListItemSelected, @Self);
end; {TMRadioButtons.MovedTo}

{ used to respond to mouse clicks and shortcut keys: }
procedure TMRadioButtons.Press(Item: integer);
begin
    inherited Press(Item);
    Message(TopView, evBroadcast, cmListItemSelected, @Self);
end; {TMRadioButtons.Press}

{*******************************************************}
{                                                       }
{   PString primitives: Dispose, Change, Get -String    }
{                                                       }
{*******************************************************}

procedure DisposeStr(var P: PString);
begin
    if P <> nil then begin
        FreeMem(P, Length(P^) + 1);
        P:= nil;        {Objects unit doesn't do this}
    end;
end; {DisposeStr}

procedure ChangeStr(var Targ: PString; const Src: string);
begin
    DisposeStr(Targ);
    Targ:= NewStr(Src);
end; {ChangeStr}

function GetStr(S: PString): string;
begin
    if S = nil then GetStr:= '' else GetStr:= S^;
end; {GetStr}

{*******************************************************}
{                                                       }
{               Messages for Stream Errors              }
{                                                       }
{*******************************************************}

procedure StreamErrorMsg(var S: TStream);
var
    M: string;
begin
    if StreamErrMsg <> nil then begin
        M:= StreamErrMsg^;
    end else begin
        case S.Status of
            stError:        M:= 'access';
            stInitError:    M:= 'initialize';
            stReadError:    M:= 'read past end of';
            stWriteError:   M:= 'expand (write to)';
            stGetError:     M:= 'get unregistered object from';
            stPutError:     M:= 'put unregistered object on';
        end; {case}
        M:= 'Can''t ' + M + ' stream.';
    end;
    MessageBox(M, nil, mfError+mfOkButton);
end; {StreamErrorMsg}

end.
