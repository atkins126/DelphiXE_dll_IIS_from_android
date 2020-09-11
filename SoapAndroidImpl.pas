{ Invokable implementation File for TSoapAndroid which implements ISoapAndroid }

unit SoapAndroidImpl;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns, SoapAndroidIntf;

type

  { TSoapAndroid }
  TSoapAndroid = class(TInvokableClass, ISoapAndroid)
  public
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
  end;

implementation

function TSoapAndroid.echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
begin
  { TODO : Implement method echoEnum }
  Result := Value;
end;

function TSoapAndroid.echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
begin
  { TODO : Implement method echoDoubleArray }
  Result := Value;
end;

function TSoapAndroid.echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
begin
  { TODO : Implement method echoMyEmployee }
  Result := TMyEmployee.Create;
end;

function TSoapAndroid.echoDouble(const Value: Double): Double; stdcall;
begin
  { TODO : Implement method echoDouble }
  Result := Value;
end;


initialization
{ Invokable classes must be registered }
   InvRegistry.RegisterInvokableClass(TSoapAndroid);
end.

