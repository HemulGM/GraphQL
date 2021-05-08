unit HGM.GraphQL.Types;

interface

uses
  System.StrUtils, System.SysUtils, System.Generics.Collections;

type
  TGraphArgList = class;

  TGraphArgString = class;

  TGraphArgInteger = class;

  TGraphArgBoolean = class;

  TGraphArgFloat = class;

  TGraphArgVar = class;

  //

  TGraphArgValue = class abstract
  public
    function ToString: string; reintroduce; virtual; abstract;
  end;

  TGraphArgItem<T> = class abstract(TGraphArgValue)
  private
    FValue: T;
  public
    constructor Create(const AValue: T); reintroduce;
  end;

  TGraphArg = class
  private
    FName: string;
    FValue: TGraphArgValue;
    procedure SetValue(const Value: TGraphArgValue);
    procedure SetName(const Value: string);
  public
    class function Create(const Name: string; const Value: string; IsVar: Boolean = False): TGraphArg; overload;
    class function Create(const Name: string; const Value: Integer): TGraphArg; overload;
    class function Create(const Name: string; const Value: Extended): TGraphArg; overload;
    class function Create(const Name: string; const Value: Boolean): TGraphArg; overload;
    class function Create(const Name: string; const Value: TGraphArgValue): TGraphArg; overload;
    class function Create(const Name: string; const Value: TArray<Integer>): TGraphArg; overload;
  public
    property Name: string read FName write SetName;
    property Value: TGraphArgValue read FValue write SetValue;
    function ToString: string; reintroduce; virtual;
    constructor Create(const AName: string = ''); reintroduce; overload;
    destructor Destroy; override;
  end;

  TGraphArgObject = class(TGraphArgValue)
  private
    FItems: TObjectList<TGraphArg>;
    procedure SetItems(const Value: TObjectList<TGraphArg>);
  public
    function AddPair(const Name: string; const Value: string; AsVar: Boolean = False): TGraphArgObject; overload;
    function AddPair(const Name: string; const Value: Integer): TGraphArgObject; overload;
    function AddPair(const Name: string; const Value: Extended): TGraphArgObject; overload;
    function AddPair(const Name: string; const Value: Boolean): TGraphArgObject; overload;
    function AddPair(const Name: string; const Value: TGraphArgValue): TGraphArgObject; overload;
  public
    function ToString: string; override;
    property Items: TObjectList<TGraphArg> read FItems write SetItems;
    constructor Create; overload;
    constructor Create(Values: array of TGraphArg); overload;
    destructor Destroy; override;
  end;

  TGraphArgList = class(TObjectList<TGraphArg>)
  public
    function AddPair(const Name: string; const Value: string; AsVar: Boolean = False): TGraphArgList; overload;
    function AddPair(const Name: string; const Value: Integer): TGraphArgList; overload;
    function AddPair(const Name: string; const Value: Extended): TGraphArgList; overload;
    function AddPair(const Name: string; const Value: Boolean): TGraphArgList; overload;
    function AddPair(const Name: string; const Value: TGraphArgValue): TGraphArgList; overload;
    function AddPair(const Name: string; const Value: TArray<Integer>): TGraphArgList; overload;
  public
    constructor Create; reintroduce;
    function ToString: string; reintroduce; virtual;
  end;

  TGraphArgString = class(TGraphArgItem<string>)
  public
    function ToString: string; override;
  end;

  TGraphArgInteger = class(TGraphArgItem<Integer>)
  public
    function ToString: string; override;
  end;

  TGraphArgIntegerArray = class(TGraphArgItem<TArray<Integer>>)
  public
    function ToString: string; override;
  end;

  TGraphArgBoolean = class(TGraphArgItem<Boolean>)
  public
    function ToString: string; override;
  end;

  TGraphArgFloat = class(TGraphArgItem<Extended>)
  public
    function ToString: string; override;
  end;

  TGraphArgVar = class(TGraphArgItem<string>)
  public
    function ToString: string; override;
  end;

implementation

{ TGraphArg }

class function TGraphArg.Create(const Name, Value: string; IsVar: Boolean): TGraphArg;
begin
  Result := TGraphArg.Create;
  if IsVar then
    Result.Value := TGraphArgVar.Create(Value)
  else
    Result.Value := TGraphArgString.Create(Value);
  Result.Name := Name;
end;

class function TGraphArg.Create(const Name: string; const Value: Integer): TGraphArg;
begin
  Result := TGraphArg.Create;
  Result.Value := TGraphArgInteger.Create(Value);
  Result.Name := Name;
end;

class function TGraphArg.Create(const Name: string; const Value: Extended): TGraphArg;
begin
  Result := TGraphArg.Create;
  Result.Value := TGraphArgFloat.Create(Value);
  Result.Name := Name;
