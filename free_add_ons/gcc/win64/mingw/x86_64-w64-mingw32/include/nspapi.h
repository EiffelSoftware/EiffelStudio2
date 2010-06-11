/**
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is part of the w64 mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER.PD within this package.
 */
#ifndef _NSPAPI_INCLUDED
#define _NSPAPI_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif

#ifndef _tagBLOB_DEFINED
#define _tagBLOB_DEFINED
#define _BLOB_DEFINED
#define _LPBLOB_DEFINED
  typedef struct _BLOB {
    ULONG cbSize;
    BYTE *pBlobData;
  } BLOB,*LPBLOB;
#endif

#ifndef GUID_DEFINED
#define GUID_DEFINED
  typedef struct _GUID {
    unsigned long Data1;
    unsigned short Data2;
    unsigned short Data3;
    unsigned char Data4[8];
  } GUID;
#endif

#ifndef __LPGUID_DEFINED__
#define __LPGUID_DEFINED__
  typedef GUID *LPGUID;
#endif

#define SERVICE_RESOURCE (0x00000001)
#define SERVICE_SERVICE (0x00000002)
#define SERVICE_LOCAL (0x00000004)

#define SERVICE_REGISTER (0x00000001)
#define SERVICE_DEREGISTER (0x00000002)
#define SERVICE_FLUSH (0x00000003)
#define SERVICE_ADD_TYPE (0x00000004)
#define SERVICE_DELETE_TYPE (0x00000005)

#define SERVICE_FLAG_DEFER (0x00000001)
#define SERVICE_FLAG_HARD (0x00000002)

#define PROP_COMMENT (0x00000001)
#define PROP_LOCALE (0x00000002)
#define PROP_DISPLAY_HINT (0x00000004)
#define PROP_VERSION (0x00000008)
#define PROP_START_TIME (0x00000010)
#define PROP_MACHINE (0x00000020)
#define PROP_ADDRESSES (0x00000100)
#define PROP_SD (0x00000200)
#define PROP_ALL (0x80000000)

#define SERVICE_ADDRESS_FLAG_RPC_CN (0x00000001)
#define SERVICE_ADDRESS_FLAG_RPC_DG (0x00000002)
#define SERVICE_ADDRESS_FLAG_RPC_NB (0x00000004)

#define NS_DEFAULT (0)

#define NS_SAP (1)
#define NS_NDS (2)
#define NS_PEER_BROWSE (3)

#define NS_TCPIP_LOCAL (10)
#define NS_TCPIP_HOSTS (11)
#define NS_DNS (12)
#define NS_NETBT (13)
#define NS_WINS (14)

#define NS_NBP (20)

#define NS_MS (30)
#define NS_STDA (31)
#define NS_NTDS (32)

#define NS_X500 (40)
#define NS_NIS (41)

#define NS_VNS (50)

#define NSTYPE_HIERARCHICAL (0x00000001)
#define NSTYPE_DYNAMIC (0x00000002)
#define NSTYPE_ENUMERABLE (0x00000004)
#define NSTYPE_WORKGROUP (0x00000008)

#define XP_CONNECTIONLESS (0x00000001)
#define XP_GUARANTEED_DELIVERY (0x00000002)
#define XP_GUARANTEED_ORDER (0x00000004)
#define XP_MESSAGE_ORIENTED (0x00000008)
#define XP_PSEUDO_STREAM (0x00000010)
#define XP_GRACEFUL_CLOSE (0x00000020)
#define XP_EXPEDITED_DATA (0x00000040)
#define XP_CONNECT_DATA (0x00000080)
#define XP_DISCONNECT_DATA (0x00000100)
#define XP_SUPPORTS_BROADCAST (0x00000200)
#define XP_SUPPORTS_MULTICAST (0x00000400)
#define XP_BANDWIDTH_ALLOCATION (0x00000800)
#define XP_FRAGMENTATION (0x00001000)
#define XP_ENCRYPTS (0x00002000)

#define RES_SOFT_SEARCH (0x00000001)
#define RES_FIND_MULTIPLE (0x00000002)
#define RES_SERVICE (0x00000004)

