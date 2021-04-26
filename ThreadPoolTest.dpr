program ThreadPoolTest;

{
  A small program that creates a thread pool and prints a message every time
  a new thread in it is created.
}

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.WinNt, Ntapi.ntpsapi, NtUtils, NtUtils.SysUtils, NtUtils.Threads,
  NtUtils.Threads.Worker, NtUtils.Synchronization, NtUiLib.Errors;

procedure ThreadPoolMain(Context: Pointer); stdcall;
begin
  writeln('Hello from a thread pool''s thread!');
  NtxSetNameThread(NtCurrentThread, 'Thread Pool''s thread');
  NtxDelayExecution(NT_INFINITE)
end;

function Main: TNtxStatus;
var
  hxIoCompletion, hxWorkerFactory: IHandle;
begin
  writeln('This is a sample application with a thread pool.');

  Result := NtxCreateIoCompletion(hxIoCompletion);

  if not Result.IsSuccess then
    Exit;

  Result := NtxCreateWorkerFactory(hxWorkerFactory, hxIoCompletion.Handle,
    ThreadPoolMain, nil);

  if not Result.IsSuccess then
    Exit;

  writeln;
  writeln('Current PID: ', NtCurrentProcessId);
  writeln('Thread pool''s handle: ', RtlxIntToStr(hxWorkerFactory.Handle, 16));
  writeln;
  writeln('Now try to trigger thread creation. You will see a message on success.');

  NtxDelayExecution(NT_INFINITE);
end;

procedure ReportFailures(const xStatus: TNtxStatus);
begin
  if not xStatus.IsSuccess then
    writeln(xStatus.Location, ': ', RtlxNtStatusName(xStatus.Status));
end;

begin
  ReportFailures(Main);
end.