end;

class function TGraphArg.Create(const Name: string; const Value: Boolean): TGraphArg;
begin
  Result := TGraphArg.Create;
  Result.Value := TGraphArgBoolean.Create(Value);
  Result.Name := Name;
end;

class function TGraphArg.Create(const Name: string; const Value: TGraphArgValue): TGraphArg;
begin
  Result := TGraphArg.Create;
  Result.Value := Value;
  Result.Name := Name;
end;

class function TGraphArg.Create(const Name: string; const Value: TArray<Integer>): TGraphArg;
begin
  Result := TGraphArg.Create;
  Result.Value := TGraphArgIntegerArray.Create(Value);
  Result.Name := Name;
end;

destructor TGraphArg.Destroy;
begin
  if Assigned(FValue) then
  begin
    FValue.Free;
    FValue := nil;
  end;
  inherited;
end;

procedure TGraphArg.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TGraphArg.SetValue(const Value: TGraphArgValue);
begin
  FValue := Value;
end;

function TGraphArg.ToString: string;
begin
  Result := Name + ': ' + FValue.ToString;
end;

{ TGraphArgs }

function TGraphArgObject.AddPair(const Name, Value: string; AsVar: Boolean): TGraphArgObject;
begin
  FItems.Add(TGraphArg.Create(Name, Value, AsVar));
  Result := Self;
end;

function TGraphArgObject.AddPair(const Name: string; const Value: Integer): TGraphArgObject;
begin
  FItems.Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgObject.AddPair(const Name: string; const Value: Extended): TGraphArgObject;
begin
  FItems.Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgObject.AddPair(const Name: string; const Value: Boolean): TGraphArgObject;
begin
  FItems.Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgObject.AddPair(const Name: string; const Value: TGraphArgValue): TGraphArgObject;
begin
  FItems.Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

constructor TGraphArgObject.Create;
begin
  inherited Create;
  FItems := TObjectList<TGraphArg>.Create(True);
end;

constructor TGraphArgObject.Create(Values: array of TGraphArg);
begin
  Create;
  FItems.AddRange(Values);
end;

destructor TGraphArgObject.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TGraphArgObject.SetItems(const Value: TObjectList<TGraphArg>);
begin
  FItems := Value;
end;

function TGraphArgObject.ToString: string;
var
  i: Integer;
begin
  for i := 0 to Pred(FItems.Count) do
    Result := Result + FItems[i].ToString + ', ';
  Result := '{' + Result.TrimRight([',', ' ']) + '}';
end;

constructor TGraphArg.Create(const AName: string);
begin
  FName := AName;
end;

{ TGraphArgString }

function TGraphArgString.ToString: string;
begin
  Result := '"' + FValue + '"';
end;

{ TGraphArgList }

function TGraphArgList.AddPair(const Name, Value: string; AsVar: Boolean): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value, AsVar));
  Result := Self;
end;

function TGraphArgList.AddPair(const Name: string; const Value: Integer): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgList.AddPair(const Name: string; const Value: Extended): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgList.AddPair(const Name: string; const Value: Boolean): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgList.AddPair(const Name: string; const Value: TGraphArgValue): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

function TGraphArgList.AddPair(const Name: string; const Value: TArray<Integer>): TGraphArgList;
begin
  Add(TGraphArg.Create(Name, Value));
  Result := Self;
end;

constructor TGraphArgList.Create;
begin
  inherited Create;
end;

function TGraphArgList.ToString: string;
var
  i: Integer;
begin
  for i := 0 to Pred(Count) do
    Result := Result + Items[i].ToString + ', ';
  Result := '(' + Result.TrimRight([',', ' ']) + ')';
end;

{ TGraphArgItem<T> }

constructor TGraphArgItem<T>.Create(const AValue: T);
begin
  FValue := AValue;
end;

{ TGraphArgInteger }

function TGraphArgInteger.ToString: string;
begin
  Result := FValue.ToString;
end;

{ TGraphArgBoolean }

function TGraphArgBoolean.ToString: string;
begin
  if FValue then
    Exit('true')
  else
    Exit('false');
end;

{ TGraphArgFloat }

function TGraphArgFloat.ToString: string;
var
  FS: TFormatSettings;
begin
  FS := FormatSettings;
  FS.DecimalSeparator := '.';
  Result := FValue.ToString(FS);
end;

{ TGraphArgVar }

function TGraphArgVar.ToString: string;
begin
  Result := FValue;
end;

{ TGraphArgIntegerArray }

function TGraphArgIntegerArray.ToString: string;
var
  i: Integer;
begin
  for i := 0 to High(FValue) do
    Result := Result + FValue[i].ToString + ', ';
  Result := '[' + Result.TrimRight([',', ' ']) + ']';
end;

end.