#define SERVICE_TYPE_VALUE_SAPIDA "SapId"
#define SERVICE_TYPE_VALUE_SAPIDW L"SapId"

#define SERVICE_TYPE_VALUE_CONNA "ConnectionOriented"
#define SERVICE_TYPE_VALUE_CONNW L"ConnectionOriented"

#define SERVICE_TYPE_VALUE_TCPPORTA "TcpPort"
#define SERVICE_TYPE_VALUE_TCPPORTW L"TcpPort"

#define SERVICE_TYPE_VALUE_UDPPORTA "UdpPort"
#define SERVICE_TYPE_VALUE_UDPPORTW L"UdpPort"

#ifdef UNICODE

#define SERVICE_TYPE_VALUE_SAPID SERVICE_TYPE_VALUE_SAPIDW
#define SERVICE_TYPE_VALUE_CONN SERVICE_TYPE_VALUE_CONNW
#define SERVICE_TYPE_VALUE_TCPPORT SERVICE_TYPE_VALUE_TCPPORTW
#define SERVICE_TYPE_VALUE_UDPPORT SERVICE_TYPE_VALUE_UDPPORTW
#else

#define SERVICE_TYPE_VALUE_SAPID SERVICE_TYPE_VALUE_SAPIDA
#define SERVICE_TYPE_VALUE_CONN SERVICE_TYPE_VALUE_CONNA
#define SERVICE_TYPE_VALUE_TCPPORT SERVICE_TYPE_VALUE_TCPPORTA
#define SERVICE_TYPE_VALUE_UDPPORT SERVICE_TYPE_VALUE_UDPPORTA
#endif

#define SET_SERVICE_PARTIAL_SUCCESS (0x00000001)

  typedef struct _NS_INFOA {
    DWORD dwNameSpace;
    DWORD dwNameSpaceFlags;
    LPSTR lpNameSpace;
  } NS_INFOA,*PNS_INFOA,*LPNS_INFOA;

  typedef struct _NS_INFOW {
    DWORD dwNameSpace;
    DWORD dwNameSpaceFlags;
    LPWSTR lpNameSpace;
  } NS_INFOW,*PNS_INFOW,*LPNS_INFOW;
#ifdef UNICODE
  typedef NS_INFOW NS_INFO;
  typedef PNS_INFOW PNS_INFO;
  typedef LPNS_INFOW LPNS_INFO;
#else
  typedef NS_INFOA NS_INFO;
  typedef PNS_INFOA PNS_INFO;
  typedef LPNS_INFOA LPNS_INFO;
#endif

  typedef struct _SERVICE_TYPE_VALUE {
    DWORD dwNameSpace;
    DWORD dwValueType;
    DWORD dwValueSize;
    DWORD dwValueNameOffset;
    DWORD dwValueOffset;
  } SERVICE_TYPE_VALUE,*PSERVICE_TYPE_VALUE,*LPSERVICE_TYPE_VALUE;

  typedef struct _SERVICE_TYPE_VALUE_ABSA {
    DWORD dwNameSpace;
    DWORD dwValueType;
    DWORD dwValueSize;
    LPSTR lpValueName;
    PVOID lpValue;
  } SERVICE_TYPE_VALUE_ABSA,*PSERVICE_TYPE_VALUE_ABSA,*LPSERVICE_TYPE_VALUE_ABSA;

  typedef struct _SERVICE_TYPE_VALUE_ABSW {
    DWORD dwNameSpace;
    DWORD dwValueType;
    DWORD dwValueSize;
    LPWSTR lpValueName;
    PVOID lpValue;
  } SERVICE_TYPE_VALUE_ABSW,*PSERVICE_TYPE_VALUE_ABSW,*LPSERVICE_TYPE_VALUE_ABSW;
#ifdef UNICODE
  typedef SERVICE_TYPE_VALUE_ABSW SERVICE_TYPE_VALUE_ABS;
  typedef PSERVICE_TYPE_VALUE_ABSW PSERVICE_TYPE_VALUE_ABS;
  typedef LPSERVICE_TYPE_VALUE_ABSW LPSERVICE_TYPE_VALUE_ABS;
