unit HGM.GraphQL;

interface

uses
  System.Classes, REST.Client, System.StrUtils, REST.Types, System.SysUtils, System.Net.URLClient, System.Net.HttpClient,
  System.JSON, HGM.GraphQL.Query;

type
  TGraphQL = class(TComponent)
  private
    FClient: TRESTClient;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Call(out Response: TJSONObject; Query: TGraphQuery; Variables: TJSONObject = nil): Integer; overload;
    function Call(out Response: TJSONObject; const OperationName, Query: string; Variables: TJSONObject = nil): Integer; overload;
    function Call(const OperationName, Query: string; Variables: TJSONObject = nil): Integer; overload;
    property Client: TRESTClient read FClient;
  end;

implementation

uses
  System.NetConsts, REST.Json, Winapi.Windows, System.Net.Mime;

{ TGraphQL }

function TGraphQL.Call(out Response: TJSONObject; const OperationName, Query: string; Variables: TJSONObject): Integer;
var
  Body: TJSONObject;
  Request: TRESTRequest;
begin
  OutputDebugString(PChar(Query));
  Response := nil;
  Body := TJSONObject.Create;
  Body.AddPair('operationName', OperationName);
  Body.AddPair('query', Query);
  if Assigned(Variables) then
    Body.AddPair('variables', Variables);
  OutputDebugString(PChar(TJSON.JsonEncode(Body)));
  Request := TRESTRequest.Create(nil);
  Request.Client := Client;
  try
    Request.AddParameter(CONTENTTYPE_APPLICATION_JSON, Body);
    Request.Method := TRESTRequestMethod.rmPOST;
    Request.Execute;
    with Request.Response do
    begin
      Response := TJSONObject(TJSONObject.ParseJSONValue(Content));
      OutputDebugString(PChar(Content));
      //BodyText.Text := Content;
      Result := StatusCode;
    end;
  finally
    //Body.Free;
    Request.Free;
  end;
end;

function TGraphQL.Call(const OperationName, Query: string; Variables: TJSONObject): Integer;
var
  Response: TJSONObject;
begin
  Result := Call(Response, OperationName, Query, Variables);
  if Assigned(Response) then
    Response.Free;
end;

function TGraphQL.Call(out Response: TJSONObject; Query: TGraphQuery; Variables: TJSONObject): Integer;
begin
  Result := Call(Response, Query.Name, Query.ToString, Variables);
end;

constructor TGraphQL.Create(AOwner: TComponent);
begin
  inherited;
  FClient := TRESTClient.Create(nil);
  FClient.RaiseExceptionOn500 := False;
  FClient.ContentType := CONTENTTYPE_APPLICATION_JSON;
end;

destructor TGraphQL.Destroy;
begin
  FClient.Free;
  inherited;
end;

end.
