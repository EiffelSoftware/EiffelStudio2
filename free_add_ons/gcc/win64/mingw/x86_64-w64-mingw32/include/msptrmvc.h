#ifndef _MSPTRMVC_H_
#define _MSPTRMVC_H_

class CVideoCaptureTerminal : public CSingleFilterStaticTerminal {
public:
  CVideoCaptureTerminal();
  virtual ~CVideoCaptureTerminal();
public:
  static HRESULT CreateTerminal(CComPtr<IMoniker> pMoniker,MSP_HANDLE htAddress,ITTerminal **ppTerm);
  DECLARE_LOG_ADDREF_RELEASE(CVideoCaptureTerminal);
private:
  virtual HRESULT AddFiltersToGraph();
  virtual LONG CountOfMediaTypes() { return 1; }
  virtual DWORD GetSupportedMediaTypes(void) { return (DWORD) TAPIMEDIATYPE_VIDEO; }
  HRESULT CreateFilters();
  HRESULT FindCapturePin();
};

inline CVideoCaptureTerminal::CVideoCaptureTerminal() {
  m_TerminalDirection = TD_CAPTURE;
  m_TerminalType = TT_STATIC;
}

#endif