#else
  typedef SERVICE_TYPE_VALUE_ABSA SERVICE_TYPE_VALUE_ABS;
  typedef PSERVICE_TYPE_VALUE_ABSA PSERVICE_TYPE_VALUE_ABS;
  typedef LPSERVICE_TYPE_VALUE_ABSA LPSERVICE_TYPE_VALUE_ABS;
#endif

  typedef struct _SERVICE_TYPE_INFO {
    DWORD dwTypeNameOffset;
    DWORD dwValueCount;
    SERVICE_TYPE_VALUE Values[1];
  } SERVICE_TYPE_INFO,*PSERVICE_TYPE_INFO,*LPSERVICE_TYPE_INFO;

  typedef struct _SERVICE_TYPE_INFO_ABSA {
    LPSTR lpTypeName;
    DWORD dwValueCount;
    SERVICE_TYPE_VALUE_ABSA Values[1];
  } SERVICE_TYPE_INFO_ABSA,*PSERVICE_TYPE_INFO_ABSA,*LPSERVICE_TYPE_INFO_ABSA;
  typedef struct _SERVICE_TYPE_INFO_ABSW {
    LPWSTR lpTypeName;
    DWORD dwValueCount;
    SERVICE_TYPE_VALUE_ABSW Values[1];
  } SERVICE_TYPE_INFO_ABSW,*PSERVICE_TYPE_INFO_ABSW,*LPSERVICE_TYPE_INFO_ABSW;
#ifdef UNICODE
  typedef SERVICE_TYPE_INFO_ABSW SERVICE_TYPE_INFO_ABS;
  typedef PSERVICE_TYPE_INFO_ABSW PSERVICE_TYPE_INFO_ABS;
  typedef LPSERVICE_TYPE_INFO_ABSW LPSERVICE_TYPE_INFO_ABS;
#else
  typedef SERVICE_TYPE_INFO_ABSA SERVICE_TYPE_INFO_ABS;
  typedef PSERVICE_TYPE_INFO_ABSA PSERVICE_TYPE_INFO_ABS;
  typedef LPSERVICE_TYPE_INFO_ABSA LPSERVICE_TYPE_INFO_ABS;
#endif

  typedef struct _SERVICE_ADDRESS {
    DWORD dwAddressType;
    DWORD dwAddressFlags;
    DWORD dwAddressLength;
    DWORD dwPrincipalLength;
    BYTE *lpAddress;
    BYTE *lpPrincipal;
  } SERVICE_ADDRESS,*PSERVICE_ADDRESS,*LPSERVICE_ADDRESS;

  typedef struct _SERVICE_ADDRESSES {
    DWORD dwAddressCount;
    SERVICE_ADDRESS Addresses[1];
  } SERVICE_ADDRESSES,*PSERVICE_ADDRESSES,*LPSERVICE_ADDRESSES;

  typedef struct _SERVICE_INFOA {
    LPGUID lpServiceType;
    LPSTR lpServiceName;
    LPSTR lpComment;
    LPSTR lpLocale;
    DWORD dwDisplayHint;
    DWORD dwVersion;
    DWORD dwTime;
    LPSTR lpMachineName;
    LPSERVICE_ADDRESSES lpServiceAddress;
    BLOB ServiceSpecificInfo;
  } SERVICE_INFOA,*PSERVICE_INFOA,*LPSERVICE_INFOA;

  typedef struct _SERVICE_INFOW {
    LPGUID lpServiceType;
    LPWSTR lpServiceName;
    LPWSTR lpComment;
    LPWSTR lpLocale;
    DWORD dwDisplayHint;
    DWORD dwVersion;
    DWORD dwTime;
    LPWSTR lpMachineName;
    LPSERVICE_ADDRESSES lpServiceAddress;
    BLOB ServiceSpecificInfo;
  } SERVICE_INFOW,*PSERVICE_INFOW,*LPSERVICE_INFOW;
#ifdef UNICODE
  typedef SERVICE_INFOW SERVICE_INFO;
  typedef PSERVICE_INFOW PSERVICE_INFO;
  typedef LPSERVICE_INFOW LPSERVICE_INFO;
#else
  typedef SERVICE_INFOA SERVICE_INFO;
  typedef PSERVICE_INFOA PSERVICE_INFO;
  typedef LPSERVICE_INFOA LPSERVICE_INFO;
