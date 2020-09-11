library merch;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  SoapAndroidImpl in 'SoapAndroidImpl.pas',
  SoapAndroidIntf in 'SoapAndroidIntf.pas';

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.Run;
end.
