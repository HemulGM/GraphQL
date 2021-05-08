# GraphQL
 GraphQL Query Constructor

```Pascal
GraphQL: TGraphQL;
Response: TJSONObject;
...
GraphQL := TGraphQL.Create(Self);
GraphQL.Client.BaseUrl := 'https:\\api.site.io';
if GraphQL.Call(Response, Query) = 200 then
 ...
```

```Pascal
with TGraphQuery.Create('query', 'query_name') do
  begin
    AddMethod('bonuses', 
      //Args
      TGraphArgList.Create
      .AddPair('limit', 1)
      .AddPair('offset', 0)
      .AddPair('filter', TGraphArgObject.Create
        .AddPair('branch_id', 1)
        .AddPair('type', ''))
      .AddPair('sort', TGraphArgObject.Create
        .AddPair('field', 'name')
        .AddPair('order', 'asc')),
      //Fields
      TGraphFields.Create
      .AddField(TGraphField.Create('result'))
      .AddField(TGraphField.Create('items')
        .AddSub(TGraphField.Create('id'))
        .AddSub(TGraphField.Create('date')))
      .AddField(TGraphField.Create('totalCount')));
    if GraphQL.Call(Response, Query) = 200 then
     ...
    ShowMessage(Query.ToString); 
    Free;
  end;
  ```