#endif

  typedef struct _NS_SERVICE_INFOA {
    DWORD dwNameSpace;
    SERVICE_INFOA ServiceInfo;
  } NS_SERVICE_INFOA,*PNS_SERVICE_INFOA,*LPNS_SERVICE_INFOA;

  typedef struct _NS_SERVICE_INFOW {
    DWORD dwNameSpace;
    SERVICE_INFOW ServiceInfo;
  } NS_SERVICE_INFOW,*PNS_SERVICE_INFOW,*LPNS_SERVICE_INFOW;
#ifdef UNICODE
  typedef NS_SERVICE_INFOW NS_SERVICE_INFO;
  typedef PNS_SERVICE_INFOW PNS_SERVICE_INFO;
  typedef LPNS_SERVICE_INFOW LPNS_SERVICE_INFO;
#else
  typedef NS_SERVICE_INFOA NS_SERVICE_INFO;
  typedef PNS_SERVICE_INFOA PNS_SERVICE_INFO;
  typedef LPNS_SERVICE_INFOA LPNS_SERVICE_INFO;
#endif

#ifndef __CSADDR_DEFINED__
#define __CSADDR_DEFINED__

  typedef struct _SOCKET_ADDRESS {
    LPSOCKADDR lpSockaddr;
    INT iSockaddrLength;
  } SOCKET_ADDRESS,*PSOCKET_ADDRESS,*LPSOCKET_ADDRESS;

  typedef struct _CSADDR_INFO {
    SOCKET_ADDRESS LocalAddr;
    SOCKET_ADDRESS RemoteAddr;
    INT iSocketType;
    INT iProtocol;
  } CSADDR_INFO,*PCSADDR_INFO,*LPCSADDR_INFO;
#endif

  typedef struct _PROTOCOL_INFOA {
    DWORD dwServiceFlags;
    INT iAddressFamily;
    INT iMaxSockAddr;
    INT iMinSockAddr;
    INT iSocketType;
    INT iProtocol;
    DWORD dwMessageSize;
    LPSTR lpProtocol;
  } PROTOCOL_INFOA,*PPROTOCOL_INFOA,*LPPROTOCOL_INFOA;

  typedef struct _PROTOCOL_INFOW {
    DWORD dwServiceFlags;
    INT iAddressFamily;
    INT iMaxSockAddr;
    INT iMinSockAddr;
    INT iSocketType;
    INT iProtocol;
    DWORD dwMessageSize;
    LPWSTR lpProtocol;
  } PROTOCOL_INFOW,*PPROTOCOL_INFOW,*LPPROTOCOL_INFOW;
#ifdef UNICODE
  typedef PROTOCOL_INFOW PROTOCOL_INFO;
  typedef PPROTOCOL_INFOW PPROTOCOL_INFO;
  typedef LPPROTOCOL_INFOW LPPROTOCOL_INFO;
#else
  typedef PROTOCOL_INFOA PROTOCOL_INFO;
  typedef PPROTOCOL_INFOA PPROTOCOL_INFO;
  typedef LPPROTOCOL_INFOA LPPROTOCOL_INFO;
#endif

  typedef struct _NETRESOURCE2A {
    DWORD dwScope;
    DWORD dwType;
    DWORD dwUsage;
    DWORD dwDisplayType;
    LPSTR lpLocalName;
    LPSTR lpRemoteName;
    LPSTR lpComment;
    NS_INFO ns_info;
    GUID ServiceType;
    DWORD dwProtocols;
    LPINT lpiProtocols;
  } NETRESOURCE2A,*PNETRESOURCE2A,*LPNETRESOURCE2A;

  typedef struct _NETRESOURCE2W {
    DWORD dwScope;
    DWORD dwType;
    DWORD dwUsage;
    DWORD dwDisplayType;
    LPWSTR lpLocalName;
    LPWSTR lpRemoteName;
    LPWSTR lpComment;
    NS_INFO ns_info;
    GUID ServiceType;
    DWORD dwProtocols;
    LPINT lpiProtocols;
  } NETRESOURCE2W,*PNETRESOURCE2W,*LPNETRESOURCE2W;
