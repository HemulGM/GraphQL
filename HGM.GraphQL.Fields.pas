unit HGM.GraphQL.Fields;

interface

uses
  System.Generics.Collections, HGM.GraphQL.Types;

type
  TGraphFields = class;

  TGraphField = class
  private
    FArgs: TGraphArgList;
    FName: string;
    FSubFields: TGraphFields;
    procedure SetName(const Value: string);
  public
    function ToString: string; reintroduce;
    constructor Create(const AName: string);
    destructor Destroy; override;
    function AddSub(const Item: TGraphField): TGraphField;
    function AddArg(const Item: TGraphArg): TGraphField;
    property Args: TGraphArgList read FArgs;
    property SubFields: TGraphFields read FSubFields;
    property Name: string read FName write SetName;
  end;

  TGraphFields = class(TObjectList<TGraphField>)
  public
    constructor Create; reintroduce; overload;
    constructor Create(const Items: TArray<string>); overload;
    function AddField(const Item: TGraphField): TGraphFields;
    function ToString: string; reintroduce;
  end;

implementation

uses
  System.SysUtils;

{ TGraphField }

function TGraphField.AddArg(const Item: TGraphArg): TGraphField;
begin
  Args.Add(Item);
  Result := Self;
end;

function TGraphField.AddSub(const Item: TGraphField): TGraphField;
begin
  SubFields.Add(Item);
  Result := Self;
end;

constructor TGraphField.Create(const AName: string);
begin
  FArgs := TGraphArgList.Create;
  FSubFields := TGraphFields.Create;
  FName := AName;
end;

destructor TGraphField.Destroy;
begin
  FArgs.Free;
  FSubFields.Free;
  inherited;
end;

procedure TGraphField.SetName(const Value: string);
begin
  FName := Value;
end;

function TGraphField.ToString: string;
begin
  Result := FName;
  if FArgs.Count > 0 then
    Result := Result + FArgs.ToString;
  if FSubFields.Count > 0 then
    Result := Result + FSubFields.ToString;
end;

{ TGraphFields }

constructor TGraphFields.Create;
begin
  inherited Create;
end;

function TGraphFields.AddField(const Item: TGraphField): TGraphFields;
begin
  Add(Item);
  Result := Self;
end;

constructor TGraphFields.Create(const Items: TArray<string>);
var
  Item: string;
begin
  Create;
  for Item in Items do
    Add(TGraphField.Create(Item));
end;

function TGraphFields.ToString: string;
var
  i: Integer;
begin
  for i := 0 to Pred(Count) do
    Result := Result + Items[i].ToString + ', ';
  Result := '{' + Result.TrimRight([',', ' ']) + '}';
end;

end.

