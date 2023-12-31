// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright � 2018 Salvador D�az Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

program FMXSkiaBrowser;

uses
  {$IFDEF DELPHI17_UP}
  System.StartUpCopy,
  {$ENDIF }
  FMX.Forms,
  FMX.Types,
  Skia.FMX,     // This unit comes from the Skia4Delphi project
  uCEFApplication,
  uCEFFMXWorkScheduler,
  uMainForm in 'uMainForm.pas' {MainForm},
  uFMXApplicationService in 'uFMXApplicationService.pas';

{$R *.res}

{$IFDEF MSWINDOWS}
// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
{$SetPEFlags $20}
{$ENDIF}

begin
  // Enable Skia usage. 
  GlobalUseMetal := True;
  GlobalUseSkiaRasterWhenAvailable := False;
  GlobalUseSkia := True;
  // GlobalCEFApp creation and initialization moved to a different unit to fix the memory leak described in the bug #89
  // https://github.com/salvadordf/CEF4Delphi/issues/89
  CreateGlobalCEFApp;

  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.CreateForm(TMainForm, MainForm);
      Application.Run;

      // The form needs to be destroyed *BEFORE* stopping the scheduler.
      MainForm.Free;

      GlobalFMXWorkScheduler.StopScheduler;
    end;

  DestroyGlobalCEFApp;
  DestroyGlobalFMXWorkScheduler;
end.