#ifdef UNICODE
  typedef NETRESOURCE2W NETRESOURCE2;
  typedef PNETRESOURCE2W PNETRESOURCE2;
  typedef LPNETRESOURCE2W LPNETRESOURCE2;
#else
  typedef NETRESOURCE2A NETRESOURCE2;
  typedef PNETRESOURCE2A PNETRESOURCE2;
  typedef LPNETRESOURCE2A LPNETRESOURCE2;
#endif

  typedef DWORD (*LPFN_NSPAPI)(VOID);

  typedef VOID (*LPSERVICE_CALLBACK_PROC)(LPARAM lParam,HANDLE hAsyncTaskHandle);
  typedef struct _SERVICE_ASYNC_INFO {
    LPSERVICE_CALLBACK_PROC lpServiceCallbackProc;
    LPARAM lParam;
    HANDLE hAsyncTaskHandle;
  } SERVICE_ASYNC_INFO,*PSERVICE_ASYNC_INFO,*LPSERVICE_ASYNC_INFO;

#ifdef UNICODE
#define EnumProtocols EnumProtocolsW
#define GetAddressByName GetAddressByNameW
#define GetTypeByName GetTypeByNameW
#define GetNameByType GetNameByTypeW
#define SetService SetServiceW
#define GetService GetServiceW
#else
#define EnumProtocols EnumProtocolsA
#define GetAddressByName GetAddressByNameA
#define GetTypeByName GetTypeByNameA
#define GetNameByType GetNameByTypeA
#define SetService SetServiceA
#define GetService GetServiceA
#endif

  INT WINAPI EnumProtocolsA(LPINT lpiProtocols,LPVOID lpProtocolBuffer,LPDWORD lpdwBufferLength);
  INT WINAPI EnumProtocolsW(LPINT lpiProtocols,LPVOID lpProtocolBuffer,LPDWORD lpdwBufferLength);
  INT WINAPI GetAddressByNameA(DWORD dwNameSpace,LPGUID lpServiceType,LPSTR lpServiceName,LPINT lpiProtocols,DWORD dwResolution,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo,LPVOID lpCsaddrBuffer,LPDWORD lpdwBufferLength,LPSTR lpAliasBuffer,LPDWORD lpdwAliasBufferLength);
  INT WINAPI GetAddressByNameW(DWORD dwNameSpace,LPGUID lpServiceType,LPWSTR lpServiceName,LPINT lpiProtocols,DWORD dwResolution,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo,LPVOID lpCsaddrBuffer,LPDWORD lpdwBufferLength,LPWSTR lpAliasBuffer,LPDWORD lpdwAliasBufferLength);
  INT WINAPI GetTypeByNameA(LPSTR lpServiceName,LPGUID lpServiceType);
  INT WINAPI GetTypeByNameW(LPWSTR lpServiceName,LPGUID lpServiceType);
  INT WINAPI GetNameByTypeA(LPGUID lpServiceType,LPSTR lpServiceName,DWORD dwNameLength);
  INT WINAPI GetNameByTypeW(LPGUID lpServiceType,LPWSTR lpServiceName,DWORD dwNameLength);
  INT WINAPI SetServiceA(DWORD dwNameSpace,DWORD dwOperation,DWORD dwFlags,LPSERVICE_INFOA lpServiceInfo,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo,LPDWORD lpdwStatusFlags);
  INT WINAPI SetServiceW(DWORD dwNameSpace,DWORD dwOperation,DWORD dwFlags,LPSERVICE_INFOW lpServiceInfo,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo,LPDWORD lpdwStatusFlags);
  INT WINAPI GetServiceA(DWORD dwNameSpace,LPGUID lpGuid,LPSTR lpServiceName,DWORD dwProperties,LPVOID lpBuffer,LPDWORD lpdwBufferSize,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo);
  INT WINAPI GetServiceW(DWORD dwNameSpace,LPGUID lpGuid,LPWSTR lpServiceName,DWORD dwProperties,LPVOID lpBuffer,LPDWORD lpdwBufferSize,LPSERVICE_ASYNC_INFO lpServiceAsyncInfo);

#ifdef __cplusplus
}
#endif
#endif
